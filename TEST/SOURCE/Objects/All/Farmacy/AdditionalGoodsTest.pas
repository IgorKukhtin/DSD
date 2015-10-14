unit AdditionalGoodsTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAdditionalGoodsTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

procedure TAdditionalGoodsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\AdditionalGoods\';
  inherited;
end;

procedure TAdditionalGoodsTest.Test;
begin

end;

initialization
  TestFramework.RegisterTest('Объекты', TAdditionalGoodsTest.Suite);

end.

