unit LocalWorkUnit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, Authentication,
  VKDBFDataSet, DB, DataSnap.DBClient, Windows;

type
  TSaveLocalMode = (slmRewrite, slmUpdate, slmAppend);

function CheckLocalConnect(ALogin, APassword: String; var pUser: TUser): Boolean;
function SaveLocalConnect(ALogin, APassword, ASession: String): Boolean;

function AddIntField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef; overload;
function AddIntField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef; overload;
function AddDateField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef; overload;
function AddDateField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef; overload;
function AddStrField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string; ALen: Integer): TVKDBFFieldDef; overload;
function AddStrField(ADataBase: TVKSmartDBF; AName: string; ALen: Integer): TVKDBFFieldDef; overload;
function AddFloatField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef; overload;
function AddFloatField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef; overload;
function AddBoolField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef; overload;
function AddBoolField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef; overload;

function Users_lcl: String;
function Remains_lcl: String;
function Alternative_lcl: String;
function Goods_lcl: String;
function DiffKind_lcl: String;
function Member_lcl: String;
function Vip_lcl: String;
function VipList_lcl: String;
function VipDfm_lcl: String;
function ListDiff_lcl: String;
function EmployeeWorkLog_lcl: String;
function BankPOSTerminal_lcl: String;
function UnitConfig_lcl: String;
function TaxUnitNight_lcl: String;

procedure SaveLocalData(ASrc: TClientDataSet; AFileName: String);
procedure LoadLocalData(ADst: TClientDataSet; AFileName: String);
function GetFileSizeByName(AFileName: String): DWord;
function GetBackupFileName(AFileName: String): string;

implementation

function GetBackupFileName(AFileName: String): string;
begin
  Result := ChangeFileExt(AFileName, '.backup');
end;

function GetFileSizeByName(AFileName: string): DWord;
var
  Handle: THandle;
begin
  if not FileExists(AFilename) then exit;
  Handle := FileOpen(AFilename, fmOpenRead or fmShareDenyNone);
  Result := GetFileSize(Handle, nil);
  CloseHandle(Handle);
end;

function Users_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'users.local';
End;

function Remains_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'remains.local';
End;

function Alternative_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'alternative.local';
End;

function Goods_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'goods.local';
End;

function DiffKind_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'DiffKind.local';
End;

function Member_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'member.local';
End;

function Vip_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'VIP.local';
End;

function VipList_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'VIPList.local';
End;

function VipDfm_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'VIP.dfm.local';
End;

function ListDiff_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'ListDiff.local';
End;

function EmployeeWorkLog_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'EmployeeWorkLog.local';
End;

function BankPOSTerminal_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'BankPOSTerminal.local';
End;

function UnitConfig_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'UnitConfig.local';
End;

function TaxUnitNight_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'UnitConfig.local';
End;

function AddIntField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef;
begin
  Result := ADBFFieldDefs.Add as TVKDBFFieldDef;

  with Result do
  begin
    Name := AName;
    field_type := 'N';
    len := 10;
  end;
end;

function AddIntField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef;
begin
  Result := AddIntField(ADataBase.DBFFieldDefs, AName);
end;

function AddDateField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef;
begin
  Result := ADBFFieldDefs.Add as TVKDBFFieldDef;

  with Result do
  begin
    Name := AName;
    field_type := 'N';
    len := 18;
    dec := 10;
  end;
end;

function AddDateField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef;
begin
  Result := AddDateField(ADataBase.DBFFieldDefs, AName);
end;

function AddStrField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string; ALen: Integer): TVKDBFFieldDef;
begin
  Result := ADBFFieldDefs.Add as TVKDBFFieldDef;

  with Result do
  begin
    Name := AName;
    field_type := 'C';
    len := ALen;
  end;
end;

function AddStrField(ADataBase: TVKSmartDBF; AName: string; ALen: Integer): TVKDBFFieldDef;
begin
  Result := AddStrField(ADataBase.DBFFieldDefs, AName, ALen);
end;

function AddFloatField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef;
begin
  Result := ADBFFieldDefs.Add as TVKDBFFieldDef;

  with Result do
  begin
    Name := AName;
    field_type := 'N';
    len := 10;
    dec := 4;
  end;
end;

function AddFloatField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef;
begin
  Result := AddFloatField(ADataBase.DBFFieldDefs, AName);
end;

function AddBoolField(ADBFFieldDefs: TVKDBFFieldDefs; AName: string): TVKDBFFieldDef;
begin
  Result := ADBFFieldDefs.Add as TVKDBFFieldDef;

  with Result do
  begin
    Name := AName;
    field_type := 'L';
  end;
