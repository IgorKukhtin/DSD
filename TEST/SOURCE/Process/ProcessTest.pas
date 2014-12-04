unit ProcessTest;

interface
uses TestFramework, DB, dbTest;

type

  TdbProcessTest = class (TdbTest)
  published
      // �������� ��������� �� ������������ ����������
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst;

{ TdbProcessTest }

procedure TdbProcessTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcessPath;
  inherited;
end;

initialization
  TestFramework.RegisterTest('��������', TdbProcessTest.Suite);

end.
