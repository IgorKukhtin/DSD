unit CommonObjectHistoryProcedureTest;

interface
uses dbTest, dbObjectTest, ObjectTest;

type

  TObjectHistoryProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

  TObjectHistoryTest = class(TObjectTest)
  public
    procedure DeleteRecord(Id: Integer); override;
  end;


implementation

uses UtilConst, TestFramework, Storage, SysUtils;

{ TCommonMovementProcedure }

procedure TObjectHistoryProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'ObjectHistory\_Common\';
  inherited;
  ScriptDirectory := localProcedurePath + 'ObjectHistory\JuridicalDetails\';
  inherited;
  ScriptDirectory := localProcedurePath + 'ObjectHistory\Price\';
  inherited;
end;

{ TObjectHistoryTest }

procedure TObjectHistoryTest.DeleteRecord(Id: Integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_ObjectHistory OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_ObjectHistory>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;

initialization

//  TestFramework.RegisterTest('Истории', TObjectHistoryProcedure.Suite);
//  TestFramework.RegisterTest('Процедуры', TObjectHistoryProcedure.Suite);
end.
