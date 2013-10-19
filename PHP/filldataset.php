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
     while ($line = pg_fetch_row($dataset)) {
        $i = 0;
        $res .= '<ROW';
        foreach ($line as $col_value) {
           if (pg_field_type($dataset, $i) == 'timestamptz')
           {
              $res .= ' '.$fieldname[$i].'="'.str_replace(' ', 'T', $col_value).'"';
           }
	   else
           {
              $res .= ' '.$fieldname[$i].'="'.htmlspecialchars($col_value, ENT_COMPAT, 'WIN-1251').'"';
           }; 
           $i++;
        }
        $res .= '/>';
     };      

     $res .= '</ROWDATA></DATAPACKET>';
    
     return $res;
   };
?>