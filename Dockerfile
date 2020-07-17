FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    git\
    curl\
    make \
    xz-utils \
    file \
    vim
WORKDIR /opt
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.02-Linux-x86_64.sh &&  \
    sh Anaconda3-2020.02-Linux-x86_64.sh  -b -p /opt/anaconda3 && \
    rm -f Anaconda3-2020.02-Linux-x86_64.sh

ENV PATH /opt/anaconda3/bin:$PATH

RUN pip install --upgrade pip

# mecabの環境設定
RUN apt-get install -y mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y

RUN sudo cp /etc/mecabrc /usr/local/etc/
# インタラクティブな可視化ツールplotlyを使うため、Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
    && sudo apt-get install -y nodejs
RUN conda install nodejs
RUN conda install -c conda-forge jupyterlab-plotly-extension
# ライブラリの追加はよくありそうなので、下の方に書いている方がベター
COPY requirements.txt ./
RUN pip install -r requirements.txt

WORKDIR /
CMD ["jupyter","lab","--ip=0.0.0.0","--allow-root","--LabApp.token=''"]