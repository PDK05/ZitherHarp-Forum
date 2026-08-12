<?php
return [
    'database' => [
        'driver'    => 'mysql',
        'host'      => 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
        'port'      => '4000',
        'database'  => 'zitherharp_forum_db',
        // Đọc giá trị từ biến môi trường của hệ thống
        'username'  => getenv('DB_USERNAME'),
        'password'  => getenv('DB_PASSWORD'),
        'charset'   => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix'    => '',
        'strict'    => true,
        'engine'    => null,
        'options'   => [
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