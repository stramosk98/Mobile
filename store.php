<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Obtém os dados enviados no corpo da requisição
$postdata = file_get_contents("php://input");

if (isset($postdata) && !empty($postdata)) {
    $request = json_decode($postdata, true);

    if (!isset($request['author']) || !isset($request['date']) || !isset($request['explanation']) || !isset($request['url'])) {
        http_response_code(400);
        echo json_encode(["error" => "All fields (author, date, explanation, url) are required."]);
        exit;
    }

    $author = trim($request['author']);
    $date = trim($request['date']);
    $explanation = trim($request['explanation']);
    $url = trim($request['url']);

    $picture = [
        "author" => $author,
        "date" => $date,
        "explanation" => $explanation,
        "url" => $url
    ];

    if (file_exists("pictures.txt")) {
        $fileContent = file_get_contents("pictures.txt");
        $lines = explode("\n", $fileContent);

        foreach ($lines as $line) {
            if (!empty($line)) {
                $existingPicture = json_decode($line, true);

                if ($existingPicture['url'] === $url && $existingPicture['date'] === $date) {
                    http_response_code(409); // Conflict
                    echo json_encode(["error" => "Picture already exists."]);
                    exit;
                }
            }
        }
    }

    try {
        $fp = fopen("pictures.txt", "a");
        fwrite($fp, json_encode($picture) . "\n");
        fclose($fp);

        http_response_code(201);
        echo json_encode(["message" => "Picture stored successfully!", "data" => $picture]);

    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(["error" => "Failed to store data."]);
    }
}
?>