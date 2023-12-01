# 使用 PHP 7.4-Apache 镜像
FROM php:7.4-apache

# 安装 GD 库及其依赖项
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd

RUN echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p

# 将当前目录中的所有文件复制到容器的 /var/www/html 目录下
COPY . /var/www/html

# 设置工作目录
WORKDIR /var/www/html

# 拷贝 Apache 配置文件，确保加载 GD 扩展
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# 暴露 Apache 默认端口
EXPOSE 80

# 启动 Apache 服务器
CMD ["apache2-foreground"]
