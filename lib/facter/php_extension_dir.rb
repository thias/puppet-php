# Gets the directory where PHP modules are stored. Requires PHP
# to be installed.
Facter.add("php_extension_dir") do
  setcode do
    Facter::Util::Resolution.exec('php -r "echo ini_get(\'extension_dir\');"')
  end
end