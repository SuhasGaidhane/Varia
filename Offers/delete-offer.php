<?php
header("Content-Type: application/json");

// Include database connection
require_once("../db.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get the offer_id from the request
        $offerId = $_POST['offer_id']; // Pass the offer_id to delete the corresponding offer

        // Check if the offer exists
        $checkQuery = "SELECT * FROM offers WHERE offer_id = :offer_id";
        $stmt = $pdo->prepare($checkQuery);
        $stmt->bindParam(':offer_id', $offerId);
        $stmt->execute();
        $offer = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$offer) {
            echo json_encode(["status" => "error", "message" => "Offer not found."]);
            exit;
        }

        // Get the image path from the database
        $imagePath = $offer['image_url'];

        // Delete the offer from the database
        $deleteQuery = "DELETE FROM offers WHERE offer_id = :offer_id";
        $stmt = $pdo->prepare($deleteQuery);
        $stmt->bindParam(':offer_id', $offerId);
        $stmt->execute();

        // If the offer had an associated image, delete it from the server
        if ($imagePath && file_exists(".." . $imagePath)) {
            unlink(".." . $imagePath); // Delete the file from the server
        }

        echo json_encode(["status" => "success", "message" => "Offer deleted successfully."]);
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>
