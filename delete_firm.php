<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get Firm ID (Required)
        $masterFirmId = $_POST['masterFirmId'] ?? null;
        if (empty($masterFirmId)) {
            echo json_encode(["status" => "error", "message" => "Firm ID is required"]);
            exit;
        }

        // Check if the firm exists
        $stmt = $pdo->prepare("SELECT firm_image, firmOwnerImage FROM masterfirm WHERE masterFirmId = :masterFirmId");
        $stmt->execute(["masterFirmId" => $masterFirmId]);
        $firm = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$firm) {
            echo json_encode(["status" => "error", "message" => "Firm not found"]);
            exit;
        }

        // Delete firm images from server
        if (!empty($firm['firm_image']) && file_exists($firm['firm_image'])) {
            unlink($firm['firm_image']);
        }
        if (!empty($firm['firmOwnerImage']) && file_exists($firm['firmOwnerImage'])) {
            unlink($firm['firmOwnerImage']);
        }

        // Delete the firm from the database
        $stmt = $pdo->prepare("DELETE FROM masterfirm WHERE masterFirmId = :masterFirmId");
        $stmt->execute(["masterFirmId" => $masterFirmId]);

        echo json_encode(["status" => "success", "message" => "Firm deleted successfully"]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Failed to delete firm: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
