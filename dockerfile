FROM php:8.2-apache

# Cài đặt các extension cần thiết
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

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Sao chép mã nguồn vào container
COPY src /var/www/html

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Chạy composer install
RUN composer install --no-dev --prefer-dist --optimize-autoloader

# Trỏ Apache vào thư mục public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# CẤU HÌNH QUAN TRỌNG: Tạo thư mục và phân quyền
# Chúng ta tạo thư mục storage và assets trước khi phân quyền để tránh lỗi "No such file"
RUN mkdir -p /var/www/html/storage /var/www/html/public/assets \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/public/assets

# Mở cổng 80
EXPOSE 80