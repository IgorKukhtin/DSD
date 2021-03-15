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

function GetFieldType2($type)
{
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

function PostgresTypeToClientDataSet($type, $size)
 {
   switch ($type) {
     case 'int4':
        $type = 'i4';
        break;
     case 'varchar':
        $type = 'string" WIDTH="'.$size;
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

function PostgresTypeToClientDataSetBinary($type, $size)
 {
   switch ($type) {
     case 23:   // Integer
        $res = pack('S', 4).pack('S', 1).pack('S', 16).pack('S', 0);
        break;
     case 1043: // Varchar
        $res = pack('S',2).pack('S', 73).pack('S', 16).pack('S', 1).pack('C',5).'WIDTH'.
                pack('S',2).pack('S',2).pack('S', $size);
        break;
     case 25:
        $res = pack('S', 4).pack('S', 75).pack('S', 16).pack('S', 2).pack('C',7).'SUBTYPE'.
               pack('S', 2).pack('S', 73).pack('S', 5).'Text'.pack('C', 0).pack('C', 5).
               'WIDTH'.pack('S',2).pack('S',2).pack('S',1);
        break;
     case 16:
        $res = pack('S', 2).pack('S', 3).pack('S', 16).pack('S', 0);
        break;
     case 1700: // numeric
        $res = pack('S', 8).pack('S', 4).pack('S', 16).pack('S', 0);
        break;
     case 20: // datetime
        $res = pack('S', 8).pack('S', 8).pack('S', 16).pack('S', 0);
        break;
//     case 1184: // datetime
  //      $res = pack('S', 8).pack('S', 8).pack('S', 16).pack('S', 0);
    //    break;
//     case 1114: // datetime
  //      $res = pack('S', 8).pack('S', 8).pack('S', 16).pack('S', 0);
    //    break;
   }
   return $res;
 }

?>