export def main [tag:string = "nightly"] {
  let installer_name = "nvim-win64.msi"
  let installer_path = ($env.TMP)\\($installer_name)

  http get https://github.com/neovim/neovim/releases/download/($tag)/($installer_name)
  | save -f $installer_path
  msiexec /i $installer_path /passive
}
