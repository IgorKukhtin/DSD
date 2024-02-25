unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants,
  System.Classes, System.IOUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls,
  Vcl.ActnList,
  dsdDB, dsdAction, dsdInternetAction, System.Actions, FormStorage, UnilWin, IniFiles;

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
    spInsertUpdate_Invoice: TdsdStoredProc;
    PanelInfo: TPanel;
    spInsertUpdate_InvoicePdf: TdsdStoredProc;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
  private

    FUserName: String;
    FUserPassword: String;

    FDropBoxDir: String;

    FIsBegin: Boolean;// запущена обработка
    FOnTimer: TDateTime;// время когда сработал таймер

    function fBeginAll  : Boolean; // обработка все
    function fBeginMail : Boolean; // обработка всей почты
  public
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
begin

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + TPath.GetFileNameWithoutExtension(Application.ExeName) + '.ini');

  try

    FUserName := Ini.ReadString('Connect', 'UserName', 'Админ');
    Ini.WriteString('Connect', 'User', FUserName);

    FUserPassword := Ini.ReadString('Connect', 'UserPassword', 'Админ');
    Ini.WriteString('Connect', 'Password', FUserPassword);

    FDropBoxDir := Ini.ReadString('DropBox', 'DropBoxDir', '');
    Ini.WriteString('DropBox', 'DropBoxDir', FDropBoxDir);

  finally
    Ini.free;
  end;

  // ЗАХАРДКОДИЛ - Важный параметр - Определяет "Загрузка Счетов"
  Self.Caption:= Self.Caption + ' - Только Счета';

  //создает сессию и коннект
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, FUserName, FUserPassword, gc_User);
  // запущена обработка
  FIsBegin:= false;
  //
  GaugeCopyFile.Progress:=0;
  //
  AddToLog('---- Start');
  // включаем таймер
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
// обработка всей почты
function TMainForm.fBeginMail : Boolean;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка все
function TMainForm.fBeginAll : Boolean;
var isErr : Boolean;
begin
    Result := True;
    PanelError.Caption:= '';
    PanelError.Invalidate;
    PanelInfo.Caption:= 'Начало цикла обработки.';
    PanelInfo.Invalidate;
    isErr:= False;
    Timer.Enabled:= false;
    BtnStart.Enabled:= false;

    try

       // Проверка наличия целевой папки
       if FDropBoxDir = '' then
       begin
         isErr:= True;
         PanelCopyFile.Caption:= '!!! ERROR - fBeginAll: Не установлена целевая папка.';
         PanelCopyFile.Invalidate;
         Exit;
       end;

       if not DirectoryExists(FDropBoxDir) then
       begin
         isErr:= True;
         PanelCopyFile.Caption:= '!!! ERROR - fBeginAll: Не найдена целевая папка.';
         PanelCopyFile.Invalidate;
         Exit;
       end;



       // обработка всей почты
       PanelInfo.Caption:= 'Обработка всей почты.';
       PanelInfo.Invalidate;
       try
         fBeginMail;
       except on E: Exception do
         begin
           isErr:= True;
           PanelCopyFile.Caption:= '!!! ERROR - fBeginMail: ' + E.Message;
           PanelCopyFile.Invalidate;
         end;
       end;

    finally
       PanelInfo.Caption:= 'Цикл завершен.';
       PanelInfo.Invalidate;
       //
       if isErr = false
       then
       begin
           PanelCopyFile.Caption:= 'End !!!ERROR!!! - fBeginMail ... and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',now + Timer.Interval / 1000 / 60 /  24 / 60 );
           PanelCopyFile.Invalidate;
       end;
       //
       FIsBegin:= false;
       Timer.Enabled:= true;
       BtnStart.Enabled:= FIsBegin = false;
    end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BtnStartClick(Sender: TObject);
begin
     // типа, время когда сработал таймера
     FOnTimer:= NOW;
     // обработка все
     fBeginAll;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.TimerTimer(Sender: TObject);
begin
  try
     // время когда сработал таймера
     FOnTimer:= NOW;
     Timer.Interval := 1000 * 60;
     cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',FOnTimer)+')';
     Sleep(500);
     // обработка все
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
