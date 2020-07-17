#' retrieveSMB
#' @description Use python SMBConnection to retrieve the contents of a file at path on a SMB share. If the file already exists on the `file_location`, it will be truncated and overwritten.
#' @param userID Your SMB user name
#' @param password Your SMB user password, do not store this in your code!
#' @param client_machine_name The machine you are running this operation on (Default : `Sys.info()[["nodename"]]`)
#' @param server_name The smb server name
#' @param share The share name i.e. `'Share'`
#' @param smb_path The folder path to put your file e.g. `'Files/Reporting/'` to output the file to the Reporting subfolder of the Files root folder.
#' @param smb_file_name The name and extension of the file you are saving e.g. `'MyData.csv'`""
#' @param domain SMB server domain
#' @param file_location Full file path e.g. `'\home\username\file.txt'`
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
retrieveSMB <-
  function(userID,
           password,
           client_machine_name = Sys.info()[["nodename"]],
           server_name,
           share,
           smb_path,
           smb_file_name,
           domain,
           file_location,
           port = 445,
           timeout = 30,
           python_location) {
    use_python(python_location)
    smb <- import("smb.SMBConnection")
    if (!grepl(smb_path, pattern = "/$")) {
      warning('Path does not end in "/"')
    }
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

with open('",
        file_location,
        "',mode='wb') as file:
    conn.retrieveFile(service_name='",
        share,
        "',path='",
        smb_path,
        smb_file_name,
        "', file_obj=file,timeout=",
        timeout,
        ")

conn.close()
"
      )
    )
  }
