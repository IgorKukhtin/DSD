program EUSignFlexCubeAXDemoP;

uses
  Forms,
  Main in 'Main.pas' {TestForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '��� ���������� ���-1. ��������� "FlexCube (Active-X)"';
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
