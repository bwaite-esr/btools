#' storeFileSMB
#' @description Use python SMBConnection to store the contents of a file at path on a SMB service_name. If the file already exists on the remote server, it will be truncated and overwritten.
#' @param username Your SMB user name
#' @param password Your SMB user password, do not store this in your code!
#' @param my_name The machine you are running this operation on (Default : `Sys.info()[["nodename"]]`)
#' @param remote_name The smb server name
#' @param service_name The service_name name i.e. `'Share'`
#' @param path The path to put your file e.g. `'/home/username/file.txt'`
#' @param domain SMB server domain
#' @param file_obj  Full file path, to be read e.g. `'Files/Reporting/MyData.csv'`
#' @param port Common port  (Default : `445`)
#' @param timeout  How long to keep the connection open before timeout (Default : `30`)
#' @param python_location The location of your python installation
#'
#' @importFrom reticulate use_python
#' @importFrom reticulate import
#' @importFrom reticulate import_builtins
#' @importFrom reticulate %as%
#' @return Returns no value
#' @export
#'
storeFileSMB <-
  function(username,
           password,
           my_name = Sys.info()[["nodename"]],
           remote_name,
           service_name,
           path,
           domain,
           file_obj,
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
        domain = domain,
        use_ntlm_v2 = 'True',
        is_direct_tcp = 'True'
      )
    connected <- smb$connect(remote_name, as.integer(port))
    py <- import_builtins()
    with(py$open(file_obj, "rb") %as% file, {
      smb$storeFile(
        service_name,
        path = path,
        file_obj = file,
        timeout = timeout
      )
      file$close()
    })
    smb$close()
  }
