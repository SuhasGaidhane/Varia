<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $districtId = isset($_GET['district_id']) ? intval($_GET['district_id']) : null;

    if (!$districtId) {
        echo json_encode(["status" => "error", "code" => 400, "message" => "Missing or invalid district_id"]);
        exit;
    }

    try {
        // Fetch firms with taluka name and district name
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
            WHERE mf.district_id = :district_id
        ");
        $stmt->execute(['district_id' => $districtId]);
        $firms = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Check if data exists
        if ($firms) {
            echo json_encode(["status" => "success", "code" => 200, "data" => $firms]);
        } else {
            echo json_encode(["status" => "error", "code" => 404, "message" => "No firms found for this district"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to fetch data: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
