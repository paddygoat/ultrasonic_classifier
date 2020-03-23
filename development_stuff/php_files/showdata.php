<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">
  
  <meta http-equiv='refresh' content='60';url='showdata.php'> <!-- Refreshes page every 60 seconds -->
  <META NAME="description" CONTENT="Intelligent Bat Detector ... Are not all bats intelligent?">

  <META NAME="keywords" CONTENT="Intelligent Bat Detector random forest classification deep learning raspberry pi jetson nano 4g LTE">

  <link REL="SHORTCUT ICON" HREF="http://www.goatindustries.co.uk/goat.ico">
  <title>Intelligent Bat Detector</title>


</html>

<?php

$host="localhost"; // Host name 
$username="#############"; // Mysql username 
$password="#############"; // Mysql password 
$db_name="#############"; // Database name 
$tbl_name="#############"; // Table name

// Connect to server and select database.
mysql_connect("$host", "$username", "$password")or die("cannot connect"); 
mysql_select_db("$db_name")or die("cannot select DB");


$query12="SELECT * FROM ############# ORDER BY id DESC LIMIT 1";
$result12=mysql_query($query12);
while($row12=mysql_fetch_array($result12))
   {  
   $id = $row12['ID'];
   $timeStamp = $row12['TIME'];
   $temp = $row12['temp'];
   $humidity = $row12['humidity'];
   $battery = $row12['battery'];
   $windSpeed = $row12['wind'];
   $CPU_temp = $row12['CPU_temp'];
   }
   
// Time stuff:
$localTime = time();
//echo(date("M-d h:i:s",$localTime));
$timestamp2 = strtotime($timeStamp);
$timeDifference = $localTime - $timestamp2;
// echo $timeDifference;

// Retrieve data from database 
$sql2="SELECT * FROM #############  ORDER BY id DESC LIMIT 10";
$result2=mysql_query($sql2);

// Get wind data:
$host="localhost"; // Host name 
$username="#############"; // Mysql username 
$password="#############"; // Mysql password 
$db_name="#############"; // Database name 
$tbl_name="#############"; // Table name

// Connect to server and select database.
mysql_connect("$host", "$username", "$password")or die("cannot connect"); 
mysql_select_db("$db_name")or die("cannot select DB");

// Retrieve data from database 
$sql3="SELECT * FROM #############  ORDER BY id DESC LIMIT 1";
$result3=mysql_query($sql3);
while($row13=mysql_fetch_array($result3))
{
    $windSpeed = $row13['windgust'];
}

?>

<style type="text/css">
<!--
.style1 {font-size: 10px}  <!-- Data font size -->
-->
</style>

<style type="text/css">
<!--
.style2 {font-size: 12px}  <!-- Readings font size -->
-->
</style>

<style type="text/css">
<!--
.style3 {font-size: 14px; text-decoration: underline; font-weight: bold; opacity: 0.7}  <!-- Heading -->
-->
</style>

<style type="text/css">
.blink_me {
  color: green;
  font-weight: bold;
  animation: blinker 1s linear infinite;
}

@keyframes blinker {
  50% {
    opacity: 0;
  }
}
</style>

<body>
	
<table width="580">
  <tr><span class="style2">
    <td><div align="center"><span class="style3">Intelligent Bat Detector</td>
  </tr>
</table>

<img src="http://www.goatindustries.co.uk/bat_detector/graph.png" alt="graphical results">



<table width="0">
  <tr><span class="style2">
    <td><div align="left"><a href="http://www.goatindustries.co.uk/bat_detector/saved_audio_files.html"><button>Show Saved Audio Files</button></a></td>
    <td><div align="left"><a href="http://www.goatindustries.co.uk/bat_detector/results.csv"><button>Download CSV</button></a></td>
  </tr>
</table>

<table width="580">
  <tr><span class="style2">
    <td><span class="style2">Last update: <?php echo(date("M-d H:i:s",$timestamp2)); ?></td>
    <td><span class="style2">Local time: <?php echo(date("M-d H:i:s",$localTime)); ?></td>
	<?php
	$t = date("H");

	if ($timeDifference < "600")
	{
		?> <td><div align="center"><div class="blink_me">NOW LIVE !</div></td> <?php
	} else {
		?> <td><div align="right">NOT LIVE</td><td>..... Please check later.</td> <?php
	}
	?>
    
  </tr>
  <tr>
	<td><span class="style2">Battery: <?php echo $battery; ?> Volts</td>
    <td><span class="style2">Temp: <?php echo $temp; ?> ℃</td>
    <td><span class="style2">Humidity: <?php echo $humidity; ?> %</td>
    <td><div align="right"<span class="style2">Wind: <?php echo $windSpeed; ?> knots</td>
  </tr>
</table>


<table width="580" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6%"><span class="style1"><div align="center">Id </div></td>
		<td width="12%"><span class="style1"><div align="center">Time Stamp </div></td>
		<td width="9%"><span class="style1"><div align="center">Temp </div></td>
		<td width="8%"><span class="style1"><div align="center">Humidity </div></td>
		<td width="7%"><span class="style1"><div align="center">Battery </div></td>
		<td width="7%"><span class="style1"><div align="center">Wind </div></td>
		<td width="7%"><span class="style1"><div align="center">CPU temp </div></td>  
	</tr>
</table>
<table width="580" border="1" cellspacing="0" cellpadding="0"> 
 
<?php

// Start looping rows in mysql database.
while($rows=mysql_fetch_array($result2))
{

?>

 <tr>

 <td bgcolor="#cce2ff" width="6%"><div align="center"><span class="style1"><? echo $rows['ID']; ?></span></td>
 <td bgcolor="#FFFFCC" width="12%"><div align="center"><span class="style1"><? echo $rows['TIME']; ?></span></td>
 <td bgcolor="#ccffcd" width="9%"><div align="center"><span class="style1"><? echo $rows['temp']; ?></span></td>
 <td bgcolor="#ffccd9" width="8%"><div align="center"><span class="style1"><? echo $rows['humidity']; ?></span></td>
 <td bgcolor="#cce2ff" width="7%"><div align="center"><span class="style1"><? echo $rows['battery']; ?></span></td>
 <td bgcolor="#FFFFCC" width="7%"><div align="center"><span class="style1"><? echo $rows['wind']; ?></span></td>
 <td bgcolor="#FFFFCC" width="7%"><div align="center"><span class="style1"><? echo $rows['CPU_temp']; ?></span></td>   
 </tr>

<?php
// close while loop 
}

?>
</table>
</body>
</html>

<?php
// close MySQL connection 
mysql_close();
 ?>
