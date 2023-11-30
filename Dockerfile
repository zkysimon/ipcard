# 第一阶段，用于安装构建依赖项
FROM php:7.4-apache AS builder

RUN apt-get update && \
    apt-get install -y libpng-dev zlib1g-dev libjpeg-dev libfreetype6-dev

# 其他构建步骤，比如安装GD库等
RUN docker-php-ext-install gd

# 第二阶段，用于构建最终镜像
FROM php:7.4-apache

# 从第一阶段拷贝必要的文件
COPY --from=builder /usr/lib/x86_64-linux-gnu/ /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/include/freetype2/ /usr/include/freetype2/

# 将当前目录中的所有文件复制到容器的 /var/www/html 目录下
COPY . /var/www/html

# 设置工作目录
WORKDIR /var/www/html

# 暴露 Apache 默认端口
EXPOSE 80

# 启动 Apache 服务器
CMD ["apache2-foreground"]
