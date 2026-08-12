FROM php:8.2-apache

RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip

RUN a2enmod rewrite
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

# Tạo đầy đủ các thư mục con bên trong storage và assets, sau đó phân quyền toàn diện cho www-data
RUN mkdir -p /var/www/html/src/storage/logs \
    && mkdir -p /var/www/html/src/storage/formatter \
    && mkdir -p /var/www/html/src/storage/cache \
    && mkdir -p /var/www/html/src/public/assets \
    && chown -R www-data:www-data /var/www/html/src/storage /var/www/html/src/public/assets \
    && chmod -R 775 /var/www/html/src/storage /var/www/html/src/public/assets

# Cấu hình Apache trỏ đúng vào src/public
ENV APACHE_DOCUMENT_ROOT /var/www/html/src/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

RUN echo '<Directory /var/www/html/src/public>\n\
    Options -Indexes +FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
    DirectoryIndex index.php\n\
</Directory>' >> /etc/apache2/apache2.conf

EXPOSE 80