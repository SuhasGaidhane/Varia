<?php
header("Content-Type: application/json");

// Include database connection
require_once("../db.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get offer_id from request to know which offer to update
        $offerId = $_POST['offer_id']; // You should send the offer_id to identify which offer to update

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

        // Prepare data for update
        $title = $_POST['title'];
        $description = $_POST['description'];
        $startDate = $_POST['start_date'];
        $endDate = $_POST['end_date'];
        $isActive = $_POST['is_active'];

        // Image handling (if new image is uploaded)
        $imagePath = $offer['image_url']; // Default to the old image path if no new image is uploaded

        if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
            // Handle image upload
            $targetDir = "../images/offers_img/"; // Folder to store images (relative to project root)

            // Create a unique name for the image
            $imageName = basename($_FILES["image"]["name"]);
            $imageFileType = strtolower(pathinfo($imageName, PATHINFO_EXTENSION));

            // Generate a unique file name using the original name, timestamp, and random string
            $uniqueName = pathinfo($imageName, PATHINFO_FILENAME) . "_" . time() . "_" . bin2hex(random_bytes(5)) . "." . $imageFileType;

            $targetFile = $targetDir . $uniqueName;

            // Validate file type (optional)
            $allowedTypes = ['jpg', 'jpeg', 'png', 'gif'];
            if (!in_array($imageFileType, $allowedTypes)) {
                echo json_encode(["status" => "error", "message" => "Invalid image type."]);
                exit;
            }

            // Move the uploaded file to the target directory
            if (!move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
                echo json_encode(["status" => "error", "message" => "Failed to upload image."]);
                exit;
            }

            // Update image path to store it from the root directory
            $imagePath = "/images/offers_img/" . $uniqueName;
        }

        // Prepare SQL query to update offer
        $query = "UPDATE offers SET title = :title, description = :description, start_date = :start_date, end_date = :end_date, is_active = :is_active, image_url = :image_url WHERE offer_id = :offer_id";
        $stmt = $pdo->prepare($query);

        // Bind values
        $stmt->bindParam(':title', $title);
        $stmt->bindParam(':description', $description);
        $stmt->bindParam(':start_date', $startDate);
        $stmt->bindParam(':end_date', $endDate);
        $stmt->bindParam(':is_active', $isActive);
        $stmt->bindParam(':image_url', $imagePath);
        $stmt->bindParam(':offer_id', $offerId);

        // Execute the query
        $stmt->execute();

        echo json_encode(["status" => "success", "message" => "Offer updated successfully."]);
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>
