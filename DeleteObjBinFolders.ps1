# PowerShell script that recursively deletes all 'bin' and 'obj' (or any other specified) folders inside current folder

$CurrentPath = (Get-Location -PSProvider FileSystem).ProviderPath
Write-Host "Please wait while searching for 'bin' and 'obj' folders to remove in $CurrentPath and it's subdirectories."

# recursively get all folders matching given includes, except ignored folders
$FoldersToRemove = @();

Write-Host "`rCurrently searching... So far we've found:"$FoldersToRemove.Count"to be removed." -NoNewline

Get-ChildItem .\ -include bin,obj -Recurse | Where-Object {$_ -notmatch '_tools' -and $_ -notmatch '_build' -and $_ -notmatch 'node_modules' -and $_ -notmatch 'packages'} | ForEach-Object {
	Write-Host "`rCurrently searching... So far we've found:"$FoldersToRemove.Count"folders to be removed." -NoNewline
	$FoldersToRemove += $_.fullname;
}

if($null -ne $FoldersToRemove)
{
	Write-Host "`rSearch completed, found:"$FoldersToRemove.Count"folders to be removed.                         " -foregroundcolor green
}
else {
	Read-Host "`rNo folders to remove, press enter to exit." -foregroundcolor green
	Exit
}

# remove folders and print to output
if($null -ne $FoldersToRemove)
{			
    Write-Host 
	foreach ($item in $FoldersToRemove) 
	{ 
		Remove-Item $item -Force -Recurse;
		Write-Host "Removed: ." -nonewline; 
		Write-Host $item.replace($CurrentPath, ""); 
	} 
}

Write-Host 
Write-Host "Removed"$FoldersToRemove.Count"folders." -foregroundcolor green
# prevent closing the window immediately
Read-Host "Clean up completed, press enter to exit."
