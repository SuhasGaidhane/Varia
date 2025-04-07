<?php
header("Content-Type: application/json");

// Include database connection
require_once("db.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate input data
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['MasterLoginId']) || empty($data['MasterLoginId']) || 
        !isset($data['district_id']) || empty($data['district_id'])) {
        echo json_encode(["status" => "error", "message" => "MasterLoginId and district_id are required."]);
        exit;
    }

    $masterLoginId = $data['MasterLoginId'];
    $districtId = $data['district_id'];

    try {
        // Check if the district exists and is active
        $districtCheckQuery = "SELECT district_id, is_active FROM districts WHERE district_id = :district_id AND is_active = 1";
        $stmt = $pdo->prepare($districtCheckQuery);
        $stmt->bindParam(':district_id', $districtId, PDO::PARAM_INT);
        $stmt->execute();
        $district = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$district) {
            echo json_encode(["status" => "error", "message" => "District not found or inactive."]);
            exit;
        }

        // Check if the user has already made a request for the district
        $userAccessCheckQuery = "SELECT * FROM user_district_access WHERE MasterLoginId = :MasterLoginId AND district_id = :district_id";
        $stmt = $pdo->prepare($userAccessCheckQuery);
        $stmt->bindParam(':MasterLoginId', $masterLoginId, PDO::PARAM_INT);
        $stmt->bindParam(':district_id', $districtId, PDO::PARAM_INT);
        $stmt->execute();
        $userAccess = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($userAccess) {
            echo json_encode(["status" => "error", "message" => "You have already requested access for this district."]);
            exit;
        }

        // Insert the user's request for access
        $insertQuery = "INSERT INTO user_district_access (MasterLoginId, district_id, access_approved, created_at, updated_at) 
                        VALUES (:MasterLoginId, :district_id, 0, NOW(), NOW())";
        $stmt = $pdo->prepare($insertQuery);
        $stmt->bindParam(':MasterLoginId', $masterLoginId, PDO::PARAM_INT);
        $stmt->bindParam(':district_id', $districtId, PDO::PARAM_INT);
        $stmt->execute();

        echo json_encode(["status" => "success", "message" => "Access request submitted successfully. Awaiting approval."]);
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
