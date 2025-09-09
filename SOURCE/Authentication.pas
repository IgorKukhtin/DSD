unit Authentication;

interface

uses Storage;

type

  ///	<summary>
  /// ����� �������� ���������� � ������� ������������
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TUser = class
  strict private
    class var FLocal: boolean;
    class var FLocalMaxAtempt: Byte;

  private
    FSession: String;
    FLogin: String;
    procedure SetLocal(const Value: Boolean);
    function GetLocal: Boolean;
    procedure SetLocalMaxAtempt(const Value: Byte = 10);
    function GetLocalMaxAtempt: Byte;
  public
    property Session: String read FSession;
    Property Local: Boolean read GetLocal Write SetLocal;
    Property LocalMaxAtempt: Byte read GetLocalMaxAtempt Write SetLocalMaxAtempt;
    property Login: String read FLogin;
    constructor Create(ASession: String; ALogin: String = ''; ALocal: Boolean = false);
  end;

  ///	<summary>
  /// ����� �������������� ������������
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TAuthentication = class
    ///	<summary>
    /// �������� ������ � ������. � ������ ������ ���������� ������ � ������������.
    ///	</summary>
    class function CheckLogin(pStorage: IStorage;
      const pUserName, pPassword: string; var pUser: TUser;
      ANeedShowException: Boolean = True): boolean;
    // �������� ������ ������� � �������
    class function GetLoginList(pStorage: IStorage): string;
    class function spCheckGoogleOTPAuthent (pStorage: IStorage; const pSession, pProjectName, pUserName, pGoogleSecret: string; ANeedShowException: Boolean = True): boolean;
    class function spCheckPhoneAuthentSMS (pStorage: IStorage;const pSession, pPhoneAuthent: string; ANeedShowException: Boolean = True): boolean;
  end;

implementation

uses iniFiles, Xml.XMLDoc, UtilConst, SysUtils, IdIPWatch, Xml.XmlIntf, CommonData, WinAPI.Windows,
  vcl.Forms, vcl.Dialogs, dsdAction, GoogleOTPRegistration, GoogleOTPDialogPsw, DialogPswSms;

{------------------------------------------------------------------------------}
function GetIniFile(out AIniFileName: String):boolean;
const
  FileName: String = '\Boutique.ini';
var
  dir: string;
  f: TIniFile;
Begin
  result := False;
  dir := ExtractFilePath(Application.exeName)+'ini';
  AIniFileName := dir + FileName;
  //
  if not DirectoryExists(dir) AND not ForceDirectories(dir) then
  Begin
    ShowMessage('������������ �� ����� �������� ������ � ����� ��������:'+#13
              + AIniFileName+#13
              + '���������� ������ ��������� ����������.'+#13
              + '���������� � ��������������.');
    exit;
  End;
  //
  if not FileExists (AIniFileName) then
  Begin
    f := TiniFile.Create(AIniFileName);
    try
      try
        F.WriteString('Common','BoutiqueName','');
      Except
        ShowMessage('������������ �� ����� �������� ������ � ����� ��������:'+#13
                  + AIniFileName+#13
                  + '���������� ������ ��������� ����������.'+#13
                  + '���������� � ��������������.');
        exit;
      end;
    finally
      f.Free;
    end;
  end;
  //
  result := True;
End;
{------------------------------------------------------------------------------}
constructor TUser.Create(ASession: String; ALogin: String = ''; ALocal: Boolean = false);
begin
  FSession := ASession;
  FLocal := ALocal;
  FLogin := ALogin;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.spCheckPhoneAuthentSMS (pStorage: IStorage;const pSession, pPhoneAuthent: string; ANeedShowException: Boolean = True): boolean;
var SendSMSAction_ks : TdsdSendSMSKyivstarAction;
var SendSMSAction : TdsdSendSMSAction;
var N: IXMLNode;
    pXML : String;
