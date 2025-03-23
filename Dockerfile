# PHP + FPM（高速化のためにApacheなし）
FROM php:8.2-fpm

# システムのアップデート＆必要パッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo_mysql

# Composer をインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 作業ディレクトリを設定
WORKDIR /var/www

# ソースコードをコピー
COPY . /var/www

# Laravel の権限設定
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Laravel の依存関係をインストール
RUN composer install --no-dev --optimize-autoloader

# PHP-FPM を起動
CMD ["php-fpm"]
