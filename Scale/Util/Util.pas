unit Util;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs;

type

  TDBObject = record
    Id:   integer;
    Code: integer;
    Name: string;
  end;

  TSetting = record
    ScaleNum:         integer;
    ToolsCode:        integer;
    DefaultToolsCode: integer;
    RouteSortingId:   integer;
    RouteSortingCode: integer;
    RouteSortingName: string;
    DescId:           integer;
    DescName:         string;
    FromId:           integer;
    FromCode:         integer;
    FromName:         string;
    ToId:             integer;
    ToCode:           integer;
    ToName:           string;
    PartnerId:        integer;
    PartnerCode:      integer;
    PartnerName:      string;
    PriceListId:      integer;
    PriceListCode:    integer;
    PriceListName:    string;
    PaidKindId:       integer;
    PaidKindName:     string;
    ColorGridName:    string;
  end;

function GetObject_byCode(Code, DescId: integer): TDBObject;


var
  CurSetting: TSetting;
  NewSetting: TSetting;

implementation

function GetObject_byCode(Code, DescId: integer): TDBObject;
var
 spExec : TdsdStoredProc;
begin
  spExec:=TdsdStoredProc.Create(spExec);
  try
    with spExec do begin
       OutputType:=otResult;
       StoredProcName:='gpGetObject_byCode';
       Params.AddParam('inCode', ftInteger, ptInput, Code);
       Params.AddParam('inDescId', ftInteger, ptInput, DescId);
       Params.AddParam('outId', ftInteger, ptOutput, 0);
       Params.AddParam('outName', ftString, ptOutput, 'test');
       try
         Execute;
         result.Code := Code;
         result.Id   := ParamByName('outId').Value;
         result.Name := ParamByName('outName').Value;
       except
//         ShowMessage('Ошибка получения объекта');
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';

       end;
    end;
  finally spExec.Free end;
end;


end.
