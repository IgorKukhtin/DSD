<?php

 ini_set('display_errors', 0);
 ini_set('display_startup_errors', 0);
 error_reporting(E_FATAL);

; ini_set("display_errors", 1);
; error_reporting(E_ALL);

 set_error_handler(function($errno, $errstr, $errfile, $errline ){
    throw new ErrorException($errstr, $errno, 0, $errfile, $errline);
 });
 $res = '';

try {
 
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
 
 function savetofile($value, $filename = 'response.txt') {
    $file = $filename;
    file_put_contents($file, $value); 
 }
 
 $isUTF8 = isset($_POST["ENC"]) && strtoupper($_POST["ENC"]) == 'UTF8';
 if ($isUTF8) {
    $encoding = 'UTF-8';
 }
 else {
    $encoding = 'WIN-1251';
 }

 set_time_limit (0);
 
// ����������, ����� ���� ������

//echo XML_MAX_TEXT_LENGTH;

$dbconn = pg_connect($connectstring)
    or die('Could not connect: ' . pg_last_error());
if ($isUTF8) {
    $query = 'set client_encoding=Utf8';
}
else {
    $query = 'set client_encoding=WIN1251';
}
$result = pg_query($dbconn, $query);
if($result)
    pg_free_result($result);


if ($isUTF8) {
    $doc = new DOMDocument('1.0');
}
else {
    $doc = new DOMDocument('1.0','windows-1251');
}

//c ���� �� �������� �������� ������ �������� �������
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

// ���������� SQL �������
if ($OutputType=='otMultiDataSet')
{
   pg_query($dbconn, 'BEGIN;');
   $query = 'select * from '.$StoredProcName.'('.$ParamName.')';
}
else
{
   $query = 'select * from '.$StoredProcName.'('.$ParamName.')';
};

                 
if ($OutputType=='otMultiExecute')
{
  $data = $doc->documentElement->childNodes->Item(1);
  // ��������� ��������� �� ����� ����������� �� $data
  foreach ($data->childNodes as $dataitem) {
      $i = 0;
      // ��������� ���������� ����������� �� $dataitem
      foreach($dataitem->childNodes as $param) {
         if ($param->getAttribute('Value') == 'NULL') 
         { 
             $ParamValues[$i] = NULL;
         }
         else
         {
            if ($isUTF8) {
                $ParamValues[$i] = $param->getAttribute('Value');
            }
            else {
                $ParamValues[$i] = iconv ('utf-8', 'windows-1251', $param->getAttribute('Value'));
            }
         };
         $i = $i + 1;
      };
     $result = pg_send_query_params ($dbconn, $query, $ParamValues);
     $result = pg_get_result($dbconn);
     $result_error = pg_result_error($result);
     if ($result_error != false)
     {
         $res = '<error ';                                                   
         $res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, $encoding).'"';
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
     $res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, $encoding).'"';
     $res .= ' />';
     echo 'error        '.PrepareStr($res);
}
else
{
  if ($OutputType=='otResult')
  {// ����� ����������� � XML
    $res = "<Result";
      $fieldcount = pg_num_fields($result);
      for ($i = 0; $i < $fieldcount; $i++) {
          $fieldtype[$i] = pg_field_type($result, $i);
          $fieldname[$i] = pg_field_name($result, $i);
      };
    while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        $i = 0;
        foreach ($line as $col_value) {
           if (strtoupper($fieldtype[$i]) == 'TIMESTAMPTZ')
           {
              $res .=  ' ' . $fieldname[$i] . '="' . str_replace(' ', 'T', $col_value) . '"';
           }
           else
           {
              $res .=  ' ' . $fieldname[$i] . '="' . htmlspecialchars($col_value, ENT_COMPAT, 'WIN-1251') . '"';
           };
           $i++;
        }
    }
    $res .= "/>";
    echo 'Result       '.PrepareStr($res);
  };

  if ($OutputType=='otBlob')
  {// ����� ����������� � XML
    $line = pg_fetch_array($result, null, PGSQL_ASSOC);
        foreach ($line as $col_value) {
            $res =  $col_value;
        }
    echo 'Result       '.PrepareStr($res);
  };
  
  if ($OutputType=='otDataSet')
  {
     $res = FillDataSet($result, $DataSetType, $AutoWidht);
     // ���������� ���������
     savetofile($res);
     echo 'DataSet      '.PrepareStr($res);
     
  };
   
  if ($OutputType=='otMultiDataSet')
  { 
    $res = '';
    $CursorsClose = '';
    $XMLStructure = '<DataSets>';
    while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) 
    {   
        // ��������� FETCH ��� ������� �������
        foreach ($line as $col_value) {
           $query = 'FETCH ALL "'.$col_value.'";';       
           $CursorsClose .= 'CLOSE "'.$col_value.'";';
        };
        $result_cursor = pg_query($query);
        $DataSetStr = FillDataSet($result_cursor, $DataSetType, $AutoWidht, true);
        $res .= $DataSetStr;
        $XMLStructure .= '<DataSet length = "'.strlen($DataSetStr).'"/>';
    };
    $XMLStructure .= '</DataSets>';
    // ������� ����������
        
    pg_query($CursorsClose . 'COMMIT; END;');
    echo 'MultiDataSet ' . PrepareStr(sprintf("%010d", strlen($XMLStructure)) . $XMLStructure . $res);  
  };
  // ������� ����������
  pg_free_result($result);
};

// �������� ����������
pg_close($dbconn);
  
} catch(Exception $e) {
    $res = '<error ';                                                   
    $res .= 'ErrorCode = ""'.' ErrorMessage = "'.htmlspecialchars($e->getMessage(), ENT_COMPAT, $encoding).' on line '. $e->getLine().' in file '. $e->getFile().'"';
    $res .= ' />';
    echo 'error        '.PrepareStr($res);
}

?>