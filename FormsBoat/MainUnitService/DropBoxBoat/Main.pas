unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants,
  System.Classes, System.IOUtils, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges,
  Vcl.ExtCtrls, Vcl.ActnList, System.Types, System.Generics.Collections, System.RegularExpressions,
  dsdDB, dsdAction, dsdInternetAction, System.Actions, FormStorage, UnilWin, IniFiles,
  Document;

const SAVE_LOG = true;

type
  TPanel = class(Vcl.ExtCtrls.TPanel)
  private
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  end;

type

  TMainForm = class(TForm)
    BtnStart: TBitBtn;
    spSelect: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    PanelCopyFile: TPanel;
    GaugeCopyFile: TGauge;
    Timer: TTimer;
    cbTimer: TCheckBox;
    PanelError: TPanel;
    PanelInfo: TPanel;
    BitSendUnscheduled: TBitBtn;
    Document: TDocument;
    spGetDocument: TdsdStoredProc;
    spInvoicePdf_DateUnloading: TdsdStoredProc;
    spUpdate_PostedToDropBox: TdsdStoredProc;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SetDateSend(Value : TDateTime);
    procedure BitSendUnscheduledClick(Sender: TObject);
  private

    FUserName: String;
    FUserPassword: String;

    FDropBoxDir: String;
    FDateSend: TDateTime;

    FIsBegin: Boolean;// �������� ���������
    FOnTimer: TDateTime;// ����� ����� �������� ������
    FSendUnscheduled: Boolean;// ��������� ����������

    FDateSendList: TList<TDateTime>;// ��������� ������ ��������

    function fBeginAll  : Boolean; // ��������� ���
    procedure fCopyFile;           // ����������� ���� ������
  public

    property DateSend: TDateTime read FDateSend write SetDateSend;
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst, StrUtils;
{$R *.dfm}

procedure AddToLog(ALogMessage: string);
var F: TextFile;
begin
  if not SAVE_LOG then Exit;

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

function PADR(Src: string; Lg: Integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := Result + ' ';
end;


//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  cTimeList: String;
  Res: TArray<string>;
  I: Integer;
begin

  Self.Caption:= Self.Caption + ' - ������ �����';

  FDateSendList := TList<TDateTime>.Create;
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + TPath.GetFileNameWithoutExtension(Application.ExeName) + '.ini');

  try

    FUserName := Ini.ReadString('Connect', 'UserName', '�����');
    Ini.WriteString('Connect', 'UserName', FUserName);

    FUserPassword := Ini.ReadString('Connect', 'UserPassword', '�����');
    Ini.WriteString('Connect', 'UserPassword', FUserPassword);

    FDropBoxDir := Ini.ReadString('DropBox', 'DropBoxDir', '');
    if FDropBoxDir <> '' then
    begin
      if FDropBoxDir[Length(FDropBoxDir)] <> '\' then FDropBoxDir := FDropBoxDir + '\';
      Ini.WriteString('DropBox', 'DropBoxDir', FDropBoxDir);
    end;

    FDateSend := Ini.ReadDateTime('DropBox', 'DateSend', EncodeDate(2024, 1, 1));
    Ini.WriteDateTime('DropBox', 'DateSend', FDateSend);

    cTimeList := Ini.ReadString('Scheduler', 'TimeList', '18:00:00');
    Ini.WriteString('Scheduler', 'TimeList', cTimeList);

  finally
    Ini.free;
  end;

  // �������� �������
  Res := TRegEx.Split(cTimeList, ';');

  for I := 0 to High(Res) do
  try
    if FDateSendList.IndexOfItem(Date + StrToTime(Res[I]), TDirection.FromBeginning) < 0 then
      FDateSendList.Add(Date + StrToTime(Res[I]));
  except
  end;
  FDateSendList.Sort;


  //������� ������ � �������
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, FUserName, FUserPassword, gc_User);
  // �������� ���������
  FIsBegin:= false;
  // ��������� ����������
  FSendUnscheduled:= false;
  //
  GaugeCopyFile.Progress:=0;
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

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FDateSendList.Free;
end;

