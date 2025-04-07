<?php
header("Content-Type: application/json");

// Include database connection
require_once("../db.php");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Get the isExpire parameter from the query string
        $isExpire = isset($_GET['isExpire']) ? $_GET['isExpire'] : null;

        // Validate the parameter
        if ($isExpire !== null && !in_array($isExpire, ['true', 'false'])) {
            echo json_encode(["status" => "error", "message" => "Invalid value for isExpire. Use 'true' or 'false'."]);
            exit;
        }

        // Prepare the base query
        $query = "SELECT * FROM offers";

        // Append condition based on isExpire
        if ($isExpire === 'true') {
            $query .= " WHERE end_date < NOW()"; // Expired offers
        } elseif ($isExpire === 'false') {
            $query .= " WHERE end_date >= NOW()"; // Active offers
        }

        // Add sorting
        $query .= " ORDER BY start_date DESC";

        $stmt = $pdo->prepare($query);
        $stmt->execute();

        $offers = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Add the is_expired field to each offer
        foreach ($offers as &$offer) {
            $offer['is_expired'] = strtotime($offer['end_date']) < time(); // Check if end_date is in the past
        }

        // Check if offers are found
        if (empty($offers)) {
            echo json_encode(["status" => "success", "message" => "No offers found.", "data" => []]);
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
