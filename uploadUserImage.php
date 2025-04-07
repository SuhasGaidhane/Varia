<?php
require_once 'db.php'; // Include database connection

// Define upload directory
$userImageDir = "UserImages/";

// Ensure directory exists
if (!is_dir($userImageDir)) {
    mkdir($userImageDir, 0777, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get form data
        $masterLoginId = $_POST['MasterLoginId'] ?? null;

        // Validate required fields
        if (empty($masterLoginId)) {
            echo json_encode(["status" => "error", "message" => "MasterLoginId is required"]);
            exit;
        }

        // Handle user image upload
        $userImagePath = null;
        if (!empty($_FILES['user_image']['name'])) {
            $fileExtension = pathinfo($_FILES['user_image']['name'], PATHINFO_EXTENSION);
            $userImageName = "user_{$masterLoginId}." . $fileExtension; // Name file based on MasterLoginId
            $userImagePath = $userImageDir . $userImageName;

            if (!move_uploaded_file($_FILES['user_image']['tmp_name'], $userImagePath)) {
                echo json_encode(["status" => "error", "message" => "Failed to upload user image"]);
                exit;
            }

            // Update database with new image path
            $stmt = $pdo->prepare("UPDATE masterlogin SET UserImage = :user_image WHERE MasterLoginId = :masterLoginId");
            $stmt->execute([
                'user_image' => $userImagePath,
                'masterLoginId' => $masterLoginId
            ]);

            echo json_encode(["status" => "success", "message" => "User image updated successfully", "image_path" => $userImagePath]);
        } else {
            echo json_encode(["status" => "error", "message" => "No image uploaded"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Database error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
