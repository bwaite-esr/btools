% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rcloneSMB.R
\name{delete_rclone_smb}
\alias{delete_rclone_smb}
\title{Delete files}
\usage{
delete_rclone_smb(
  host,
  user,
  path,
  password = NULL,
  rclone_location = Sys.getenv("rclone_location"),
  rmdirs = FALSE,
  dry_run = TRUE,
  ...
)
}
\arguments{
\item{host}{SMB server hostname to connect to.}

\item{user}{SMB username.}

\item{path}{File path to delete on smb connection}

\item{password}{Plain text password. If you have an obscured password
pass the obscured password in variable \code{pass}.}

\item{rclone_location}{Location of \code{rclone}}

\item{rmdirs}{Remove empty directories but leaves root intact}

\item{dry_run}{Do a trial run with no permanent changes}

\item{...}{Additional variables for \link{rclone_smb_connection_string}}
}
\value{
List of file changes
}
\description{
Delete files
}
