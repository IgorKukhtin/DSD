<?php


function GetFieldTypeMemTable($result, $i)
{
   $type = pg_field_type($result, $i);
   switch ($type) {
     case 'int4':
        $type = 'Integer,0';
        break;
     case 'varchar':
        $type = 'string,255';
        break;
     case 'text':
        $type = 'Memo,0';
        break;
     case 'bool':
        $type = 'Boolean,0';
        break;
     case 'numeric':
        $type = 'Float,0';
        break;
     case 'timestamptz':
        $type = 'Date,0';
        break;
     case 'timestamp':
        $type = 'Date,0';
        break;
   }
   return $type;
};

function GetFieldType($result, $i)
 {
   $type = pg_field_type($result, $i);
   switch ($type) {
     case 'int4':
        $type = 'i4';
        break;
     case 'varchar':
        $type = 'string" WIDTH="255';
        break;
     case 'text':
        $type = 'bin.hex" SUBTYPE="Text" WIDTH="1';
        break;
     case 'bool':
        $type = 'boolean';
        break;
     case 'numeric':
        $type = 'r8';
        break;
     case 'timestamptz':
        $type = 'dateTime';
        break;
     case 'timestamp':
        $type = 'dateTime';
        break;
   }
   return ' fieldtype="'.$type.'"';
 }

?>