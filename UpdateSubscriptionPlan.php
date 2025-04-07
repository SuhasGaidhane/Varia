<?php
require_once 'db.php'; // Include database connection

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    // Validate database connection
    if (!isset($pdo)) {
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Database connection not established.']);
        exit;
    }

    // Get JSON input
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate input data
    if (
        !isset($data['MasterSubscriptionId']) || empty($data['MasterSubscriptionId']) ||
        !isset($data['PlanName']) || empty($data['PlanName']) ||
        !isset($data['Description']) || empty($data['Description']) ||
        !isset($data['Credit']) || !is_numeric($data['Credit']) ||
        !isset($data['BasePrice']) || !is_numeric($data['BasePrice'])
    ) {
        http_response_code(400); // Bad Request
        echo json_encode(['error' => 'Missing or invalid input parameters.']);
        exit;
    }

    try {
        $masterSubscriptionId = $data['MasterSubscriptionId'];
        $planName = $data['PlanName'];
        $description = $data['Description'];
        $credit = $data['Credit'];
        $basePrice = $data['BasePrice'];

        // Check if the subscription plan exists
        $checkStmt = $pdo->prepare("SELECT * FROM SubscriptionPlans WHERE MasterSubscriptionId = ?");
        $checkStmt->execute([$masterSubscriptionId]);
        $existingPlan = $checkStmt->fetch(PDO::FETCH_ASSOC);

        if (!$existingPlan) {
            http_response_code(404); // Not Found
            echo json_encode(['error' => 'Subscription plan not found.']);
            exit;
        }

        // Update the subscription plan
        $updateStmt = $pdo->prepare("
            UPDATE SubscriptionPlans
            SET PlanName = ?, Description = ?, Credit = ?, BasePrice = ?
            WHERE MasterSubscriptionId = ?
        ");
        $updateStmt->execute([
            $planName,
            $description,
            $credit,
            $basePrice,
            $masterSubscriptionId
        ]);

        http_response_code(200); // OK
        echo json_encode(['message' => 'Subscription plan updated successfully']);
    } catch (PDOException $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Failed to update subscription plan: ' . $e->getMessage()]);
    }
} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Method Not Allowed']);
}
?>
