<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $masterLoginId = isset($_GET['MasterLoginId']) ? $_GET['MasterLoginId'] : null;

    try {
        // Fetch only active districts
        $stmt = $pdo->prepare("SELECT district_id, district_name, created_at, updated_at FROM districts WHERE is_active = 1");
        $stmt->execute();
        $districts = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($masterLoginId) {
            // Fetch user's subscriptions based on MasterLoginId
            $stmt = $pdo->prepare("
                SELECT district_id, SubscriptionEnd 
                FROM usersubscriptions 
                WHERE MasterLoginId = :MasterLoginId
            ");
            $stmt->execute(['MasterLoginId' => $masterLoginId]);
            $subscriptions = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Prepare subscription status mapping
            $subscriptionStatus = [];
            foreach ($subscriptions as $sub) {
                $subscriptionStatus[$sub['district_id']] = (strtotime($sub['SubscriptionEnd']) < time()) ? 0 : 1;
            }

            // Merge subscription status with active districts
            foreach ($districts as &$district) {
                $district['subscription_status'] = $subscriptionStatus[$district['district_id']] ?? 0;
            }
        } else {
            // If MasterLoginId is not provided, set subscription status to 0
            foreach ($districts as &$district) {
                $district['subscription_status'] = 0;
            }
        }

        echo json_encode(["status" => "success", "code" => 200, "data" => $districts]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to fetch data: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
