unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls, Vcl.ActnList,
  dsdAction, ExternalLoad, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdIMAP4, dsdInternetAction, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, System.Actions;

const SAVE_LOG = true;

type
  TPanel = class(Vcl.ExtCtrls.TPanel)
  private
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  end;

type
  // ������� "�������� ����"
  TMailItem = record
    AreaId        : Integer;
    AreaName      : string;
    Host          : string;
    Port          : Integer;
    Mail          : string;
    UserName      : string;
    PasswordValue : string;
    Directory     : string;    // ����, �� �������� ����������� ��������� ������� �� �����, � ���� ���������� - ��� �� ���������������
    BeginTime     : TDateTime; // ����� ��������� ��������
    onTime        : Integer;   // � ����� �������������� ��������� ����� � �������� �������, ���
  end;
  TArrayMail = array of TMailItem;
  // ������� "��������� � ��������� �������� ����������"
  TImportSettingsItem = record
    UserName      : string;
    AreaId        : Integer;
    AreaName      : string;
    AreaId_load   : Integer;
    AreaName_load : string;
    Id            : Integer;
    Code          : Integer;
    Name          : string;
    JuridicalId   : Integer;
    JuridicalCode : Integer;
    JuridicalName : string;
    JuridicalMail : string;
    ContactPersonId   : Integer;
    ContactPersonName : string;
    ContractId    : Integer;
    ContractName  : string;
    Directory     : string;    // ����, � ������� ������ ������� xls ����� ����� ��������� � ���������
    StartTime     : TDateTime; // ����� ������ �������� ��������
    EndTime       : TDateTime; // ����� ��������� �������� ��������
    isMultiLoad   : Boolean;   // ����� ��� ��������� �����

    zc_Enum_EmailKind_InPrice    : integer;
    zc_Enum_EmailKind_IncomeMMO  : integer;
    zc_Area_Basis                : integer;

    EmailKindId                  : integer;
    EmailKindname                : string;
  end;
  TArrayImportSettings = array of TImportSettingsItem;

  TMainForm = class(TForm)
    IdMessage: TIdMessage;
    BtnStart: TBitBtn;
    spSelect: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    PanelHost: TPanel;
    GaugeHost: TGauge;
    PanelMailFrom: TPanel;
    PanelParts: TPanel;
    GaugeMailFrom: TGauge;
    GaugeParts: TGauge;
    GaugeLoadXLS: TGauge;
    GaugeMove: TGauge;
    ActionList: TActionList;
    actExecuteImportSettings: TExecuteImportSettingsAction;
    PanelLoadXLS: TPanel;
    MasterCDS: TClientDataSet;
    spSelectMove: TdsdStoredProc;
    PanelMove: TPanel;
    spUpdateGoods: TdsdStoredProc;
    spLoadPriceList: TdsdStoredProc;
    actMovePriceList: TdsdExecStoredProc;
    Timer: TTimer;
    cbTimer: TCheckBox;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    cbBeginMove: TCheckBox;
    spGet_LoadPriceList: TdsdStoredProc;
    spUpdate_Protocol_LoadPriceList: TdsdStoredProc;
    actProtocol: TdsdExecStoredProc;
    mactExecuteImportSettings: TMultiAction;
    PanelError: TPanel;
    actSendEmail: TdsdSMTPFileAction;
    spExportSettings_Email: TdsdStoredProc;
    ExportSettingsCDS: TClientDataSet;
    spRefreshMovementItemLastPriceList_View: TdsdStoredProc;
    actRefreshMovementItemLastPriceList_View: TdsdExecStoredProc;
    PanelInfo: TPanel;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
  private
    vbEmailKindDesc :String;// ������ �������� - ���������� "�������� ������" ��� "�������� ���"

    vbIsBegin :Boolean;// �������� ���������
    vbOnTimer :TDateTime;// ����� ����� �������� ������
    fIsOptimizeLastPriceList_View :Boolean;// ���� ���� �������� ������ - ���� ����� ��������� �����������

    vbArrayMail :TArrayMail; // ������ �������� ������
    vbArrayImportSettings :TArrayImportSettings; // ������ ����������� � ���������� �������� ����������

    function GetArrayList_Index_byUserName (ArrayList : TArrayMail; UserName : String; AreaId : Integer):Integer;//������� ������ � ������� �� �������� Host
    function GetArrayList_Index_byJuridicalMail (ArrayList : TArrayImportSettings; UserName,JuridicalMail : String; AreaId :Integer ):Integer;//������� ������ � ������� �� �������� Host + MailJuridical + AreaId

    function fGet_LoadPriceList (inJuridicalId, inContractId, inAreaId  :Integer) : Integer;

    function fError_SendEmail (inImportSettingsId, inContactPersonId:Integer; inByDate :TDateTime; inByMail, inByFileName : String) : Boolean;

    function fBeginAll  : Boolean; // ��������� ���
    function fInitArray : Boolean; // �������� ������ � ������� � �� ��������� ���� ������ ��������� �������
    function fBeginMail : Boolean; // ��������� ���� �����
    function fBeginXLS  : Boolean; // ��������� ���� XLS
    function fBeginXLS_ONE  (inUserName : String; inImportSettingsId, inAreaId : Integer) : Boolean; // ��������� XLS - ������ ImportSettingsId
    function fBeginMMO (inUserName:String;inImportSettingsId:Integer;msgDate:TDateTime)  : Boolean; // ��������� MMO
    function fBeginMMO_all   : Boolean; // ��������� MMO
    function fBeginMove : Boolean; // ������� ���
    function fRefreshMovementItemLastPriceList_View : Boolean; // ����������� ���� ���� �������� XLS
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst, sevenzip, StrUtils, zLibUtil;
{$R *.dfm}

procedure AddToLog(ALogMessage: string);
var F: TextFile;
begin
  if not SAVE_LOG then Exit;

  AssignFile(F, ChangeFileExt(Application.ExeName,'_Test.log'));
  if FileExists(ChangeFileExt(Application.ExeName,'_Test.log')) then
    Append(F)
  else
    Rewrite(F);
  //
  if (ALogMessage = '---- Start')
  then WriteLn(F, '');
  WriteLn(F, DateTimeToStr(Now) + ' : ' + ALogMessage);
  if (ALogMessage = '---- Start')
  then WriteLn(F, '');
  CloseFile(F);


  //
  if (Pos('Error', ALogMessage) = 0) and (Pos('Exception', ALogMessage) = 0) and (Pos('---- Start', ALogMessage) = 0)
  then Exit;
  //
  AssignFile(F, ChangeFileExt(Application.ExeName,'.log'));
  if FileExists(ChangeFileExt(Application.ExeName,'.log')) then
    Append(F)
  else
    Rewrite(F);
  //
  if (ALogMessage = '---- Start')
  then WriteLn(F, '');
  WriteLn(F, DateTimeToStr(Now) + ' : ' + ALogMessage);
  if (ALogMessage = '---- Start')
  then WriteLn(F, '');
  CloseFile(F);
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  // ����������� - ������ �������� - ���������� "�������� ������" ��� "�������� ���"
  if Pos ('GetEmail.exe', Application.ExeName) > 0
  then begin vbEmailKindDesc:= 'zc_Enum_EmailKind_InPrice';   Self.Caption:= Self.Caption + ' - ������ ������'; end
  else begin vbEmailKindDesc:= 'zc_Enum_EmailKind_IncomeMMO'; Self.Caption:= Self.Caption + ' - ������ ���';    end;

  //������� ������ � �������
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� �����-���������', gc_AdminPassword, gc_User);
  // �������� ���������
  vbIsBegin:= false;
  // ���������� ����� � ���������� ���� (� �������� ����������� ������)
  cbBeginMove.Checked:=false;
  //
  GaugeHost.Progress:=0;
  GaugeMailFrom.Progress:=0;
  GaugeParts.Progress:=0;
  GaugeLoadXLS.Progress:=0;
  GaugeMove.Progress:=0;
  //
  AddToLog('---- Start');
  // �������� ������
  Timer.Interval:=3000;
  cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' sec';
  cbTimer.Checked:=false;
  cbTimer.Checked:=true;
  //Timer.Enabled:=true;
  Sleep(50);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbTimerClick(Sender: TObject);
