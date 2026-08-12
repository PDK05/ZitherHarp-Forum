<?php
use Flarum\User\User;
use Illuminate\Contracts\Container\Container;

// Khởi động ứng dụng Flarum
require 'vendor/autoload.php';
$app = require 'bootstrap/app.php';

$container = $app->make(Container::class);
$bootstrapper = $container->make('Flarum\Foundation\Application');
$bootstrapper->boot();

// Lấy thông tin tài khoản từ biến môi trường trên Render
$username = getenv('ADMIN_USERNAME');
$email = getenv('ADMIN_EMAIL');
$password = getenv('ADMIN_PASSWORD');

// Kiểm tra xem biến môi trường có tồn tại không
if (!$username || !$email || !$password) {
    die("Lỗi: Bạn chưa thiết lập đầy đủ các biến môi trường ADMIN_USERNAME, ADMIN_EMAIL, hoặc ADMIN_PASSWORD trên Render!");
}

$user = User::register($username, $email, $password);
$user->is_email_confirmed = true;
$user->save();

// Gán quyền Admin (Group ID = 1 là Administrator)
$user->groups()->attach(1);

echo "Đã tạo thành công tài khoản quản trị: $username";