unit PriceListTest;

interface

  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TPriceListTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPriceList = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceList(const Id, Code: Integer; Name: string;
      PriceWithVAT:Boolean;VATPercent:Double; CurrencyId: Integer): integer;
    constructor Create; override;
  end;


implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CurrencyTest;

constructor TPriceList.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PriceList';
  spSelect := 'gpSelect_Object_PriceList';
  spGet := 'gpGet_Object_PriceList';
end;

function TPriceList.InsertDefault: integer;
var
  CurrencyId: Integer;
begin
  With TCurrency.Create do
  Begin
    if not GetDataSet.isEmpty then
      CurrencyId := GetDataSet.FieldByName('Id').AsInteger
    else
      CurrencyId := GetDefault;
  End;
  result := InsertUpdatePriceList(0, -1, 'Прайс-лист',false,20,CurrencyId);
  inherited;
end;

function TPriceList.InsertUpdatePriceList(const Id, Code: Integer;Name: string;
  PriceWithVAT:Boolean;VATPercent:Double; CurrencyId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  result := InsertUpdate(FParams);
end;

  procedure TPriceListTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\PriceList\';
  inherited;
end;
procedure TPriceListTest.Test;
begin

end;
     initialization
  TestFramework.RegisterTest('Объекты', TPriceListTest.Suite);
end.
