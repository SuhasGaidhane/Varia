<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $masterLoginId = isset($_GET['MasterLoginId']) ? $_GET['MasterLoginId'] : null;

    if (!$masterLoginId) {
        echo json_encode(["status" => "error", "code" => 400, "message" => "MasterLoginId is required"]);
        exit;
    }

    try {
        // Fetch the user's district subscription history
        $stmt = $pdo->prepare("
            SELECT 
                us.UserSubscriptionId,
                us.MasterSubscriptionId,
                us.district_id,
                d.district_name,
                us.MasterLoginId,
                us.IsActive,
                us.SubscriptionStart,
                us.SubscriptionEnd,
                us.RenewalDate
            FROM usersubscriptions us
            LEFT JOIN districts d ON us.district_id = d.district_id
            WHERE us.MasterLoginId = :MasterLoginId
            ORDER BY us.SubscriptionStart DESC
        ");
        $stmt->execute(['MasterLoginId' => $masterLoginId]);
        $subscriptions = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (empty($subscriptions)) {
            echo json_encode(["status" => "error", "code" => 404, "message" => "No previous district requests found"]);
            exit;
        }

        echo json_encode([
            "status" => "success",
            "code" => 200,
            "data" => $subscriptions
        ]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to fetch data: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
