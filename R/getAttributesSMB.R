#' getAttributesSMB
#' @description Use python SMBConnection to retrieve information about the file at `path` on the `service_name.`
#' @param username Your SMB user name
#' @param password Your SMB user password, do not store this in your code!
#' @param my_name The machine you are running this operation on (Default : `Sys.info()[["nodename"]]`)
#' @param remote_name The smb server name
#' @param service_name The service_name name i.e. `'service_name'`
#' @param path The SMB folder path where your file is e.g. `'Files/Reporting/Test.csv'`
#' @param domain SMB server domain
#' @param port Common port  (Default : `445`)
#' @param timeout  How long to keep the connection open before timeout (Default : `30`)
#' @param python_location The location of your python installation
#'
#' @importFrom reticulate use_python
#' @importFrom reticulate import
#' @return Retrieve a dataframe of attributes
#' @export
#'
getAttributesSMB <-
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
    reticulate::use_python(python_location)
    smb <- reticulate::import("smb.SMBConnection")
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
    connected <- smb$connect(ip = remote_name, port = as.integer(port),timeout = as.integer(timeout))
    service_fileattributes <-
      smb$getAttributes(service_name, path = path)
    smb$close()

    dt <- data.frame(
      alloc_size = service_fileattributes$alloc_size,
      create_time = as.POSIXct(service_fileattributes$create_time, origin = "1970-01-01 00:00:00"),
      file_attributes = service_fileattributes$file_attributes,
      file_size = service_fileattributes$file_size,
      filename = service_fileattributes$filename,
      isDirectory = service_fileattributes$isDirectory,
      isNormal = service_fileattributes$isNormal,
      isReadOnly = service_fileattributes$isReadOnly,
      last_access_time = as.POSIXct(service_fileattributes$last_access_time, origin = "1970-01-01 00:00:00"),
      last_attr_change_time = as.POSIXct(service_fileattributes$last_attr_change_time, origin = "1970-01-01 00:00:00"),
      last_write_time = as.POSIXct(service_fileattributes$last_write_time, origin = "1970-01-01 00:00:00"),
      short_name = service_fileattributes$short_name
    )


    return(dt)
  }
