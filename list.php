<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if (file_exists("pictures.txt")) {
    $fileContent = file_get_contents("pictures.txt");
    $lines = explode("\n", $fileContent);

    $pictures = [];

    foreach ($lines as $line) {
        if (!empty($line)) {
            $picture = json_decode($line, true);
            $pictures[] = $picture;
        }
    }

    http_response_code(200);
    echo json_encode($pictures);
} else {
    http_response_code(404);
    echo json_encode(["error" => "No pictures found."]);
}
?>