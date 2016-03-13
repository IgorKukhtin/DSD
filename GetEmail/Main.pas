unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls, Vcl.ActnList,
  dsdAction, ExternalLoad, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL;

type
  // ������� "�������� ����"
  TMailItem = record
    Host          : string;
    Port          : Integer;
    Mail          : string;
    UserName      : string;
    PasswordValue : string;
    Directory     : string;    // ����, �� �������� ����������� ��������� ������� �� �����, � ���� ���������� - ��� �� ���������������
    onTime        : Integer;   // � ����� �������������� ��������� ����� � �������� �������, ���
    BeginTime     : TDateTime; // ����� ��������� ��������
  end;
  TArrayMail = array of TMailItem;
  // ������� "��������� � ��������� �������� ����������"
  TImportSettingsItem = record
    Host          : string;
    Id            : Integer;
    Code          : Integer;
    Name          : string;
    JuridicalId   : Integer;
    JuridicalCode : Integer;
    JuridicalName : string;
    JuridicalMail : string;
    ContractId    : Integer;
    ContractName  : string;
    Directory     : string;    // ����, � ������� ������ ������� xls ����� ����� ��������� � ���������
    StartTime     : TDateTime; // ����� ������ �������� ��������
    EndTime       : TDateTime; // ����� ��������� �������� ��������
  end;
  TArrayImportSettings = array of TImportSettingsItem;

  TMainForm = class(TForm)
    IdPOP3: TIdPOP3;
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
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
  private
    vbIsBegin :Boolean;// �������� ���������

    vbArrayMail :TArrayMail; // ������ �������� ������
    vbArrayImportSettings :TArrayImportSettings; // ������ ����������� � ���������� �������� ����������

    function GetArrayList_Index_byHost(ArrayList:TArrayMail;Host:String):Integer;//������� ������ � ������� �� �������� Host
    function GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;Host,JuridicalMail:String):Integer;//������� ������ � ������� �� �������� Host + MailJuridical

    function fGet_LoadPriceList (inJuridicalId, inContractId :Integer) : Integer;

    function fBeginAll  : Boolean; // ��������� ���
    function fInitArray : Boolean; // �������� ������ � ������� � �� ��������� ���� ������ ��������� �������
    function fBeginMail : Boolean; // ��������� ���� �����
    function fBeginXLS  : Boolean; // ��������� ���� XLS
    function fBeginMove : Boolean; // ������� ���
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst, sevenzip;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  //������� ������ � �������
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� �����-���������', gc_AdminPassword, gc_User);
  // �������� ���������
  vbIsBegin:= false;
  // ���������� ����� � ���������� ���� (� �������� ����������� ������)
  cbBeginMove.Checked:=false;
  // �������� ������
  cbTimer.Checked:=true;
  Timer.Enabled:=cbTimer.Checked;
  //
  GaugeHost.Progress:=0;
  GaugeMailFrom.Progress:=0;
  GaugeParts.Progress:=0;
  GaugeLoadXLS.Progress:=0;
  GaugeMove.Progress:=0;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbTimerClick(Sender: TObject);
begin
     Timer.Enabled:=cbTimer.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//������� ������ � ������� �� �������� Host
function TMainForm.GetArrayList_Index_byHost(ArrayList:TArrayMail;Host:String):Integer;
var i: Integer;
begin
     //������� ������ � ������� �� �������� Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].Host = Host) then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
//������� ������ � ������� �� �������� Host + MailJuridical + �����
function TMainForm.GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;Host,JuridicalMail:String):Integer;
var i: Integer;
    Year, Month, Day: Word;
    Second, MSec: word;
    Hour_calc, Minute_calc: word;
    StartTime_calc,EndTime_calc:TDateTime;
begin
     //������� ������ � ������� �� �������� Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].Host = Host) and (AnsiUpperCase(ArrayList[i].JuridicalMail) = AnsiUpperCase(JuridicalMail))
      then begin Result:=i;break;end;
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
         EndTime_calc:= EncodeDateTime(Year, Month, Day, Hour_calc, Minute_calc, 0, 0);
         //������ ����� ���������
         if not ((StartTime_calc <= NOW) and (EndTime_calc >= NOW))
         then Result:= -1;
    end;
end;
{------------------------------------------------------------------------}
// �������� ������ � ������� � �� ��������� ���� ������ ��������� �������
function TMainForm.fInitArray : Boolean;
var i:Integer;
    HostStringList:TStringList;
