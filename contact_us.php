<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get raw JSON input
    $inputData = json_decode(file_get_contents("php://input"), true);

    // Validate input
    if (!isset($inputData['full_name'], $inputData['mobile_number'], $inputData['email_address'], $inputData['message'])) {
        echo json_encode(["status" => "error", "code" => 400, "message" => "All fields are required"]);
        exit;
    }

    $fullName = trim($inputData['full_name']);
    $mobileNumber = trim($inputData['mobile_number']);
    $emailAddress = trim($inputData['email_address']);
    $message = trim($inputData['message']);
    $createdAt = date('Y-m-d H:i:s'); // Current timestamp

    try {
        // Insert into database
        $stmt = $pdo->prepare("
            INSERT INTO contact_us (full_name, mobile_number, email_address, message, created_at) 
            VALUES (:full_name, :mobile_number, :email_address, :message, :created_at)
        ");
        $stmt->execute([
            ':full_name' => $fullName,
            ':mobile_number' => $mobileNumber,
            ':email_address' => $emailAddress,
            ':message' => $message,
            ':created_at' => $createdAt
        ]);

        echo json_encode(["status" => "success", "code" => 200, "message" => "Your message has been submitted successfully!"]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Database error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
