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

    // Check if the mobile number exists in the `masterlogin` table
    $stmt = $pdo->prepare("SELECT MasterLoginId FROM masterlogin WHERE MobileNumber = ?");
    $stmt->execute([$mobile_number]);

    if ($stmt->rowCount() > 0) {
        echo json_encode(["status" => "error", "message" => "User already exists"]);
        exit;
    }

    // Generate a random 4-digit OTP
    $otp = rand(1000, 9999);

    // Fast2SMS API URL
    $api_url = "https://www.fast2sms.com/dev/bulkV2";
    
    // API Parameters
    $params = [
        "authorization" => "uEXyjpio5NjLERWLSciOMnyk1s7MZ4qtdCoKehIiKXAgeXVJ5Xgad6E7sqiU",
        "route" => "q",
        "message" => "This is your OTP: $otp",
        "language" => "english",
        "flash" => "0",
        "numbers" => $mobile_number
    ];

    // Initialize cURL
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $api_url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($params));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "authorization: " . $params['authorization'], 
        "Content-Type: application/x-www-form-urlencoded"
    ]);
    

    // Execute API request
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    // Check API response
    if ($http_code == 200) {
        echo json_encode(["status" => "success", "message" => "OTP sent successfully", "otp" => $otp]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to send OTP", "response" => $response]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
