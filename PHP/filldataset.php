<?php
  include_once "getfieldtype.php";

  function FillDataSet($dataset)
  {
     $res = '<?xml version="1.0" standalone="yes"?>  <DATAPACKET Version="2.0"><METADATA><FIELDS>';

     $fieldcount = pg_num_fields($dataset);
     // Информация о полях запроса
     for ($i = 0; $i < $fieldcount; $i++) {
        $fieldname[$i] = pg_field_name($dataset, $i);
        $res .= '<FIELD attrname="'.pg_field_name($dataset, $i).'"'.getfieldtype($dataset, $i).'/>';
     };
     $res .= '</FIELDS></METADATA><ROWDATA>';

     // Заполняем дата сет
     while ($line = pg_fetch_array($dataset, null, PGSQL_ASSOC)) {
        $i = 0;
        $res .= '<ROW';
        foreach ($line as $col_value) {
           $res .= ' '.$fieldname[$i].'="'.str_replace('"', '&quot;', $col_value).'"'; 
           $i++;
        }
        $res .= '/>';
     };      

     $res .= '</ROWDATA></DATAPACKET>';
    
     return $res;
   };
?>