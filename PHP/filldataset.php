<?php
  include_once "getfieldtype.php";

  function ClientDataSetFillDataSet($dataset)
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

  function MemTableFillDataSet($dataset)
  { 
     $res = '"@@FILE VERSION@@","251"';
     $res .= PHP_EOL.'"@@TABLEDEF START@@"';

     $fieldnames = '';

     $fieldcount = pg_num_fields($dataset);
     // Информация о полях запроса
     for ($i = 0; $i < $fieldcount; $i++) {
        $fieldnames .= pg_field_name($dataset, $i).',';
        $res .= PHP_EOL.'"'.pg_field_name($dataset, $i).'='.getfieldtypememtable($dataset, $i).',""'.pg_field_name($dataset, $i).'"","""",10,Data,"""""';
     };
     $res .= PHP_EOL."@@TABLEDEF END@@";
     $res .= PHP_EOL.$fieldnames;

     while ($line = pg_fetch_row($dataset)) {
        $res .= PHP_EOL;
        foreach ($line as $col_value) {
           $res .= '"'.$col_value.'",';
        }
     };      

     return $res;
  };


  function FillDataSet($dataset, $DataSetType)
  {
     if ($DataSetType == 'TkbmMemTable')
        {
           return MemTableFillDataSet($dataset);
        }
     else
        {
           return ClientDataSetFillDataSet($dataset);
        };


   };
?>