begin
     Timer.Enabled:=cbTimer.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//������� ������ � ������� �� �������� UserName
function TMainForm.GetArrayList_Index_byUserName (ArrayList : TArrayMail; UserName : String; AreaId : Integer):Integer;
var i: Integer;
begin
     //������� ������ � ������� �� �������� Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].UserName = UserName) and (ArrayList[i].AreaId = AreaId) then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
//������� ������ � ������� �� �������� UserName + MailJuridical + �����
function TMainForm.GetArrayList_Index_byJuridicalMail (ArrayList : TArrayImportSettings; UserName,JuridicalMail : String; AreaId :Integer ) : Integer;
var i: Integer;
    Year, Month, Day: Word;
    Second, MSec: word;
    Hour_calc, Minute_calc: word;
    StartTime_calc,EndTime_calc:TDateTime;
begin
     //������� ������ � ������� �� �������� UserName + JuridicalMail
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].UserName = UserName) and (System.Pos(AnsiUpperCase(JuridicalMail), AnsiUpperCase(ArrayList[i].JuridicalMail)) > 0)
         and (ArrayList[i].AreaId   = AreaId)
      then begin Result:=i;break;end;
     // �������� � ���
    AddToLog('����� �����������: <' + UserName + '> <' + JuridicalMail + '> <' + IntToStr(AreaId) + '> <' + IntToStr(Result) + '>');
    //
    // �������� - ������� �����
    if Result >=0 then
    begin
         //������� ����
         DecodeDate(NOW, Year, Month, Day);
         //������ ��������� ���� + �����
         DecodeTime(ArrayList[i].StartTime, Hour_calc, Minute_calc, Second, MSec);
         StartTime_calc:= EncodeDateTime(Year, Month, Day, Hour_calc, Minute_calc, 0, 0);
         //������ �������� ���� + �����
         DecodeTime(ArrayList[i].EndTime, Hour_calc, Minute_calc, Second, MSec);
         EndTime_calc:= EncodeDateTime(Year, Month, Day, Hour_calc, Minute_calc, 59, 0);
         //������ ����� ���������
         if not ((StartTime_calc <= NOW) and (EndTime_calc >= NOW))
         then Result:= -1;
    end;
end;
{------------------------------------------------------------------------}
//�������� ��������� ���� �������� ������
function TMainForm.fError_SendEmail (inImportSettingsId, inContactPersonId:Integer; inByDate :TDateTime; inByMail, inByFileName : String) : Boolean;
begin
     if (inByFileName = '0') or (inByFileName = '4')
     then if IdMessage.MessageParts.Count > 0
          then PanelError.Caption:= '+Error : ' + PanelParts.Caption
          else PanelError.Caption:= '+Error : ' + PanelMailFrom.Caption
     else PanelError.Caption:= '+Error : ' + PanelLoadXLS.Caption;
     PanelError.Invalidate;
     Application.ProcessMessages;
     //
     with spExportSettings_Email do
     begin
       try
         ParamByName('inObjectId').Value         :=inImportSettingsId;
         ParamByName('inContactPersonId').Value  :=inContactPersonId;
         ParamByName('inByDate').Value    :=inByDate;
         ParamByName('inByMail').Value    :=inByMail;
         ParamByName('inByFileName').Value:=inByFileName;
         //�������� ���� ���� ��������� Email �� ������
         Execute;
         DataSet.First;
         while not DataSet.EOF do begin

             AddToLog('�������� ����� � ������: ' + DataSet.FieldByName('Host').AsString + '; ' +
                                                    DataSet.FieldByName('Port').AsString + '; ' +
                                                    DataSet.FieldByName('UserName').AsString + '; ' +
                                                    DataSet.FieldByName('PasswordValue').AsString + '; ' +
                                                    DataSet.FieldByName('MailFrom').AsString + ' -> ' +
                                                    DataSet.FieldByName('MailTo').AsString +
                                                    DataSet.FieldByName('Subject').AsString +
                                                    DataSet.FieldByName('Body').AsString);
            {FormParams.ParamByName('Host').Value       :=DataSet.FieldByName('Host').AsString;
            FormParams.ParamByName('Port').Value       :=DataSet.FieldByName('Port').AsInteger;
            FormParams.ParamByName('UserName').Value   :=DataSet.FieldByName('UserName').AsString;
            FormParams.ParamByName('Password').Value   :=DataSet.FieldByName('PasswordValue').AsString;
            FormParams.ParamByName('AddressFrom').Value:=DataSet.FieldByName('MailFrom').AsString;
            FormParams.ParamByName('AddressTo').Value  :=DataSet.FieldByName('MailTo').AsString;
            FormParams.ParamByName('Subject').Value    :=DataSet.FieldByName('Subject').AsString;
            FormParams.ParamByName('Body').Value       :=DataSet.FieldByName('Body').AsString;}
            //
            try
              actSendEmail.Execute;
            except on E: Exception do AddToLog(E.Message);
            end;
            //������� � ����������
            DataSet.Next;
         end;
       except on E: Exception do AddToLog(E.Message);
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// �������� ������ � ������� � �� ��������� ���� ������ ��������� �������
function TMainForm.fInitArray : Boolean;
var i,nn:Integer;
    UserNameStringList:TStringList;
begin
     if vbIsBegin = true then exit;
     // !!!��������� ������!!!
