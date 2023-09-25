#' SMB Connection String
#'
#' @param host SMB server hostname to connect to.
#' @param user SMB username.
#' @param port SMB port number.
#' @param pass SMB password. NB Input to this must be obscured. See [btools::rclone_obscure]
#' @param domain Domain name for NTLM authentication.
#' @param spn Service principal name.
#' @param timeout Max time before closing idle connections.
#' @param hide_special Hide special shares (e.g. print$) which users aren't supposed to access.
#' @param case_insensitive Whether the server is configured to be case-insensitive.
#' @param encoding The encoding for the backend. [https://rclone.org/overview/#encoding]
#'
#' @return Character string for connecting to SMB share
#' @keywords internal
#' @export
rclone_smb_connection_string <-
  function(host,
           user = Sys.getenv("username"),
           port = 445,
           pass = "",
           domain = "WORKGROUP",
           spn = NULL,
           timeout = "1m0s",
           hide_special = TRUE,
           case_insensitive = TRUE,
           encoding = "Slash,LtGt,DoubleQuote,Colon,Question,Asterisk,Pipe,BackSlash,Ctl,RightSpace,RightPeriod,InvalidUtf8,Dot") {
    paste0(
      "--smb-host ",
      shQuote(host[1]),
      " --smb-user ",
      shQuote(user[1]),
      " --smb-port ",
      shQuote(port[1]),
      " --smb-pass ",
      shQuote(pass[1]),
      " --smb-domain ",
      shQuote(domain[1]),
      ifelse(
        test = !is.null(spn),
        yes = paste0(" --smb-spn ",
                     shQuote(spn[1])),
        no = ""
      ),
      " --smb-idle-timeout ",
      shQuote(timeout[1]),
      ifelse(test = hide_special[1],
             yes = " --smb-hide-special-share", no = ""),
      ifelse(test = case_insensitive[1],
             yes = " --smb-case-insensitive", no = ""),
      " --smb-encoding ",
      shQuote(encoding[1])
    )
  }

#' Obscure Password
#' @description rclone requires passwords to shares are obscured. This function
#' takes a plain-text password and obscures it using `rclone obscure`.
#' @param pass Plain-text password
#' @param rclone_location Location of `rclone`
#'
#' @return Password obscured by rclone
#' @keywords internal
#' @export
rclone_obscure <-
  function(pass,
           rclone_location = Sys.getenv("rclone_location")) {
    return(system2(
      command = rclone_location,
      args = list("obscure", shQuote(pass)),
      stdout = TRUE
    ))
  }

#' List files and folders
#'
#' @param host SMB server hostname to connect to.
#' @param user SMB username.
#' @param path Folder path
#' @param password Plain text password. If you have an obscured password
#' pass the obscured password in variable `pass`.
#' @param rclone_location Location of `rclone`
#' @param files_only Do not return directories
#' @param dirs_only Do not return files
#' @param recursive Recurse into the listing
#' @param ... Additional variables for [btools::rclone_smb_connection_string]
#'
#' @return dataframe of files and folder within `path`
#' @export
#' @importFrom rlang inject
#' @importFrom jsonlite fromJSON
ls_rclone_smb <-
  function(host,
           user,
           path,
           password = NULL,
           rclone_location = Sys.getenv("rclone_location"),
           files_only = FALSE,
           dirs_only = FALSE,
           recursive = FALSE,
           ...) {
    arg_list <- list(...)
    if (!is.null(password)) {
      arg_list$pass <- rclone_obscure(password, rclone_location)
    }
    connection_string <-
      rlang::inject(rclone_smb_connection_string(host, user,!!!arg_list))
    if (files_only) {
      connection_string <- paste0(connection_string, " --files-only")
    }
    if (dirs_only) {
      connection_string <- paste0(connection_string, " --dirs-only")
    }
    if (recursive) {
      connection_string <- paste0(connection_string, " --recursive")
    }
    if (all(files_only, dirs_only)) {
      warning("files_only and dirs_only both TRUE: No results will be returned!")
    }
    path <- shQuote(path[1])
    content_json <-
      system(
        command = paste0(rclone_location, " lsjson ",
                         connection_string, " :smb:", path),
        intern = TRUE
      )
    content_df <-
      structure(
        list(
          Path = character(0),
          Name = character(0),
          Size = integer(0),
          MimeType = character(0),
          ModTime = character(0),
          IsDir = logical(0)
        ),
        row.names = integer(0),
        class = "data.frame"
      )
    content_df <- rbind(content_df, jsonlite::fromJSON(content_json))
    return(content_df)
  }

