FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

RUN apt-get update &&  apt-get install -y curl build-essential software-properties-common apt-utils tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Setup Node with NVM v 0.35.3
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

# Set additional software
RUN npm install -g pm2

RUN apt-get update && apt-get install -y clang g++-multilib gcc-multilib git libasound2-dev libaudit1 libc6 libcap-dev libcups2-dev libdbus-1-dev libgconf-2-4 libgconf2-dev  libgl1-mesa-dri libgl1-mesa-glx libglu1-mesa libgnome-keyring-dev libgtk2.0-0 libgtk2.0-dev libgtk-3-0 libnotify-dev libnss3 libnss3-dev libpixman-1-0 libselinux1 libxau6 libxdmcp6 libxpm4 libxrender1 libxss1 libxtst-dev sudo x11-apps x11-xkb-utils x11-xserver-utils xauth xfonts-100dpi xfonts-75dpi xfonts-base xfonts-cyrillic xfonts-scalable xserver-common xterm xvfb

WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ./package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY ./ .

EXPOSE 8080

CMD [ "pm2-runtime", "start", "server.js" ]