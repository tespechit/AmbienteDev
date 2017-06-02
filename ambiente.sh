#!/bin/bash
clear
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

clear
## dependências para o sistema
sudo apt install -y \
build-essential \
git \
xclip \
xsel \
qt5-default \
libqt5webkit5-dev \
python-lxml \
xvfb \
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

sudo pip3 install --upgrade pip setuptools dryscrape beautifulsoup4
clear
echo "Baixar e instalar o Pycharm-community"
# read -p 'Pressione qualquer tecla para continuar: ' q
touch /tmp/versao.py
echo '
import dryscrape
from bs4 import BeautifulSoup
session = dryscrape.Session()
session.visit("http://www.jetbrains.com/pycharm/download/#section=linux")
response = session.body()
bsObj = BeautifulSoup(response, "lxml")
print(bsObj.findAll("ul", class_="g-col-12 _md-6 _sm-12 download__list-details").__str__()[118:126])
' > /tmp/versao.py
clear
versaoNova=`python3 /tmp/versao.py`
versaoVelha=`echo /opt/pycharm-community-* | sed "s/.*-//"`
# read -p 'Pressione qualquer tecla para continuar: ' q
if test ${versaoNova} != ${versaoVelha}; then
    wget -c -q -P /tmp/ https://download.jetbrains.com/python/pycharm-community-${versaoNova}.tar.gz
    wget -c -q -P /tmp/  https://github.com/Zen-CODE/kivybits/blob/master/IDE/PyCharm_kv_completion.jar
    sudo chmod +x /tmp/pycharm-community-${versaoNova}.tar.gz
    sudo chmod +x /tmp/PyCharm_kv_completion.jar
    sudo tar xvzf /tmp/pycharm-community-${versaoNova}.tar.gz -C /opt/
    
    echo 'O Pycharm-community foi atualizado para a versão mais recente: Pycharm-community-'${versaoNova}
    echo /opt/pycharm-community-*
# read -p 'Pressione qualquer tecla para continuar: ' q
    sudo rm -r /tmp/*.tar.gz
    sudo rm -r /tmp/versao.py
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
# read -p "Qual o nome do ambiente virtual (virtualenv)? " venv
# mkdir -p ~/PycharmProjects/${projeto}/src/{model/bd,view/tela,controller/logica}
mkdir -p ~/PycharmProjects/${projeto}/src/model/bd
mkdir -p ~/PycharmProjects/${projeto}/src/view/tela
mkdir -p ~/PycharmProjects/${projeto}/src/controller/logica

touch ~/PycharmProjects/${projeto}/src/main.py
echo "
import kivy
kivy.require('1.7.0')

import src.myApp as app

if __name__ == '__main__':
    app.MyApp().run()
" >> ~/PycharmProjects/${projeto}/src/main.py
cd ~/PycharmProjects/${projeto}
touch ~/PycharmProjects/${projeto}/src/myApp.py
echo "
import kivy
kivy.require('1.7.0')

from kivy.app import App
from kivy.uix.button import Button

class MyApp(App):
    title = 'Minha App'

    def build(self):
        return Button(text='Olá mundo!')

" >> ~/PycharmProjects/${projeto}/src/myApp.py
export projeto
clear
    
clear
echo "A preparar o ambiente de desenvolvomento Kivy para o projeto: "${projeto}" no abiente" ${novoProjeto}_venv
# read -p 'Pressione qualquer tecla para continuar: ' q
virtualenv -p python3.5 $VIRTUALENVWRAPPER_HOOK_DIR/${novoProjeto}_venv
ativa=$VIRTUALENVWRAPPER_HOOK_DIR/${novoProjeto}_venv/bin/activate
export venv ativa
. ${ativa}
pip3 install cython==0.23
pip3 install --upgrade numpy kivy pygame urllib3 beautifulsoup4 lxml html5lib kivy-garden jupyter dryscrape
/opt/pycharm-community-*/bin/pycharm.sh ~/PycharmProjects/${projeto} &
# sleep 3
jupyter notebook  ~/PycharmProjects/${projeto} &
exit 0