#' Copy file from source to destination
#' @description Overwrite file/folder at destination with source
#' @param host SMB server hostname to connect to
#' @param user SMB username
#' @param password Plain text password. If you have an obscured password
#' pass the obscured password in variable `pass`.
#' @param rclone_location Location of `rclone`
#' @param ... Additional variables for [btools::rclone_smb_connection_string]
#' @param src Source file/folder path
#' @param dest Destination file/folder path
#' @param src_smb Source is on smb. If false path is treated as local
#' @param dest_smb Destination is on smb. If false path is treated as local
#'
#' @return Silent
#' @export
#' @importFrom rlang inject
copyto_rclone_smb <-   function(host,
                                user,
                                src,
                                dest,
                                src_smb = TRUE,
                                dest_smb = TRUE,
                                password = NULL,
                                rclone_location = Sys.getenv("rclone_location"),
                                ...) {
  arg_list <- list(...)
  if (!is.null(password)) {
    arg_list$pass <- rclone_obscure(password, rclone_location)
  }
  connection_string <-
    rlang::inject(rclone_smb_connection_string(host, user,!!!arg_list))
  src <- shQuote(src[1])
  dest <- shQuote(dest[1])
  if (src_smb) {
    src <- paste0(":smb:",src)
  }
  if (dest_smb) {
    dest <- paste0(":smb:",dest)
  }
  system(
    command = paste(
      rclone_location,
      connection_string ,
      "copyto",
      src,
      dest
    ),
    intern = FALSE
  )
}
#' Delete files
#'
#' @param host SMB server hostname to connect to.
#' @param user SMB username.
#' @param password Plain text password. If you have an obscured password
#' pass the obscured password in variable `pass`.
#' @param rclone_location Location of `rclone`
#' @param path File path to delete on smb connection
#' @param rmdirs Remove empty directories but leaves root intact
#' @param dry_run Do a trial run with no permanent changes
#' @param ... Additional variables for [btools::rclone_smb_connection_string]
#' @return List of file changes
#' @export
#' @importFrom rlang inject
delete_rclone_smb <-   function(host,
                                user,
                                path,
                                password = NULL,
                                rclone_location = Sys.getenv("rclone_location"),
                                rmdirs = FALSE,
                                dry_run = TRUE,
                                ...) {
  arg_list <- list(...)
  if (!is.null(password)) {
    arg_list$pass <- rclone_obscure(password, rclone_location)
  }
  connection_string <-
    rlang::inject(rclone_smb_connection_string(host, user,!!!arg_list))
  path <- shQuote(path[1])
  system(
    command = paste0(
      rclone_location,
      " ",
      connection_string ,
      " delete :smb:",
      path,
      if (rmdirs) {
        " --rmdirs"
      } else{
        ""
      },
      if (dry_run) {
        " --dry-run"
      } else{
        ""
      }
    ),
    intern = FALSE
  )
}
#' Make folder
#'
#' @param host SMB server hostname to connect to.
#' @param user SMB username.
#' @param password Plain text password. If you have an obscured password
#' pass the obscured password in variable `pass`.
#' @param rclone_location Location of `rclone`
#' @param path SMB folder to create
#' @param ... Additional variables for [btools::rclone_smb_connection_string]
#' @return Silent
#' @export
#' @importFrom rlang inject
mkdir_rclone_smb <-   function(host,
                                user,
                                path,
                                password = NULL,
                                rclone_location = Sys.getenv("rclone_location"),
                                ...) {
  arg_list <- list(...)
  if (!is.null(password)) {
    arg_list$pass <- rclone_obscure(password, rclone_location)
  }
  connection_string <-
    rlang::inject(rclone_smb_connection_string(host, user,!!!arg_list))
  path <- shQuote(path[1])
  system(
    command = paste0(
      rclone_location,
      " ",
      connection_string ,
      " mkdir :smb:",
      path
    ),
    intern = FALSE
  )
}
#' Remove path and all files
#'
#' @param host SMB server hostname to connect to.
#' @param user SMB username.
#' @param password Plain text password. If you have an obscured password
#' pass the obscured password in variable `pass`.
#' @param rclone_location Location of `rclone`
#' @param path SMB folder path to remove
#' @param dry_run Do a trial run with no permanent changes
#' @param ... Additional variables for [btools::rclone_smb_connection_string]
#' @return List of file changes
#' @export
#' @importFrom rlang inject
purge_rclone_smb <-   function(host,
                                user,
                                path,
                                password = NULL,
                                rclone_location = Sys.getenv("rclone_location"),
                                dry_run = TRUE,
                                ...) {
  arg_list <- list(...)
  if (!is.null(password)) {
    arg_list$pass <- rclone_obscure(password, rclone_location)
  }
  connection_string <-
    rlang::inject(rclone_smb_connection_string(host, user,!!!arg_list))
  path <- shQuote(path[1])
  system(
    command = paste0(
      rclone_location,
      " ",
      connection_string ,
      " purge :smb:",
      path,
      if (dry_run) {
        " --dry-run"
      } else{
        ""
      }
    ),
    intern = FALSE
  )
}
