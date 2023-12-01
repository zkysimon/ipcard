# 第一阶段，用于安装构建依赖项
FROM php:7.4-apache AS builder

# 安装依赖项和GD扩展
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd

RUN php -v

# 第二阶段，用于构建最终镜像
FROM php:7.4-apache

# 从第一阶段拷贝必要的文件
COPY --from=builder /usr/lib/x86_64-linux-gnu/ /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/include/freetype2/ /usr/include/freetype2/
COPY gd.ini /usr/local/etc/php/conf.d/gd.ini

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
