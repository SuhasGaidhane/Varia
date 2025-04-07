<?php
require_once 'db.php'; // Include database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    $requiredFields = ['MasterProfileId', 'MobileNumber', 'FullName', 'MasterDistrictId', 'MasterCityId'];
    foreach ($requiredFields as $field) {
        if (empty($data[$field])) {
            echo json_encode(["status" => "error", "code" => 400, "message" => "Missing field: $field"]);
            exit;
        }
    }

    try {
        $pdo->beginTransaction();

        // Check if MobileNumber already exists
        $stmt = $pdo->prepare("SELECT MasterLoginId FROM MasterLogin WHERE MobileNumber = :MobileNumber");
        $stmt->execute(['MobileNumber' => $data['MobileNumber']]);
        $existingUser = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($existingUser) {
            echo json_encode(["status" => "error", "code" => 409, "message" => "Mobile number already registered"]);
            exit;
        }

        // Insert new user into MasterLogin (with YourAddress)
        $stmt = $pdo->prepare("
            INSERT INTO MasterLogin (MasterProfileId, MobileNumber, FullName, FirmName, MasterDistrictId, MasterCityId, IsVerified, AvailableCredit, LastUsedDate, YourAddress) 
            VALUES (:MasterProfileId, :MobileNumber, :FullName, :FirmName, :MasterDistrictId, :MasterCityId, 1, :AvailableCredit, :LastUsedDate, :YourAddress)
        ");
        $stmt->execute([
            'MasterProfileId' => $data['MasterProfileId'],
            'MobileNumber'    => $data['MobileNumber'],
            'FullName'        => $data['FullName'],
            'FirmName'        => $data['FirmName'] ?? null,
            'MasterDistrictId'=> $data['MasterDistrictId'],
            'MasterCityId'    => $data['MasterCityId'],
            'AvailableCredit' => $data['AvailableCredit'] ?? 0,
            'LastUsedDate'    => $data['LastUsedDate'] ?? null,
            'YourAddress'     => $data['YourAddress'] ?? null  // New field added
        ]);

        $masterLoginId = $pdo->lastInsertId();

        // Handle Subscription (If Provided)
        if (!empty($data['Subscription'])) {
            $subscription = $data['Subscription'];
            $stmt = $pdo->prepare("
                INSERT INTO usersubscriptions (MasterSubscriptionId, MasterLoginId, IsActive, SubscriptionStart, SubscriptionEnd, RenewalDate, district_id) 
                VALUES (:MasterSubscriptionId, :MasterLoginId, :IsActive, :SubscriptionStart, :SubscriptionEnd, :RenewalDate, :district_id)
            ");
            $stmt->execute([
                'MasterSubscriptionId' => $subscription['MasterSubscriptionId'],
                'MasterLoginId'        => $masterLoginId,
                'IsActive'             => $subscription['IsActive'] ?? true,
                'SubscriptionStart'    => $subscription['SubscriptionStart'] ?? null,
                'SubscriptionEnd'      => $subscription['SubscriptionEnd'] ?? null,
                'RenewalDate'          => $subscription['RenewalDate'] ?? null,
                'district_id'          => $subscription['district_id'] ?? null
            ]);
        }

        $pdo->commit();

        echo json_encode(["status" => "success", "code" => 201, "message" => "Registration successful"]);
    } catch (PDOException $e) {
        $pdo->rollBack();
        echo json_encode(["status" => "error", "code" => 500, "message" => "Failed to register: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "code" => 405, "message" => "Invalid request method"]);
}
?>
