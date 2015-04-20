unit COMTestUnit;

interface

uses DB, TestFramework;

type
  // ����� ��������� ��������� ������ TELOLAPSalers.
  TCOMTest = class(TTestCase)
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ����� ������������}
    procedure TearDown; override;
  published
    // ��������� ��� ������
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
  Check((ioId <> 0) and (ioMovementItemId <>0), '������!!!');
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

  TestFramework.RegisterTest('����������', TCOMTest.Suite);


end.
