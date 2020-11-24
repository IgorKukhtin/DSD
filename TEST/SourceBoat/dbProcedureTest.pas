unit dbProcedureTest;

interface
uses TestFramework, dbTest;

type
  TdbProcedureTest = class (TdbTest)
  published
    procedure CreateCommonObjectProcedure;
    procedure CreateCommonProtocolProcedure;
  end;


implementation

uses zLibUtil, utilConst;

const
  CommonProcedurePath = '..\DATABASE\Boat\PROCEDURE\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateCommonObjectProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'OBJECTS\_Common\';
  ProcedureLoad;

  ExecFile(CommonProcedurePath + 'ObjectsTools\User\gpInsertUpdate_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'ObjectsTools\User\gpSelect_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'ObjectsTools\User\gpGet_Object_User.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'ObjectsTools\Form\gpInsertUpdate_Object_Form.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'ObjectsTools\Form\gpGet_Object_Form.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'ObjectsTools\UserFormSettings\gpInsertUpdate_Object_UserFormSettings.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'ObjectsTools\UserFormSettings\gpGet_Object_UserFormSettings.sql', ZQuery);
end;

procedure TdbProcedureTest.CreateCommonProtocolProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'Protocol\';
  ProcedureLoad;
end;


initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