begin
     if vbIsBegin = true then exit;
     // �������� ���������
     vbIsBegin:= true;

     HostStringList:=TStringList.Create;
     HostStringList.Sorted:=true;
     //
     with spSelect do
     begin
       StoredProcName:='gpSelect_Object_ImportSettings_Email';
       OutputType:=otDataSet;
       Params.Clear;
       Execute;// �������� ���� �����������, �� ������� ���� ��������� Email
       //
       //������ ����
       DataSet.First;
       i:=0;
       SetLength(vbArrayImportSettings,DataSet.RecordCount);//����� ������ ������������� ���-�� �����������
       while not DataSet.EOF do begin
          //��������� ������� ����������
          vbArrayImportSettings[i].Host         :=DataSet.FieldByName('Host').asString;
          vbArrayImportSettings[i].Id           :=DataSet.FieldByName('Id').asInteger;
          vbArrayImportSettings[i].Code         :=DataSet.FieldByName('Code').asInteger;
          vbArrayImportSettings[i].Name         :=DataSet.FieldByName('Name').asString;
          vbArrayImportSettings[i].JuridicalId  :=DataSet.FieldByName('JuridicalId').asInteger;
          vbArrayImportSettings[i].JuridicalCode:=DataSet.FieldByName('JuridicalCode').asInteger;
          vbArrayImportSettings[i].JuridicalName:=DataSet.FieldByName('JuridicalName').asString;
          vbArrayImportSettings[i].JuridicalMail:=DataSet.FieldByName('JuridicalMail').asString;
          vbArrayImportSettings[i].ContractId   :=DataSet.FieldByName('ContractId').asInteger;
          vbArrayImportSettings[i].ContractName :=DataSet.FieldByName('ContractName').asString;
          // ����, � ������� ������ ������� xls ����� ����� ��������� � ���������
          vbArrayImportSettings[i].Directory    :=ExpandFileName(DataSet.FieldByName('DirectoryImport').asString);
          // ����� ������ �������� ��������
          vbArrayImportSettings[i].StartTime    :=DataSet.FieldByName('StartTime').AsDateTime;
          // ����� ��������� �������� ��������
          vbArrayImportSettings[i].EndTime      :=DataSet.FieldByName('EndTime').AsDateTime;

          //�������� ��������� ������ Host
          if not (HostStringList.IndexOf(DataSet.FieldByName('Host').asString) >= 0)
          then begin HostStringList.Add(DataSet.FieldByName('Host').asString);HostStringList.Sort;end;

          //������� � ����������
          DataSet.Next;
          i:=i+1;
       end;
       //
       //������ ����
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,HostStringList.Count);//����� ������ ������������� ���-�� Host-��
       while not DataSet.EOF do
       begin
          if GetArrayList_Index_byHost(vbArrayMail, DataSet.FieldByName('Host').asString) = -1 then
          begin
                //��������� ����� Host
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
                cbBeginMove.Checked:=DataSet.FieldByName('isBeginMove').asBoolean;
                //
                //� ������ ��������� - ������������� �������� �����
                if (Timer.Interval > vbArrayMail[i].onTime * 60 * 1000) or (Timer.Interval <= 1000) then
                begin
                     Timer.Interval:= vbArrayMail[i].onTime * 60 * 1000;
                     cbTimer.Caption:= 'Timer ON ' + IntToStr(vbArrayMail[i].onTime * 60) + ' sec';
                end;
                //
                i:=i+1;
          end;
          //������� � ����������
          DataSet.Next;
       end;
     end;
     //
     HostStringList.Free;
     // ��������� ���������
     vbIsBegin:= false;
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
begin
     if vbIsBegin = true then exit;
     // �������� ���������
     vbIsBegin:= true;


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
       // ���� ����� ���������� ��������� ������ > onTime �����
       if (NOW - vbArrayMail[ii].BeginTime) * 24 * 60 > vbArrayMail[ii].onTime
       then
           with IdPOP3 do
           begin
              //
              PanelHost.Caption:= 'Start Host : '+vbArrayMail[ii].Host+' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              Application.ProcessMessages;
              //current directory to store the email
              mailFolderMain:= vbArrayMail[ii].Directory + '\' + vbArrayMail[ii].Host + '_' + Session;
              //������� ����� ��� ����� ���� ������� ��� + ��� �������� ��� �� ������� ����� ���� ���������
              ForceDirectories(mailFolderMain);

              //��������� ����������� � �����
              Host    := vbArrayMail[ii].Host;
              UserName:= vbArrayMail[ii].UserName;
              Password:= vbArrayMail[ii].PasswordValue;
              Port    := vbArrayMail[ii].Port;

              try
                 //������������ � �����
                 IdPOP3.Connect;
                 //���������� �����
                 msgcnt:= IdPOP3.CheckMessages;
                 //
                 GaugeMailFrom.Progress:=0;
                 GaugeMailFrom.MaxValue:=msgcnt;
                 Application.ProcessMessages;
                 //���� �� �������� �������
                 for I:= msgcnt downto 1 do
                 begin
                   IdMessage.Clear; // ������� ������ ��� ���������
                   flag:= false;

                   //���� ���������� �� ����� ������
                   if (IdPOP3.Retrieve(i, IdMessage)) then
                   begin
                        //������� ����������, ������� �������� �� ���� Host + ���� � ����� ������ + �����
                        JurPos:=GetArrayList_Index_byJuridicalMail(vbArrayImportSettings, vbArrayMail[ii].Host, IdMessage.From.Address);
                        //
                        if JurPos >=0
                        then PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' (' +  IntToStr(vbArrayImportSettings[JurPos].Id) + ') ' + vbArrayImportSettings[JurPos].Name
                        else PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' ' + IdMessage.From.Address + ' - ???';
                        Application.ProcessMessages;
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
                             //��������� �� ���� ������ ������
                             for j := 0 to IdMessage.MessageParts.Count - 1 do
                             begin
                               //
                               PanelParts.Caption:= 'Parts : '+IdMessage.From.Address;
                               Application.ProcessMessages;
                               //���� ��� ��������� ������
                               if IdMessage.MessageParts[j] is TIdAttachment then
                               begin
                                   // ��������� ������ �� ������
                                   (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                   // ���� ���� - ���������������
                                   if not (System.Pos(AnsiUppercase('.xls'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                    and not(System.Pos(AnsiUppercase('.xlsx'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                    and not(System.Pos(AnsiUppercase('.xml'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
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

                            // ������ ���� "�������" �� ���� �������� JurPos
                            if fGet_LoadPriceList (vbArrayImportSettings[JurPos].JuridicalId, vbArrayImportSettings[JurPos].ContractId ) = 0 then
                            begin
                                  // ����� ����������� ��� ������� � ����� �� ������� ��� ����� ��������
                                  StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.xls' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                  WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                                  // ����� ����������� ��� ������� � ����� �� ������� ��� ����� ��������
                                  StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.xlsx' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                  WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                            end;
                            // ����� ���� ������� ������ � �����
                            flag:= true;
                        end
                        // ���� �� ����� - ��� ����� ������� ������ � �����
                        else flag:= true;
                   end
                   else ShowMessage('not read :' + IntToStr(i));

                   //�������� ������
                   if flag then IdPOP3.Delete(i);

                   //
                   GaugeMailFrom.Progress:=GaugeMailFrom.Progress+1;
                   Application.ProcessMessages;

                 end;//����� - ���� �� �������� �������
                 //�������� ��������� ����� ��������� ��������� ��������� �����
                 vbArrayMail[ii].BeginTime:=NOW;
                 //
                 PanelHost.Caption:= 'End Host '+vbArrayMail[ii].Host+' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 GaugeHost.Progress:=GaugeHost.Progress + 1;
                 Application.ProcessMessages;
              finally
                 IdPOP3.Disconnect;
              end;

           end;//����� - ���� �� �������� ������

     // ��������� ���������
     vbIsBegin:= false;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���� XLS
function TMainForm.fBeginXLS : Boolean;
begin
     if vbIsBegin = true then exit;
     // �������� ���������
     vbIsBegin:= true;

     with ClientDataSet do begin
        GaugeLoadXLS.Progress:=0;
        GaugeLoadXLS.MaxValue:=RecordCount;
        Application.ProcessMessages;
        //
        First;
        while not EOF do begin
           PanelLoadXLS.Caption:= 'Load XLS : ('+FieldByName('Id').AsString + ') ' + FieldByName('Name').AsString;
           Application.ProcessMessages;
           //��������� ���� ���� ������
           if FieldByName('DirectoryImport').asString <> ''
           then actExecuteImportSettings.Execute;

           Next;
           //
           GaugeLoadXLS.Progress:=GaugeLoadXLS.Progress + 1;
           Application.ProcessMessages;
        end;
     end;

     // ��������� ���������
     vbIsBegin:= false;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ������� ���
function TMainForm.fBeginMove : Boolean;
var StartTime:TDateTime;
begin
     if vbIsBegin = true then exit;
     // �������� ���������
     vbIsBegin:= true;

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
           Application.ProcessMessages;
           //
           if DataSet.FieldByName('isMoved').AsBoolean = FALSE
           then actMovePriceList.Execute;
           //
           DataSet.Next;
           //
           PanelMove.Caption:= 'Move : ('+FormatDateTime('dd.mm.yyyy',DataSet.FieldByName('OperDate').AsDateTime) + ') ' + DataSet.FieldByName('JuridicalName').AsString + ' : ' + DataSet.FieldByName('ContractName').AsString + ' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW);
           GaugeMove.Progress:=GaugeMove.Progress + 1;
           Application.ProcessMessages;
        end;
     end;

     // ��������� ���������
     vbIsBegin:= false;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���
function TMainForm.fBeginAll : Boolean;
begin
     //�������������� ������ �� ���� �����������
     fInitArray;
     // ��������� ���� �����
     fBeginMail;
     // ��������� ���� XLS
     fBeginXLS;
     // ������� ���
     if cbBeginMove.Checked = TRUE then fBeginMove;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BtnStartClick(Sender: TObject);
begin
     // ��������� ���
     fBeginAll;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.TimerTimer(Sender: TObject);
begin
     // ��������� ���
     fBeginAll;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGet_LoadPriceList (inJuridicalId, inContractId :Integer) : Integer;
begin
     with spGet_LoadPriceList do
     begin
       ParamByName('inJuridicalId').Value:=inJuridicalId;
       ParamByName('inContractId').Value:=inContractId;
       Execute;
       Result:=ParamByName('outId').Value;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
end.
