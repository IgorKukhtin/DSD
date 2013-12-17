unit ComponentDBTest;

interface

uses
  TestFramework;

type

  TComponentDBTest = class (TTestCase)
  private
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
  published
    procedure ParamTest;
    procedure ShowStoredProcParamTest;
    procedure SetParamToStoredProc;
    procedure DBFOpenTest;
    procedure ExecuteStoredProcOnServerTest;
  end;

implementation

uses dsdDB, SysUtils, DateUtils, cxCalendar, Storage, DB, Dialogs,
     Authentication, CommonData, DBClient, MemDBFTable, dsdAction;

{ TComponentDBTest }

procedure TComponentDBTest.DBFOpenTest;
{var ZConnection : TZConnection;
    ZTable : TZTable;}
    var Table: TMemDBFTable;
begin
  {ZConnection := TZConnection.Create(nil);
  ZConnection.Protocol := 'ado';
  ZConnection.Database := 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=dBASE Files;Initial Catalog=c:\';
  ZConnection.Connected := true;
  ZTable := TZTable.Create(nil);
  ZTable.Connection := ZConnection;
  ZTable.TableName := 'export';
  ZTable.Open;}
end;

procedure TComponentDBTest.ExecuteStoredProcOnServerTest;
var
   MasterStoredProc: TdsdStoredProc;
   ClientStoredProc: TdsdStoredProc;
   SecondClientStoredProc: TdsdStoredProc;
   ExecServerStoredProc: TExecServerStoredProc;
begin
  // формируем процедуры для вызовов. Одна - получит рекордсет. Вторая - будет запускаться по его результатам
  MasterStoredProc := TdsdStoredProc.Create(nil);
  ClientStoredProc := TdsdStoredProc.Create(nil);
  SecondClientStoredProc := TdsdStoredProc.Create(nil);
  ExecServerStoredProc := TExecServerStoredProc.Create(nil);
  //
  MasterStoredProc.StoredProcName := 'test_Select_Object';
  ClientStoredProc.StoredProcName := 'test_Execute_Sleep';
  SecondClientStoredProc.StoredProcName := 'test_Execute_Sleep';
  ClientStoredProc.Params.AddParam('inId', ftInteger, ptInput, 0).ComponentItem := 'Id';
  SecondClientStoredProc.Params.AddParam('inId', ftInteger, ptInput, 0).ComponentItem := 'Id';

  ExecServerStoredProc.MasterProcedure := MasterStoredProc;
  ExecServerStoredProc.StoredProc := ClientStoredProc;
  ExecServerStoredProc.StoredProcList.Add.StoredProc := SecondClientStoredProc;

  ExecServerStoredProc.Execute;

end;

procedure TComponentDBTest.ParamTest;
var param: TdsdParam;
    edDate: TcxDateEdit;
    s: string;
    D: Variant;
begin
  D := EndOfTheMonth(Date)-0.5;
  Check(D = EndOfTheMonth(Date), '');
  param := TdsdParam.Create(nil);
  edDate := TcxDateEdit.Create(nil);
  param.Component := edDate;
  s := param.Value;
  edDate.Destroy;
//  edDate.Free;
  edDate := nil;
  s := param.Value;
  s := param.Component.Name;
end;

type
  TAccessdsdStoredProc = class(TdsdStoredProc)
     function GetXML: string;
     procedure SetDesigning(Value: Boolean; SetChildren: Boolean = True);
  end;

procedure TComponentDBTest.SetParamToStoredProc;
var lStoredProc: TAccessdsdStoredProc;
    lDataSet: TClientDataSet;
begin
  lStoredProc := TAccessdsdStoredProc.Create(nil);
  lDataSet := TClientDataSet.Create(nil);
  lStoredProc.SetDesigning(true);
  lStoredProc.StoredProcName := 'gpinsertupdate_movement_service';
  lStoredProc.StoredProcName := 'gpSelect_PeriodClose';
end;

procedure TComponentDBTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TComponentDBTest.ShowStoredProcParamTest;
var SaveUserFormSettingsStoredProc: TdsdStoredProc;
begin
  gc_User :=  TUser.Create('1');
  SaveUserFormSettingsStoredProc := TdsdStoredProc.Create(nil);
  SaveUserFormSettingsStoredProc.StoredProcName := 'gpInsertUpdate_Object_UserFormSettings';
  SaveUserFormSettingsStoredProc.OutputType := otResult;
  SaveUserFormSettingsStoredProc.Params.AddParam('inFormName', ftString, ptInput, '');
  SaveUserFormSettingsStoredProc.Params.AddParam('inUserFormSettingsData', ftBlob, ptInput, '');
 // ShowMessage(ConvertXMLParamToStrings(TAccessdsdStoredProc(SaveUserFormSettingsStoredProc).GetXML));
end;

{ TAccessdsdStoredProc }

function TAccessdsdStoredProc.GetXML: string;
begin
  result := inherited GetXML;
end;

procedure TAccessdsdStoredProc.SetDesigning(Value, SetChildren: Boolean);
begin
  inherited;
end;

initialization
  TestFramework.RegisterTest('Компоненты', TComponentDBTest.Suite);

end.