procedure TMainForm.SetDateSend(Value : TDateTime);
var
  Ini: TIniFile;
begin

  FDateSend := Value;

  Self.Caption:= Self.Caption + ' - ������ �����';

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + TPath.GetFileNameWithoutExtension(Application.ExeName) + '.ini');
  try

    Ini.WriteDateTime('DropBox', 'DateSend', FDateSend);

  finally
    Ini.free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbTimerClick(Sender: TObject);
begin
     Timer.Enabled:=cbTimer.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ����������� ���� ������
procedure TMainForm.fCopyFile;
  var DateStart : TDateTime;
      FileName: String;
      MovementId: Integer;
      isPostedToDropBox: Boolean;
      //searchResult : TSearchRec;
begin

  // �������� ���� �� ���� ���������� ��� ���� �� ����������� �������� �������
  if (FDateSendList.Items[0] > NOW) and not FSendUnscheduled then Exit;

  try
    // ��������� ���� ������
    DateStart := Now;
    try

      spSelect.ParamByName('inStartDate').Value := FDateSend;
      spSelect.Execute;
      if not ClientDataSet.Active then Exit;

      MovementId := 0;
      isPostedToDropBox := False;
      ClientDataSet.First;
      GaugeCopyFile.MaxValue := ClientDataSet.RecordCount;
      GaugeCopyFile.Progress := 0;
      while not ClientDataSet.Eof do
      begin

        // ���� ����� ������ ����� "�������� �� ��������� ����� � DropBox" �� ������ zc_MovementBoolean_FilesNotUploaded()
        if (MovementId <> 0) and (MovementId <> ClientDataSet.FieldByName('MovementId').AsInteger) and not isPostedToDropBox then
        begin
          spUpdate_PostedToDropBox.ParamByName('inId').Value := MovementId;
          spUpdate_PostedToDropBox.ParamByName('ioisPostedToDropBox').Value := False;
          spUpdate_PostedToDropBox.Execute;
        end;

        // �������� �������� ����� ��������
        if not ForceDirectories(FDropBoxDir + ClientDataSet.FieldByName('FilePath').AsString) then
        begin
          PanelError.Caption:= '!!! ERROR - fCopyFile: �� ������� ����� ��� ���������� ������ ' + FDropBoxDir + ClientDataSet.FieldByName('FilePath').AsString;
          PanelError.Invalidate;
          Exit;
        end;

        // ����������� ��� �����
        FileName := FDropBoxDir + ClientDataSet.FieldByName('FilePath').AsString + '\' +
                    TPath.GetFileNameWithoutExtension(ClientDataSet.FieldByName('FileName').AsString) +
                    '_' + ClientDataSet.FieldByName('ReceiptNumber').AsString + TPath.GetExtension(ClientDataSet.FieldByName('FileName').AsString);

        // ������ ���� ���� ���������
