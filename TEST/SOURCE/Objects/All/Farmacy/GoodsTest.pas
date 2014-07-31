unit GoodsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TGoodsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TGoodsTest }

procedure TGoodsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\Goods\';
  inherited;
end;

procedure TGoodsTest.Test;
begin
  inherited;

end;

initialization
  TestFramework.RegisterTest('Объекты', TGoodsTest.Suite);


end.
