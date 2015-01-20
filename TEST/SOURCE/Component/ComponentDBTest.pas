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
  '<xml Session = "" AutoWidht = "false" >' +
    '<gpExecSql OutputType="otDataSet">' +
         '<inSqlText DataType="ftString" Value="''SELECT 1 AS test''" />' +
    '</gpExecSql>' +
  '</xml>';
//'<xml Session = "9458" AutoWidth = "0" ><gpSelect_Object_Partner OutputType = "otDataSet" DataSetType = "TClientDataSet" ><inJuridicalId  DataType="ftInteger"   Value="0" /></gpSelect_Object_Partner></xml>';

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
//    ClientDataSet.XMLData := St;
  //  ClientDataSet.SaveToFile('c:\datanew.hhh');
    StringStream := TStringStream.Create(st);
    StringStream.SaveToFile('c:\datanewnew.hhh');
    StringStream.LoadFromStream(FileStream);
  //  ClientDataSet.LoadFromStream(StringStream);
    Stt := StringStream.DataString;

    for I := 1 to length(st) do
        if i <> 23 then // здесь размер пакета и он может отличаться
           check(st[i] = stt[i], IntToHex(i, 1) + '  ' + IntToStr(i)+'   '+IntToStr(byte(st[i]))+ ' '+IntToStr(byte(stt[i])));

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
var DateTime: TDateTime;
    I:Int64;
    DDW: Int64;
    TimeStamp: TTimeStamp;
  buf: int64;
  d: TDateTime;
  a : Pointer;
const
  b: array[0..7] of Byte = ($00, $B0, $2A, $60, $01, $E8, $CC, $42);
var
  x: Double;
begin
  Move(b, x, SizeOf(x));
  buf:=$42CCE801602AB000;
  a:=@buf;
  d:=Double(a^);
  // 63565562140000  -- миллисекунды
  // 63565562140 - секунды
  TimeStamp := MSecsToTimeStamp(d);
  // 735712 -Day - 45340000 мсек - 45340 сек
  // 62135578800
  DateTime := TimeStampToDateTime(TimeStamp);
  //buf:=4675728260250941765;
  //buf:=$42CCE801602AB000;
  //a:=@buf;
  //d:=Double(a^);
  check(false, DateTimeToStr(DateTime));

{  I := $40E3118000000000;//42CCE360E0495C00;
  DDW := StrToInt64('$' + '40E3118000000000'); // '$' отдельно для привлечения внимания
                           //42CCE360E0495C00
  TimeStamp := MSecsToTimeStamp(I);
  DateTime. := TimeStampToDateTime(TimeStamp);
  check(false, DateToStr(DateTime));}

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
