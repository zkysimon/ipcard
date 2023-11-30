# 使用官方 PHP 镜像作为基础镜像
FROM php:7.4-apache

# 安装gd库，以解决libpng警告
RUN apt-get update && \
    apt-get install -y libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# 安装FreeType库，以解决imagettftext()函数问题
RUN apt-get install -y libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ && \
    docker-php-ext-install gd

# 将当前目录中的所有文件复制到容器的 /var/www/html 目录下
COPY . /var/www/html

# 设置工作目录
WORKDIR /var/www/html

# 安装依赖，例如你的应用可能需要的扩展
# RUN docker-php-ext-install pdo_mysql

# 如果有其他依赖或配置文件，可以在这里添加

# 暴露 Apache 默认端口
EXPOSE 80

# 启动 Apache 服务器
CMD ["apache2-foreground"]