//     Timer.Enabled:=false;
//     Timer.Interval:=1000;
     // �������� ���������
     vbIsBegin:= true;

     UserNameStringList:=TStringList.Create;
     UserNameStringList.Sorted:=true;
     try
     //
     with spSelect do
     begin
       StoredProcName:='gpSelect_Object_ImportSettings_Email';
       Params.Clear;
       // ������ �������� - ���������� "�������� ������" ��� "�������� ���"
       Params.AddParam('inEmailKindDesc',ftString,ptInput,vbEmailKindDesc);

       OutputType:=otDataSet;
       Execute;// �������� ���� �����������, �� ������� ���� ��������� Email
       //
       //������ ����
       DataSet.First;
       i:=0;
       SetLength(vbArrayImportSettings,DataSet.RecordCount);//����� ������ ������������� ���-�� �����������
       while not DataSet.EOF do begin
          //��������� ������� ����������
          vbArrayImportSettings[i].UserName     :=DataSet.FieldByName('UserName').asString;

          vbArrayImportSettings[i].AreaId       :=DataSet.FieldByName('AreaId').asInteger;
          vbArrayImportSettings[i].AreaName     :=DataSet.FieldByName('AreaName').asString;
          vbArrayImportSettings[i].AreaId_load  :=DataSet.FieldByName('AreaId_load').asInteger;
          vbArrayImportSettings[i].AreaName_load:=DataSet.FieldByName('AreaName_load').asString;

          vbArrayImportSettings[i].Id           :=DataSet.FieldByName('Id').asInteger;
          vbArrayImportSettings[i].Code         :=DataSet.FieldByName('Code').asInteger;
          vbArrayImportSettings[i].Name         :=DataSet.FieldByName('Name').asString;
          vbArrayImportSettings[i].JuridicalId  :=DataSet.FieldByName('JuridicalId').asInteger;
          vbArrayImportSettings[i].JuridicalCode:=DataSet.FieldByName('JuridicalCode').asInteger;
          vbArrayImportSettings[i].JuridicalName:=DataSet.FieldByName('JuridicalName').asString;
          vbArrayImportSettings[i].JuridicalMail:=DataSet.FieldByName('JuridicalMail').asString;
          vbArrayImportSettings[i].ContactPersonId  :=DataSet.FieldByName('ContactPersonId').asInteger;
          vbArrayImportSettings[i].ContactPersonName:=DataSet.FieldByName('ContactPersonName').asString;
          vbArrayImportSettings[i].ContractId   :=DataSet.FieldByName('ContractId').asInteger;
          vbArrayImportSettings[i].ContractName :=DataSet.FieldByName('ContractName').asString;
          vbArrayImportSettings[i].isMultiLoad  :=DataSet.FieldByName('isMultiLoad').asBoolean;

          vbArrayImportSettings[i].zc_Enum_EmailKind_InPrice   := DataSet.FieldByName('zc_Enum_EmailKind_InPrice').asInteger;
          vbArrayImportSettings[i].zc_Enum_EmailKind_IncomeMMO := DataSet.FieldByName('zc_Enum_EmailKind_IncomeMMO').asInteger;
          vbArrayImportSettings[i].zc_Area_Basis               := DataSet.FieldByName('zc_Area_Basis').asInteger;

          vbArrayImportSettings[i].EmailKindId   := DataSet.FieldByName('EmailKindId').asInteger;
          vbArrayImportSettings[i].EmailKindname := DataSet.FieldByName('EmailKindname').asString;

          // ����, � ������� ������ ������� xls ����� ����� ��������� � ���������
          vbArrayImportSettings[i].Directory    :=ExpandFileName(DataSet.FieldByName('DirectoryImport').asString);
          // ����� ������ �������� ��������
          vbArrayImportSettings[i].StartTime    :=DataSet.FieldByName('StartTime').AsDateTime;
          // ����� ��������� �������� ��������
          vbArrayImportSettings[i].EndTime      :=DataSet.FieldByName('EndTime').AsDateTime;

          //�������� ��������� ������ UserName
          if not (UserNameStringList.IndexOf(DataSet.FieldByName('UserName').asString+'_'+IntToStr(DataSet.FieldByName('AreaId').asInteger)) >= 0)
          then begin UserNameStringList.Add(DataSet.FieldByName('UserName').asString+'_'+IntToStr(DataSet.FieldByName('AreaId').asInteger));UserNameStringList.Sort;end;

          //������� � ����������
          DataSet.Next;
          i:=i+1;
       end;
       //
       //�������� UserName
       for i:=0 to Length(vbArrayMail) - 1 do vbArrayMail[i].UserName:='';
       //������ ����
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,UserNameStringList.Count);//����� ������ ������������� ���-�� UserName-��
       while not DataSet.EOF do
       begin
          nn:= GetArrayList_Index_byUserName(vbArrayMail, DataSet.FieldByName('UserName').asString, DataSet.FieldByName('AreaId').asInteger);
          if nn = -1 then
          begin
                vbArrayMail[i].AreaId   :=DataSet.FieldByName('AreaId').asInteger;
                vbArrayMail[i].AreaName :=DataSet.FieldByName('AreaName').asString;
                //��������� ����� Host + UserName
                vbArrayMail[i].Host:=DataSet.FieldByName('Host').asString;
                vbArrayMail[i].Port:=DataSet.FieldByName('Port').asInteger;
                vbArrayMail[i].Mail:=DataSet.FieldByName('Mail').asString;
                vbArrayMail[i].UserName:=DataSet.FieldByName('UserName').asString;
                vbArrayMail[i].PasswordValue:=DataSet.FieldByName('PasswordValue').asString;
                // ����, �� �������� ����������� ��������� ������� �� �����, � ���� ���������� - ��� �� ���������������
                vbArrayMail[i].Directory:=ExpandFileName(DataSet.FieldByName('DirectoryMail').asString);
                // � ����� �������������� ��������� ����� � �������� �������, ���
                vbArrayMail[i].onTime:=DataSet.FieldByName('onTime').asInteger;
                // ����� ��������� �������� - �������������� ��������� "����� ���� �����"
                vbArrayMail[i].BeginTime:=NOW-1000;
                // ���������� ����� � ���������� ���� (� �������� ����������� ������)
                cbBeginMove.Checked:=(vbEmailKindDesc= 'zc_Enum_EmailKind_InPrice') and (DataSet.FieldByName('isBeginMove').asBoolean);
                //
                i:=i+1;
          end
          else if vbArrayMail[nn].onTime > DataSet.FieldByName('onTime').asInteger
               then // �������� ����� ������� -  � ����� �������������� ��������� ����� � �������� �������, ���
                    vbArrayMail[nn].onTime:=DataSet.FieldByName('onTime').asInteger;

          // !!!� �������!!! �������� ����� ������� -  � ����� �������������� ��������� ����� � �������� �������
          if (Timer.Interval > DataSet.FieldByName('onTime').asInteger * 60 * 1000) or (Timer.Interval <= 1000) then
          begin
               Timer.Interval:= DataSet.FieldByName('onTime').asInteger * 60 * 1000;
               cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' sec ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
          end;
          //������� � ����������
          DataSet.Next;
       end;
     end;
     //
     finally
       UserNameStringList.Free;
       // ��������� ���������
       vbIsBegin:= false;
       // !!!�������� ������!!!
       //Timer.Enabled:=true;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��� � �������� ������ - ������� � ��� �������
