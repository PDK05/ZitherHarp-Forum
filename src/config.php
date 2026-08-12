<?php
return [
    'database' => [
        'driver'    => 'mysql',
        'host'      => getenv('DB_HOST'),
        'port'      => getenv('DB_PORT') ?: '4000',
        'database'  => getenv('DB_DATABASE'),
        'username'  => getenv('DB_USERNAME'),
        'password'  => getenv('DB_PASSWORD'),
        'charset'   => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix'    => '',
        'strict'    => true,
        'engine'    => null,
        'options'   => [
            1002 => 'SET NAMES utf8mb4',
            // Sử dụng hằng số trực tiếp hoặc giá trị số cho PDO SSL CA nếu cần, hoặc cấu hình mảng SSL:
            PDO::MYSQL_ATTR_SSL_CA => '/var/www/html/isrgrootx1.pem',
            PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        ],
    ],
    'url' => 'https://zitherharp-forum.onrender.com',
    'paths' => [
        'api' => 'api',
        'admin' => 'admin',
    ],
];