function Join-Markdowns ($Title, $Path, $OutputFile, [switch] $Overwrite) {
	$MdFiles = Get-ChildItem -Path $Path -Filter *.md -Recurse
	if ($MdFiles.Count -eq 0) {
		Write-Host "No markdown files found in the specified path."
		return
	}
	if (Test-Path -Path $OutputFile) {
		if ($Overwrite) {
			Remove-Item -Path $OutputFile
			Write-Information "Existing output file has been overwritten."
		} else {
			Write-Host "Output file already exists. Please choose a different name or use the -Overwrite switch to overwrite the existing file."
			return
		}
	}
	$OutputContent = "# $Title`n`n"
	foreach ($File in $MdFiles) {
		$Content = "(File: $(Split-Path -Path $File -Leaf))`n`n"
		foreach ($Line in Get-Content -Path $File.FullName) {
			# Convert heading levels by adding one more '#' to each heading
			if ($Line -match '^(#+)\s') {
				$Content += "#$Line`n"
			} else {
				$Content += "$Line`n"
			}
		}
		$OutputContent += $Content + "`n" # Add a newline between files
	}
	Set-Content -Path $OutputFile -Value $OutputContent
	Write-Host "Markdown files have been successfully joined into $OutputFile"
}