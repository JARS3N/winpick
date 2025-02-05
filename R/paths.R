paths <- function() {
  # Get all directories from PATH
  path_dirs <- strsplit(Sys.getenv("PATH"), ";")[[1]]
  
  # Filter only valid directories
  path_dirs <- path_dirs[file.exists(path_dirs)]
  
  # List all executables in the directories
  executables <- unlist(lapply(path_dirs, function(dir) {
    list.files(dir, pattern = "\\.(exe|bat|cmd)$", ignore.case = TRUE, full.names = FALSE)
  }))
  
  # Remove duplicates and sort
  executables <- sort(unique(executables))
  
  if (length(executables) == 0) return(NULL)
  return(executables)
}
