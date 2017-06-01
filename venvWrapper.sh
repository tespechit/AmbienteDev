#!/bin/bash
touch /tmp/atualiza.sh
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
sudo apt install python3-pip python3 python3-dev -y

echo '
#!/bin/bash
sudo pip3 install --upgrade pip virtualenvwrapper virtualenv
echo "
# configuração das variáveis de ambiente para o virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
source /usr/local/bin/virtualenvwrapper.sh
" >> ~/.bashrc
source ~/.bashrc
cat ~/.bashrc
quit=`pidof gnome-terminal-server`
kill ${quit}' > /tmp/atualiza.sh
nohup bash /tmp/atualiza.sh &

