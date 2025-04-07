<?php
require_once 'db.php'; // Database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    // Validate required fields
    if (!isset($data["MasterLoginId"], $data["AvailableCredit"], $data["Subscription"])) {
        echo json_encode(["status" => "error", "code" => 400, "message" => "Missing required fields"]);
        exit;
    }

    $masterLoginId = intval($data["MasterLoginId"]);
    $newCredit = intval($data["AvailableCredit"]);
    $subscription = $data["Subscription"];

    $masterSubscriptionId = intval($subscription["MasterSubscriptionId"]);
    $districtId = intval($subscription["district_id"]);
    $isActive = $subscription["IsActive"] ? 1 : 0;
    $subscriptionStart = $subscription["SubscriptionStart"];
    $subscriptionEnd = $subscription["SubscriptionEnd"];
    $renewalDate = $subscription["RenewalDate"];

    try {
        $pdo->beginTransaction(); // Start transaction

        // Step 1: Get current AvailableCredit
        $stmt = $pdo->prepare("SELECT AvailableCredit FROM masterlogin WHERE MasterLoginId = ?");
        $stmt->execute([$masterLoginId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$row) {
            throw new Exception("MasterLoginId not found", 404);
        }

        $currentCredit = intval($row["AvailableCredit"]);
        $updatedCredit = $currentCredit + $newCredit; // Add new credit

        // Step 2: Insert into usersubscriptions
        $stmt = $pdo->prepare("
            INSERT INTO usersubscriptions 
            (MasterSubscriptionId, district_id, MasterLoginId, IsActive, SubscriptionStart, SubscriptionEnd, RenewalDate)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([$masterSubscriptionId, $districtId, $masterLoginId, $isActive, $subscriptionStart, $subscriptionEnd, $renewalDate]);

        // Step 3: Update AvailableCredit in masterlogin
        $stmt = $pdo->prepare("UPDATE masterlogin SET AvailableCredit = ? WHERE MasterLoginId = ?");
        $stmt->execute([$updatedCredit, $masterLoginId]);

        $pdo->commit(); // Commit transaction

        echo json_encode([
            "status" => "success",
            "code" => 200,
            "message" => "Subscription added and credit updated.",
            "newCredit" => $updatedCredit
        ]);
    } catch (Exception $e) {
        $pdo->rollBack(); // Rollback transaction on error
        echo json_encode(["status" => "error", "code" => $e->getCode() ?: 500, "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
