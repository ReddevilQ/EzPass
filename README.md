# EzPass
A simple way to use 2 passwords at the same time one long for First Login and one for After First Login. plan is to have the passwords secure in KeePass XC


Requeierments 
  KeePassxc-cli 
  chpasswd


Have a keepassxc db with the 2 passwords make sure to not have a passoword only a Key-file

## Install
echo "alias shutdown="~/Git/EzPass/HardPass.sh && shutdown now"" >> ~/.zshrc
mv EzPass.sh /usr/local/bin/
mv EzPass.service /etc/systemd/system/
systemctl enable EzPass.service
sudo systemctl daemon-reload    
