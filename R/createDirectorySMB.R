#' createDirectorySMB
#' @description Use python SMBConnection to create a directory at `path`
#' @param username Your SMB user name
#' @param password Your SMB user password, do not store this in your code!
#' @param my_name The machine you are running this operation on (Default : `Sys.info()[["nodename"]]`)
#' @param remote_name The smb server name
#' @param service_name The service_name name i.e. `'service_name'`
#' @param path The SMB folder path ro create e.g. `'Files/Reporting/'`
#' @param domain SMB server domain
#' @param port Common port  (Default : `445`)
#' @param timeout  How long to keep the connection open before timeout (Default : `30`)
#' @param python_location The location of your python installation
#'
#' @importFrom reticulate use_python
#' @importFrom reticulate import
#' @return Retrieve a directory listing of files/folders at `path`
#' @export
#'
createDirectorySMB <-
  function(username,
           password,
           my_name = Sys.info()[["nodename"]],
           remote_name,
           service_name,
           path,
           domain,
           port = 445,
           timeout = 30,
           python_location) {
    use_python(python_location)
    smb <- import("smb.SMBConnection")
    smb <-
      smb$SMBConnection(
        username,
        password,
        my_name,
        remote_name,
        domain = 'ESR-AD',
        use_ntlm_v2 = 'True',
        is_direct_tcp = 'True'
      )
    connected <- smb$connect(remote_name, as.integer(port))
    smb$createDirectory(service_name, path)
    smb$close()
  }
