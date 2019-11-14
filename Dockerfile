FROM php:7.2-cli

MAINTAINER Daniel Wolf <daniel.wolf@8mylez.com>

# Add dir to prevent bug when installing packages
RUN mkdir -p /usr/share/man/man1

RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libicu-dev \
    zlib1g-dev \
    jpegoptim \
    pngcrush \
    guetzli \ 
    optipng \
    libjpeg-progs \
    default-jre-headless \
    build-essential \
    mariadb-server \
    mariadb-client \
    default-libmysqlclient-dev \
    && docker-php-ext-install -j$(nproc) iconv pdo pdo_mysql zip bcmath intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install calendar && docker-php-ext-configure calendar

# Install ant manually to get version 1.9.4 to prevent a bug while building shopware
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz
RUN tar -xf apache-ant-1.9.4-bin.tar.gz
RUN mv apache-ant-1.9.4 /opt/ant
RUN sh -c 'echo ANT_HOME=/opt/ant >> /etc/environment'
RUN ln -s /opt/ant/bin/ant /usr/bin/ant 

COPY clone-shopware /usr/local/bin/

# Set correct rights to make the file executable
RUN chmod +x /usr/local/bin/clone-shopware