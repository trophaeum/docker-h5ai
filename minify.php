<?php

require "minify.json.php";

$in_cfg = "/usr/share/h5ai/_h5ai/private/conf/options.json";
$out_cfg = $in_cfg;

$handle = fopen($in_cfg,"r");
$contents = fread($handle, filesize($in_cfg));
fclose($handle);

$contents = json_minify($contents);

$handle = fopen($out_cfg,"w+");
$contents = fwrite($handle, $contents);
fclose($handle);

?>
