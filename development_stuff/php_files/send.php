<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Send</title>
    <link REL="SHORTCUT ICON" HREF="goat.ico">
</html>

<?php

// Create connection
$host="localhost"; // Host name 
$username="paddygoat_bat"; // Mysql username 
$password="##############"; // Mysql password 
$db_name="paddygoat_bat_01"; // Database name 
$tbl_name="bat_01"; // Table name

// Connect to server and select database.
$dbhandle = mysql_connect($hostname, $username, $password) 
or die("Unable to connect to MySQL");

$selected = mysql_select_db("paddygoat_bat_01",$dbhandle) 
or die("Could not select database");

////////////////////////////////////////////////////////////////////////////////
// Send the new info to the table:
$result = mysql_query("INSERT INTO $tbl_name(temp,humidity,battery,wind) VALUES (
'" . $_GET[temp] . "',
'" . $_GET[humidity] . "',
'" . $_GET[battery] . "',
'" . $_GET[wind] . "')",
$dbhandle);

//echo "<html>";
//echo "<head><Title> ... Success! ... </title>";
//echo "</head>";
//echo "<body>";
//echo "</body>";
//echo "</html>";
echo " ... Success! ... ";
//////////////////////////////////////////////////////////////////////////////////

// close MySQL connection 
mysql_close();
?>
