unit CurrencyTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TCurrencyTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


  TCurrency = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

{ TCurrencyTest }

constructor TCurrency.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Currency';
  spSelect := 'gpSelect_Object_Currency';
  spGet := 'gpGet_Object_Currency';
end;

function TCurrency.InsertDefault: integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('inCurrencyCode', ftInteger, ptInput, 920);
  FParams.AddParam('inCurrencyName', ftString, ptInput, 'GRN');
  FParams.AddParam('inFullName', ftString, ptInput, 'Гривна');
  result := InsertUpdate(FParams);
  inherited;
end;

procedure TCurrencyTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Currency\';
  inherited;
end;

procedure TCurrencyTest.Test;
begin

end;

  initialization
  TestFramework.RegisterTest('Объекты', TCurrencyTest.Suite);

end.
