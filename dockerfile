FROM php:8.2-apache

# Cài đặt các extension PHP cần thiết và git/unzip để Composer hoạt động
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip

# Bật module Apache Rewrite cho Flarum
RUN a2enmod rewrite

# Cài đặt Composer phiên bản mới nhất
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Sao chép toàn bộ mã nguồn (ngoại trừ vendor vì đã chặn ở .gitignore) vào container
COPY src /var/www/html

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Tự động chạy Composer install để tải thư mục vendor trực tiếp trên server Render khi build
RUN composer install --no-dev --prefer-dist --optimize-autoloader

# Trỏ thư mục gốc của Apache vào thư mục public của Flarum
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# Phân quyền ghi cho thư mục lưu trữ và cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/public/assets

# Mở cổng 80 cho web server
EXPOSE 80