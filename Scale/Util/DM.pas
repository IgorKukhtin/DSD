unit DM;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs;

type
  TDMMain = class(TDataModule)
    DataSource1: TDataSource;
    ClientDataSet: TClientDataSet;
    spExec: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDBObject = record
    Id:   integer;
    Code: integer;
    Name: string;
  end;

  TSetting = record
    DescId:   integer;
    DescName: string;
    FromId:   integer;
    FromCode: integer;    
    FromName: string;
    ToId:   integer;
    ToCode: integer;        
    ToName: string;
    PartnerId:   integer;
    PartnerCode: integer;        
    PartnerName: string;    
    PaidKindId:   integer;
    PaidKindName: string;
    ColorGridName: string;
  end;

function GetObject_byCode(var Code: integer): TDBObject;


var
  DMMain: TDMMain;
  CurSetting: TSetting;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function GetObject_byCode(var Code: integer): TDBObject;
var
 spExc : TdsdStoredProc; 
begin
  spExc:=TdsdStoredProc.Create(spExc);
  try
    with spExc do begin
       OutputType:=otResult;    
       StoredProcName:='gpGetObject_byCode';
       Params.AddParam('inCode', ftInteger, ptInput, Code);       
       Params.AddParam('outId', ftInteger, ptOutput, 0);              
       Params.AddParam('outName', ftString, ptOutput, 'test');                     
       try       
         Execute;
         result.Code := Code;
         result.Id   := ParamByName('outId').Value;
         result.Name := ParamByName('outName').Value;         
       except
         ShowMessage('Ошибка получения объекта');
       end;
    end;
  finally spExc.Free end;
end;


end.
