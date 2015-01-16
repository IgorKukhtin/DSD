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
    procedure dsdStoredProcTest;
    procedure BinaryFlowTest;
  end;

implementation

uses dsdDB, SysUtils, DateUtils, cxCalendar, Storage, DB, Dialogs,
     Authentication, CommonData, DBClient, dsdAction, forms,
     UtilConst, Classes;

{ TComponentDBTest }

procedure TComponentDBTest.BinaryFlowTest;
const  pXML =
  (*'<xml Session = "" AutoWidht = "false" >' +
    '<gpExecSql OutputType="otDataSet">' +
         '<inSqlText DataType="ftString" Value="''SELECT 1 AS test''" />' +
    '</gpExecSql>' +
  '</xml>'(*)
    '<xml Session = "" AutoWidht = "false" >' +
    '<gpSelect_Object_PaidKind OutputType="otDataSet">' +
    '</gpSelect_Object_PaidKind>' +
  '</xml>';

var St: AnsiString;
    ClientDataSet: TClientDataSet;
    FileStream: TFileStream;
    StringStream: TStringStream;
    Stt: AnsiString;
    i: integer;
begin
  ClientDataSet := TClientDataSet.Create(nil);
  FileStream := TFileStream.Create('c:\datanew.hhh', fmOpenRead  );
  try
    St := TStorageFactory.GetStorage.ExecuteProc(pXML);
    StringStream := TStringStream.Create(St);
    StringStream.SaveToFile('c:\datanewnew.hhh');
//    ClientDataSet.LoadFromStream(StringStream);
    StringStream.LoadFromStream(FileStream);
    Stt := StringStream.DataString;

    for I := 1 to length(st) do
        check(st[i] = stt[i], IntToStr(i)+'   '+IntToStr(byte(st[i]))+ ' '+IntToStr(byte(stt[i])));

   // ClientDataSet.XMLData := St;
   // ClientDataSet.SaveToFile('c:\datanew.hhh', dfBinary);

  //  Check(ClientDataSet.FieldCount = 4, IntToStr(ClientDataSet.FieldCount));
   // Check(ClientDataSet.Fields[3].FieldName = 'iserased', ClientDataSet.Fields[3].FieldName);
  finally
    FreeAndNil(ClientDataSet);
    FreeAndNil(FileStream);
    FreeAndNil(StringStream);
  end;
end;

procedure TComponentDBTest.DBFOpenTest;
{var ZConnection : TZConnection;
    ZTable : TZTable;}
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

procedure TComponentDBTest.dsdStoredProcTest;
var Form: TForm;
    StoredProc: TdsdStoredProc;
begin
  Form := TForm.Create(nil);
  StoredProc := TdsdStoredProc.Create(Form);
  try
    Form.RemoveComponent(StoredProc);

  finally
    FreeAndNil(Form)
  end;
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
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
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
