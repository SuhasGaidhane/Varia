<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $masterLoginId = isset($_GET['masterLoginId']) ? intval($_GET['masterLoginId']) : null;

    if (!$masterLoginId) {
        echo json_encode(["status" => "error", "code" => 400, "message" => "Missing or invalid masterLoginId"]);
        exit;
    }

    try {
        // Step 1: Get mobile number from masterlogin
        $stmt = $pdo->prepare("SELECT MobileNumber FROM masterlogin WHERE MasterLoginId = :masterLoginId");
        $stmt->execute(['masterLoginId' => $masterLoginId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            echo json_encode(["status" => "error", "code" => 404, "message" => "User not found"]);
            exit;
        }

        $mobileNumber = $user['MobileNumber'];

        // Step 2: Get firms using this mobile number
        $stmt = $pdo->prepare("
            SELECT 
                mf.masterFirmId, 
                mf.shop_name, 
                mf.proprieter_name, 
                mf.address, 
                mf.city, 
                mf.taluka_id, 
                t.taluka_name, 
                mf.district_id, 
                d.district_name, 
                mf.mobile, 
                mf.email, 
                mf.gst, 
                mf.mfms, 
                mf.firm_image,
                mf.firmOwnerImage
            FROM masterfirm mf
            LEFT JOIN talukas t ON mf.taluka_id = t.taluka_id
            LEFT JOIN districts d ON mf.district_id = d.district_id
            WHERE mf.mobile = :mobileNumber
        ");
        $stmt->execute(['mobileNumber' => $mobileNumber]);
        $firms = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Step 3: Return the result
        if ($firms) {
            echo json_encode(["status" => "success", "code" => 200, "data" => $firms]);
        } else {
            echo json_encode(["status" => "error", "code" => 404, "message" => "No firms found for this user"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to fetch data: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
