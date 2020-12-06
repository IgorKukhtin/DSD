unit LocalWorkUnit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, Authentication,
  VKDBFDataSet, DB, DataSnap.DBClient, Soap.EncdDecd, Windows;

type
  TSaveLocalMode = (slmRewrite, slmUpdate, slmAppend);

function CheckLocalConnect(ALogin, APassword: String; var pUser: TUser): Boolean;
function GetLocalMainFormData(ASession : string) : String;

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
function GoodsExpirationDate_lcl: String;
function GoodsAnalog_lcl: String;
function CashAttachment_lcl: String;
function UserHelsi_lcl: String;
function UserSettings_lcl: String;
function EmployeeSchedule_lcl: String;
function Buyer_lcl: String;
function DistributionPromo_lcl: String;

procedure SaveLocalData(ASrc: TClientDataSet; AFileName: String);
procedure LoadLocalData(ADst: TClientDataSet; AFileName: String);
function GetFileSizeByName(AFileName: String): DWord;
function GetBackupFileName(AFileName: String): string;
function CreateCashAttachment(ATable : TClientDataSet): Boolean;

procedure InitMutex;
procedure CloseMutex;


var
  MutexUserSettings, MutexDBF, MutexDBFDiff,  MutexVip, MutexRemains, MutexAlternative, MutexRefresh,
  MutexAllowedConduct, MutexGoods, MutexDiffCDS, MutexDiffKind, MutexEmployeeWorkLog,
  MutexBankPOSTerminal, MutexUnitConfig, MutexTaxUnitNight, MutexGoodsExpirationDate,
  MutexGoodsAnalog, MutexUserHelsi, MutexEmployeeSchedule, MutexBuyer, MutexDistributionPromo : THandle;

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
  Result := ExtractFilePath(Application.ExeName) + 'TaxUnitNight.local';
End;

function GoodsExpirationDate_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'GoodsExpirationDate.local';
End;

function GoodsAnalog_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'GoodsAnalog.local';
End;

function CashAttachment_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'CashAttachment.local';
End;

function UserHelsi_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'UserHelsi.local';
End;

function UserSettings_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'UserSettings.local';
End;

function EmployeeSchedule_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'EmployeeSchedule.local';
End;

function Buyer_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'Buyer.local';
End;

