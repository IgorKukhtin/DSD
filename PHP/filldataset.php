<?php
  include_once "getfieldtype.php";

  function ClientDataSetFillDataSetBinary($dataset)
  {
     $header = pack('C', hexdec('96')).pack('C', hexdec('19')).pack('C', hexdec('E0')).pack('C', hexdec('BD'));
     $header .= pack('I', 1);
     $header .= pack('I', hexdec('18'));

     $fieldcount = pg_num_fields($dataset);

     $fieldlistheader  = pack('S', $fieldcount); // количество полей
     $fieldlistheader .= pack('I', pg_num_rows($dataset)); // количество записей в пакете
     $fieldlistheader .= pack('I', 3);

     for ($i = 0; $i < $fieldcount; $i++) {
         $type[$i] = pg_field_type_oid($dataset, $i);
         $fieldname[$i] = pg_field_name($dataset, $i);
     };
 
     $res = '';
     // «аполн€ем дата сет
     while ($line = pg_fetch_row($dataset)) 
     {
        $res .= pack('C', 0);  //RecordStatus  

        for ($i = 0; $i <= ($fieldcount-1)/4 ; $i++)
            {$res .= pack('C', 0); }; //StatusBits
        $i = 0;
        foreach ($line as $col_value) 
        {
          $typeint = $type[$i];
          switch ($typeint) 
           {
                case 1043: // Varchar
                   $res .= pack('S', strlen($col_value)); 
                   $res .= $col_value;
                   break;
                case 23:   // Integer
                   $res .= pack('L', $col_value);
                   break;
                case 25:   // Text
                   $res .= pack('l', strlen($col_value)); 
                   $res .= $col_value;
                   break;
                case 16:
                   if ($col_value == 't') 
                      { $res .= pack('S', 1);}
                   else
                      { $res .= pack('S', 0);};
                   break;
                case 1700: // numeric
                   $res .= pack('d', $col_value);
                   break;
                case 20: // datetime 
                   $res .= pack('d', ($col_value + 62135683200) * 1000);
                   break;
//                case 1114: // datetime //strtotime($col_value) + (62135694000) * 1000
//                   $res .= pack('d', 0);
//                   break;
//                case 1184: // datetime TimeZone //strtotime($col_value) + (62135694000) * 1000
//                   $res .= pack('d', 1000000000000);
//                   break;
           };            
          $i++;                                       
        };
     };      

     $fieldlist = '';
     for ($i = 0; $i < $fieldcount; $i++) {
         $fieldlist .= pack('C', strlen($fieldname[$i])); // длина названи€
         $fieldlist .= $fieldname[$i];  // название
         $fieldlist .= PostgresTypeToClientDataSetBinary($type[$i], 255); // тип и размер типа
     };
     $fieldlist .= pack('S', 0);// количество свойств вообще
     
     return $header.$fieldlistheader.pack('S', strlen($fieldlist) + 24).$fieldlist.$res;
  }; 
	
  function ClientDataSetFillDataSetBinaryAutoWidth($dataset)
  {
     $header = pack('C', hexdec('96')).pack('C', hexdec('19')).pack('C', hexdec('E0')).pack('C', hexdec('BD'));
     $header .= pack('I', 1);
     $header .= pack('I', hexdec('18'));

     $fieldcount = pg_num_fields($dataset);

     $fieldlistheader  = pack('S', $fieldcount); // количество полей
     $fieldlistheader .= pack('I', pg_num_rows($dataset)); // количество записей в пакете
     $fieldlistheader .= pack('I', 3);

     for ($i = 0; $i < $fieldcount; $i++) {
         $type[$i] = pg_field_type_oid($dataset, $i);
         $fieldname[$i] = pg_field_name($dataset, $i);
         $maxlen[$i] = 1;
     };
 
     $res = '';
     // «аполн€ем дата сет
     while ($line = pg_fetch_row($dataset)) 
     {
        $res .= pack('C', 0);  //RecordStatus  

        for ($i = 0; $i <= ($fieldcount-1)/4 ; $i++)
            {$res .= pack('C', 0); }; //StatusBits
        $i = 0;
        foreach ($line as $col_value) 
        {
          $typeint = $type[$i];
          switch ($typeint) 
           {
                case 1043: // Varchar
                   $len = strlen($col_value);
                   if ($len > $maxlen[$i])
                           {$maxlen[$i] = $len;};
                   $res .= pack('S', $len); 
                   $res .= $col_value;
                   break;
                case 23:   // Integer
                   $res .= pack('L', $col_value);
                   break;
                case 25:   // Text
                   $res .= pack('l', strlen($col_value)); 
                   $res .= $col_value;
                   break;
                case 16:
                   if ($col_value == 't') 
                      { $res .= pack('S', 1);}
                   else
                      { $res .= pack('S', 0);};
                   break;
                case 1700: // numeric
                   $res .= pack('d', $col_value);
                   break;
                case 20: // datetime 
                   $res .= pack('d', ($col_value + 62135683200) * 1000);
                   break;
//                case 1114: // datetime //strtotime($col_value) + (62135694000) * 1000
//                   $res .= pack('d', 0);
//                   break;
//                case 1184: // datetime TimeZone //strtotime($col_value) + (62135694000) * 1000
//                   $res .= pack('d', 1000000000000);
//                   break;
           };            
          $i++;                                       
        };
     };      

     $fieldlist = '';
     for ($i = 0; $i < $fieldcount; $i++) {
         $fieldlist .= pack('C', strlen($fieldname[$i])); // длина названи€
         $fieldlist .= $fieldname[$i];  // название
         $fieldlist .= PostgresTypeToClientDataSetBinary($type[$i], $maxlen[$i]); // тип и размер типа
     };
     $fieldlist .= pack('S', 0);// количество свойств вообще
     
     return $header.$fieldlistheader.pack('S', strlen($fieldlist) + 24).$fieldlist.$res;
  }; 

  function ClientDataSetFillDataSet($dataset)
  {
     $res = '<?xml version="1.0" standalone="yes"?>  <DATAPACKET Version="2.0"><METADATA><FIELDS>';

     $fieldcount = pg_num_fields($dataset);
     // »нформаци€ о пол€х запроса
     for ($i = 0; $i < $fieldcount; $i++) {
        $type[$i] = pg_field_type($dataset, $i);
        $fieldname[$i] = pg_field_name($dataset, $i);
        $res .= '<FIELD attrname="'.$fieldname[$i].'"'.GetFieldType2($type[$i]).'/>';
     };
     $res .= '</FIELDS></METADATA><ROWDATA>';

     // «аполн€ем дата сет
     while ($line = pg_fetch_row($dataset)) {
        $i = 0;
        $res .= '<ROW';
        foreach ($line as $col_value) {
           if(strtoupper($type[$i])== 'TIMESTAMPTZ')//if (pg_field_type($dataset, $i) == 'timestamptz')
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


  function ClientDataSetFillDataSetAutoWidth($dataset)
  {

     $header = '<?xml version="1.0" standalone="yes"?>  <DATAPACKET Version="2.0"><METADATA><FIELDS>';

     $fieldcount = pg_num_fields($dataset);
     // »нформаци€ о пол€х запроса
     for ($i = 0; $i < $fieldcount; $i++) {
        $fieldname[$i] = pg_field_name($dataset, $i);
        $type[$i] = pg_field_type($dataset, $i);
        $type_oid[$i] = pg_field_type_oid($dataset, $i);
        $maxlenght[$i] = 1;
     };
     
     $res = '<ROWDATA>';

     // «аполн€ем дата сет
     while ($line = pg_fetch_row($dataset)) {
        $i = 0;
        $res .= '<ROW';
        foreach ($line as $col_value) {
           if (strtoupper($type[$i])== 'TIMESTAMPTZ')
           {
              $res .= ' '.$fieldname[$i].'="'.str_replace(' ', 'T', $col_value).'"';
           }
	   else
           {
              if ($type_oid[$i] == 1043)
              {
                  $len = strlen($col_value);
                  if ($len > $maxlenght[$i]) 
                  {
                      $maxlenght[$i] = $len;
                  };
              };
              $res .= ' '.$fieldname[$i].'="'.htmlspecialchars($col_value, ENT_COMPAT, 'WIN-1251').'"';
           }; 
           $i++;
        }
        $res .= '/>';
     };      

     $res .= '</ROWDATA></DATAPACKET>';

     $fieldinfo = '';
     for ($i = 0; $i < $fieldcount; $i++) {
        $fieldinfo .= '<FIELD attrname="'.$fieldname[$i].'"'.PostgresTypeToClientDataSet($type[$i], $maxlenght[$i]).'/>';
     };
     $fieldinfo .= '</FIELDS></METADATA>';

     return $header.$fieldinfo.$res;

  }; 

  function MemTableFillDataSet($dataset)
  { 
     $res = '"@@FILE VERSION@@","251"';
     $res .= PHP_EOL.'"@@TABLEDEF START@@"';

     $fieldnames = '';

     $fieldcount = pg_num_fields($dataset);
     // »нформаци€ о пол€х запроса
     for ($i = 0; $i < $fieldcount; $i++) {
         $fieldName = pg_field_name($dataset, $i);
         $fieldnames .= '"'.$fieldName.'",';
         $res .= PHP_EOL.'"'.$fieldName.'='.getfieldtypememtable($dataset, $i).',""'.$fieldName.'"","""",10,Data,"""""';
     };
     $res .= PHP_EOL."@@TABLEDEF END@@";
     $res .= PHP_EOL.$fieldnames;

     while ($line = pg_fetch_row($dataset)) {
        $res .= PHP_EOL;
        foreach ($line as $col_value) {
             $res .= '"'.$col_value.'",';
        }
     };      
     $res .= PHP_EOL;

     return $res;
  };


  function FillDataSet($dataset, $DataSetType, $AutoWidth)
  {
      $isDateField = false;
      $fieldcount = pg_num_fields($dataset);
      for ($i = 0; $i < $fieldcount; $i++) 
      {
        $type = pg_field_type_oid($dataset, $i);      
        if ( ($type == 1114) or ($type == 1184) ) 
            { 
               $isDateField = true; 
               break; 
            };
      };


      if ($AutoWidth)
      {
         if ($isDateField)
         {  
            return ClientDataSetFillDataSetAutoWidth($dataset);
         }
         else
         {
           return ClientDataSetFillDataSetBinaryAutoWidth($dataset);
         }
      }
      else
      { 
         if ($isDateField)
         {  
            return ClientDataSetFillDataSet($dataset);
         }
         else
         {
            return ClientDataSetFillDataSetBinary($dataset);
         }
      };
  };
?>