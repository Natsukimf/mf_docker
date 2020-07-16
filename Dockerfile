FROM ubuntu:latest
# FROM gcr.io/kaggle-images/python:v79

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    vim
WORKDIR /opt
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.02-Linux-x86_64.sh &&  \
    sh Anaconda3-2020.02-Linux-x86_64.sh  -b -p /opt/anaconda3 && \
    rm -f Anaconda3-2020.02-Linux-x86_64.sh

ENV PATH /opt/anaconda3/bin:$PATH

RUN pip install --upgrade pip

# mecab
RUN apt-get install -y mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

# インタラクティブな可視化ツールplotlyを使うため、Node.jsをインストール
RUN conda install nodejs
# ライブラリの追加はよくありそうなので、下の方に書いている方がベター
COPY requirements.txt ./
RUN pip install -r requirements.txt

WORKDIR /
CMD ["jupyter","lab","--ip=0.0.0.0","--allow-root","--LabApp.token=''"]