begin
    Result:= pPhoneAuthent = '';
    // �����
    if Result = TRUE then exit;

    //
    pXML :=
    '<xml Session = "' + pSession + '" >' +
      '<gpSelect_Object_User_bySMS OutputType="otResult">' +
        '<inPhoneAuthent DataType="ftString" Value="%s" />' +
      '</gpSelect_Object_User_bySMS>' +
    '</xml>';

    try
      N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pPhoneAuthent]), False, 4, ANeedShowException)).DocumentElement;
      //
      if Assigned(N) then Result:= N.GetAttribute(AnsiLowerCase('Message_sms')) <> '' else Result:= false;
      //
      if Assigned(N) and (Result = TRUE) then
      begin
         try
           // Send SMS
           if N.GetAttribute(AnsiLowerCase('isKS')) = TRUE
           then begin
               //SendSMSAction_ks:= TdsdSendSMSCPAAction.Create(nil);
               SendSMSAction_ks:= TdsdSendSMSKyivstarAction.Create(nil);
               //
               SendSMSAction_ks.AlphaName.Value  := N.GetAttribute(AnsiLowerCase('AlphaName_Sms'));
               SendSMSAction_ks.Host.Value       := N.GetAttribute(AnsiLowerCase('HostName_Sms'));
               SendSMSAction_ks.Environment.Value:= N.GetAttribute(AnsiLowerCase('Environment_Sms'));
               SendSMSAction_ks.Version.Value    := N.GetAttribute(AnsiLowerCase('Version_Sms'));
               SendSMSAction_ks.ClientId.Value   := N.GetAttribute(AnsiLowerCase('ClientId'));
               SendSMSAction_ks.ClientSecret.Value:= N.GetAttribute(AnsiLowerCase('ClientSecret'));
               SendSMSAction_ks.ClientSecret.Value:= N.GetAttribute(AnsiLowerCase('ClientSecret'));
               SendSMSAction_ks.Message.Value := N.GetAttribute(AnsiLowerCase('Message_sms'));
               SendSMSAction_ks.Phones.Value  := N.GetAttribute(AnsiLowerCase('PhoneNum_sms'));
               //Result:= SendSMSAction_ks.Authentication;
               Result:= SendSMSAction_ks.Execute;
           end
           else begin
               SendSMSAction:= TdsdSendSMSAction.Create(nil);
               //
               SendSMSAction.Host.Value    := N.GetAttribute(AnsiLowerCase('HostName_Sms'));
               SendSMSAction.Login.Value   := N.GetAttribute(AnsiLowerCase('Login_sms'));
               SendSMSAction.Password.Value:= N.GetAttribute(AnsiLowerCase('Password_sms'));
               SendSMSAction.ShowCost.Value:= N.GetAttribute(AnsiLowerCase('ShowCost_sms'));
               SendSMSAction.Message.Value := N.GetAttribute(AnsiLowerCase('Message_sms'));
               SendSMSAction.Phones.Value  := N.GetAttribute(AnsiLowerCase('PhoneNum_sms'));
               Result:= SendSMSAction.Execute;
           end;
           //Result:= true;
           if not Result then begin ShowMessage('������ ��� �������� ��� �� ����� <'+pPhoneAuthent+'>.������ � ���������� �������������.');exit;end;
         except
           Result:= false;
           exit;
         end;
         //

         // Check Enter SMS
         with TDialogPswSmsForm.Create(nil) do
         begin
              Result:= Execute (pStorage, pSession) <> '';
              Free;
         end;

      end;

    finally
       if Assigned (SendSMSAction_ks) then SendSMSAction_ks.Free;
       if Assigned (SendSMSAction)    then SendSMSAction.Free;
    end;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.spCheckGoogleOTPAuthent (pStorage: IStorage; const pSession, pProjectName, pUserName, pGoogleSecret: string; ANeedShowException: Boolean = True): boolean;
var GoogleSecret: string;
    N: IXMLNode;
    pXML : String;
begin
   Result := True;

   // Genegate and registretion GoogleSecret
   if pGoogleSecret = '' then
   begin
     with TGoogleOTPRegistrationForm.Create(nil) do
     try
       Result:= Execute (pProjectName, pUserName, GoogleSecret);
     finally
       Free;
     end;
   end else GoogleSecret := pGoogleSecret;

   if not Result OR (GoogleSecret = '') then Exit;

   // Validate Pas
   with TGoogleOTPDialogPswForm.Create(nil) do
   try
     Result:= Execute (pStorage, pSession, GoogleSecret);
   finally
     Free;
   end;

   if Result and (pGoogleSecret <> GoogleSecret) then
   begin
      pXML :=
      '<xml Session = "' + pSession + '" >' +
        '<gpUpdate_Object_User_GoogleSecret OutputType="otResult">' +
          '<inGoogleSecret DataType="ftString" Value="%s" />' +
        '</gpUpdate_Object_User_GoogleSecret>' +
      '</xml>';

      N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [GoogleSecret]), False, 4, TRUE)).DocumentElement;
      //
      Result:= Assigned(N);
   end;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLogin(pStorage: IStorage;
  const pUserName, pPassword: string; var pUser: TUser;
  ANeedShowException: Boolean = True): boolean;
var IP_str:string;
    N: IXMLNode;
    pXML : String;
    BoutiqueName, IniFileName, S, ProjectName: String;
    f: TIniFile;
    isBoutique, isProject : Boolean;
