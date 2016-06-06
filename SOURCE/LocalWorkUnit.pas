unit LocalWorkUnit;

interface
uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, Authentication,
  VKDBFDataSet, DB, DataSnap.DBClient;
  type
    TSaveLocalMode = (slmRewrite, slmUpdate, slmAppend);

  function CheckLocalConnect(ALogin, APassword: String; var pUser: TUser): Boolean;
  function SaveLocalConnect(ALogin, APassword, ASession: String): Boolean;

  Procedure AddIntField(ADataBase: TVKSmartDBF; AName:String);
  Procedure AddDateField(ADataBase: TVKSmartDBF;AName:String);
  Procedure AddStrField(ADataBase: TVKSmartDBF;AName:String; ALen:Integer);
  Procedure AddFloatField(ADataBase: TVKSmartDBF;AName:String);
  Procedure AddBoolField(ADataBase: TVKSmartDBF;AName:String);


  function Users_lcl: String;
  function Remains_lcl: String;
  function Alternative_lcl: String;
  function Member_lcl: String;
  function Vip_lcl: String;
  function VipList_lcl: String;
  function VipDfm_lcl: String;

  procedure SaveLocalData(ASrc: TClientDataSet; AFileName: String);
  procedure LoadLocalData(ADst: TClientDataSet; AFileName: String);

implementation

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

Procedure AddIntField(ADataBase: TVKSmartDBF; AName:String);
Begin
  with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
  begin
    Name := AName;
    field_type := 'N';
    len := 10;
  end;
end;

Procedure AddDateField(ADataBase: TVKSmartDBF;AName:String);
Begin
  with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
  begin
    Name := AName;
    field_type := 'N';
    len := 18;
    dec := 10;
  end;
end;

Procedure AddStrField(ADataBase: TVKSmartDBF;AName:String; ALen:Integer);
Begin
  with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
  begin
    Name := AName;
    field_type := 'C';
    len := ALen;
  end;
end;

Procedure AddFloatField(ADataBase: TVKSmartDBF;AName:String);
Begin
  with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
  begin
    Name := AName;
    field_type := 'N';
    len := 10;
    dec := 4;
  end;
end;

Procedure AddBoolField(ADataBase: TVKSmartDBF;AName:String);
Begin
  with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
  begin
    Name := AName;
    field_type := 'L';
  end;
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
Begin
  result := False;
  User := TClientDataSet.Create(nil);
  try
    if FileExists(users_lcl) then
    Begin
      User.LoadFromFile(Users_lcl);
      User.Open;
    End
    else
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
Begin
  ASrc.SaveToFile(AFileName,dfBinary);
End;

procedure LoadLocalData(ADst: TClientDataSet; AFileName: String); overload;
Begin
  ADst.Close;
  ADst.LoadFromFile(AFileName);
  ADst.Open;
End;

end.
