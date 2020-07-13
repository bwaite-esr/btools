test_that("can process test excel file", {
  expect_equal(pivotCacheExtractor(
    file = system.file(
      "extdata/test_sheet.xlsx",
      package = "pivotCacheExtractor",
      mustWork = TRUE
    )
  )
  ,
  structure(list(
    `1` = structure(
      list(
        id = structure(
          c(1L, 3L,
            4L, 5L, 6L, 7L, 8L, 9L, 10L, 2L),
          .Label = c("1", "10", "2",
                     "3", "4", "5", "6", "7", "8", "9"),
          class = "factor"
        ),
        first_name = structure(
          c(2L,
            9L, 3L, 8L, 1L, 5L, 10L, 7L, 4L, 6L),
          .Label = c(
            "Gavan",
            "Hi",
            "Lorens",
            "Mohandis",
            "Perrine",
            "Rudiger",
            "Ruttger",
            "Stanleigh",
            "Wendell",
            "Zaccaria"
          ),
          class = "factor"
        ),
        last_name = structure(
          c(1L,
            4L, 10L, 2L, 9L, 8L, 6L, 3L, 7L, 5L),
          .Label = c(
            "Beazley",
            "Blacksland",
            "Croxon",
            "Haresnaip",
            "Kenney",
            "Nibloe",
            "Redmain",
            "Shreve",
            "Tousy",
            "Widger"
          ),
          class = "factor"
        ),
        email = structure(
          c(2L,
            9L, 3L, 8L, 1L, 5L, 10L, 6L, 4L, 7L),
          .Label = c(
            "gtousy4@house.gov",
            "hbeazley0@wp.com",
            "lwidger2@yale.edu",
            "mredmain8@ftc.gov",
            "pshreve5@freewebs.com",
            "rcroxon7@prlog.org",
            "rkenney9@google.nl",
            "sblacksland3@un.org",
            "wharesnaip1@4shared.com",
            "znibloe6@ucsd.edu"
          ),
          class = "factor"
        ),
        gender = structure(
          c(2L, 2L, 2L, 2L, 2L,
            1L, 2L, 2L, 2L, 2L),
          .Label = c("Female", "Male"),
          class = "factor"
        ),
        ip_address = structure(
          c(10L, 1L, 4L, 5L, 9L, 6L, 7L, 3L,
            2L, 8L),
          .Label = c(
            "158.119.61.151",
            "171.61.223.221",
            "232.85.215.192",
            "236.195.97.62",
            "240.240.57.68",
            "25.236.184.34",
            "250.76.63.189",
            "51.111.94.106",
            "66.133.246.224",
            "67.254.76.138"
          ),
          class = "factor"
        )
      ),
      .Names = c(
        "id",
        "first_name",
        "last_name",
        "email",
        "gender",
        "ip_address"
      ),
      row.names = c(NA,-10L),
      class = "data.frame"
    ),
    `2` = structure(
      list(
        id = structure(
          c(1L,
            3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 2L),
          .Label = c("1", "10", "2",
                     "3", "4", "5", "6", "7", "8", "9"),
          class = "factor"
        ),
        name = structure(
          c(4L,
            8L, 3L, 10L, 7L, 9L, 5L, 1L, 2L, 6L),
          .Label = c(
            "African darter",
            "Blue-breasted cordon bleu",
            "Bushpig",
            "Cattle egret",
            "Common ringtail",
            "Common shelduck",
            "Moccasin, water",
            "Nile crocodile",
            "Parakeet, rose-ringed",
            "Waterbuck, common"
          ),
          class = "factor"
        ),
        s_name = structure(
          c(3L,
            4L, 6L, 5L, 1L, 8L, 7L, 2L, 10L, 9L),
          .Label = c(
            "Agkistrodon piscivorus",
            "Anhinga rufa",
            "Bubulcus ibis",
            "Crocodylus niloticus",
            "Kobus defassa",
            "Potamochoerus porcus",
            "Pseudocheirus peregrinus",
            "Psittacula krameri",
            "Tadorna tadorna",
            "Uraeginthus angolensis"
          ),
          class = "factor"
        ),
        datetime = structure(
          c(6L, 8L, 7L, 5L, 3L, 4L, 1L, 10L, 2L, 9L),
          .Label = c(
            "2019-09-24 00:59:05",
            "2019-10-05 15:56:33",
            "2019-11-01 22:08:04",
            "2020-01-14 00:37:18",
            "2020-01-15 18:07:33",
            "2020-03-27 01:02:49",
            "2020-03-27 12:42:21",
            "2020-05-31 12:26:15",
            "2020-06-29 06:54:30",
            "2020-06-29 12:52:38"
          ),
          class = "factor"
        )
      ),
      .Names = c("id", "name", "s_name", "datetime"),
      row.names = c(NA,-10L),
      class = "data.frame"
    )
  ), .Names = c("1", "2")))
})