procedure Add_Log_XML(APath, AMessage: String);
var F: TextFile;
begin
  try
    AssignFile(F,APath+'\'+ChangeFileExt(ExtractFileName (Application.ExeName),'_err.txt'));
    if not fileExists(APath+'\'+ChangeFileExt(ExtractFileName (Application.ExeName),'_err.txt')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F,AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���� �����
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  Session,mailFolderMain,mailFolder,StrCopyFolder: ansistring;
  JurPos: integer;
  arch:i7zInArchive;
  StartTime:TDateTime;
  IdIMAP4:TIdIMAP4;
  searchResult, searchResult_save : TSearchRec;
  fOK,fMMO:Boolean;
  msgDate_save:TDateTime;
begin
   //
   if vbIsBegin = true then exit;
   // �������� ���������
   vbIsBegin:= true;
   // ���� �� ���� �������� ������ - �� ���� ����� ��������� �����������
   fIsOptimizeLastPriceList_View:= false;
   try

     //������ - � ��� ����� ����� ��������� ������� - ��� ������������ �������� ������� ���������
     StartTime:=NOW;
     Session:=FormatDateTime('yyyy-mm-dd hh-mm-ss',StartTime);
     //
     arch:=CreateInArchive(CLSID_CFormatZip);

     //
     GaugeHost.Progress:=0;
     GaugeHost.MaxValue:=Length(vbArrayMail);
     Application.ProcessMessages;
     //���� �� �������� ������
     for ii := 0 to Length(vbArrayMail)-1 do
     begin
       // ���� ����� ���������� ��������� ������ > onTime �����
       if (NOW - vbArrayMail[ii].BeginTime) * 24 * 60 > vbArrayMail[ii].onTime
       then try
           PanelHost.Caption:= 'Start Mail (0.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4:=TIdIMAP4.Create(Self);
           PanelHost.Caption:= 'Start Mail (0.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4.IOHandler:=IdSSLIOHandlerSocketOpenSSL;
           PanelHost.Caption:= 'Start Mail (0.3) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;

           if Pos(AnsiUpperCase('@mail.ru'), AnsiUpperCase(vbArrayMail[ii].UserName)) > 0
           then IdIMAP4.UseTLS:=utUseRequireTLS   //��� ����.��
           else IdIMAP4.UseTLS:=utUseImplicitTLS; //��� ������;

           PanelHost.Caption:= 'Start Mail (0.4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4.AuthType:=iatUserPass;
           PanelHost.Caption:= 'Start Mail (0.5) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4.MilliSecsToWaitToClearBuffer:=100;

           with IdIMAP4 do
           begin
              //
              PanelHost.Caption:= 'Start Mail (1.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              PanelHost.Invalidate;
              Sleep(200);
              //current directory to store the email
              mailFolderMain:= vbArrayMail[ii].Directory + '\' + ReplaceStr(vbArrayMail[ii].UserName, '@', '_') + '_' + Session;
              //������� ����� ��� ����� ���� ������� ��� + ��� �������� ��� �� ������� ����� ���� ���������
              ForceDirectories(mailFolderMain);

              PanelHost.Caption:= 'Start Mail (1.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              PanelHost.Invalidate;
              //��������� ����������� � �����
              Host    := vbArrayMail[ii].Host;
              UserName:= vbArrayMail[ii].UserName;
              Password:= vbArrayMail[ii].PasswordValue;
              Port    := vbArrayMail[ii].Port;

              try
                 PanelHost.Caption:= 'Start Mail (2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;

                 AddToLog('------------');
                 AddToLog('����������� � �����: ' + vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host);

                 //������������ � �����
                 //***IdPOP3.Connect;          //POP3
                 try IdIMAP4.Connect(TRUE);     //IMAP
                 except
                      on E: Exception do begin
                         PanelError.Caption:= ' ERROR - IdIMAP4.Connect(TRUE) for ' + UserName + '  : ' + E.Message;
                         PanelError.Invalidate;
                         Continue;
                      end;
                 end;

                 PanelHost.Caption:= 'Start Mail (3.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;
                 IdIMAP4.SelectMailBox('INBOX');//only IMAP
                 PanelHost.Caption:= 'Start Mail (3.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;
                 //���������� �����
                 //***msgcnt:= IdPOP3.CheckMessages;   //POP3
                 msgcnt:= IdIMAP4.MailBox.TotalMsgs;   //IMAP
                 PanelHost.Caption:= 'Start Mail (3.4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;
                 //
                 GaugeMailFrom.Progress:=0;
                 GaugeMailFrom.MaxValue:=msgcnt;
                 Application.ProcessMessages;
                 //���� �� �������� �������
                 AddToLog('    ���� �� �������� �������: ' + IntToStr(msgcnt));
                 for I:= msgcnt downto 1 do
                 begin
                   PanelHost.Caption:= 'Start Mail (4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   PanelHost.Invalidate;
                   AddToLog('       - : ' + IntToStr(I));
                   IdMessage.Clear; // ������� ������ ��� ���������
                   flag:= false;

                   //������ ����� - ���
                   fMMO:= false;

                   PanelHost.Caption:= 'Start Mail (5.1.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   PanelHost.Invalidate;
                   //���� ���������� �� ����� ������
                   if (IdIMAP4.Retrieve(i, IdMessage)) then
                   begin
                        PanelHost.Caption:= 'Start Mail (5.2.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                        PanelHost.Invalidate;
                        //IdMessage.CharSet := 'UTF-8';

                        //������� ����������, ������� �������� �� ���� UserName + ���� � ����� ������ + �����
                        JurPos:=GetArrayList_Index_byJuridicalMail(vbArrayImportSettings, vbArrayMail[ii].UserName, Trim(IdMessage.From.Address), vbArrayMail[ii].AreaId);
                        //
                        if JurPos >=0
                        then PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' (' +  IntToStr(vbArrayImportSettings[JurPos].Id) + ') ' + vbArrayImportSettings[JurPos].AreaName + ' * ' + vbArrayImportSettings[JurPos].Name
                        else PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' ' + vbArrayMail[ii].AreaName + ' * ' + Trim(IdMessage.From.Address) + ' - ???';
                        PanelMailFrom.Invalidate;
                        //���� ����� ����������, ����� ��� ������ ���� ���������
                        if JurPos >= 0 then
                        begin
                             //current directory to store the email files
                             mailFolder:= mailFolderMain + '\' + FormatDateTime('yyyy-mm-dd hh-mm-ss',IdMessage.Date) + '_' +  IntToStr(vbArrayImportSettings[JurPos].Id) + '_' + vbArrayImportSettings[JurPos].Name;
                             //������� ����� ��� ����� ���� ������� ���
                             ForceDirectories(mailFolder);

                             //
                             GaugeParts.Progress:=0;
                             GaugeParts.MaxValue:=IdMessage.MessageParts.Count;
                             Application.ProcessMessages;
                             PanelHost.Caption:= 'Start Mail (5.3.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                             PanelHost.Invalidate;
                             //��������� �� ���� ������ ������
                             for j := 0 to IdMessage.MessageParts.Count - 1 do
                             begin
                               //
                               PanelParts.Caption:= 'Parts : '+Trim(IdMessage.From.Address);
                               Application.ProcessMessages;
                               //���� ��� ��������� ������
                               if IdMessage.MessageParts[j] is TIdAttachment then
                               begin
                                   // ��������� ������ �� ������
                                   (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                   // ���� ���� - ���������������
                                   //if not (System.Pos(AnsiUppercase('.xls'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   // and not(System.Pos(AnsiUppercase('.xlsx'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   // and not(System.Pos(AnsiUppercase('.xml'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   if (System.Pos(AnsiUppercase('.zip'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   then begin
                                             arch.OpenFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                             arch.ExtractTo(mailFolder + '\');
                                        end;
                               end;
                               GaugeParts.Progress:=GaugeParts.Progress+1;
                               Application.ProcessMessages;
                             end;//����������� ��������� ���� ������ ������ ������

                            //������� ����� ��� ��������, ���� ������� ���
                            ForceDirectories(vbArrayImportSettings[JurPos].Directory);

                            // ������ ���� "�������" �� ���� �������� JurPos ��� ��� ������
                            if (fGet_LoadPriceList (vbArrayImportSettings[JurPos].JuridicalId, vbArrayImportSettings[JurPos].ContractId, vbArrayImportSettings[JurPos].AreaId_load) = 0)
                             or(vbArrayImportSettings[JurPos].isMultiLoad = TRUE)
                             or(vbArrayImportSettings[JurPos].EmailKindId = vbArrayImportSettings[JurPos].zc_Enum_EmailKind_IncomeMMO)
                            then
                            begin
                                 //�� ����� ����������
                                 fOK:=false;

                                 //1. ����� ����� MMO
                                 if System.SysUtils.FindFirst(mailFolder + '\*.mmo', faAnyFile, searchResult) = 0 then
                                 begin
                                      searchResult_save:=searchResult;
                                      if (System.SysUtils.FindNext(searchResult) <> 0)and(fOK=false)
                                      then begin
                                          //����� ���� - �������
                                          fMMO:= true;
                                          //��������� ��� �������� �� ���������� MessageParts
                                          msgDate_save:=IdMessage.Date;
                                          //����� ����������
                                          fOK:=true;
                                      end
                                      else begin
                                          //����� ���� - �������
                                          fMMO:= true;
                                          //��������� ��� �������� �� ���������� MessageParts
                                          msgDate_save:=IdMessage.Date;
                                          //�� ������ - ������ �� ���� ���� MMO ��� ��������
                                          fOK:=true;
                                          {fError_SendEmail(vbArrayImportSettings[JurPos].Id
                                                         , vbArrayImportSettings[JurPos].ContactPersonId
                                                         , IdMessage.Date
                                                         , vbArrayMail[ii].Mail + ' * ' + vbArrayImportSettings[JurPos].JuridicalMail
                                                         , '44');}
                                      end;
                                 end;
                                 //2.1. ����� ����� xls � ��� �� MMO
                                 if (System.SysUtils.FindFirst(mailFolder + '\*.xls', faAnyFile, searchResult) = 0)
                                  and(vbArrayImportSettings[JurPos].EmailKindId <> vbArrayImportSettings[JurPos].zc_Enum_EmailKind_IncomeMMO)
                                 then
                                 begin
                                      searchResult_save:=searchResult;
                                      if System.SysUtils.FindNext(searchResult) <> 0
                                      then
                                          //����� ����������
                                          fOK:=true
                                      else
                                          //������ - ������ �� ���� ���� xls ��� ��������
                                          fError_SendEmail(vbArrayImportSettings[JurPos].Id
                                                         , vbArrayImportSettings[JurPos].ContactPersonId
                                                         , IdMessage.Date
                                                         , vbArrayImportSettings[JurPos].JuridicalMail + ' * ' + vbArrayMail[ii].Mail
                                                         , '4');
                                 end;
                                 //2.2. ����� ����� xlsx � ��� �� MMO
                                 if (System.SysUtils.FindFirst(mailFolder + '\*.xlsx', faAnyFile, searchResult) = 0)
                                  and(vbArrayImportSettings[JurPos].EmailKindId <> vbArrayImportSettings[JurPos].zc_Enum_EmailKind_IncomeMMO)
                                 then begin
                                      searchResult_save:=searchResult;
                                      if (System.SysUtils.FindNext(searchResult) <> 0)and(fOK=false)
                                      then
                                          //����� ����������
                                          fOK:=true
                                      else
                                          //������ - ������ �� ���� ���� xls ��� ��������
                                          fError_SendEmail(vbArrayImportSettings[JurPos].Id
                                                         , vbArrayImportSettings[JurPos].ContactPersonId
                                                         , IdMessage.Date
                                                         , vbArrayImportSettings[JurPos].JuridicalMail + ' * ' + vbArrayMail[ii].Mail
                                                         , '4');
                                 end
                                 else // ���� �� ������� ����� ��� ����������� � �� ���
                                      if (fOK = FALSE)
                                         and(vbArrayImportSettings[JurPos].EmailKindId = vbArrayImportSettings[JurPos].zc_Enum_EmailKind_InPrice)
                                      then //������ - �� ������ ���� xls ��� ��������
                                           fError_SendEmail(vbArrayImportSettings[JurPos].Id
                                                          , vbArrayImportSettings[JurPos].ContactPersonId
                                                          , IdMessage.Date
                                                          , vbArrayImportSettings[JurPos].JuridicalMail + ' * ' + vbArrayMail[ii].Mail
                                                          , '0');
                                           ;
                                  //
                                  // ���� ���� - ����� ����������
                                  if fOK = TRUE then
                                  begin
                                        //���� ��� �� MMO
                                        if (vbArrayImportSettings[JurPos].EmailKindId <> vbArrayImportSettings[JurPos].zc_Enum_EmailKind_IncomeMMO)
                                        then begin
                                              // ����� ����������� ��� ������� xls � ����� �� ������� ��� ����� ��������
                                              StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.xls' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                              WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                                              // ����� ����������� ��� ������� xlsx � ����� �� ������� ��� ����� ��������
                                              StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.xlsx' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                              WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                                        end;
                                        // ����� ����������� ��� ������� � ����� �� ������� ��� ����� ��������
                                        StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.mmo' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                        WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                                  end;
                                  // ����� ���� ������� ������ � �����
                                  if (vbArrayImportSettings[JurPos].EmailKindId = vbArrayImportSettings[JurPos].zc_Enum_EmailKind_IncomeMMO)
                                  then // ��� ����� ������� ������ � �����
                                       flag:= true
                                       // ���� ������� ����� ��� �����������
                                  else flag:= fOK
                            end
                            else
                                // ���� "�������" ���� �������� JurPos - ���� ������� ������ � �����
                                flag:= true;
                        end
                        // ���� �� ����� - ��� ����� ������� ������ � �����
                        else flag:= true;
                   end
                   else
                   begin
                    PanelError.Caption:= 'Error while retrieving message :' + IntToStr(i);
                    PanelError.Invalidate;
                   end;

                   //�������� ������
                   //***if flag then IdPOP3.Delete(i);   //POP3
                   PanelHost.Caption:= 'Start Mail (5.4.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   PanelHost.Invalidate;
                   if flag then
                   begin
                        if Pos(AnsiUpperCase('@ukr.net'), AnsiUpperCase(vbArrayMail[ii].UserName)) > 0 then
                          IdIMAP4.CopyMsg(i, '���������');

                        IdIMAP4.DeleteMsgs([i]);    //IMAP
                        IdIMAP4.ExpungeMailBox;
                   end;
                   PanelHost.Caption:= 'Start Mail (5.5.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   PanelHost.Invalidate;
                   //

                   //� ������ ������ ��� ������ - ���������
                   if (JurPos >= 0) and (fMMO = FALSE) and (vbArrayImportSettings[JurPos].EmailKindId = vbArrayImportSettings[JurPos].zc_Enum_EmailKind_InPrice)
                   then fBeginXLS_ONE (vbArrayMail[ii].UserName, vbArrayImportSettings[JurPos].Id,vbArrayImportSettings[JurPos].AreaId);

                   //� ������ ������ ��� ��� - ���������
                   if (JurPos >= 0) and (fMMO = TRUE) and (vbArrayImportSettings[JurPos].EmailKindId = vbArrayImportSettings[JurPos].zc_Enum_EmailKind_IncomeMMO)
                   then fBeginMMO (vbArrayMail[ii].UserName, vbArrayImportSettings[JurPos].Id,msgDate_save);


                   //���, ���� ������
                   Sleep(200);
                   GaugeMailFrom.Progress:=GaugeMailFrom.Progress+1;
                   Application.ProcessMessages;

                 end;//����� - ���� �� �������� �������

                 PanelHost.Caption:= 'End Mail (5.6) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;

                 //�������� ��������� ����� ��������� ��������� ��������� �����
                 vbArrayMail[ii].BeginTime:=vbOnTimer;
                 //
                 PanelHost.Caption:= 'End Mail (5.7): '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
                 GaugeHost.Progress:=GaugeHost.Progress + 1;
                 Application.ProcessMessages;
              finally
                 PanelHost.Caption:= 'End Mail (6.1.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
                 //***IdPOP3.Disconnect;     // POP3
                 IdIMAP4.Disconnect();       //IMAP
                 PanelHost.Caption:= 'End Mail (6.2.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
                 IdIMAP4.Free;               //IMAP
                 PanelHost.Caption:= 'End Mail (6.3) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
              end;

              AddToLog('    ����� ��������� �����.');

              PanelHost.Caption:= 'OK - End Mail (7.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
              PanelHost.Invalidate;
              Application.ProcessMessages;
              Sleep(200);

           end;// with IdIMAP4 do
       except
           PanelHost.Caption:= 'ERROR - TIdIMAP4 - try on Next Step - End Mail (8.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
           PanelHost.Invalidate;

           //current directory to store the email
           mailFolderMain:= vbArrayMail[ii].Directory + '\' + ReplaceStr(vbArrayMail[ii].UserName, '@', '_') + '_' + Session;
           //������� ����� ��� ��������� ���� ������� ��� + ��� �������� ��� �� ������� ����� ���� ���������
           ForceDirectories(mailFolderMain);
           //��������� - ��� ���� ������
           Add_Log_XML(mailFolderMain, PanelHost.Caption);

           Application.ProcessMessages;
           Sleep(1000);
       end;//����� - ���� �� �������� ������
    end;
  finally
   // ��������� ���������
   vbIsBegin:= false;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���� XLS
function TMainForm.fBeginXLS : Boolean;
var
 searchResult, searchResult_save : TSearchRec;
begin
     //
     //exit;
     //
     if vbIsBegin = true then exit;
     // �������� ���������
     vbIsBegin:= true;
     PanelInfo.Caption:= 'O�������� ���� XLS.';
     PanelInfo.Invalidate;
     // ���� �� ���� �������� ������ - �� ���� ����� ��������� �����������
     fIsOptimizeLastPriceList_View:= false;
     try
       with ClientDataSet do begin
        GaugeLoadXLS.Progress:=0;
        GaugeLoadXLS.MaxValue:=RecordCount;
        Application.ProcessMessages;
        //
        First;
        while not EOF do begin
           //1.������ ��� zc_Enum_EmailKind_InPrice!!!
           if FieldByName('EmailKindId').asInteger = FieldByName('zc_Enum_EmailKind_InPrice').asInteger then
           begin
                 PanelLoadXLS.Caption:= 'Load XLS - '+FieldByName('AreaName').asString+'/'+IntToStr(FieldByName('AreaId_load').asInteger)+'  : ('+FieldByName('Id').AsString + ') ' + FieldByName('Name').AsString + ' - ' + FieldByName('ContactPersonName').AsString;
                 PanelLoadXLS.Invalidate;
                 Sleep(200);
                 //��������� ���� ���� ������
                 if FieldByName('DirectoryImport').asString <> ''
                 then try
                          //����� ����� xls
                          if System.SysUtils.FindFirst(FieldByName('DirectoryImport').asString + '*.xls', faAnyFile, searchResult) = 0 then
                          begin
                               searchResult_save:=searchResult;
                               if System.SysUtils.FindNext(searchResult) <> 0
                               then begin
                                   //
                                   AddToLog('������ ���� '+ FieldByName('DirectoryImport').asString + searchResult_save.Name +' ������ ��������');
                                   // ����������� ��������
                                   actExecuteImportSettings.ExternalParams.ParamByName('inAreaId').Value:= FieldByName('AreaId_load').asInteger;
                                   actExecuteImportSettings.ExternalParams.ParamByName('Directory_add').Value:= FieldByName('AreaName').asString;
                                   // ����������� ��������
                                   mactExecuteImportSettings.Execute;
                                   if actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value <> '' then
                                   begin
                                     PanelError.Caption := actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value;
                                     PanelError.Invalidate;
                                   end;
                                   // ���� ���� �������� ������ - ���� ����� ��������� �����������
                                   fIsOptimizeLastPriceList_View:= true;
                               end
                               else
                               begin
                                   AddToLog('������ - ������ �� ���� ���� xls ��� ��������');
                                   //������ - ������ �� ���� ���� xls ��� ��������
                                   fError_SendEmail(FieldByName('Id').AsInteger
                                                  , FieldByName('ContactPersonId').AsInteger
                                                  , NOW
                                                  //, FieldByName('JuridicalMail').AsString
                                                  , FieldByName('DirectoryImport').asString
                                                  , '2');
                               end;
                          end
                          else;
                              //������ - �� ������ ���� xls ��� ��������
                              //�� ��, ��� ��������� :)
                      except on E: Exception do
                        begin
                          AddToLog(E.Message);
                          {fError_SendEmail(FieldByName('Id').AsInteger
                                            , FieldByName('ContactPersonId').AsInteger
                                            , searchResult_save.TimeStamp
                                            , FieldByName('JuridicalMail').AsString
                                            , searchResult_save.Name);}
                        end
                      end;
           end;//1.if ... !!!������ ��� zc_Enum_EmailKind_InPrice!!!

           //2.������ ��� zc_Enum_EmailKind_IncomeMMO!!!
           if FieldByName('EmailKindId').asInteger = FieldByName('zc_Enum_EmailKind_IncomeMMO').asInteger then
           begin // ��� ��������� ����� � �����
           end;//2.if ... !!!������ ��� zc_Enum_EmailKind_IncomeMMO!!!

           Next;
           //
           GaugeLoadXLS.Progress:=GaugeLoadXLS.Progress + 1;
           Application.ProcessMessages;
        end;
     end;
     finally
       // ��������� ���������
       vbIsBegin:= false;
     end;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� XLS - ������ ImportSettingsId
function TMainForm.fBeginXLS_ONE (inUserName : String; inImportSettingsId, inAreaId : Integer) : Boolean;
var
 searchResult, searchResult_save : TSearchRec;
begin
     //
     exit;
     //

     // ���� �� ���� �������� ������ - �� ���� ����� ��������� �����������
     //fIsOptimizeLastPriceList_View:= false;

     with ClientDataSet do begin
        GaugeLoadXLS.Progress:=0;
        GaugeLoadXLS.MaxValue:= RecordCount;
        Application.ProcessMessages;
        //
        First;
        while not EOF do begin
           //1.������ ��� zc_Enum_EmailKind_InPrice!!!
           if (FieldByName('EmailKindId').asInteger = FieldByName('zc_Enum_EmailKind_InPrice').asInteger)
              and (FieldByName('Id').asInteger = inImportSettingsId)
              and (FieldByName('AreaId').asInteger = inAreaId)
              and (FieldByName('UserName').asString = inUserName)
           then begin
                 PanelLoadXLS.Caption:= 'Load XLS : ('+FieldByName('Id').AsString + ') ' + FieldByName('Name').AsString + ' - ' + FieldByName('ContactPersonName').AsString;
                 PanelLoadXLS.Invalidate;
                 Sleep(200);
                 //��������� ���� ���� ������
                 if FieldByName('DirectoryImport').asString <> ''
                 then try
                          //����� ����� xls
                          if System.SysUtils.FindFirst(FieldByName('DirectoryImport').asString + '*.xls', faAnyFile, searchResult) = 0 then
                          begin
                               searchResult_save:=searchResult;
                               if System.SysUtils.FindNext(searchResult) <> 0
                               then begin
                                   // ����������� ��������
                                   actExecuteImportSettings.ExternalParams.ParamByName('inAreaId').Value:= FieldByName('AreaId_load').asInteger;
                                   actExecuteImportSettings.ExternalParams.ParamByName('Directory_add').Value:= FieldByName('AreaName').asString;
                                   // ����������� ��������
                                   mactExecuteImportSettings.Execute;
                                   // ���� ���� �������� ������ - ���� ����� ��������� �����������
                                   fIsOptimizeLastPriceList_View:= true;
                               end
                               else
                                   //������ - ������ �� ���� ���� xls ��� ��������
                                   fError_SendEmail(FieldByName('Id').AsInteger
                                                  , FieldByName('ContactPersonId').AsInteger
                                                  , NOW
                                                  //, FieldByName('JuridicalMail').AsString
                                                  , FieldByName('DirectoryImport').asString
                                                  , '2');
                          end
                          else;
                              //������ - �� ������ ���� xls ��� ��������
                              //�� ��, ��� ��������� :)
                      except fError_SendEmail(FieldByName('Id').AsInteger
                                            , FieldByName('ContactPersonId').AsInteger
                                            , searchResult_save.TimeStamp
                                            , FieldByName('JuridicalMail').AsString
                                            , searchResult_save.Name);
                      end;
           end;//1.if ... !!!������ ��� zc_Enum_EmailKind_InPrice!!!

           Next;
           //
           GaugeLoadXLS.Progress:=GaugeLoadXLS.Progress + 1;
           Application.ProcessMessages;
        end;
     end;

     // ��������� ���������
     Sleep(200);


end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fRefreshMovementItemLastPriceList_View : Boolean; // ����������� ���� ���� �������� XLS
var StartTime:TDateTime;
    oldCaption:String;
begin
    //���� �� ���� �������� ������ - �� ���� ��������� �����������
    if fIsOptimizeLastPriceList_View = false then exit;
    PanelInfo.Caption:= 'O���������� ���� ���� �������� XLS.';
    PanelInfo.Invalidate;
    //
    oldCaption:= PanelLoadXLS.Caption;
    StartTime:=NOW;
    PanelLoadXLS.Caption:= 'start: ' + FormatDateTime('hh-mm-ss',StartTime) + ' - fRefreshMovementItemLastPriceList_View' + oldCaption;
    //
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
    //
    try
       // ����������� �������� - �������� ��� �����������
       actRefreshMovementItemLastPriceList_View.Execute;
       // ��������� ��� ����������� ������
       fIsOptimizeLastPriceList_View := false;
       //
       PanelLoadXLS.Caption:= 'start/end: ' + FormatDateTime('hh-mm-ss',StartTime) + ' _ '  +FormatDateTime('hh-mm-ss',now) + ' - fRefreshMovementItemLastPriceList_View' + oldCaption;
       PanelLoadXLS.Invalidate;
       Sleep(1000);
    except
       PanelLoadXLS.Caption:= '!!!ERROR!!! start/end: ' + FormatDateTime('hh-mm-ss',StartTime) + ' _ '  +FormatDateTime('hh-mm-ss',now) + ' - fRefreshMovementItemLastPriceList_View' + oldCaption;
       PanelLoadXLS.Invalidate;
       Sleep(20000);
    end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���� MMO
function TMainForm.fBeginMMO (inUserName:String;inImportSettingsId:Integer;msgDate:TDateTime) : Boolean;
var
 searchResult : TSearchRec;
 mailFolder,StrCopyFolder: ansistring;
begin
     with ClientDataSet do begin
        GaugeLoadXLS.Progress:=0;
        GaugeLoadXLS.MaxValue:=RecordCount;
        Application.ProcessMessages;
        //
        First;
        while not EOF do begin

           //2.������ ��� zc_Enum_EmailKind_IncomeMMO!!!
           if (FieldByName('EmailKindId').asInteger = FieldByName('zc_Enum_EmailKind_IncomeMMO').asInteger)
              and (FieldByName('Id').asInteger = inImportSettingsId)
              and (FieldByName('UserName').asString = inUserName)
           then begin
                 PanelLoadXLS.Caption:= 'Load MMO : ('+FieldByName('Id').AsString + ') ' + FieldByName('Name').AsString + ' - ' + FieldByName('ContactPersonName').AsString;
                 PanelLoadXLS.Invalidate;
                 Sleep(50);
                 //��������� ���� ���� ������
                 if FieldByName('DirectoryImport').asString <> ''
                 then try
                          //����� ����� MMO
                          if System.SysUtils.FindFirst(FieldByName('DirectoryImport').asString + '\*.mmo', faAnyFile, searchResult) = 0 then
                          begin
                               //�� ������ - ������ �� ���� ���� MMO ��� ��������
                               if (1=1 )
                               then
                               begin
                                   AddToLog('������ ��������: '+ FieldByName('DirectoryImport').asString);
                                   // ����������� ��������
                                   actExecuteImportSettings.ExternalParams.ParamByName('Directory_add').Value:= '';
                                   // ����������� ��������
                                   mactExecuteImportSettings.Execute;
                                   if actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value <> '' then
                                   begin
                                     PanelError.Caption := actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value;
                                     PanelError.Invalidate;
                                   end;
                                   AddToLog('��������� ��������' + FieldByName('DirectoryImport').asString);
                               end
                               else //������ - ������ �� ���� ���� MMO ��� ��������
                               begin
                                   AddToLog('������: ������ �� ���� ���� MMO ��� ��������');
                               end;
                               if actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value <> ''
                               then begin
                                    //current directory to store the email files
                                    mailFolder:= FieldByName('DirectoryImport').AsString+'\������\';
                                    //������� ����� ��� ... ���� ������� ���
                                    ForceDirectories(mailFolder);

                                    //��������� ��� ������� � �������� � ����� "������"
                                    StrCopyFolder:='cmd.exe /c move ' + chr(34) + FieldByName('DirectoryImport').AsString + '\*.mmo' + chr(34) + ' ' + chr(34) + mailFolder + chr(34);
                                    WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);

                                    //� ����� ��� ������
                                    fError_SendEmail(FieldByName('Id').AsInteger
                                                   , FieldByName('ContactPersonId').AsInteger
                                                   , msgDate
                                                   , FieldByName('JuridicalMail').AsString + ' * ' + FieldByName('Mail').AsString
                                                   , actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value);
                                end;

                          end
                          else //������ - �� ������ ���� MMO ��� ��������
                               //�� ��, ��� ��������� :)
                               ;
                      except on E: Exception do //� ����� ��� ������
                        begin
                             AddToLog('Exception (fBeginMMO): '+ E.Message + '???'+actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value);
                             {fError_SendEmail(FieldByName('Id').AsInteger
                                            , FieldByName('ContactPersonId').AsInteger
                                            , msgDate
                                            , FieldByName('JuridicalMail').AsString + ' * ' + FieldByName('Mail').AsString
                                            , '???'+actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value)};
                        end;
                      end;
           end;//2.if ... !!!������ ��� zc_Enum_EmailKind_IncomeMMO!!!

           Next;
           //
           GaugeLoadXLS.Progress:=GaugeLoadXLS.Progress + 1;
           Application.ProcessMessages;
        end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fBeginMMO_all : Boolean;
var
 searchResult : TSearchRec;
 mailFolder,StrCopyFolder: ansistring;
begin
     //
     if vbIsBegin = true then exit;
     PanelInfo.Caption:= '��������� ��������.';
     PanelInfo.Invalidate;
     //
     try
     // �������� ���������
     vbIsBegin:= true;
     //
     //
     with ClientDataSet do begin
        GaugeLoadXLS.Progress:=0;
        GaugeLoadXLS.MaxValue:=RecordCount;
        Application.ProcessMessages;
        //
        First;
        while not EOF do begin

           //2.������ ��� zc_Enum_EmailKind_IncomeMMO!!!
           if (FieldByName('EmailKindId').asInteger = FieldByName('zc_Enum_EmailKind_IncomeMMO').asInteger)
              //and (FieldByName('Id').asInteger = inImportSettingsId)
              //and (FieldByName('UserName').asString = inUserName)
           then begin
                 PanelLoadXLS.Caption:= 'Load MMO : ('+FieldByName('Id').AsString + ') ' + FieldByName('Name').AsString + ' - ' + FieldByName('ContactPersonName').AsString;
                 PanelLoadXLS.Invalidate;
                 Sleep(50);
                 //��������� ���� ���� ������
                 if FieldByName('DirectoryImport').asString <> ''
                 then try
                          //����� ����� MMO
                          if System.SysUtils.FindFirst(FieldByName('DirectoryImport').asString + '\*.mmo', faAnyFile, searchResult) = 0 then
                          begin
                               //�� ������ - ������ �� ���� ���� MMO ��� ��������
                               if (1=1 )
                               then
                               begin
                                   AddToLog('������ �������� (all): '+ FieldByName('DirectoryImport').asString);
                                   // ����������� ��������
                                   actExecuteImportSettings.ExternalParams.ParamByName('Directory_add').Value:= '';
                                   // ����������� ��������
                                   mactExecuteImportSettings.Execute;
                                   if actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value <> '' then
                                   begin
                                     PanelError.Caption := actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value;
                                     PanelError.Invalidate;
                                   end;
                                   AddToLog('��������� �������� (all)' + FieldByName('DirectoryImport').asString);
                               end
                               else //������ - ������ �� ���� ���� MMO ��� ��������
                               begin
                                   AddToLog('������: ������ �� ���� ���� MMO ��� ��������');
                               end;
                               if actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value <> ''
                               then begin
                                    //current directory to store the email files
                                    mailFolder:= FieldByName('DirectoryImport').AsString+'\������\';
                                    //������� ����� ��� ... ���� ������� ���
                                    ForceDirectories(mailFolder);

                                    //��������� ��� ������� � �������� � ����� "������"
                                    StrCopyFolder:='cmd.exe /c move ' + chr(34) + FieldByName('DirectoryImport').AsString + '\*.mmo' + chr(34) + ' ' + chr(34) + mailFolder + chr(34);
                                    WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);

                                    AddToLog('Exception (fBeginMMO_all): �������� ����� � ������');

                                    //� ����� ��� ������
                                    fError_SendEmail(FieldByName('Id').AsInteger
                                                   , FieldByName('ContactPersonId').AsInteger
                                                   , now
                                                   , FieldByName('JuridicalMail').AsString + ' * ' + FieldByName('Mail').AsString
                                                   , actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value);
                                end;

                          end
                          else //������ - �� ������ ���� MMO ��� ��������
                               //�� ��, ��� ��������� :)
                               ;
                      except on E: Exception do //� ����� ��� ������
                        begin
                             AddToLog('Exception (fBeginMMO_all): '+ E.Message);
//                             fError_SendEmail(FieldByName('Id').AsInteger
//                                            , FieldByName('ContactPersonId').AsInteger
//                                            , now
//                                            , FieldByName('JuridicalMail').AsString + ' * ' + FieldByName('Mail').AsString
//                                            , '???'+actExecuteImportSettings.ExternalParams.ParamByName('outMsgText').Value);
                        end;
                      end;
           end;//2.if ... !!!������ ��� zc_Enum_EmailKind_IncomeMMO!!!

           Next;
           //
           GaugeLoadXLS.Progress:=GaugeLoadXLS.Progress + 1;
           Application.ProcessMessages;
        end;
     end;

     finally
       // ��������� ���������
       vbIsBegin:= false;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ������� ���
function TMainForm.fBeginMove : Boolean;
var StartTime:TDateTime;
begin
// exit;
     if vbIsBegin = true then exit;
      PanelInfo.Caption:= '������� ���.';
      PanelInfo.Invalidate;
     // �������� ���������
     vbIsBegin:= true;
     try
       with spSelectMove do
       begin
        StoredProcName:='gpSelect_Movement_LoadPriceList';
        OutputType:=otDataSet;
        Params.Clear;
        Execute;// �������� ��� ������
        //
        GaugeMove.Progress:=0;
        GaugeMove.MaxValue:=DataSet.RecordCount;
        Application.ProcessMessages;
        //
        DataSet.First;
        while not Dataset.EOF do begin
           StartTime:=NOW;
           PanelMove.Caption:= 'Move : ('+FormatDateTime('dd.mm.yyyy',DataSet.FieldByName('OperDate').AsDateTime) + ') ' + DataSet.FieldByName('JuridicalName').AsString + ' : ' + DataSet.FieldByName('ContractName').AsString + ' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelMove.Invalidate;
           Sleep(100);
           //
           try
              if DataSet.FieldByName('isMoved').AsBoolean = FALSE then actMovePriceList.Execute;
           except on E: Exception do
             begin
               fError_SendEmail(0 //Dataset.FieldByName('Id').AsInteger
                              , 0 // Dataset.FieldByName('ContactPersonId').AsInteger
                              , NOW
                              , Dataset.FieldByName('JuridicalName').AsString
                              , '-1');
             end;
           end;
           //
           DataSet.Next;
           //
           PanelMove.Caption:= 'Move : ('+FormatDateTime('dd.mm.yyyy',DataSet.FieldByName('OperDate').AsDateTime) + ') ' + DataSet.FieldByName('JuridicalName').AsString + ' : ' + DataSet.FieldByName('ContractName').AsString + ' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW);
           PanelMove.Invalidate;
           GaugeMove.Progress:=GaugeMove.Progress + 1;
           Application.ProcessMessages;
        end;
     end;
     finally
       // ��������� ���������
       vbIsBegin:= false;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���
function TMainForm.fBeginAll : Boolean;
var isErr, isErr_exit : Boolean;
begin
     PanelError.Caption:= '';
     PanelError.Invalidate;
     PanelInfo.Caption:= '������ ����� ���������.';
     PanelInfo.Invalidate;

     try
       isErr_exit:= false;
       Timer.Enabled:= false;
       BtnStart.Enabled:= false;

       //�������������� ������ �� ���� �����������
       try fInitArray;
       except
         PanelHost.Caption:= '!!! ERROR - fInitArray - exit !!!';
         PanelHost.Invalidate;
         isErr_exit:= true;
         exit;
       end;
       //
       //
       // !!!��������� ���� - MMO!!!
       if vbEmailKindDesc= 'zc_Enum_EmailKind_IncomeMMO' then fBeginMMO_all;
       //
       // ��������� ���� �����
       PanelInfo.Caption:= '��������� ���� �����.';
       PanelInfo.Invalidate;
       try
        isErr:= true;
        fBeginMail;
        isErr:= false;
       except on E: Exception do
        begin
          vbIsBegin:= false;
          PanelHost.Caption:= '!!! ERROR - fBeginMail: ' + E.Message;
          PanelHost.Invalidate;
        end;
       end;
       // ��������� ���� XLS - !!!������ ���� "�������� ������"!!!
       try if vbEmailKindDesc= 'zc_Enum_EmailKind_InPrice' then fBeginXLS;
       except
         vbIsBegin:= false;
         PanelHost.Caption:= '!!! ERROR - fBeginXLS - exit !!!';
         PanelHost.Invalidate;
         isErr_exit:= true;
         exit;
       end;
       // ����������� ���� ���� �������� XLS - !!!������ ���� "�������� ������"!!!
       try if vbEmailKindDesc= 'zc_Enum_EmailKind_InPrice' then fRefreshMovementItemLastPriceList_View;
       except
         vbIsBegin:= false;
         PanelHost.Caption:= '!!! ERROR - fRefreshMovementItemLastPriceList_View - exit !!!';
         PanelHost.Invalidate;
         isErr_exit:= true;
         exit;
       end;
       // ������� ��� - !!!������ ���� "�������� ������"!!!
       try if (cbBeginMove.Checked = TRUE) and (vbEmailKindDesc= 'zc_Enum_EmailKind_InPrice') then fBeginMove;
       except
         vbIsBegin:= false;
         PanelHost.Caption:= '!!! ERROR - fBeginMove - exit !!!';
         PanelHost.Invalidate;
         isErr_exit:= true;
         exit;
       end;

     finally
       Timer.Enabled:= true;
       BtnStart.Enabled:= vbIsBegin = false;
       PanelInfo.Caption:= '���� ��������.';
       PanelInfo.Invalidate;
       //
       if isErr_exit= false
       then
       begin
           if isErr = true
           then PanelHost.Caption:= 'End !!!ERROR!!! - fBeginMail ... and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',now + Timer.Interval / 1000 / 60 /  24 / 60 )
           else PanelHost.Caption:= 'End OK all ... and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',now + Timer.Interval / 1000 / 60 / 24 / 60 );
           PanelHost.Invalidate;
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BtnStartClick(Sender: TObject);
begin
     // ����, ����� ����� �������� �������
     vbOnTimer:= NOW;
     // ��������� ���
     fBeginAll;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.TimerTimer(Sender: TObject);
begin
  try
     // ����� ����� �������� �������
     vbOnTimer:= NOW;
     Timer.Interval := 10000;
     cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
     Sleep(500);
     // ��������� ���
     fBeginAll;
  finally

  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGet_LoadPriceList (inJuridicalId, inContractId, inAreaId :Integer) : Integer;
begin
     //gpGet_LoadPriceList
     with spGet_LoadPriceList do
     begin
       ParamByName('inJuridicalId').Value:=inJuridicalId;
       ParamByName('inContractId').Value:=inContractId;
       ParamByName('inAreaId').Value:=inAreaId;
       Execute;
       Result:=ParamByName('outId').Value;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
{ TPanel }

procedure TPanel.CMTextChanged(var Message: TMessage);
begin
  if (Caption <> '') and (Name = 'PanelError') then
    AddToLog(ReplaceStr(Name, 'Panel', '') + ' - ' + Caption);
end;

end.
