# 使用官方 PHP 镜像作为基础镜像
FROM php:7.4-apache

# 将当前目录下的所有文件复制到容器的 /var/www/html 目录下
COPY . /var/www/html

# 安装一些依赖库和工具
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip \
    && a2enmod rewrite \
    && echo 'gd.jpeg_ignore_warning = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-gd.ini

# 设置 Apache 配置，启用 .htaccess 文件
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# 如果你的应用需要一些环境变量，可以在这里设置
# ENV EXAMPLE_VAR=value

# 暴露 Apache 端口
EXPOSE 80

# 定义容器启动时执行的命令
CMD ["apache2-foreground"]