begin
   //����� ProjectTest.exe
   S:= ExtractFileName(ParamStr(0));
   //
   isBoutique:= (AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Podium.exe'))
              or(AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Boutique.exe'))
              or(AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Boutique_Demo.exe'));
   //
   isProject:= (AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Project.exe'))
           and (UpperCase(S) <> UpperCase('ProjectTest.exe'))
              ;
   if Pos('.', gc_ProgramName) > 0 then
     ProjectName := Copy(gc_ProgramName, 1, Pos('.', gc_ProgramName) - 1)
   else ProjectName := gc_ProgramName;

  {������� XML ������ ��������� �� �������}
  if isBoutique = TRUE
  then begin
      //
      if GetIniFile (IniFileName) then
        try BoutiqueName:= '';
            f := TiniFile.Create(IniFileName);
            BoutiqueName:= f.ReadString('Common','BoutiqueName','');
        finally
            f.Free;
        end
      else begin
        result:=false;
        exit;
      end;

      // ��� ������� - ��� 1 ��������
      pXML :=
      '<xml Session = "" >' +
        '<gpCheckLogin OutputType="otResult">' +
          '<inUserLogin    DataType="ftString" Value="%s" />' +
          '<inUserPassword DataType="ftString" Value="%s" />' +
          '<inIP           DataType="ftString" Value="%s" />' +
          '<inBoutiqueName DataType="ftString" Value="%s" />' +
        '</gpCheckLogin>' +
      '</xml>';
  end
  else
      // ��� Project - ��� 2 ��������� - ��� Google Authenticator
      if isProject = TRUE
      then
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
            '<ioisGoogleOTP  DataType="ftBoolean" Value="%s" />' +
            '<ioGoogleSecret DataType="ftString" Value="%s" />' +
            // ��� �������� - PhoneAuthent
            '<ioPhoneAuthent DataType="ftString" Value="%s" />' +
          '</gpCheckLogin>' +
        '</xml>'
      else if POS(AnsiUpperCase('Farmacy'), AnsiUpperCase(ProjectName)) = 1
      then
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
            '<inProjectName  DataType="ftString" Value="%s" />' +
          '</gpCheckLogin>' +
        '</xml>'
      else
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
          '</gpCheckLogin>' +
        '</xml>';

  with TIdIPWatch.Create(nil) do
  begin
        Active:=true;
        IP_str:=LocalIP;
        Free;
  end;

  if isBoutique = TRUE
  then
       // ��� ������� - ��� 1 ��������
       N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, BoutiqueName]), False, 4, ANeedShowException)).DocumentElement
  else if isProject = TRUE
       then
         // ��� Project - ��� 2 ��������� - ��� Google Authenticator + 1 �������� - ������� ��� ��������������
         //N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, 'False', '', '']), False, 4, ANeedShowException)).DocumentElement

         // ��� Project - ��� ��� 2 ��������� - ��� Google Authenticator
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, 'False', '', '']), False, 4, ANeedShowException)).DocumentElement

       else if POS(AnsiUpperCase('Farmacy'), AnsiUpperCase(ProjectName)) = 1 then
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, ProjectName]), False, 4, ANeedShowException)).DocumentElement
       else
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str]), False, 4, ANeedShowException)).DocumentElement;
  //
  result := TRUE;
  //
  if Assigned(N) then
  begin
       // ������������ ���, ��������� ��� �� ����������
       //if isProject = TRUE then result := spCheckPhoneAuthentSMS(pStorage, N.GetAttribute(AnsiLowerCase(gcSession)), N.GetAttribute(AnsiLowerCase('ioPhoneAuthent')), ANeedShowException);
       // Google Authenticator
       if (isProject = TRUE) and N.GetAttribute(AnsiLowerCase('ioisGoogleOTP')) then
         result := spCheckGoogleOTPAuthent(pStorage, N.GetAttribute(AnsiLowerCase(gcSession)), ProjectName, pUserName, N.GetAttribute(AnsiLowerCase('ioGoogleSecret')), ANeedShowException);
       //
       pUser := TUser.Create(N.GetAttribute(AnsiLowerCase(gcSession)));
       pUser.FLogin := pUserName;
  end;
  //
  if result = FALSE then pUser:= nil;
  //
  result := (pUser <> nil);
end;

{------------------------------------------------------------------------------}
class function TAuthentication.GetLoginList(pStorage: IStorage): string;
var N: IXMLNode;
    pXML : String;
begin

  Result := '';

  {������� XML ������ ��������� �� �������}
  pXML :=
    '<xml Session = "" >' +
      '<gpSelect_Object_UserLogin OutputType="otResult">' +
      '</gpSelect_Object_UserLogin>' +
    '</xml>';


  N := LoadXMLData(pStorage.ExecuteProc(pXML, False, 2, False)).DocumentElement;
  //
  if Assigned(N) then
  begin
     Result := N.GetAttribute(AnsiLowerCase('outLogin'));
  end;
end;

function TUser.GetLocal: Boolean;
begin
  Result := TUser.FLocal;
end;

procedure TUser.SetLocal(const Value: Boolean);
var
  I : Integer;
  F: TForm;
begin
  TUser.FLocal := Value;
  for I := 0 to Screen.FormCount - 1 do
  Begin
    try
      F := Screen.Forms[I];
      if assigned(F) AND (F.Handle <> 0) AND (F.ClassNameIs('TMainCashForm') or F.ClassNameIs('TMainCashForm2')) then
        PostMessage(F.Handle, UM_LOCAL_CONNECTION,0,0);
    Except
    end;
  End;
end;

function TUser.GetLocalMaxAtempt: Byte;
begin
  Result := TUser.FLocalMaxAtempt;
end;

procedure TUser.SetLocalMaxAtempt(const Value: Byte = 10);
begin
  TUser.FLocalMaxAtempt := Value;
end;

end.
