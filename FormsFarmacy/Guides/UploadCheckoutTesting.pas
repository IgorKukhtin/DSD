unit UploadCheckoutTesting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, Registry, StrUtils,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, dsdDB, DB,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, cxClasses, cxPropertiesStore,  dxSkinsCore,
  dxSkinsDefaultPainters, Vcl.ComCtrls, cxProgressBar, ZConnection;

type

  TUploadThread = class(TThread)
  private
    { Private declarations }
    FFileName: string;
    FFilePath: string;
    FError: string;
  protected
    procedure Execute; override;
  end;

  TUploadCheckoutTestingForm = class(TForm)
    edMsgDescription: TEdit;
    cxProgressBar1: TcxProgressBar;
    Timer: TTimer;
    labInterval: TcxLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FInterval : Integer;
    FStep : Integer;
    FUploadThread : TUploadThread;
  public
    { Public declarations }
    procedure LoadFileFromFile(FileName, FilePath: string);
  end;

implementation

uses UtilConst, CommonData, ZStoredProcedure, FormStorage, UnilWin;

{$R *.dfm}

  {TUploadThread}

procedure TUploadThread.Execute;
  var Stream: TStream; ZConnection: TZConnection;

  function GetConnection: TZConnection;
  var
    f: System.text;
    ConnectionString: string;
    List: TStringList;
  begin
    AssignFile(F, ConnectionPath);
    Reset(f);
    readln(f, ConnectionString);
    readln(f, ConnectionString);
    CloseFile(f);
    // Вырезаем строку подключения
    ConnectionString := Copy(ConnectionString, Pos('=', ConnectionString) + 3, maxint);
    ConnectionString := Copy(ConnectionString, 1, length(ConnectionString) - 2);
    ConnectionString := ReplaceStr(ConnectionString, ' ', #13#10);
    List := TStringList.Create;
    result := TZConnection.Create(nil);
    try
      List.Text := ConnectionString;
      result.HostName := List.Values['host'];
      result.Port := StrToInt(List.Values['port']);
      result.User := List.Values['user'];
      result.Password := List.Values['password'];
      result.Database := List.Values['dbname'];
      result.Protocol := 'postgresql-9';
      result.Properties.Add('timeout=12');
    finally
      List.Free
    end;
  end;

begin
  FError := '';
  ZConnection := GetConnection;
  try
    try
      ZConnection.Connected := true;

      Stream := TStringStream.Create(ConvertConvert(FileReadString(FFilePath)));
      with TZStoredProc.Create(nil), UnilWin.GetFileVersion(FFilePath) do begin
        try
          Connection := ZConnection;
          StoredProcName := 'gpInsertUpdate_Object_Program';
          Params.Clear;
          Params.CreateParam(ftString, 'inProgramName', ptInput);
          Params.CreateParam(ftFloat, 'inMajorVersion', ptInput);
          Params.CreateParam(ftFloat, 'inMinorVersion', ptInput);
          Params.CreateParam(ftBlob, 'inProgramData', ptInput);
          Params.CreateParam(ftString, 'inSession', ptInput);
          ParamByName('inProgramName').AsString := ExtractFileName(FFileName) + GetBinaryPlatfotmSuffics(FFilePath, '');
          ParamByName('inMajorVersion').AsFloat := VerHigh;
          ParamByName('inMinorVersion').AsFloat := VerLow;
          ParamByName('inProgramData').LoadFromStream(Stream, ftMemo);
          ParamByName('inSession').AsString := gc_User.Session;
          ExecProc;
        finally
          Free;
          Stream.Free;
        end;
      end;
    finally
      ZConnection.Free;
    end;
  except
     on E: Exception do FError := E.Message;
  end;
end;

  {TUploadCheckoutTestingForm}

procedure TUploadCheckoutTestingForm.LoadFileFromFile(FileName, FilePath: string);
begin
  FUploadThread := TUploadThread.Create(True);
  try
    FUploadThread.FFileName := FileName;
    FUploadThread.FFilePath := FilePath;
    FUploadThread.Start;
  finally
  end;
end;

procedure TUploadCheckoutTestingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FUploadThread) then Action := caNone;
end;

procedure TUploadCheckoutTestingForm.FormCreate(Sender: TObject);
begin
  FInterval := 0;
  FStep := 0;
  FUploadThread := Nil;
end;

procedure TUploadCheckoutTestingForm.FormShow(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TUploadCheckoutTestingForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  try
    FInterval := FInterval + Timer.Interval;
    if Assigned(FUploadThread) and FUploadThread.Finished and (FStep = 2) then
    begin
      FreeAndNil(FUploadThread);
      ModalResult := mrCancel;
    end else if Assigned(FUploadThread) and FUploadThread.Finished and (FStep = 1) then
    begin
     if FUploadThread.FError <> '' then ShowMessage(FUploadThread.FError);
     FreeAndNil(FUploadThread);
     FStep := 2;
     edMsgDescription.Text := 'Отправка файла сервиса';
     Application.ProcessMessages;
     LoadFileFromFile('FarmacyCashServise_Test.exe', ExtractFileDir(ParamStr(0)) + '\FarmacyCashServise.exe');
    end else if not Assigned(FUploadThread) and (FStep = 0) then
    begin
      if MessageDlg('Отправить тестовые файлы кассы и сервиса на сервер?',mtConfirmation,mbYesNo,0) = mrYes then
      begin
        edMsgDescription.Text := 'Отправка файла кассы';
        FStep := 1;
        LoadFileFromFile('FarmacyCash_Test.exe', ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe');
      end else ModalResult := mrCancel;
    end;
    labInterval.Caption := IntToStr(FInterval div 60000) + ':' + IfThen(Length(IntToStr(FInterval mod 60000 div 1000)) = 1, '0', '') +
      IntToStr(FInterval mod 60000 div 1000);
  finally
    Timer.Enabled := True;
  end;
end;

initialization
  RegisterClass(TUploadCheckoutTestingForm);

end.
