dirs <- function(default_path = NULL) {
  ps_script <- tempfile(fileext = ".ps1")
  
  script_content <- sprintf('
  Add-Type -AssemblyName System.Windows.Forms
  $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
  $folderBrowser.Description = "Select a folder"
  $folderBrowser.SelectedPath = "%s"

  if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
      $selectedFolder = $folderBrowser.SelectedPath -replace "\\\\", "/"
      Write-Output $selectedFolder
  } else {
      Write-Output ""
  }', default_path %||% "")
  
  writeLines(script_content, ps_script)
  folder <- system(sprintf('powershell -File "%s"', ps_script), intern = TRUE)
  unlink(ps_script)  # Cleanup temp file
  
  folder <- folder[folder != ""]
  if (length(folder) == 0) return(NULL)
  return(folder)
}
