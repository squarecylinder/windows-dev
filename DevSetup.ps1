$apps = @(
        @{name = "Git.Git"},
        @{name = "PostgreSQL.PostgreSQL.17"},
        @{name = "Neovim.Neovim"},
        @{name = "junegunn.fzf"},
        @{name = "JesseDuffield.lazygit"},
        @{name = "DEVCOM.JetBrainsMonoNerdFont"}
        );

Write-host "Winget dev deps"
Foreach ($app in $apps) {
#Check if already wingotted
    $listApp = winget list --exact -q $app.name
        if (![String]::join("", $listApp).Contains($app.name)){
            Write-host "Installing:" $app.name
                if($app.source -ne $null) {
                    winget install --exact --silent $app.name --source $app.source --accept-package-agreements
                }
                else {
                    winget install --exact --silent $app.name --accept-package-agreements
                }
        }
        else {
            Write-host "Skipping Install of" $app.name "already WinGotted"
        }
}

Write-host "Check for Elixir/OTP install"

$paths = $env:PATH -split ";"
$isElixirOTPInstalled = $false

function CheckPath
{
    foreach ($path in $paths) {
        if($path.ToLower().Contains("elixir") -or $path.ToLower().Contains("Erlang")) {
            return $true
        }
    }
}
$isElixirOTPInstalled = CheckPath

if($isElixirOTPInstalled){
    Write-host "Elixir/OTP is installed"
}
else {
    Write-host "Elixir/OTP not installed"
        $installEOTP = Read-host "Try to install Elixir/OTP? [Y]es or [N]"
        if($installEOTP.ToLower() -eq "y"){
            Write-host "Trying to install Elixir from curl"
                try {
                    curl.exe -fsSO https://elixir-lang.org/install.bat
                        .\install.bat elixir@1.18.2 otp@27.1.2
                        $installs_dir = "$env:USERPROFILE\.elixir-install\installs"
                        $env:PATH = "$installs_dir\otp\27.1.2\bin;$env:PATH"
                        $env:PATH = "$installs_dir\elixir\1.18.2-otp-27\bin;$env:PATH"
                }
            catch {
                Write-host "Could not install Elixir"
            }
        }
        else {
                Write-host "Skipping Elixir install, re-run this script if you wanted to install it -\_(~-~)_/-"
            }
}
Write-host "I grab my .dotfiles from https://github.com/DoggettCK/dotfiles, mans a 1e10x dev"

