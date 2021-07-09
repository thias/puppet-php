Facter.add(:ubuntu_release) do
  setcode "lsb_release -r | awk '/^Release:/ {print $2}'"
end
