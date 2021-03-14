#' xlsxPivotCacheExtractor
#' @param file An excel xlsx file with pivot tables.
#' @description Extract the hidden table that feeds excel pivot tables. Each pivot table is extracted from the excel file.
#' @return a list of dataframes, one for each pivot table cache in the excel file.
#' @export
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr left_join
#' @importFrom dplyr filter
#' @importFrom stringr str_extract
#' @importFrom stringr str_extract_all
#' @importFrom stats setNames
#' @importFrom utils unzip
#' @importFrom rlang .data
#'
#' @examples
#' xlsxPivotCacheExtractor(file = system.file("extdata/test_sheet.xlsx",
#' package = "btools",mustWork = TRUE))
xlsxPivotCacheExtractor <- function(file){
  temporary_directory <- tempdir()
  unzip(zipfile = file,exdir = paste0(temporary_directory,"/extracted/"))
  extracted_files <- list.files(temporary_directory,recursive = TRUE,full.names = TRUE)


  pivotTables <- function(){
    definitions <- data.frame("definition" = sort(extracted_files[which(grepl(extracted_files,pattern = "pivotCacheDefinition.+xml$",ignore.case = TRUE))]), stringsAsFactors = FALSE) %>%
      mutate(n = str_extract(.data$definition,"(?<=Definition)[0-9]+(?=.xml$)"))

    records <- data.frame("record" = sort(extracted_files[which(grepl(extracted_files,pattern = "pivotCacheRecords.+xml$",ignore.case = TRUE))]), stringsAsFactors = FALSE) %>%
      mutate(n = str_extract(.data$record,"(?<=Records)[0-9]+(?=.xml$)"))

    return(left_join(records,definitions,by = "n"))
  }
  pivot_tables <- pivotTables()
  unusual_pivot_tables <- pivot_tables %>% filter(is.na(.data$definition))
  if(nrow(unusual_pivot_tables)>0){
    warning(nrow(unusual_pivot_tables)," pivot tables without matching definitions")
  }
  pivot_list <- apply(pivot_tables,MARGIN = 1,FUN = function(x) {
    if(!is.na(x["definition"])){
      definition <- suppressWarnings(readLines(x["definition"])) %>%
        paste(collapse = "") %>%
        str_extract_all("<cacheField name=.*?</cacheField",simplify = TRUE)
      definition_names <- definition %>%
        str_extract_all('(?<=<cacheField name=\").+?(?=\")',simplify = TRUE)
      definition_values <- definition %>%
        str_extract_all('(?<=v=\").+?(?=\"/>)') %>%
        setNames(definition_names)
    }else{
      definition_values <- list()
    }
    row_data <- suppressWarnings(readLines(x["record"])) %>%
      paste(collapse = "") %>% str_extract_all('<r>.+?</r>',simplify = TRUE) %>% str_extract_all('(?<=v=").+?(?="/>)',simplify = TRUE) %>%
      as.data.frame(stringAsFactors=FALSE) %>%
      setNames(definition_names)

    #row_data <- sample_n(row_data,size = 10000)
    for(n in names(definition_values)) {
      if (length(definition_values[[eval(n)]]) == 0) {
        next()
      }
      row_data[, eval(n)] <-
        factor(
          x = as.numeric(row_data[, eval(n)]),
          labels = definition_values[[eval(n)]],
          levels = unique(row_data[, eval(n)])
        )
    }
    return(row_data)
  })
  pivot_list <- setNames(pivot_list,nm = pivot_tables$n)
  unlink(temporary_directory,recursive = TRUE)
  return(pivot_list)
}
