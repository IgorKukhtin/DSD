<?php

 include_once "createparamsarray.php";
 include_once "getfieldtype.php";
 include_once "filldataset.php";
 include_once "init.php";
 include_once "storedproc.php";

   set_time_limit (0);

 function PrepareStr($str)
 {
   global $isArchive;
   if ($isArchive)
   {
 
     return 't ' . gzcompress($str);
   }
   else
   {
     return 'f ' . $str;
   }
 };


   $doc = new DOMDocument('1.0','windows-1251');
   $doc->loadXML($_POST["XML"]);
/* <xml>
     <master>
        <xml Session = "5" ><test_Select_Object OutputType = "otDataSet"></test_Select_Object>
        </xml>
     </master>
     <list>
       <xml Session = "" ><test_Execute_Sleep OutputType = "otDataSet"><inId  DataType="ftInteger"   Value="Id" /></test_Execute_Sleep>
       </xml>
       <xml Session = "" ><test_Execute_Sleep OutputType = "otDataSet"><inId  DataType="ftInteger"   Value="Id" /></test_Execute_Sleep>
       </xml>
     </list>
   </xml>
*/

// Соединение, выбор базы данных

$dbconn = pg_connect($connectstring)
    or die('Could not connect: ' . pg_last_error());
$query = 'set client_encoding=WIN1251';
$result = pg_query_params($query, array());
pg_free_result($result);

$master = $doc->documentElement->getElementsByTagName('master')->item(0);
$list = $doc->documentElement->getElementsByTagName('list')->item(0);
$ProcedureList = $list->getElementsByTagName('xml');
$SessionNode = $master->firstChild;
$Session = $SessionNode->getAttribute('Session');
$StoredProcNode = $SessionNode->firstChild;

foreach($ProcedureList as $node) {
  $ChildStoredProcList[] = new StoredProc($node->firstChild, $Session, $dbconn);
};
 

$MasterStoredProc = new StoredProc($StoredProcNode, $Session, $dbconn);
$result = $MasterStoredProc->ExecStoredProc();

if ($result == false)
{
     $res = '<error ';
     $res .= 'ErrorMessage = "'.htmlspecialchars(pg_last_error(), ENT_COMPAT, 'WIN-1251').'"';
     $res .= ' />';
     echo 'error        '.PrepareStr($res);
}
else
{
     $recordcount = pg_num_rows($result);
     $step = 100 / $recordcount;
     $currentvalue = 1;
     $currentstep = 0;

     while ($line = pg_fetch_array($result)) {
       // А здесь надо выполнять процедуры на сервере!!!
       foreach($ChildStoredProcList as $ChildStoredProc) {
           // Заполняем параметры из запроса
           $ChildStoredProc->FillParamFromDataSet($line);
           $NewRes = $ChildStoredProc->ExecStoredProc();
           if ($NewRes == false)
           {
               $res = '<error ';
               $res .= 'ErrorMessage = "'.htmlspecialchars(pg_last_error(), ENT_COMPAT, 'WIN-1251').'"';
               $res .= ' />';
               echo 'error        '.PrepareStr($res);
               return;
           };
       }; 
       $currentstep = $currentstep + $step;
       if ($currentstep > $currentvalue){
         while ($currentstep > $currentvalue){
           echo 1;
           $currentvalue = $currentvalue + 1;
         };//while
         flush();
         ob_flush();
       };//if
     }; //while      

  // Очистка результата
  pg_free_result($result); 
};
  
// Закрытие соединения
pg_close($dbconn);

?>