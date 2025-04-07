<?php
header('Content-Type: application/json'); // Ensure JSON responses

// Define available routes and methods
$routes = [
    'register' => [
        'file' => 'register.php',
        'methods' => ['POST'] // Specify allowed methods
    ],
    // Additional routes can be added here
];

// Get the request URI and method
$requestUri = trim($_SERVER['REQUEST_URI'], '/');
$requestMethod = $_SERVER['REQUEST_METHOD'];

// Parse the route (e.g., /api/register)
$route = explode('/', $requestUri);
$endpoint = isset($route[1]) ? $route[1] : '';

// Check if the endpoint exists
if (isset($routes[$endpoint])) {
    $routeConfig = $routes[$endpoint];
    if (in_array($requestMethod, $routeConfig['methods'])) {
        require_once $routeConfig['file']; // Load the appropriate API file
    } else {
        echo json_encode([
            "status" => "error",
            "code" => 405, // HTTP status code for Method Not Allowed
            "method" => $requestMethod,
            "message" => "Method not allowed for this endpoint"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "code" => 404, // HTTP status code for Not Found
        "method" => $requestMethod,
        "message" => "Endpoint not found"
    ]);
}
?>
