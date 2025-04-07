<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Fetch all subscription plans
        $stmt = $pdo->prepare("SELECT MasterSubscriptionId, PlanName, Description, Credit, BasePrice, Month FROM subscriptionplans");
        $stmt->execute();
        $subscriptionPlans = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($subscriptionPlans) {
            echo json_encode(["status" => "success", "code" => 200, "data" => $subscriptionPlans]);
        } else {
            echo json_encode(["status" => "error", "code" => 404, "message" => "No subscription plans found"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to fetch subscription plans: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