//        if (System.SysUtils.FindFirst(FDropBoxDir + ClientDataSet.FieldByName('FilePath').AsString + '\*_' +
//            ClientDataSet.FieldByName('Id').AsString + '.*', faArchive, searchResult) = 0) then
//        begin
//          repeat
//            //
//            if ((searchResult.Attr and faArchive) = searchResult.Attr) and
//               (searchResult.Name <> TPath.GetFileName(FileName)) then
//            begin
//              DeleteFile(FDropBoxDir + ClientDataSet.FieldByName('FilePath').AsString + '\' + searchResult.Name);
//            end;
//          until System.SysUtils.FindNext(searchResult) <> 0;
//          System.SysUtils.FindClose(searchResult);
//        end;


        // �������� ���� � ����� DropBox
        spGetDocument.ParamByName('inInvoicePdfId').Value :=  ClientDataSet.FieldByName('Id').AsInteger;
        Document.SaveDocument(FileName);

        // ������� ���� ����������
        spInvoicePdf_DateUnloading.ParamByName('inId').Value :=  ClientDataSet.FieldByName('Id').AsInteger;
        spInvoicePdf_DateUnloading.Execute;

        MovementId := ClientDataSet.FieldByName('MovementId').AsInteger;
        isPostedToDropBox := ClientDataSet.FieldByName('isPostedToDropBox').AsBoolean;

        ClientDataSet.Next;
        GaugeCopyFile.Progress := ClientDataSet.RecNo;
      end;
      GaugeCopyFile.Progress := 0;

      // ���� ����� ������ ����� "�������� �� ��������� ����� � DropBox" �� ������ zc_MovementBoolean_FilesNotUploaded()
      if (MovementId <> 0) and not isPostedToDropBox then
      begin
        spUpdate_PostedToDropBox.ParamByName('inId').Value := MovementId;
        spUpdate_PostedToDropBox.ParamByName('ioisPostedToDropBox').Value := False;
        spUpdate_PostedToDropBox.Execute;
      end;

      DateSend := DateStart;
      if FDateSendList.Items[0] < FDateSend then
      begin
        FDateSendList.Items[0] := IncDay(FDateSendList.Items[0]);
        FDateSendList.Sort;
      end;

    finally
      ClientDataSet.Close;
    end;
  except on E: Exception do
    begin
      PanelError.Caption:= '!!! ERROR - fCopyFile: ' + E.Message;
      PanelError.Invalidate;
    end;
  end;


end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ��������� ���
function TMainForm.fBeginAll : Boolean;
begin
    Result := True;
    PanelError.Caption:= '';
    PanelError.Invalidate;
    PanelInfo.Caption:= '������ ����� ���������.';
    PanelInfo.Invalidate;
    Timer.Enabled:= false;
    BtnStart.Enabled:= false;
    BitSendUnscheduled.Enabled:= false;

    try

       // �������� ������� ������� �����
       if FDropBoxDir = '' then
       begin
         PanelError.Caption:= '!!! ERROR - fBeginAll: �� ����������� ������� �����.';
         PanelError.Invalidate;
         Exit;
       end;

       if not DirectoryExists(FDropBoxDir) then
       begin
         PanelError.Caption:= '!!! ERROR - fBeginAll: �� ������� ������� �����.';
         PanelError.Invalidate;
         Exit;
       end;

       if FDateSendList.Count = 0 then
       begin
         PanelError.Caption:= '!!! ERROR - fBeginAll: �� �������� �����������.';
         PanelCopyFile.Invalidate;
         Exit;
       end;

       // ����������� ���� ������
       PanelInfo.Caption:= '����������� ���� ������.';
       PanelInfo.Invalidate;
       try
         fCopyFile;
       except on E: Exception do
         begin
           PanelError.Caption:= '!!! ERROR - fCopyFile: ' + E.Message;
           PanelError.Invalidate;
         end;
       end;

    finally
       PanelInfo.Caption:= '���� ��������.';
       PanelInfo.Invalidate;
       FIsBegin:= false;
       FSendUnscheduled:= false;
       Timer.Enabled:= true;
       BitSendUnscheduled.Enabled:= true;
       BtnStart.Enabled:= FIsBegin = false;
    end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BitSendUnscheduledClick(Sender: TObject);
begin
  Timer.Enabled := False;
  try
    if MessageDlg('����������� ����������� ��������?', mtConfirmation,
      [mbYes, mbCancel], 0) = mrYes then
    begin
      Timer.Interval := 60;
      FSendUnscheduled := True;
    end else Timer.Interval := 1000 * 60;

  finally
    cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',FOnTimer)+')';
    Timer.Enabled := True;
  end;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BtnStartClick(Sender: TObject);
begin
     // ����, ����� ����� �������� �������
     FOnTimer:= NOW;
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
     FOnTimer:= NOW;
     Timer.Interval := 1000 * 60;
     cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',FOnTimer)+')';
     Sleep(500);
     // ��������� ���
     fBeginAll;
  finally

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
