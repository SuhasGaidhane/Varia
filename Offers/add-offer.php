<?php
header("Content-Type: application/json");

// Include database connection
require_once("../db.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Check if the image is provided
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

            // Collect other form data
            $title = $_POST['title'];  // Corrected this from 'offer_name' to 'title'
            $description = $_POST['description'];
            $startDate = $_POST['start_date'];
            $endDate = $_POST['end_date'];
            $isActive = $_POST['is_active'];

            // Update the image path to store it from the root directory
            $imagePath = "/images/offers_img/" . $uniqueName;

            // Prepare SQL query to insert offer
            $query = "INSERT INTO offers (title, description, start_date, end_date, is_active, image_url)
                      VALUES (:title, :description, :start_date, :end_date, :is_active, :image_url)";
            $stmt = $pdo->prepare($query);

            // Bind values
            $stmt->bindParam(':title', $title);  // Corrected this from ':offer_name' to ':title'
            $stmt->bindParam(':description', $description);
            $stmt->bindParam(':start_date', $startDate);
            $stmt->bindParam(':end_date', $endDate);
            $stmt->bindParam(':is_active', $isActive);
            $stmt->bindParam(':image_url', $imagePath);  // Using the updated image path

            // Execute the query
            $stmt->execute();

            echo json_encode(["status" => "success", "message" => "Offer created successfully."]);
        } else {
            echo json_encode(["status" => "error", "message" => "Image not uploaded or there was an error."]);
        }
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>
