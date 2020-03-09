<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">
  
  <meta http-equiv='refresh' content='60';url='showdata.php'> <!-- Refreshes page every 60 seconds -->
  <META NAME="description" CONTENT="Bat Detector">

  <META NAME="keywords" CONTENT="Bat Detector">

  <link REL="SHORTCUT ICON" HREF="http://www.goatindustries.co.uk/goat.ico">
  <title>Bat Detector</title>


</html>

<?php

    $host="localhost"; // Host name 
    $username="paddygoat_bat"; // Mysql username 
    $password="################"; // Mysql password 
    $db_name="paddygoat_bat_01"; // Database name 
    $tbl_name="bat_01"; // Table name

    // Connect to server and select database.
    mysql_connect("$host", "$username", "$password")or die("cannot connect"); 
    mysql_select_db("$db_name")or die("cannot select DB");


    $query12="SELECT * FROM bat_01 ORDER BY id DESC LIMIT 1";
    $result12=mysql_query($query12);
    while($row12=mysql_fetch_array($result12))
       {  
       $id = $row12['ID'];
       $timeStamp = $row12['TIME'];
       $temp = $row12['temp'];
       $humidity = $row12['humidity'];
       $battery = $row12['battery'];
       $windSpeed = $row12['wind'];
       }
       
    //echo $timestamp;

// Retrieve data from database 
 
$sql2="SELECT * FROM bat_01  ORDER BY id DESC LIMIT 10";
$result2=mysql_query($sql2);
 
?>

<div id="bck-img"></div>
    <script type="text/javascript">
            var container = document.getElementById("bck-img");
            var image = document.createElement("img");
            image.setAttribute("src", _spPageContextInfo.webAbsoluteUrl+"graph.png?rev="+new Date().getTime());
            container.appendChild(image);
    </script>

<html>
<head>
	<style>
    //body {background-color: powderblue;}
    h1   {color: blue;}
    p    {color: red;}

    table#007 {
    width: 580;
    background-color: #f1f1c1;
    }
    </style>
</head>	
    <body>
		<img src="http://www.goatindustries.co.uk/bat_detector/graph.png" alt="graphical results">
        <table id="007">
            <tr>
                <td width="20%"><div align="left">Time: <?php echo $timeStamp; ?> </div></td>
            </tr>
            <tr>
                <td width="20%"><div align="left">Temp: <?php echo $temp; ?> ℃</div></td>
            </tr>
            <tr>
                <td width="20%"><div align="left">Humidity: <?php echo $humidity; ?> %</div></td>
            </tr>
            <tr>
                <td width="20%"><div align="left">Battery: <?php echo $battery; ?> volts</div></td>
            </tr>
            <tr>
                <td width="20%"><div align="left">Wind speed: <?php echo $windSpeed; ?> knots</div></td>
            </tr>
        </table>
    </body>
</html>









<html>
    <style type="text/css">
<!--
.style1 {font-size: 12px}  <!-- Data font size -->
-->
    </style>
    <head>
      <title>Show Bat Detector Raw Data</title>
    </head>
    <body>
        <table width="580" border="1" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="13"><h3 align="center">Show Bat Detector Raw Data</h3></td>
            </tr>
            <tr>
                <td width="6%"><div align="center">Id </div></td>
                <td width="12%"><div align="center">Time Stamp </div></td>
                <td width="9%"><div align="center">Temp </div></td>
                <td width="8%"><div align="center">Humidity </div></td>
                <td width="7%"><div align="center">Battery </div></td>
                <td width="7%"><div align="center">Wind </div></td>  	
            </tr>
        </table>
        <table width="580" border="1" cellspacing="0" cellpadding="0"> 
 
<?php

// Start looping rows in mysql database.
    while($rows=mysql_fetch_array($result2)){

?>

 <tr>

 <td bgcolor="#cce2ff" width="6%"><div align="center"><span class="style1"><? echo $rows['ID']; ?></span></td>
 <td bgcolor="#FFFFCC" width="12%"><div align="center"><span class="style1"><? echo $rows['TIME']; ?></span></td>
 <td bgcolor="#ccffcd" width="9%"><div align="center"><span class="style1"><? echo $rows['temp']; ?></span></td>
 <td bgcolor="#ffccd9" width="8%"><div align="center"><span class="style1"><? echo $rows['humidity']; ?></span></td>
 <td bgcolor="#cce2ff" width="7%"><div align="center"><span class="style1"><? echo $rows['battery']; ?></span></td>
 <td bgcolor="#FFFFCC" width="7%"><div align="center"><span class="style1"><? echo $rows['wind']; ?></span></td>     
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
