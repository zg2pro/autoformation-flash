<?php

//$one = $_POST['one']; 
$filename = "highScores.xml";
//$filename = "newfile.xml";
$filepath = "D:\\iomedia\\autoformation-flash\\IO_MatchingGame\\";

//$file = fopen($filepath.$filename,"w+");


if (isset($GLOBALS["HTTP_RAW_POST_DATA"])){
//    $xml = xmldoc($GLOBALS["HTTP_RAW_POST_DATA"]);
    $xml = $GLOBALS["HTTP_RAW_POST_DATA"];
    //$file = fopen($filepath.$filename,"wb");
    $file = fopen($filepath.$filename,"w+");
    fwrite($file, $xml);
    fclose($file);
//    echo("<status>File saved.</status>");
//    echo($GLOBALS["HTTP_RAW_POST_DATA"]);
} 


//error_log("test from firefox");
error_log("new test");

?>