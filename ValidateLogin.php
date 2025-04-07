<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get JSON input
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate required fields
    $requiredFields = ['MobileNumber', 'OTP'];
    foreach ($requiredFields as $field) {
        if (empty($data[$field])) {
            echo json_encode([
                "status" => "error",
                "code" => 400, // HTTP status code for Bad Request
                "method" => $_SERVER['REQUEST_METHOD'],
                "message" => "Missing field: $field"
            ]);
            exit;
        }
    }

    try {
        // Step 1: Check if the mobile number exists in the system
        $stmt = $pdo->prepare("SELECT * FROM MasterLogin WHERE MobileNumber = :MobileNumber");
        $stmt->execute(['MobileNumber' => $data['MobileNumber']]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            // Step 2: Validate OTP
            if ($user['VerificationCode'] === $data['OTP']) {
                // Step 3: Update IsVerified field to 1 (verified)
                $updateStmt = $pdo->prepare("UPDATE MasterLogin SET IsVerified = 1 WHERE MobileNumber = :MobileNumber");
                $updateStmt->execute(['MobileNumber' => $data['MobileNumber']]);

                // Step 4: Return success message
                echo json_encode([
                    "status" => "success",
                    "code" => 200, // HTTP status code for OK
                    "method" => $_SERVER['REQUEST_METHOD'],
                    "message" => "User verified and logged in successfully.",
                    "data" => [
                        "MasterLoginId" => $user['MasterLoginId'],
                        "FullName" => $user['FullName'],
                        "MobileNumber" => $user['MobileNumber'],
                        "MasterDistrictId" => $user['MasterDistrictId'],
                        "MasterCityId" => $user['MasterCityId'],
                        "Pincode" => $user['Pincode'],
                        "ModifiedDate" => $user['ModifiedDate']
                    ]
                ]);
            } else {
                // Invalid OTP
                echo json_encode([
                    "status" => "error",
                    "code" => 401, // HTTP status code for Unauthorized
                    "method" => $_SERVER['REQUEST_METHOD'],
                    "message" => "Invalid OTP. Please try again."
                ]);
            }
        } else {
            // Mobile number does not exist
            echo json_encode([
                "status" => "error",
                "code" => 404, // HTTP status code for Not Found
                "method" => $_SERVER['REQUEST_METHOD'],
                "message" => "Mobile number does not exist. Please register first."
            ]);
        }
    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "code" => 500, // HTTP status code for Internal Server Error
            "method" => $_SERVER['REQUEST_METHOD'],
            "message" => "Failed to validate login: " . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "code" => 405, // HTTP status code for Method Not Allowed
        "method" => $_SERVER['REQUEST_METHOD'],
        "message" => "Invalid request method"
    ]);
}
?>
