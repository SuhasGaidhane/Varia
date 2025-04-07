<?php
require_once("db.php");

if (!$pdo) {
    die(json_encode(["status" => "error", "message" => "Database connection is not established."]));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // ✅ Decode JSON input
    $data = json_decode(file_get_contents('php://input'), true);

    if (
        empty($data['MasterProfileId']) ||
        empty($data['MobileNumber']) ||
        empty($data['FullName']) ||
        empty($data['FirmName']) ||
        empty($data['YourAddress']) ||
        empty($data['MasterDistrictId']) ||
        empty($data['MasterCityId']) ||
        !isset($data['AvailableCredit']) || // ✅ Use isset() for numeric values
        empty($data['LastUsedDate'])
    ) {
        echo json_encode(["status" => "error", "message" => "All fields are required"]);
        exit;
    }

    $MasterProfileId = $data['MasterProfileId'];
    $MobileNumber = $data['MobileNumber'];
    $FullName = $data['FullName'];
    $FirmName = $data['FirmName'];
    $YourAddress = $data['YourAddress'];
    $MasterDistrictId = $data['MasterDistrictId'];
    $MasterCityId = $data['MasterCityId'];
    $IsVerified = 1;
    $ModifiedDate = date('Y-m-d H:i:s');
    $AvailableCredit = $data['AvailableCredit'];
    $LastUsedDate = $data['LastUsedDate'];
    $UserImage = $data['UserImage'] ?? null;

    try {
        $stmt = $pdo->prepare("
            INSERT INTO masterlogin (
                MasterProfileId, MobileNumber, FullName, FirmName, YourAddress, 
                MasterDistrictId, MasterCityId, IsVerified, ModifiedDate, 
                AvailableCredit, LastUsedDate, UserImage
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ");

        $stmt->execute([
            $MasterProfileId,
            $MobileNumber,
            $FullName,
            $FirmName,
            $YourAddress,
            $MasterDistrictId,
            $MasterCityId,
            $IsVerified,
            $ModifiedDate,
            $AvailableCredit,
            $LastUsedDate,
            $UserImage
        ]);

        echo json_encode(["status" => "success", "message" => "User registered successfully"]);

    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
