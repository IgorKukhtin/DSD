<?php

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