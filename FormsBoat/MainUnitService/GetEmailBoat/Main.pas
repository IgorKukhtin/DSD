unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls, Vcl.ActnList,
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
    PanelHost: TPanel;
    GaugeHost: TGauge;
    PanelMailFrom: TPanel;
    PanelParts: TPanel;
    GaugeMailFrom: TGauge;
    GaugeParts: TGauge;
    GaugeLoadFile: TGauge;
    PanelLoadFile: TPanel;
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
    vbEmailKindDesc :String;// Важный параметр - Определяет "Загрузка Прайса" ИЛИ "Загрузка ММО"

    vbIsBegin :Boolean;// запущена обработка
    vbOnTimer :TDateTime;// время когда сработал таймер

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
  cUserName, cUserPassword: String;
begin

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BookingsForLiki24.ini');

  try

    cUserName := Ini.ReadString('Connect', 'UserName', 'Админ');
    Ini.WriteString('Connect', 'User', cUserName);

    cUserPassword := Ini.ReadString('Connect', 'UserPassword', 'Админ');
    Ini.WriteString('Connect', 'Password', cUserPassword);

  finally
    Ini.free;
  end;

  // ЗАХАРДКОДИЛ - Важный параметр - Определяет "Загрузка Счетов"
  vbEmailKindDesc:= 'zc_Enum_EmailKind_Mail_InvoiceKredit';
  Self.Caption:= Self.Caption + ' - Только Счета';

  //создает сессию и коннект
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, cUserName, cUserPassword, gc_User);
  // запущена обработка
  vbIsBegin:= false;
  //
  GaugeHost.Progress:=0;
  GaugeMailFrom.Progress:=0;
  GaugeParts.Progress:=0;
  GaugeLoadFile.Progress:=0;
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
//----------------------------------------------------------------------------------------------------------------------------------------------------
// что б отловить ошибки - запишим в лог строчку
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
// обработка всей почты
function TMainForm.fBeginMail : Boolean;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка все
function TMainForm.fBeginAll : Boolean;
var isErr, isErr_exit : Boolean;
begin
     Result := True;
     PanelError.Caption:= '';
     PanelError.Invalidate;
     PanelInfo.Caption:= 'Начало цикла обработки.';
     PanelInfo.Invalidate;
     isErr:= false;
     isErr_exit:= false;
     Timer.Enabled:= false;
     BtnStart.Enabled:= false;

     try

       // обработка всей почты
       PanelInfo.Caption:= 'Обработка всей почты.';
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

     finally
       Timer.Enabled:= true;
       BtnStart.Enabled:= vbIsBegin = false;
       PanelInfo.Caption:= 'Цикл завершен.';
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
     // типа, время когда сработал таймера
     vbOnTimer:= NOW;
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
     vbOnTimer:= NOW;
     Timer.Interval := 10000;
     cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
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
