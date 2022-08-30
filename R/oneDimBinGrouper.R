#' oneDimBinGrouper
#' @description Group together rows by their `'group'` and order the groups such that they fill 1-D bins of size `'bin_size'`
#' @param data Data table with `group` column
#' @param group Name of columns to group by
#' @param bin_size Size of 'bin' to fill (Such as 96 for a 96 well plate, or 8 for 8 rows on a plate)
#'
#' @return
#' @export
#' @importFrom magrittr %>%
#' @importFrom dplyr summarise
#' @importFrom dplyr group_by_at
#' @importFrom dplyr group_by
#' @importFrom dplyr all_of
#' @importFrom dplyr n
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr bind_rows
#' @importFrom dplyr rowwise
#' @importFrom dplyr cur_data
#' @importFrom dplyr arrange
#' @importFrom dplyr arrange
#' @importFrom RcppAlgos comboGeneral
#' @importFrom dplyr left_join
#' @importFrom dplyr pull
#'
#' @examples
#'
oneDimBinGrouper <- function(data, group, bin_size) {
  # library(tidyverse)

  is.naturalnumber <-
    function(x, tol = .Machine$double.eps^0.5) {
      x > tol & abs(x - round(x)) < tol
    }
  if (!is.naturalnumber(bin_size)) {
    stop("bin_size must be a natural number:", bin_size)
  }
  if (!group %in% names(data)) {
    stop("group variable missing from data:", group)
  }
  max_row_count <-
    data %>%
    group_by_at(all_of(group)) %>%
    summarise(count = n()) %>%
    pull(count) %>%
    max()
  if (max_row_count > bin_size) {
    excess_data <-
      data %>%
      group_by_at(all_of(group)) %>%
      summarise(count = n()) %>%
      filter(count > !!bin_size) %>%
      select(all_of(group))

    stop(
      "group counts greater than bin_size size:
",
      apply(
        excess_data,
        MARGIN = 1,
        FUN = function(x) {
          paste(x, "\n")
        }
      )
    )
  }
  count_table <-
    data %>%
    group_by_at(all_of(group)) %>%
    summarise(count = n()) %>%
    select(count) %>%
    group_by(count) %>%
    summarise(n = n())

  count_table$remanider <-
    bin_size %% count_table$count

  count_table$max_n <-
    floor(bin_size / count_table$count)

  count_list <-
    as.numeric(unlist(
      apply(
        count_table[, c("count", "max_n")],
        MARGIN = 1,
        FUN = function(x) {
          rep(x[1], times = x[2])
        }
      )
    ))
  counts <-
    count_table$count

  count_repeats <-
    rle(count_list)$lengths


  valid_combinations <- lapply(seq_along(counts), function(x) {
    comboGeneral(counts, x,
      freqs = count_repeats,
      constraintFun = "sum",
      comparisonFun = "==",
      limitConstraints = bin_size
    )
  })
  combinations <- matrix(nrow = 0, ncol = length(counts)) %>%
    as.data.frame() %>%
    setNames(counts) %>%
    mutate(combinations = NA_character_)
  for (c in 1:length(valid_combinations)) {
    if (nrow(valid_combinations[[c]]) > 0) {
      for (r in 1:nrow(valid_combinations[[c]])) {
        name <- valid_combinations[[c]][r, ] %>% paste0(., collapse = "+")
        newrow <- valid_combinations[[c]][r, ] %>%
          tabulate(nbins = length(counts)) %>%
          as.matrix() %>%
          t() %>%
          as.data.frame() %>%
          setNames(counts) %>%
          mutate(combinations = !!name)
        combinations <- bind_rows(combinations, newrow)
      }
    }
  }
  valid_combinations <- combinations

  count_totals <- count_table$n

  valid_combinations$maxplates <-
    valid_combinations %>%
    select(-all_of(c("combinations"))) %>%
    rowwise() %>%
    mutate(maxplates = floor(min(count_totals / cur_data(), na.rm = TRUE))) %>%
    pull(maxplates)

  valid_combinations <-
    valid_combinations %>%
    arrange(maxplates) %>%
    filter(is.finite(maxplates))

  valid_combinations$plate <- 0

  sample_counts <-
    count_table$n

  for (c in valid_combinations$combinations) {
    plate_count <- min(sample_counts /
      (valid_combinations %>%
        filter(combinations == !!c) %>%
        select(-all_of(c("combinations", "maxplates", "plate")))
      ),
    na.rm = TRUE
    )

    valid_combinations[which(valid_combinations$combinations == c), "plate"] <-
      floor(plate_count)

    sample_counts <-
      sample_counts - (valid_combinations %>%
        filter(combinations == c) %>%
        select(-all_of(c("combinations", "plate", "maxplates"))) * plate_count
      )
  }
  valid_combinations <- valid_combinations %>%
    filter(plate > 0)

  data_group <- data %>%
    group_by_at(all_of(group)) %>%
    summarise(count = n(), .groups = NULL) %>%
    mutate(plate = NA_integer_)

  for (c in valid_combinations$combinations) {
    for (p in 1:valid_combinations[which(valid_combinations$combinations == c), ]$plate) {
      new_plate <- max(c(0, data_group$plate), na.rm = TRUE) + 1

      for (s in count_table$count) {
        comb_count <-
          valid_combinations %>%
          filter(combinations == c) %>%
          pull(as.character(s))

        if (comb_count > 0) {
          data_group[which(is.na(data_group$plate) &
            data_group$count == s), "plate"][1:comb_count, ] <- new_plate
        }
      }
    }
  }

  for (g in group) {
    data <- data %>%
      arrange(get(g))
  }

  data <- data %>%
    left_join(., data_group) %>%
    arrange(plate, count) %>%
    select(-count)

  return(data)
}
