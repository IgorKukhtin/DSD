unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient;

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
    BitBtn1: TBitBtn;
    spSelect: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    vbArrayMail :TArrayMail; // ������ �������� ������
    vbArrayImportSettings :TArrayImportSettings; // ������ ����������� � ���������� �������� ����������
    function GetArrayList_Index_byHost(ArrayList:TArrayMail;Host:String):Integer;//������� ������ � ������� �� �������� Host
    function GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;Host,JuridicalMail:String):Integer;//������� ������ � ������� �� �������� Host + MailJuridical
    function fInitArray : Boolean; // �������� ������ � ������� � �� ��������� ���� ������ ��������� �������
    function fBeginMail : Boolean; // ��������� ���� �����
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  //������� ������ � �������
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� �����-���������', gc_AdminPassword, gc_User);
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
                // ����� ��������� ��������
                vbArrayMail[i].BeginTime:=NOW-1000;
                //
                i:=i+1;
          end;
          //������� � ����������
          DataSet.Next;
       end;
     end;
     //
     HostStringList.Free;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���� �����
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  mailFolder,mailFolder1,mailFolder2,mailFolder3,mailFolder4,Session: ansistring;
  JurPos: integer;
begin
     //������ - � ��� ����� ����� ��������� ������� - ��� ������������ �������� ������� ���������
     Session:=FormatDateTime('yyy-mm-dd hh-mm-ss',NOW);

     //���� �� �������� ������
     for ii := 0 to Length(vbArrayMail)-1 do
       // ���� ����� ���������� ��������� ������ > onTime �����
       if (NOW - vbArrayMail[ii].BeginTime) * 24 * 60 > vbArrayMail[ii].onTime
       then
           with IdPOP3 do
           begin
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
                 //���� �� �������� �������
                 for I:= msgcnt downto 1 do
                 begin
                   IdMessage.Clear; // ������� ������ ��� ���������
                   flag:= false;

                   //���� ���������� �� ����� ������
                   if (IdPOP3.Retrieve(i, IdMessage)) then
                   begin
                        //������� ����������, ������� �������� �� ���� Host + ���� � ����� ������
                        JurPos:=GetArrayList_Index_byJuridicalMail(vbArrayImportSettings, vbArrayMail[ii].Host, IdMessage.From.Address);
                        //���� ����� ����������, ����� ��� ������ ���� ���������
                        if JurPos >= 0 then
                        begin
                             //current directory to store the email files
                             mailFolder:= vbArrayMail[ii].Directory + '\' + vbArrayMail[ii].Host + '_' + Session + '_' + IntToStr(vbArrayImportSettings[JurPos].Id) + '_' + vbArrayImportSettings[JurPos].JuridicalName;
                             //������� ����� ��� ����� ���� ������� ���
                             ForceDirectories(mailFolder);

                             //��������� �� ���� ������ ������
                             for j := 0 to IdMessage.MessageParts.Count - 1
                             do
                               //���� ��� ��������� ������
                               if IdMessage.MessageParts[j] is TIdAttachment then
                               begin
                                   // ��������� ������ �� ������
                                   (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                   // ���� ���� - ���������������
                                   if not (System.Pos(AnsiUppercase('.xls'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                    and not(System.Pos(AnsiUppercase('.xlsx'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   then ;
                                   //ShowMessage(IdMessage.From.Address + ' : ' + IdMessage.Subject + ' : ' + IntToStr(j) + ' : ' + IdMessage.MessageParts[j].FileName + '   '  +FormatDateTime('dd mmm yyyy hh:mm:ss', IdMessage.Date) );
                               end;
                            //����������� ��������� ���� ������ ������ ������

                            //������� ����� ��� ��������, ���� ������� ���
                            ForceDirectories(vbArrayImportSettings[JurPos].Directory);

                            // ����� ����������� ��� ������� � ����� �� ������� ��� ����� ��������
                            mailFolder1:=mailFolder+'\*.xls';
                            CopyFile(PChar(mailFolder1),PChar(vbArrayImportSettings[JurPos].Directory),TRUE);
                            // ����� ����������� ��� ������� � ����� �� ������� ��� ����� ��������
                            mailFolder2:=mailFolder+'\*.xlsx';
                            CopyFile(PChar(mailFolder2),PChar(vbArrayImportSettings[JurPos].Directory),TRUE);
                            // !!!TEST!!!
                            mailFolder3:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.*' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                            WinExec(PAnsiChar(mailFolder3), SW_HIDE);

                            // ����� ���� ������� ������ � �����
                            flag:= true;
                        end;
                   end
                   else ShowMessage('not read :' + IntToStr(i));

                   //�������� ������
                   //if flag then IdPOP3.Delete(i);

                 end;//����� - ���� �� �������� �������
              finally
                 IdPOP3.Disconnect;
              end;

           end;//����� - ���� �� �������� ������
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
     //�������������� ������ �� ���� ����������
     fInitArray;
     // ��������� ���� �����
     fBeginMail;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.
