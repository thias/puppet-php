# Gets the directory where PHP modules are stored. Requires PHP
# to be installed.
Facter.add("php_extension_dir") do
  setcode do
    if File.exist? "/usr/bin/php"
      Facter::Util::Resolution.exec('php -r "echo ini_get(\'extension_dir\');"')
    else
      if Facter.value("architecture") == "x86_64"
        "/usr/lib64/php/modules"
      else
        "/usr/lib/php/modules"
      end
    end
  end
end