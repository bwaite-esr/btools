test_that("can process test excel file", {
  expect_equal(
    xlsxPivotCacheExtractor(
      file = system.file(
        "extdata/test_sheet.xlsx",
        package = "btools",
        mustWork = TRUE
      )
    ),
    list(
      `1` = structure(
        list(
          id = c("1", "2", "3", "4", "5", "6",
                 "7", "8", "9", "10"),
          first_name = c(
            "Hi",
            "Wendell",
            "Lorens",
            "Stanleigh",
            "Gavan",
            "Perrine",
            "Zaccaria",
            "Ruttger",
            "Mohandis",
            "Rudiger"
          ),
          last_name = c(
            "Beazley",
            "Haresnaip",
            "Widger",
            "Blacksland",
            "Tousy",
            "Shreve",
            "Nibloe",
            "Croxon",
            "Redmain",
            "Kenney"
          ),
          email = c(
            "hbeazley0@wp.com",
            "wharesnaip1@4shared.com",
            "lwidger2@yale.edu",
            "sblacksland3@un.org",
            "gtousy4@house.gov",
            "pshreve5@freewebs.com",
            "znibloe6@ucsd.edu",
            "rcroxon7@prlog.org",
            "mredmain8@ftc.gov",
            "rkenney9@google.nl"
          ),
          gender = c(
            "Male",
            "Male",
            "Male",
            "Male",
            "Male",
            "Female",
            "Male",
            "Male",
            "Male",
            "Male"
          ),
          ip_address = c(
            "67.254.76.138",
            "158.119.61.151",
            "236.195.97.62",
            "240.240.57.68",
            "66.133.246.224",
            "25.236.184.34",
            "250.76.63.189",
            "232.85.215.192",
            "171.61.223.221",
            "51.111.94.106"
          )
        ),
        class = "data.frame",
        row.names = c(NA,-10L)
      ),
      `2` = structure(
        list(
          id = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"),
          name = c(
            "Cattle egret",
            "Nile crocodile",
            "Bushpig",
            "Waterbuck, common",
            "Moccasin, water",
            "Parakeet, rose-ringed",
            "Common ringtail",
            "African darter",
            "Blue-breasted cordon bleu",
            "Common shelduck"
          ),
          s_name = c(
            "Bubulcus ibis",
            "Crocodylus niloticus",
            "Potamochoerus porcus",
            "Kobus defassa",
            "Agkistrodon piscivorus",
            "Psittacula krameri",
            "Pseudocheirus peregrinus",
            "Anhinga rufa",
            "Uraeginthus angolensis",
            "Tadorna tadorna"
          ),
          datetime = c(
            "2020-03-27 01:02:49",
            "2020-05-31 12:26:15",
            "2020-03-27 12:42:21",
            "2020-01-15 18:07:33",
            "2019-11-01 22:08:04",
            "2020-01-14 00:37:18",
            "2019-09-24 00:59:05",
            "2020-06-29 12:52:38",
            "2019-10-05 15:56:33",
            "2020-06-29 06:54:30"
          )
        ),
        class = "data.frame",
        row.names = c(NA,-10L)
      )
    )
  )
})
