unit dbCreateViewTest;

interface

uses dbTest;

type

  TView = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

implementation

uses zLibUtil, UtilConst, TestFramework;

{ ОбщиеПроцедурыОбъектов }

procedure TView.ProcedureLoad;
begin
  ExecFile(ViewPath + 'Object\ObjectLink_UserRole_View.sql', ZQuery);
  ExecFile(ViewPath + 'Object\Object_Role_Process_View.sql', ZQuery);
  ExecFile(ViewPath + 'Object\Object_RoleAccessKey_View.sql', ZQuery);
  ExecFile(ViewPath + 'Object\ObjectLink_RoleAction_View.sql', ZQuery);

//  ScriptDirectory := ViewPath;
//  inherited;
//  ScriptDirectory := LocalViewPath;
//  inherited;
end;

initialization
  TestFramework.RegisterTest('VIEW', TView.Suite);

end.
