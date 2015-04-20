unit COMTestUnit;

interface

uses DB, TestFramework;

type
  // Класс тестирует поведение класса TELOLAPSalers.
  TCOMTest = class(TTestCase)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные после тестирования}
    procedure TearDown; override;
  published
    // запускаем КОМ объект
    procedure CreateCOMApplication;
    procedure InsertUpdate_Movement_OrderExternal_1C;
  end;

implementation

{ TCOMTest }

uses ComObj, SysUtils;

procedure TCOMTest.CreateCOMApplication;
var OleObject: OleVariant;
begin
  OleObject := CreateOleObject('ProjectCOM.dsdCOMApplication');
end;

procedure TCOMTest.InsertUpdate_Movement_OrderExternal_1C;
var OleObject: OleVariant;
    ioId, ioMovementItemId: Integer;
begin
  OleObject := CreateOleObject('ProjectCOM.dsdCOMApplication');
  OleObject.InsertUpdate_Movement_OrderExternal_1C(ioId, ioMovementItemId,
                                                   '1D1', '2D2',
                                                   Date,
                                                   1001, 1002,
                                                   506.56,
                                                   605.65);
  Check((ioId <> 0) and (ioMovementItemId <>0), 'АШИБКА!!!');
end;

procedure TCOMTest.SetUp;
begin
  inherited;

end;

procedure TCOMTest.TearDown;
begin
  inherited;

end;

initialization

  TestFramework.RegisterTest('Компоненты', TCOMTest.Suite);


end.
