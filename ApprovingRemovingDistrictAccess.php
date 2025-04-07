<?php
header("Content-Type: application/json");

// Include database connection
require_once("db.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate input data
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['MasterLoginId']) || empty($data['MasterLoginId']) || 
        !isset($data['district_id']) || empty($data['district_id']) || 
        !isset($data['action']) || empty($data['action'])) {
        echo json_encode(["status" => "error", "message" => "MasterLoginId, district_id, and action are required."]);
        exit;
    }

    $masterLoginId = $data['MasterLoginId'];
    $districtId = $data['district_id'];
    $action = strtolower($data['action']);  // Ensure action is in lowercase for consistency

    // Check if the action is valid
    if ($action !== 'approve' && $action !== 'remove') {
        echo json_encode(["status" => "error", "message" => "Invalid action. Use 'approve' or 'remove'."]);
        exit;
    }

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
        $userAccessCheckQuery = "SELECT access_approved FROM user_district_access WHERE MasterLoginId = :MasterLoginId AND district_id = :district_id";
        $stmt = $pdo->prepare($userAccessCheckQuery);
        $stmt->bindParam(':MasterLoginId', $masterLoginId, PDO::PARAM_INT);
        $stmt->bindParam(':district_id', $districtId, PDO::PARAM_INT);
        $stmt->execute();
        $userAccess = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$userAccess) {
            echo json_encode(["status" => "error", "message" => "User has not requested access to this district."]);
            exit;
        }

        // Handle the action based on whether it's approve or remove
        if ($action == 'approve') {
            // If the user has requested access, and the access is not yet approved, approve the access
            if ($userAccess['access_approved'] == 1) {
                echo json_encode(["status" => "error", "message" => "Access already approved for this district."]);
                exit;
            }

            // Approve the user's access
            $approveQuery = "UPDATE user_district_access SET access_approved = 1, updated_at = NOW() WHERE MasterLoginId = :MasterLoginId AND district_id = :district_id";
            $stmt = $pdo->prepare($approveQuery);
            $stmt->bindParam(':MasterLoginId', $masterLoginId, PDO::PARAM_INT);
            $stmt->bindParam(':district_id', $districtId, PDO::PARAM_INT);
            $stmt->execute();

            echo json_encode(["status" => "success", "message" => "Access approved successfully."]);
        } elseif ($action == 'remove') {
            // If the access is already removed, return an error
            if ($userAccess['access_approved'] == 0) {
                echo json_encode(["status" => "error", "message" => "Access already removed for this district."]);
                exit;
            }

            // Remove the user's access
            $removeQuery = "UPDATE user_district_access SET access_approved = 0, updated_at = NOW() WHERE MasterLoginId = :MasterLoginId AND district_id = :district_id";
            $stmt = $pdo->prepare($removeQuery);
            $stmt->bindParam(':MasterLoginId', $masterLoginId, PDO::PARAM_INT);
            $stmt->bindParam(':district_id', $districtId, PDO::PARAM_INT);
            $stmt->execute();

            echo json_encode(["status" => "success", "message" => "Access removed successfully."]);
        }
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
