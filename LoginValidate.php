<?php
require_once("db.php");

if (!$pdo) {
    die(json_encode(["status" => "error", "message" => "Database connection is not established."]));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get JSON input
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['mobile_number'])) {
        echo json_encode(["status" => "error", "message" => "Mobile number is required"]);
        exit;
    }

    $mobile_number = $data['mobile_number'];

    // Fetch full user details based on mobile number
    $stmt = $pdo->prepare("SELECT * FROM masterlogin WHERE MobileNumber = ?");
    $stmt->execute([$mobile_number]);

    if ($stmt->rowCount() > 0) {
        $user_data = $stmt->fetch(PDO::FETCH_ASSOC);
        echo json_encode(["status" => "success", "data" => $user_data]);
    } else {
        echo json_encode(["status" => "error", "message" => "User not found"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
