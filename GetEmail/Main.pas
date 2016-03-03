unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
    Directory     : string;
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
    ContractId    : Integer;
    ContractName  : string;
    Directory     : string;
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
// �������� ������ � ������� � �� ��������� ���� ������ ��������� �������
function TMainForm.fInitArray : Boolean;
var i:Integer;
    MailStringList:TStringList;
begin
     MailStringList:=TStringList.Create(nil);
     MailStringList.Sorted:=true;
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
          vbArrayImportSettings[i].ContractId   :=DataSet.FieldByName('ContractId').asInteger;
          vbArrayImportSettings[i].ContractName :=DataSet.FieldByName('ContractName').asString;
          vbArrayImportSettings[i].Directory    :=DataSet.FieldByName('DirectoryImport').asString;
          //������� � ����������
          DataSet.Next;
          i:=i+1;
       end;
       //
       //������ ����
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,MailStringList.Count);//����� ������ ������������� ���-�� Host-��
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
                if AnsiUpperCase(DataSet.FieldByName('DirectoryMail').asString) = AnsiUpperCase('\inbox')
                then vbArrayMail[i].Directory:=GetCurrentDir() + '' + DataSet.FieldByName('DirectoryMail').asString
                else vbArrayMail[i].Directory:=DataSet.FieldByName('DirectoryMail').asString;
                //
                i:=i+1;
          end;
          //������� � ����������
          DataSet.Next;
       end;
     end;
     //
     MailStringList.Free;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���� �����
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  mailFolder: String;
begin
     //���� �� �������� ������
     for ii := 0 to Length(vbArrayMail)-1 do
     with IdPOP3 do begin
        //��������� ����������� � �����
        Host    := vbArrayMail[ii].Host;
        UserName:= vbArrayMail[ii].UserName;
        Password:= vbArrayMail[ii].PasswordValue;
        Port    := vbArrayMail[ii].Port;
        try
           //������������ � �����
           IdPOP3.Connect;
           //current directory to store the email files
           mailFolder:= vbArrayMail[ii].Directory;
           //������� ����� ���� ������� ���
           ForceDirectories(mailFolder);
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
                  //��������� �� ���� ������ ������
                  for j := 0 to IdMessage.MessageParts.Count - 1
                  do
                    //���� ��� ��������� ������
                    if IdMessage.MessageParts[j] is TIdAttachment then
                    begin
                         // ��������� ������ �� ������
                         (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder +'\' + IdMessage.MessageParts[J].FileName);
                         //ShowMessage(IdMessage.From.Address + ' : ' + IdMessage.Subject + ' : ' + IntToStr(j) + ' : ' + IdMessage.MessageParts[j].FileName + '   '  +FormatDateTime('dd mmm yyyy hh:mm:ss', IdMessage.Date) );
                    end;
                  //����������� ��������� ���� ������ 1-��� ������

                  // ����� ������ ������ � �����
                  flag:= true;
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
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.
