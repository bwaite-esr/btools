#' renameSMB
#' @description Use python SMBConnection to rename/move a file at path on a SMB share.
#' @param userID Your SMB user name
#' @param password Your SMB user password, do not store this in your code!
#' @param client_machine_name The machine you are running this operation on (Default : `Sys.info()[["nodename"]]`)
#' @param server_name The smb server name
#' @param share The share name i.e. `'Share'`
#' @param old_path The complete path including file name and extension to your file e.g. `'Files/Reporting/test.txt'`
#' @param new_path The complete path including file name and extension to your new location e.g. `'Files/Reporting/test_renamed.txt'`
#' @param domain SMB server domain
#' @param port Common port  (Default : `445`)
#' @param timeout  How long to keep the connection open before timeout (Default : `30`)
#' @param python_location The location of your python installation
#'
#' @importFrom reticulate use_python
#' @importFrom reticulate import
#' @importFrom reticulate py_run_string
#' @return Returns no value
#' @export
#'
renameSMB <-
  function(userID,
           password,
           client_machine_name = Sys.info()[["nodename"]],
           server_name,
           share,
           old_path,
           new_path,
           domain,
           port = 445,
           timeout = 30,
           python_location) {
    use_python(python_location)
    smb <- import("smb.SMBConnection")
    py_run_string(
      paste0(
        "from smb.SMBConnection import SMBConnection
conn = SMBConnection('",
        userID,
        "', '",
        password,
        "', '",
        client_machine_name,
        "', '",
        server_name,
        "', '",
        domain,
        "', use_ntlm_v2=True, is_direct_tcp=True)
assert conn.connect('",
        server_name,
        "',",
        port,
        ")

conn.rename(service_name='",
        share,
        "', old_path='",
        old_path,
        "', new_path='",
        new_path,
        "', timeout=",
        timeout,
        ")

conn.close()
"
      )
    )
  }
