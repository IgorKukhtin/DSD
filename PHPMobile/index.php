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

 set_time_limit (0);
 
// ����������, ����� ���� ������

$dbconn = pg_connect($connectstring)
    or die('Could not connect: ' . pg_last_error());
//$query = 'set client_encoding=WIN1251';
$query = 'set client_encoding=UTF8';
$result = pg_query_params($query, array());
pg_free_result($result);


//$doc = new DOMDocument('1.0','windows-1251');
$doc = new DOMDocument('1.0','UTF-8');

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
             //$ParamValues[$i] = iconv ('utf-8', 'windows-1251', $param->getAttribute('Value'));
             $ParamValues[$i] = $param->getAttribute('Value');
         };
         $i = $i + 1;
      };
     $result = pg_send_query_params ($dbconn, $query, $ParamValues);
     $result = pg_get_result($dbconn);
     $result_error = pg_result_error($result);
     if ($result_error != false)
     {
         $res = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <error ';                                                   
         //$res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, 'WIN-1251').'"';
         $res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, 'UTF-8').'"';
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
     $res = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <error ';                                                   
     //$res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, 'WIN-1251').'"';
     $res .= 'ErrorCode = "'.pg_result_error_field($result, PGSQL_DIAG_SQLSTATE).'"'.' ErrorMessage = "'.htmlspecialchars($result_error, ENT_COMPAT, 'UTF-8').'"';
     $res .= ' />';
     echo 'error        '.PrepareStr($res);
}
else
{
  if ($OutputType=='otResult')
  {// ����� ����������� � XML
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
              //$res .=  ' ' . pg_field_name($result, $i) . '="' . htmlspecialchars($col_value, ENT_COMPAT, 'WIN-1251') . '"';
              $res .=  ' ' . pg_field_name($result, $i) . '="' . htmlspecialchars($col_value, ENT_COMPAT, 'UTF-8') . '"';
           };
           $i = $i + 1;
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
        $DataSetStr = FillDataSet($result_cursor, $DataSetType, $AutoWidht);
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
  
?>