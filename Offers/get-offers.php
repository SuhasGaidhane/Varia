<?php
header("Content-Type: application/json");

// Include database connection
require_once("../db.php");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Get the current date
        $currentDate = date('Y-m-d H:i:s');
        
        // Fetch active offers where current date is between start_date and end_date
        $query = "SELECT * FROM offers WHERE is_active = 1 AND start_date <= :currentDate AND end_date >= :currentDate ORDER BY start_date DESC";
        
        // Prepare statement
        $stmt = $pdo->prepare($query);
        
        // Bind the current date parameter to the query
        $stmt->bindParam(':currentDate', $currentDate);
        
        // Execute the query
        $stmt->execute();
        
        // Fetch all offers
        $offers = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (empty($offers)) {
            echo json_encode(["status" => "success", "message" => "No active offers available or no offers currently active."]);
        } else {
            echo json_encode(["status" => "success", "data" => $offers]);
        }
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>
