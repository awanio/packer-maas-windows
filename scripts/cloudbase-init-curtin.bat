if not exist "C:\Windows\Temp\7z1900-x64.msi" (
	    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; (New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z1900-x64.msi', 'C:\Windows\Temp\7z1900-x64.msi')" <NUL
    )
    msiexec /qb /i C:\Windows\Temp\7z1900-x64.msi

    if not exist "C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi" (
	    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; (New-Object System.Net.WebClient).DownloadFile('http://%HTTPIP%:%HTTPPort%/CloudbaseInitSetup_Stable_x64.msi', 'C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi')" <NUL
	)

	msiexec /i C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi /qn /l*v log.txt

	pushd C:\Windows\Temp
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; (New-Object System.Net.WebClient).DownloadFile('http://%HTTPIP%:%HTTPPort%/windows-curtin-hooks/tarball/master', 'C:\Windows\Temp\windows-curtin-hooks.tgz')" <NUL
	cmd /c ""C:\Program Files\7-Zip\7z.exe" x windows-curtin-hooks.tgz"
	cmd /c ""C:\Program Files\7-Zip\7z.exe" x windows-curtin-hooks.tar"
	pushd cloudbase-windows-curtin-hooks-bb30d56
	xcopy curtin C:\curtin /E /H /C /I

	msiexec /qb /x C:\Windows\Temp\7z1900-x64.msi

	powershell -Command "(gc 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf') -replace 'username=Admin', 'username=Administrator' | Out-File -encoding ASCII 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf'"
	powershell -Command "(gc 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init-unattend.conf') -replace 'username=Admin', 'username=Administrator' | Out-File -encoding ASCII 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init-unattend.conf'"
