<?php
require_once 'db.php'; // Include database connection

// Define upload directories
$firmImageDir = "FirmImages/";
$firmOwnerImageDir = "FirmOwnerImages/";

// Ensure directories exist
if (!is_dir($firmImageDir)) {
    mkdir($firmImageDir, 0777, true);
}
if (!is_dir($firmOwnerImageDir)) {
    mkdir($firmOwnerImageDir, 0777, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get Firm ID (Required)
        $masterFirmId = $_POST['masterFirmId'] ?? null;
        if (empty($masterFirmId)) {
            echo json_encode(["status" => "error", "message" => "Firm ID is required"]);
            exit;
        }

        // Initialize the update query
        $updateFields = [];
        $params = ["masterFirmId" => $masterFirmId];

        // Define allowed fields for update
        $allowedFields = [
            "shop_name", "proprieter_name", "address", "city",
            "taluka_id", "district_id", "mobile", "email", "gst", "mfms"
        ];

        // Process text fields dynamically
        foreach ($allowedFields as $field) {
            if (!empty($_POST[$field])) {
                $updateFields[] = "$field = :$field";
                $params[$field] = $_POST[$field];
            }
        }

        // Handle firm image upload (optional)
        if (!empty($_FILES['firm_image']['name'])) {
            $firmImageName = time() . "_" . basename($_FILES['firm_image']['name']);
            $firmImagePath = $firmImageDir . $firmImageName;

            if (move_uploaded_file($_FILES['firm_image']['tmp_name'], $firmImagePath)) {
                $updateFields[] = "firm_image = :firm_image";
                $params['firm_image'] = $firmImagePath;
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to upload firm image"]);
                exit;
            }
        }

        // Handle firm owner image upload (optional)
        if (!empty($_FILES['firm_owner_image']['name'])) {
            $firmOwnerImageName = time() . "_" . basename($_FILES['firm_owner_image']['name']);
            $firmOwnerImagePath = $firmOwnerImageDir . $firmOwnerImageName;

            if (move_uploaded_file($_FILES['firm_owner_image']['tmp_name'], $firmOwnerImagePath)) {
                $updateFields[] = "firmOwnerImage = :firmOwnerImage";
                $params['firmOwnerImage'] = $firmOwnerImagePath;
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to upload firm owner image"]);
                exit;
            }
        }

        // If no fields are provided, return an error
        if (empty($updateFields)) {
            echo json_encode(["status" => "error", "message" => "No data provided for update"]);
            exit;
        }

        // Construct the final SQL query
        $updateQuery = "UPDATE masterfirm SET " . implode(", ", $updateFields) . " WHERE masterFirmId = :masterFirmId";

        // Execute the update query
        $stmt = $pdo->prepare($updateQuery);
        $stmt->execute($params);

        echo json_encode(["status" => "success", "message" => "Firm details updated successfully"]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Failed to update firm: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
