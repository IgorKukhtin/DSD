unit LinkGoodsTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TLinkGoodsTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

procedure TLinkGoodsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\LinkGoods\';
  inherited;
end;

procedure TLinkGoodsTest.Test;
begin

end;

initialization
 // TestFramework.RegisterTest('Объекты', TLinkGoodsTest.Suite);

end.

