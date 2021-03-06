is_windows <- function ()
{
  identical(.Platform$OS.type, 'windows')
}


root_dir <- function ()
{
  ifelse(is_windows(), "c:\\", "/")
}

R_binary <- function ()
{
  binary <- ifelse(is_windows(), 'R.exe', 'R')
  binary <- file.path(R.home("bin"), binary)
  stopifnot(file.exists(binary))
  binary
}


R_child <- function(...)
{
  spawn_process(R_binary(), '--slave', ...)
}


process_exists <- function (pid)
{
  pid <- as.integer(pid)
  
  if (is_windows()) {
    output <- system2("tasklist", c("/FI", paste0('"PID eq ', pid, '"')),
                      stdout = TRUE, stderr = NULL)
    return(length(grep(as.character(pid), output, fixed = TRUE)) > 0)
  }
  else {
    rc <- system2("ps", c("-q", as.character(pid)), stdout = NULL, stderr = NULL)
    return(rc == 0)
  }
}
