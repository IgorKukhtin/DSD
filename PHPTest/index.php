<?php
 include_once "createparamsarray.php";
 include_once "getfieldtype.php";
 include_once "filldataset.php";
 include_once "init.php";

 function PrepareStr($str)
 {
   global $isArchive;
   if (($isArchive) && (strlen($str) > 100))
   {
 
     return 't ' . gzcompress($str);
   }
   else
   {
     return 'f ' . $str;
   }
 };

 function _log($var, $clear=FALSE, $path=NULL) {
    if ($var) {
        $date = '====== '.date('Y-m-d H:i:s')." =====\n";
        $res = $var;
        if (is_array($var) || is_object($var)) {
            $res = print_r($var, 1);
        }
        $res .="\n";
        if(!$path)
            $path = dirname($_SERVER['SCRIPT_FILENAME']) . '/project.log';
        if($clear)
            file_put_contents($path, ''); 
        @error_log($date.$res, 3, $path);
        return true;
    }
    return false;
};

 set_time_limit (0);
 
// Соединение, выбор базы данных

$dbconn = pg_connect($connectstring)
    or die('Could not connect: ' . pg_last_error());
$query = 'set client_encoding=WIN1251';
$result = pg_query_params($query, array());
pg_free_result($result);


$doc = new DOMDocument('1.0','windows-1251');

//c этим не работает загрузка файлов большого размера
//if(!$doc->loadXML($_POST["XML"])) {
//echo "Input data can't be parsed as XML document";
//exit;
//}

$doc->loadXML($_POST["XML"],LIBXML_PARSEHUGE);

$Session = $doc->documentElement->getAttribute('Session');
$AutoWidht = ($doc->documentElement->getAttribute('AutoWidth') == 'true');
$StoredProcNode = $doc->documentElement->firstChild;
$StoredProcName = $StoredProcNode->nodeName;
$OutputType = $StoredProcNode->getAttribute('OutputType');
$DataSetType = $StoredProcNode->getAttribute('DataSetType');
  
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

                 
if ($OutputType=='otMultiExecute')
{
  $data = $doc->documentElement->childNodes->Item(1);
  // выполняем процедуру со всеми параметрами из $data
  foreach ($data->childNodes as $dataitem) {
      $i = 0;
      // заполняем прорцедуру параметрами из $dataitem
      foreach($dataitem->childNodes as $param) {
         if ($param->getAttribute('Value') == 'NULL') 
         { 
             $ParamValues[$i] = NULL;
         }
         else
         {
             $ParamValues[$i] = iconv ('utf-8', 'windows-1251', $param->getAttribute('Value'));
         };
         $i = $i + 1;
      };
     $result = pg_send_query_params ($dbconn, $query, $ParamValues);
     $result = pg_get_result($dbconn);
     $result_error = pg_result_error($result);
     if ($result_error != false)
     {
         $res = '<error ';                                                   
         $res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, 'WIN-1251').'"';
         $res .= ' />';
         echo 'error        '.PrepareStr($res);
     };
  };
} 
else
{
     $result = pg_send_query_params ($dbconn, $query, $ParamValues);
     $result = pg_get_result($dbconn);
     $result_error = pg_result_error($result);
};
          
if ($result_error != false)
{
     $res = '<error ';                                                   
     $res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, 'WIN-1251').'"';
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
     $res = FillDataSet($result, $DataSetType, $AutoWidht);
     // формируем строку для возврата результата
     $datares = 'DataSet      '.PrepareStr($res);
     // логируем
     _log($datares);
     // возвращаем результат
     echo $datares;
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
        $DataSetStr = FillDataSet($result_cursor, $DataSetType, $AutoWidht);
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