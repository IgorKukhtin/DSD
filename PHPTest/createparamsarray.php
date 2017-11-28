<?php

 function GetParamType($XMLParamType)
 {
   switch ($XMLParamType) {
     case 'ftInteger':
        $type = 'integer';
        break;
     case 'ftString':
        $type = 'TVarChar';
        break;
     case 'ftFloat':
        $type = 'TFloat';
        break;
     case 'ftBlob':
        $type = 'TBlob';
        break;
     case 'ftDateTime':
        $type = 'TDateTime';
        break;
     case 'ftBoolean':
        $type = 'Boolean';
        break;
   }
   return $type;
 }


 function CreateParamsArray($ParamNodes, $Session, &$ParamArray, &$ParamStr)
 {
 $i = 0;

foreach($ParamNodes as $node) {
       $ParamType = GetParamType($node->getAttribute('DataType'));

       if (($ParamType == 'TDateTime')  and  ($node->getAttribute('Value') == 'NULL')) 
       {
          $ParamArray[$i] = NULL;
       }
       else
       {
          $ParamArray[$i] = iconv ('utf-8', 'windows-1251', $node->getAttribute('Value'));
       };

       $i = $i + 1;
       if ($ParamStr=='')
       {
         $ParamStr = '$'.$i.'::'.$ParamType;
       }
       else
       {
         $ParamStr .= ', '.'$'.$i.'::'.$ParamType;  
       };
     };

$i = $i + 1;
// Добавление параметра с Сессией
if ($ParamStr=='')
{
   $ParamStr = '$'.$i.'::TVarChar';
}
else
{
   $ParamStr .= ', '.'$'.$i.'::TVarChar';  
};

$ParamArray[$i] = $Session;
  
 };
?>