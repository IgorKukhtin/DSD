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
  FunctionPath = '..\DATABASE\COMMON\FUNCTION\';
  ReportsPath = '..\DATABASE\COMMON\REPORTS\';
  CommonProcedurePath = '..\DATABASE\COMMON\PROCEDURE\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateCommonObjectProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'OBJECTS\_Common\';
  ProcedureLoad;

  ExecFile(CommonProcedurePath + 'OBJECTS\User\gpInsertUpdate_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\User\gpSelect_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\User\gpGet_Object_User.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\Form\gpInsertUpdate_Object_Form.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Form\gpGet_Object_Form.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\UserFormSettings\gpInsertUpdate_Object_UserFormSettings.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\UserFormSettings\gpGet_Object_UserFormSettings.sql', ZQuery);
end;

procedure TdbProcedureTest.CreateCommonProtocolProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'Protocol\';
  ProcedureLoad;
end;


initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
