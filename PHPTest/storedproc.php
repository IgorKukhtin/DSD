<?php

class Param {
  public $ParamName;
  public $ParamDataSetName;
  public $ParamType;
  public $ParamValue;

  public function __construct($XMLNode) 
    { 
       $this->ParamName = $XMLNode->nodeName;
       $this->ParamType = GetParamType($XMLNode->getAttribute('DataType'));
       $this->ParamValue = iconv ('utf-8', 'windows-1251', $XMLNode->getAttribute('Value'));
       $this->ParamDataSetName = strtolower($this->ParamValue);
    } 
};

class StoredProc {
  private $StoredProcName;
  private $OutputType;
  public  $Params;
  private $Connection;
  private $Session;

  public function __construct($StoredProcNode, $Session, $dbconn) 
    { 
       // Установили значения процедуры
       $this->StoredProcName = $StoredProcNode->nodeName;
       $this->OutputType = $StoredProcNode->getAttribute('OutputType');
       $this->Connection = $dbconn;
       $this->Session = $Session;

       // Заполнили параметры
       foreach($StoredProcNode->childNodes as $Param) {
            $this->Params[] = new Param($Param);
       };
    } 

  public function FillParamFromDataSet($line)
   {
       foreach($this->Params as $Param) {
         $Param->ParamValue = $line[$Param->ParamDataSetName];
       };
   }
  
  public function ExecStoredProc()
    {
        $query = 'select * from '.$this->StoredProcName.'('.$this->GetParamNames().')';
        return pg_query_params($this->Connection, $query, $this->GetParamValues());
    } 

  private function GetParamNames()
   {
       $ParamStr = '';
       $i = 0;
       foreach($this->Params as $Param) {
         $i = $i + 1;
         if ($ParamStr != '') { $ParamStr .= ', '; };
         $ParamStr .= '$'.$i.'::'.$Param->ParamType;
       };
       $i = $i + 1;
       // Добавление параметра с Сессией
       if ($ParamStr != '') { $ParamStr .= ', '; };
       $ParamStr .= '$'.$i.'::TVarChar';      

       return $ParamStr;
   }
  
   private function GetParamValues()
   {
       foreach($this->Params as $Param) {
         $outPut[] = $Param->ParamValue;
       };
       // Добавление параметра с Сессией
       $outPut[] = $this->Session;
       return $outPut;
   }

  }
?>