unit SalaryCalculation;

interface

uses TestFramework, dbTest;

type

  TCalculateTest = class (TdbTest)
  published
    // �������� ��������� �� ������������ ����������
    procedure ProcedureLoad; override;
    procedure Test;
  end;


implementation

{ TCalculateTest }

procedure TCalculateTest.ProcedureLoad;
begin
  inherited;

end;

procedure TCalculateTest.Test;
begin
  // �������� ������ � ������� �� ������ �������� � ������������� �� ������

  // ��������� ���������
end;

initialization
  TestFramework.RegisterTest('�������', TCalculateTest.Suite);

end.
