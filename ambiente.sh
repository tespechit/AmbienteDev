#!/bin/bash
clear
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

clear
sudo apt install -y \
build-essential \
git \
xclip \
xsel \
qt5-default \
libqt5webkit5-dev \
python-lxml \
xvfb
clear

sudo pip3 install --upgrade pip setuptools dryscrape beautifulsoup4
clear
echo "Baixar e instalar o Pycharm-community"
# read -p 'Pressione qualquer tecla para continuar: ' q
touch ~/versao.py
echo '
import dryscrape
from bs4 import BeautifulSoup
session = dryscrape.Session()
session.visit("http://www.jetbrains.com/pycharm/download/#section=linux")
response = session.body()
bsObj = BeautifulSoup(response, "lxml")
print(bsObj.findAll("ul", class_="g-col-12 _md-6 _sm-12 download__list-details").__str__()[118:126])
' > ~/versao.py
clear
cat ~/versao.py
versaoNova=`python3 ~/versao.py`
echo 'Versão nova: '${versaoNova}
versaoVelha=`echo /opt/pycharm-community-* | sed "s/.*-//"`
echo 'versão velha: '${versaoVelha}
# read -p 'Pressione qualquer tecla para continuar: ' q
if test ${versaoNova} != ${versaoVelha}; then
    wget -c https://download.jetbrains.com/python/pycharm-community-${versaoNova}.tar.gz
    sudo chmod +x pycharm-community-${versaoNova}.tar.gz
    sudo tar xvzf pycharm-community-${versaoNova}.tar.gz -C /opt/
    echo 'O Pycharm-community foi atualizado para a versão mais recente: Pycharm-community-'${versaoNova}
    echo /opt/pycharm-community-*
# read -p 'Pressione qualquer tecla para continuar: ' q
    sudo rm -r ~/*.tar.gz
    sudo rm -r ~/versao.py
    # sleep 3
    sudo rm -r /opt/pycharm-community-${versaoVelha}
    echo 'O Pycharm-community-'${versaoVelha}' foi removido com sucesso!'
    # read -p 'Pressione qualquer tecla para continuar: ' q
    # sleep 3
else
    echo 'Nenhuma alteração foi feita em no diretório /opt
    O Pycharm-community é a versão mais recente\n: Pycharm-community-'${versaoNova}
    # sleep 3
fi
clear
read -p "Qual o nome do novo projeto? " novoProjeto
projeto=Projeto_${novoProjeto}
read -p "Qual o nome do ambiente virtual (virtualenv)? " venv
mkdir -p ~/PycharmProjects/${projeto}
cd ~/PycharmProjects/${projeto}
export projeto
clear

sudo apt install -y \
mercurial \
ffmpeg \
libsdl1.2-dev \
libsdl2-dev \
libsmpeg-dev \
libsdl-image1.2-dev \
libsdl2-image-dev \
libsdl-mixer1.2-dev \
libsdl2-mixer-dev \
libsdl-ttf2.0-dev \
libsdl2-ttf-dev \
libportmidi-dev \
libswscale-dev \
libavformat-dev \
libavcodec-dev \
zlib1g-dev    
clear
echo "A preparar o ambiente de desenvolvomento Kivy para o projeto: "${projeto}" no abiente" ${venv}
# read -p 'Pressione qualquer tecla para continuar: ' q
virtualenv -p python3.5 $VIRTUALENVWRAPPER_HOOK_DIR/${venv}
ativa=$VIRTUALENVWRAPPER_HOOK_DIR/${venv}/bin/activate
export venv ativa
. ${ativa}
pip3 install cython==0.23
pip3 install --upgrade numpy kivy pygame urllib3 beautifulsoup4 lxml html5lib kivy-garden jupyter dryscrape
/opt/pycharm-community-*/bin/pycharm.sh ~/PycharmProjects/${projeto} &
# sleep 3
jupyter notebook  ~/PycharmProjects/${projeto} &
exit 0