function DistributionPromo_lcl: String;
Begin
  Result := ExtractFilePath(Application.ExeName) + 'DistributionPromo.local';
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
  if not FileExists(UserSettings_lcl) then
    exit;
  User := TClientDataSet.Create(nil);
  try

    WaitForSingleObject(MutexUserSettings, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
    try
      User.LoadFromFile(UserSettings_lcl);
      User.Open;
    finally
      ReleaseMutex(MutexUserSettings);
    end;

    while not User.Eof do
    Begin
      if SameText(User.FieldByName('Name').AsString, ALogin) then
      Begin
        if (DecodeString(User.FieldByName('Pass').AsString) = APassword) then
        Begin
          pUser := TUser.Create(User.FieldByName('Id').AsString, True);
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

function GetLocalMainFormData(ASession : string) : String;
var
  User: TClientDataSet;
begin
  result := '';
  if not FileExists(UserSettings_lcl) then
    exit;
  User := TClientDataSet.Create(nil);
  try

    WaitForSingleObject(MutexUserSettings, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
    try
      User.LoadFromFile(UserSettings_lcl);
      User.Open;
    finally
      ReleaseMutex(MutexUserSettings);
    end;

    while not User.Eof do
    Begin
      if SameText(User.FieldByName('Id').AsString, ASession) then
      Begin
        result := User.FieldByName('MainForm').AsString;
        Break;
      End;
      User.Next;
    End;
  finally
    User.Free;
  end;
end;

procedure SaveLocalData(ASrc: TClientDataSet; AFileName: String);
  var I : integer; Tmp: TClientDataSet;
Begin
  if not ASrc.Active then Exit;
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

function CreateCashAttachment(ATable : TClientDataSet): Boolean;
var
  User: TClientDataSet;
  bNeedCreateFields: boolean;
Begin
  result := False;
  try
    ATable.FieldDefs.Add('CashCode',ftInteger);
    ATable.FieldDefs.Add('GoodsCode',ftInteger);
    ATable.FieldDefs.Add('Price',ftCurrency);
    ATable.CreateDataSet;
    ATable.Open;
    result := True;
  finally
    User.Free;
  end;
End;

  // создаем мутексы если не созданы
procedure InitMutex;
  var LastErr: Integer;
begin
  MutexUserSettings := CreateMutex(nil, false, 'farmacycashMutexUserSettings');
  LastErr := GetLastError;
  MutexDBF := CreateMutex(nil, false, 'farmacycashMutexDBF');
  LastErr := GetLastError;
  MutexDBFDiff := CreateMutex(nil, false, 'farmacycashMutexDBFDiff');
  LastErr := GetLastError;
  MutexVip := CreateMutex(nil, false, 'farmacycashMutexVip');
  LastErr := GetLastError;
  MutexRemains := CreateMutex(nil, false, 'farmacycashMutexRemains');
  LastErr := GetLastError;
  MutexAlternative := CreateMutex(nil, false, 'farmacycashMutexAlternative');
  LastErr := GetLastError;
  MutexRefresh := CreateMutex(nil, false, 'farmacycashMutexRefresh');
  LastErr := GetLastError;
  MutexDiffKind := CreateMutex(nil, false, 'farmacycashMutexDiffKind');
  LastErr := GetLastError;
  MutexDiffCDS := CreateMutex(nil, false, 'farmacycashMutexDiffCDS');
  LastErr := GetLastError;
  MutexEmployeeWorkLog := CreateMutex(nil, false, 'farmacycashMutexEmployeeWorkLog');
  LastErr := GetLastError;
  MutexBankPOSTerminal := CreateMutex(nil, false, 'farmacycashMutexBankPOSTerminal');
  LastErr := GetLastError;
  MutexUnitConfig := CreateMutex(nil, false, 'farmacycashMutexUnitConfig');
  LastErr := GetLastError;
  MutexTaxUnitNight := CreateMutex(nil, false, 'farmacycashMutexTaxUnitNight');
  LastErr := GetLastError;
  MutexGoodsExpirationDate := CreateMutex(nil, false, 'farmacycashMutexGoodsExpirationDate');
  LastErr := GetLastError;
  MutexGoods := CreateMutex(nil, false, 'farmacycashMutexGoods');
  LastErr := GetLastError;
  MutexGoodsAnalog := CreateMutex(nil, false, 'farmacycashMutexGoodsAnalog');
  LastErr := GetLastError;
  MutexUserHelsi := CreateMutex(nil, false, 'farmacycashMutexUserHelsi');
  LastErr := GetLastError;
  MutexEmployeeSchedule := CreateMutex(nil, false, 'farmacycashMutexEmployeeSchedule');
  LastErr := GetLastError;
  MutexBuyer := CreateMutex(nil, false, 'farmacycashMutexBuyer');
  LastErr := GetLastError;
  MutexDistributionPromo := CreateMutex(nil, false, 'farmacycashMutexDistributionPromo');
  LastErr := GetLastError;
end;

procedure CloseMutex;
begin
 CloseHandle(MutexUserSettings);
 CloseHandle(MutexDBF);
 CloseHandle(MutexDBFDiff);
 CloseHandle(MutexVip);
 CloseHandle(MutexRemains);
 CloseHandle(MutexAlternative);
 CloseHandle(MutexRefresh);
 CloseHandle(MutexDiffKind);
 CloseHandle(MutexDiffCDS);
 CloseHandle(MutexEmployeeWorkLog);
 CloseHandle(MutexBankPOSTerminal);
 CloseHandle(MutexUnitConfig);
 CloseHandle(MutexTaxUnitNight);
 CloseHandle(MutexGoodsExpirationDate);
 CloseHandle(MutexGoods);
 CloseHandle(MutexGoodsAnalog);
 CloseHandle(MutexEmployeeSchedule);
 CloseHandle(MutexUserHelsi);
 CloseHandle(MutexBuyer);
 CloseHandle(MutexDistributionPromo);
end;


end.
