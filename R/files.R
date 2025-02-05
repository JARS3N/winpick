files <- function(multiple = TRUE, file_types = "All Files (*.*)|*.*", default_path = NULL) {
  ps_script <- tempfile(fileext = ".ps1")
  
  script_content <- sprintf('
  Add-Type -AssemblyName System.Windows.Forms
  $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $openFileDialog.Filter = "%s"
  $openFileDialog.Multiselect = $true  # Ensure multiple file selection
  $openFileDialog.InitialDirectory = "%s"

  if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
      $selectedFiles = $openFileDialog.FileNames | ForEach-Object { $_ -replace "\\\\", "/" }
      Write-Output ($selectedFiles -join "`n")
  } else {
      Write-Output ""
  }', file_types, default_path %||% "")
  
  writeLines(script_content, ps_script)
  files <- system(sprintf('powershell -File "%s"', ps_script), intern = TRUE)
  unlink(ps_script)  # Cleanup temp file
  
  files <- files[files != ""]  # Remove empty results
  if (length(files) == 0) return(NULL)
  return(files)
}
