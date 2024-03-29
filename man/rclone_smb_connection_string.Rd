% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rcloneSMB.R
\name{rclone_smb_connection_string}
\alias{rclone_smb_connection_string}
\title{SMB Connection String}
\usage{
rclone_smb_connection_string(
  host,
  user = Sys.getenv("username"),
  port = 445,
  pass = "",
  domain = "WORKGROUP",
  spn = NULL,
  timeout = "1m0s",
  hide_special = TRUE,
  case_insensitive = TRUE,
  encoding =
    "Slash,LtGt,DoubleQuote,Colon,Question,Asterisk,Pipe,BackSlash,Ctl,RightSpace,RightPeriod,InvalidUtf8,Dot"
)
}
\arguments{
\item{host}{SMB server hostname to connect to.}

\item{user}{SMB username.}

\item{port}{SMB port number.}

\item{pass}{SMB password. NB Input to this must be obscured. See \link{rclone_obscure}}

\item{domain}{Domain name for NTLM authentication.}

\item{spn}{Service principal name.}

\item{timeout}{Max time before closing idle connections.}

\item{hide_special}{Hide special shares (e.g. print$) which users aren't supposed to access.}

\item{case_insensitive}{Whether the server is configured to be case-insensitive.}

\item{encoding}{The encoding for the backend. \link{https://rclone.org/overview/#encoding}}
}
\value{
Character string for connecting to SMB share
}
\description{
SMB Connection String
}
\keyword{internal}
