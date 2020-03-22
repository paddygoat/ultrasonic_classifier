<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Send</title>
    <link REL="SHORTCUT ICON" HREF="goat.ico">
</html>

<?php

// Get wind data:
$host="localhost"; // Host name 
$username="#################"; // Mysql username 
$password="#################"; // Mysql password 
$db_name="#################"; // Database name 
$tbl_name="#################"; // Table name

// Connect to server and select database.
mysql_connect("$host", "$username", "$password")or die("cannot connect"); 
mysql_select_db("$db_name")or die("cannot select DB");

// Retrieve data from database 
$sql3="SELECT * FROM weather2017  ORDER BY id DESC LIMIT 1";
$result3=mysql_query($sql3);
while($row13=mysql_fetch_array($result3))
{
    $windSpeed = $row13['windgust'];
}

echo $windSpeed;
// close MySQL connection 
mysql_close();

// Create connection
$host="localhost"; // Host name 
$username="#################"; // Mysql username 
$password="#################"; // Mysql password 
$db_name="#################"; // Database name 
$tbl_name="#################"; // Table name

// Connect to server and select database.
$dbhandle = mysql_connect($hostname, $username, $password) 
or die("Unable to connect to MySQL");

$selected = mysql_select_db("#################1",$dbhandle) 
or die("Could not select database");

////////////////////////////////////////////////////////////////////////////////
// Send the new info to the table:
$result = mysql_query("INSERT INTO $tbl_name(temp,humidity,battery,CPU_temp,wind) VALUES (
'" . $_GET[temp] . "',
'" . $_GET[humidity] . "',
'" . $_GET[battery] . "',
'" . $_GET[CPU_temp] . "',
'" . $windSpeed . "')",
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
