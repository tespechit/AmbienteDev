#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sleep 3
clear
sudo apt install -y \
python3-pip \
build-essential \
git \
python3 \
python3-dev \
xclip \
xsel \
qt5-default \
libqt5webkit5-dev \
python-lxml \
xvfb
clear
sleep 3
sudo pip3 install --upgrade pip setuptools virtualenv virtualenvwrapper dryscrape beautifulsoup4
clear
echo "Baixar e instalar o Pycharm-community"
read -p '\nPressione qualquer tecla para continuar: ' q
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
echo /opt/pycharm-community-*
read -p '\nPressione qualquer tecla para continuar: ' q
versaoNova=`python3 ~/versao.py`
versaoVelha=`echo /opt/pycharm-community-* | sed "s/.*-//"`
if test ${versaoNova} != ${versaoVelha}; then
    wget -c https://download.jetbrains.com/python/pycharm-community-${versaoNova}.tar.gz
    sudo chmod +x pycharm-community-${versaoNova}.tar.gz
    sudo tar xvzf pycharm-community-${versaoNova}.tar.gz -C /opt/
    echo 'O Pycharm-community foi atualizado para a versão mais recente: Pycharm-community-'${versaoNova}
    echo /opt/pycharm-community-*
read -p '\nPressione qualquer tecla para continuar: ' q
    sudo rm -r ~/*.tar.gz
    sudo rm -r ~/versao.py
    sleep 3
    sudo rm -r /opt/pycharm-community-${versaoVelha}
    echo 'O Pycharm-community-'${versaoVelha}' foi removido com sucesso!'
    sleep 3
else
    echo 'Nenhuma alteração foi feita em no diretório /opt\nO Pycharm-community é a versão mais recente: Pycharm-community-'${versaoNova}
    sleep 3
fi
clear
read -p "Qual o nome do novo projeto? " novoProjeto
projeto=Projeto_${novoProjeto}
read -p "Qual o nome do ambiente virtual (virtualenv)? " venv
mkdir -p ~/PycharmProjects/${projeto}
cd ~/PycharmProjects/${projeto}
export projeto
clear
read -p "Novo projeto Kivy ou Django? k p/(Kivy), d p/(Django) ou c p/(cancela)  " opcao
if test $opcao = 'k' || test $opcao = 'K' || test $opcao = 'kivy' || test $opcao = 'Kivy' || test $opcao = 'KIVY'; then
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
    read -p "Se essa for a primeira instalação para um novo projeto Kivy escolha a opção 'sim' para configurar o ~/.bashrc.
    Primeiríssima vez como Kivy? S/N " primeira
    if test $primeira = 's' || test $primeira = 'S' || test $primeira = 'sim' || test $primeira = 'Sim' || test $primeira = 'SIM'; then 
        echo "export WORKON_HOME=$HOME/.virtualenvs
        export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
        export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
        source /usr/local/bin/virtualenvwrapper.sh
        
        " >> ~/.bashrc
        source ~/.bashrc
        cat ~/.bashrc
        read -p '\nPressione qualquer tecla para continuar: ' q
        clear
        virtualenv -p python3.5 $VIRTUALENVWRAPPER_HOOK_DIR/${venv}
        ativa=$VIRTUALENVWRAPPER_HOOK_DIR/${venv}/bin/activate
        export venv ativa
        . ${ativa}
        pip3 install cython==0.23
        pip3 install --upgrade numpy kivy pygame urllib3 beautifulsoup4 lxml html5lib kivy-garden jupyter dryscrape
        /opt/pycharm-community-*/bin/pycharm.sh ~/PycharmProjects/${projeto} &
        sleep 3
        jupyter notebook  ~/PycharmProjects/${projeto} &
        exit 0
        
    elif test $primeira = 'n' || test $primeira = 'N' || test $primeira = 'não' || test $primeira = 'Não' || test $primeira = 'NÃO' || test $primeira = 'nao' || test $primeira = 'Nao' || test $primeira = 'NAO'; then
        echo "A preparar o ambiente de desenvolvomento Kivy para o projeto: "${projeto}" no abiente" ${venv}
        virtualenv -p python3.5 $VIRTUALENVWRAPPER_HOOK_DIR/${venv}
        ativa=$VIRTUALENVWRAPPER_HOOK_DIR/${venv}/bin/activate
        export venv ativa
        . ${ativa}
        pip3 install cython==0.23
        pip3 install --upgrade numpy kivy pygame urllib3 beautifulsoup4 lxml html5lib kivy-garden jupyter dryscrape
        /opt/pycharm-community-*/bin/pycharm.sh ~/PycharmProjects/${projeto} &
        sleep 3
        jupyter notebook  ~/PycharmProjects/${projeto} &
        exit 0
    fi
elif test $opcao = 'c' || test $opcao = 'C' || test $opcao = 'cancela' || test $opcao = 'Cancela' || test $opcao = 'CANCELA'; then
    sudo rm -r ~/${projeto}
    exit 0
else
    echo 'opção inválida!'
fi