end;

function AddBoolField(ADataBase: TVKSmartDBF; AName: string): TVKDBFFieldDef;
begin
  Result := AddBoolField(ADataBase.DBFFieldDefs, AName);
end;

function CheckLocalConnect(ALogin, APassword: String; var pUser: TUser): Boolean;
var
  User: TClientDataSet;
Begin
  result := False;
  if not FileExists(Users_lcl) then
    exit;
  User := TClientDataSet.Create(nil);
  try
    User.LoadFromFile(Users_lcl);
    User.Open;
    while not User.Eof do
    Begin
      if SameText(User.FieldByName('USR').AsString, ALogin) then
      Begin
        if (User.FieldByName('PWD').AsString = APassword) then
        Begin
          pUser := TUser.Create(User.FieldByName('SSN').AsString, True);
          result := True;
          exit;
        End
        else
        Begin
          ShowMessage('Подключение к локальной базе данных:'+#13+'Неверный пароль!');
          exit;
        End;
      End;
      User.Next;
    End;
    ShowMessage('Подключение к локальной базе данных:'+#13+'Пользователя с таким логином в локальной базе данных нет');
  finally
    User.Free;
  end;
End;

function SaveLocalConnect(ALogin, APassword, ASession: String): Boolean;
var
  User: TClientDataSet;
  bNeedCreateFields: boolean;
Begin
  result := False;
  User := TClientDataSet.Create(nil);
  try
    bNeedCreateFields := true;
    if FileExists(users_lcl) then
    Begin
      try
        User.LoadFromFile(Users_lcl);
        User.Open;
        bNeedCreateFields := false;
      except
      end;
    End;
    if bNeedCreateFields then
    Begin
      User.FieldDefs.Add('USR',ftString,50);
      User.FieldDefs.Add('PWD',ftString,50);
      User.FieldDefs.Add('SSN',ftString,10);
      User.FieldDefs.Add('LAST',ftDateTime);
      User.CreateDataSet;
    end;
    User.Open;
    if User.Locate('USR',ALogin,[loCaseInsensitive]) then
      User.Edit
    else
      User.Append;
    User.FieldByName('USR').AsString := ALogin;
    User.FieldByName('PWD').AsString := APassword;
    User.FieldByName('SSN').AsString := ASession;
    User.FieldByName('LAST').AsDateTime := Now;
    User.Post;
    User.SaveToFile(users_lcl);
  finally
    User.Free;
  end;
End;

procedure SaveLocalData(ASrc: TClientDataSet; AFileName: String);
  var I : integer; Tmp: TClientDataSet;
Begin
  if FileExists(AFileName) and (GetFileSizeByName(AFileName) > 0) then
    CopyFile(PChar(AFileName), PChar(GetBackupFileName(AFileName)), false);
  Tmp := TClientDataSet.Create(Nil);
  try
    for I := 1 to 3 do
    begin
      ASrc.SaveToFile(AFileName,dfBinary);
      try
        Tmp.LoadFromFile(AFileName);
        Tmp.Open;
        Break;
      Except
        DeleteFile(PChar(AFileName));
        if I = 3 then ShowMessage('Ошибка сохранения файл '+ AFileName + ' !');
      end;
    end;
  finally
    Tmp.Close;
    Tmp.Free;
  end;
End;

procedure LoadLocalData(ADst: TClientDataSet; AFileName: String); overload;
  var I : integer;
Begin
  if not FileExists(AFileName) then
  begin
    ShowMessage('Файл '+ AFileName + ' не найден!');
    Exit;
  end;
  if GetFileSizeByName(AFileName) = 0 then
  begin
    if FileExists(GetBackupFileName(AFileName)) and
       (GetFileSizeByName(GetBackupFileName(AFileName)) > 0) then
      CopyFile(PChar(GetBackupFileName(AFileName)), PChar(AFileName), false)
    else
    begin
      ShowMessage('Файл '+ AFileName + ' пустой!');
      Exit;
    end;
  end;
  for I := 1 to 2 do
  begin
    try
      ADst.Close;
      ADst.LoadFromFile(AFileName);
      ADst.Open;
      Break;
    Except
      if I = 1 then
      begin
        if FileExists(GetBackupFileName(AFileName)) and
           (GetFileSizeByName(GetBackupFileName(AFileName)) > 0) then
           CopyFile(PChar(GetBackupFileName(AFileName)), PChar(AFileName), false)
      end else ShowMessage('Ошибка загрузки файл '+ AFileName + ' !');
    end;
  end;

End;

end.
