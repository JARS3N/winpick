drives <- function() {
  drives <- system("powershell Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root", intern = TRUE)
  
  # Remove empty results
  drives <- drives[drives != ""]
  
  if (length(drives) == 0) return(NULL)
  return(drives)
}
