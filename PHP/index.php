<?php
 include_once "createparamsarray.php";
 include_once "getfieldtype.php";
 include_once "filldataset.php";
 include_once "init.php";

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

 set_time_limit (0);
 
// Соединение, выбор базы данных

$dbconn = pg_pconnect($connectstring)
    or die('Could not connect: ' . pg_last_error());

$query = 'set client_encoding=WIN1251';
$result = pg_query_params($query, array());
pg_free_result($result);

$doc = new DOMDocument('1.0','windows-1251');
$doc->loadXML($_POST["XML"]);

/*$doc->loadXML('<xml Session = "" >'.
    '<gp_Select_Master OutputType="otDataSet"/>'.
  '</xml>');*/


$Session = $doc->documentElement->getAttribute('Session');
$StoredProcNode = $doc->documentElement->firstChild;
$StoredProcName = $StoredProcNode->nodeName;
$OutputType = $StoredProcNode->getAttribute('OutputType');

$ParamName = '';
$ParamValues = array();

CreateParamsArray($StoredProcNode->childNodes, $Session, $ParamValues, $ParamName);

// Выполнение SQL запроса
if ($OutputType=='otMultiDataSet')
{
   pg_query('BEGIN;'); 
   $query = 'select * from '.$StoredProcName.'('.$ParamName.')';
}
else
{
   $query = 'select * from '.$StoredProcName.'('.$ParamName.')';
};

$result = pg_query_params($query, $ParamValues);

if ($result == false)
{
     $res = '<error ';
     $res .= 'ErrorMessage = "'.htmlspecialchars(pg_last_error(), ENT_COMPAT, 'WIN-1251').'"';
     $res .= ' />';
     echo 'error        '.PrepareStr($res);
}
else
{
  if ($OutputType=='otResult')
  {// Вывод результатов в XML
    $res = "<Result";
    $i = 0;
    while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        foreach ($line as $col_value) {
           if (pg_field_type($result, $i) == 'timestamptz')
           {
              $res .=  ' ' . pg_field_name($result, $i) . '="' . str_replace(' ', 'T', $col_value) . '"';
           }
           else
           {
              $res .=  ' ' . pg_field_name($result, $i) . '="' . htmlspecialchars($col_value, ENT_COMPAT, 'WIN-1251') . '"';
           };
           $i = $i + 1;
        }
    }
    $res .= "/>";
    echo 'Result       '.PrepareStr($res);
  };

  if ($OutputType=='otBlob')
  {// Вывод результатов в XML
    $line = pg_fetch_array($result, null, PGSQL_ASSOC);
        foreach ($line as $col_value) {
            $res =  $col_value;
        }
    echo 'Result       '.PrepareStr($res);
  };
  
  if ($OutputType=='otDataSet')
  {
     $res = FillDataSet($result);
     // возвращаем результат
     echo 'DataSet      '.PrepareStr($res);
  };
   
  if ($OutputType=='otMultiDataSet')
  { 
    $res = '';
    $CursorsClose = '';
    $XMLStructure = '<DataSets>';
    while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) 
    {   
        // Выполняем FETCH для каждого курсора
        foreach ($line as $col_value) {
           $query = 'FETCH ALL "'.$col_value.'";';       
           $CursorsClose .= 'CLOSE "'.$col_value.'";';
        };
        $result_cursor = pg_query($query);
        $DataSetStr = FillDataSet($result_cursor);
        $res .= $DataSetStr;
        $XMLStructure .= '<DataSet length = "'.strlen($DataSetStr).'"/>';
    };
    $XMLStructure .= '</DataSets>';
    // Закроем транзакцию
    pg_query($CursorsClose . 'COMMIT; END;');
    echo 'MultiDataSet ' . PrepareStr(sprintf("%010d", strlen($XMLStructure)) . $XMLStructure . $res);
  };
  // Очистка результата
  pg_free_result($result);
};

// Закрытие соединения
pg_close($dbconn);
  
?>