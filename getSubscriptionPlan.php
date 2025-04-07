<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $masterLoginId = isset($_GET['MasterLoginId']) ? $_GET['MasterLoginId'] : null;

    if (!$masterLoginId) {
        echo json_encode(["status" => "error", "code" => 400, "message" => "MasterLoginId is required"]);
        exit;
    }

    try {
        // Fetch AvailableCredit and LastUsedDate from MasterLogin table
        $stmt = $pdo->prepare("
            SELECT AvailableCredit, LastUsedDate 
            FROM MasterLogin 
            WHERE MasterLoginId = :MasterLoginId
        ");
        $stmt->execute(['MasterLoginId' => $masterLoginId]);
        $loginData = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$loginData) {
            echo json_encode(["status" => "error", "code" => 404, "message" => "User not found"]);
            exit;
        }

        // Fetch the user's active subscription details with plan info and district name
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
                us.RenewalDate,
                sp.PlanName,
                sp.Description,
                sp.Credit,
                sp.BasePrice
            FROM usersubscriptions us
            LEFT JOIN subscriptionplans sp ON us.MasterSubscriptionId = sp.MasterSubscriptionId
            LEFT JOIN districts d ON us.district_id = d.district_id
            WHERE us.MasterLoginId = :MasterLoginId
        ");
        $stmt->execute(['MasterLoginId' => $masterLoginId]);
        $subscriptions = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            "status" => "success",
            "code" => 200,
            "AvailableCredit" => $loginData['AvailableCredit'] ?? 0,
            "LastUsedDate" => $loginData['LastUsedDate'] ?? null,
            "data" => $subscriptions
        ]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to fetch data: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
