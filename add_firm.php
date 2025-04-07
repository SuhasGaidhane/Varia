<?php
require_once 'db.php'; // Include database connection

// Define upload directories
$firmImageDir = "FirmImages/";
$firmOwnerImageDir = "FirmOwnerImages/";

// Ensure directories exist
if (!is_dir($firmImageDir)) {
    mkdir($firmImageDir, 0777, true);
}
if (!is_dir($firmOwnerImageDir)) {
    mkdir($firmOwnerImageDir, 0777, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get form data
        $shop_name = $_POST['shop_name'] ?? null;
        $proprieter_name = $_POST['proprieter_name'] ?? null;
        $address = $_POST['address'] ?? null;
        $city = $_POST['city'] ?? null;
        $taluka_id = $_POST['taluka_id'] ?? null;
        $district_id = $_POST['district_id'] ?? null;
        $mobile = $_POST['mobile'] ?? null;
        $email = $_POST['email'] ?? null;
        $gst = $_POST['gst'] ?? null;
        $mfms = $_POST['mfms'] ?? null;

        // Validate required fields
        $requiredFields = ['shop_name', 'mobile', 'address', 'city', 'taluka_id', 'district_id', 'email', 'gst', 'mfms'];
        foreach ($requiredFields as $field) {
            if (empty($$field)) {
                echo json_encode(["status" => "error", "message" => "Missing required field: $field"]);
                exit;
            }
        }

        // Handle firm image upload
        $firmImagePath = null;
        if (!empty($_FILES['firm_image']['name'])) {
            $firmImageName = time() . "_" . basename($_FILES['firm_image']['name']);
            $firmImagePath = $firmImageDir . $firmImageName;

            if (!move_uploaded_file($_FILES['firm_image']['tmp_name'], $firmImagePath)) {
                echo json_encode(["status" => "error", "message" => "Failed to upload firm image"]);
                exit;
            }
        }

        // Fetch Firm Owner Image from masterlogin using mobile number
        $stmt = $pdo->prepare("SELECT UserImage FROM masterlogin WHERE MobileNumber = :mobile LIMIT 1");
        $stmt->execute(['mobile' => $mobile]);
        $ownerImage = $stmt->fetchColumn();

        // Handle firm owner image upload
        $firmOwnerImagePath = $ownerImage ? $ownerImage : null;
        if (!empty($_FILES['firm_owner_image']['name'])) {
            $firmOwnerImageName = time() . "_" . basename($_FILES['firm_owner_image']['name']);
            $firmOwnerImagePath = $firmOwnerImageDir . $firmOwnerImageName;

            if (!move_uploaded_file($_FILES['firm_owner_image']['tmp_name'], $firmOwnerImagePath)) {
                echo json_encode(["status" => "error", "message" => "Failed to upload firm owner image"]);
                exit;
            }
        }

        // Insert firm data into masterfirm
        $stmt = $pdo->prepare("
            INSERT INTO masterfirm (shop_name, proprieter_name, address, city, taluka_id, district_id, mobile, email, gst, mfms, firm_image, firmOwnerImage) 
            VALUES (:shop_name, :proprieter_name, :address, :city, :taluka_id, :district_id, :mobile, :email, :gst, :mfms, :firm_image, :firmOwnerImage)
        ");
        
        $stmt->execute([
            'shop_name'       => $shop_name,
            'proprieter_name' => $proprieter_name,
            'address'         => $address,
            'city'            => $city,
            'taluka_id'       => $taluka_id,
            'district_id'     => $district_id,
            'mobile'          => $mobile,
            'email'           => $email,
            'gst'             => $gst,
            'mfms'            => $mfms,
            'firm_image'      => $firmImagePath,
            'firmOwnerImage'  => $firmOwnerImagePath
        ]);

        echo json_encode(["status" => "success", "message" => "Firm added successfully"]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Failed to insert firm: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
