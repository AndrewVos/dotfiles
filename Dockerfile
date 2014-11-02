FROM ubuntu

RUN apt-get -y update
RUN apt-get -y install vim
RUN apt-get -y install git
RUN apt-get -y install zsh

ADD . /vimfiles
RUN cd /vimfiles && ./install.sh

WORKDIR /src

CMD /bin/zsh -i
