#' renameSMB
#' @description Use python SMBConnection to rename/move a file at path on a SMB share.
#' @param username Your SMB user name
#' @param password Your SMB user password, do not store this in your code!
#' @param my_name The machine you are running this operation on (Default : `Sys.info()[["nodename"]]`)
#' @param remote_name The smb server name
#' @param service_name The share name i.e. `'Share'`
#' @param old_path The complete path including file name and extension to your file e.g. `'Files/Reporting/test.txt'`
#' @param new_path The complete path including file name and extension to your new location e.g. `'Files/Reporting/test_renamed.txt'`
#' @param domain SMB server domain
#' @param port Common port  (Default : `445`)
#' @param timeout  How long to keep the connection open before timeout (Default : `30`)
#' @param python_location The location of your python installation
#'
#' @importFrom reticulate use_python
#' @importFrom reticulate import
#' @return Returns no value
#' @export
#'
renameSMB <-
  function(username,
           password,
           my_name = Sys.info()[["nodename"]],
           remote_name,
           service_name,
           old_path,
           new_path,
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
        domain = 'domain',
        use_ntlm_v2 = 'True',
        is_direct_tcp = 'True'
      )
    connected <- smb$connect(remote_name, as.integer(port))
    sharedfiles <-
      smb$rename(service_name, old_path, new_path, timeout)
    smb$close()
  }
