unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, System.JSON,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges,
  dxBarBuiltInMenu, cxGridChartView, cxGridDBChartView, JPEG, ZStoredProcedure,
  Datasnap.DBClient, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, UtilConvert;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    UkraineAlarmDS: TDataSource;
    Panel2: TPanel;
    btnProcesAlerts: TButton;
    Panel1: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    regionId: TcxGridDBColumn;
    endDate: TcxGridDBColumn;
    spProcesUkraineAlarm: TZStoredProc;
    UkraineAlarmCDS: TClientDataSet;
    btnGetAlerts: TButton;
    tiServise: TTrayIcon;
    pmServise: TPopupMenu;
    pmClose: TMenuItem;
    btnGetHistory: TButton;
    UkraineAlarmCDSregionId: TIntegerField;
    UkraineAlarmCDSstartDate: TDateTimeField;
    UkraineAlarmCDSendDate: TDateTimeField;
    UkraineAlarmCDSalertType: TStringField;
    alertType: TcxGridDBColumn;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FRESTClient: TRESTClient;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnProcesAlertsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmCloseClick(Sender: TObject);
    procedure btnGetHistoryClick(Sender: TObject);
    procedure btnGetAlertsClick(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    Token : String;

    FCount : Integer;
    FListAlerts : String;
    FTempListAlerts : String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure GetAlerts(AregionId: Integer);
    procedure GetHistory(AregionId: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  regionIdArr : Array[0..6, 0..1] of string =
      (('9', 'Дніпропетровська область'),
       ('44', 'Дніпровський район'),
       ('47', 'Нікопольський район'),
       ('42', 'Кам’янський район'),
       ('332', 'м. Дніпро та Дніпровська територіальна громада'),
       ('351', 'м. Нікополь та Нікопольська територіальна громада'),
       ('300', 'м. Кам’янське та Кам’янська територіальна громада'));

function GetRegion(AName : String) : Integer;
  var I : Integer;
begin
  Result := 9;
  for I := 0 to High(regionIdArr) do
    if regionIdArr[I][1] = AName then
    begin
      TryStrToInt(regionIdArr[I][0], Result);
      Break;
    end;
end;

procedure TMainForm.Add_Log(AMessage: String);
var
  F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.GetAlerts(AregionId: Integer);
var
  jValue : TJSONValue;
  JSONA, JSONAA: TJSONArray;
  i, j, regionId : Integer;
  TimeZone: TTimeZoneInformation;
begin

  FRESTClient.BaseURL := 'https://api.ukrainealarm.com/api/v3';
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'alerts/' + IntToStr(AregionId);
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('Authorization', Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                   [TRESTRequestParameterOption.poDoNotEncode]);
  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    GetTimeZoneInformation(TimeZone);
    try
      JSONA := FRESTResponse.JSONValue.GetValue<TJSONArray>;
      for I := 0 to JSONA.Count - 1 do
      begin
        jValue := JSONA.Items[I];
        JSONAA := jValue.FindValue('activeAlerts').GetValue<TJSONArray>;
        for J := 0 to JSONAA.Count - 1 do
        begin
          jValue := JSONAA.Items[J];
          if TryStrToInt(jValue.FindValue('regionId').Value, regionId)  and
             not UkraineAlarmCDS.Locate('regionId;startDate', VarArrayOf([regionId, IncMinute(gfXSStrToDate(jValue.FindValue('lastUpdate').Value), 180)]), []) then
          begin
            FTempListAlerts := FTempListAlerts + jValue.FindValue('lastUpdate').Value;
            UkraineAlarmCDS.Append;
            UkraineAlarmCDS.FieldByName('regionId').AsInteger := regionId;
            UkraineAlarmCDS.FieldByName('startDate').AsDateTime := IncMinute(gfXSStrToDate(jValue.FindValue('lastUpdate').Value), 180);
            UkraineAlarmCDS.FieldByName('endDate').AsVariant := Null;
            UkraineAlarmCDS.FieldByName('alertType').AsString := jValue.FindValue('type').Value;
            UkraineAlarmCDS.Post;
          end;
        end;
      end;
    except
    end
  end;
end;

procedure TMainForm.btnGetAlertsClick(Sender: TObject);
var
  jValue : TJSONValue;
  JSONA: TJSONArray;
  i, regionId : Integer;
  TimeZone: TTimeZoneInformation;
begin

  UkraineAlarmCDS.Close;
  UkraineAlarmCDS.CreateDataSet;

  FListAlerts := '';
  FTempListAlerts := '';


  GetAlerts(332);
  GetAlerts(351);
  GetAlerts(300);

  if (FListAlerts <> FTempListAlerts) and (FListAlerts <> '') then FCount := 100;
  FListAlerts := FTempListAlerts;

end;

procedure TMainForm.GetHistory(AregionId: Integer);
var
  jValue : TJSONValue;
  JSONA, JSONAA: TJSONArray;
  i, j, regionId : Integer;
begin

  FRESTClient.BaseURL := 'https://api.ukrainealarm.com/api/v3';
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'alerts/regionHistory';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('regionId', IntToStr(AregionId), TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('Authorization', Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                   [TRESTRequestParameterOption.poDoNotEncode]);
  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    try
      JSONA := FRESTResponse.JSONValue.GetValue<TJSONArray>;
      for I := 0 to JSONA.Count - 1 do
      begin
        jValue := JSONA.Items[I];
        JSONAA := jValue.FindValue('alarms').GetValue<TJSONArray>;
        for J := 0 to JSONAA.Count - 1 do
        begin
          jValue := JSONAA.Items[J];
          regionId := GetRegion(jValue.FindValue('regionName').Value);
          if not UkraineAlarmCDS.Locate('regionId;startDate', VarArrayOf([regionId, gfXSStrToDate(jValue.FindValue('startDate').Value)]), []) then
          begin
            UkraineAlarmCDS.Last;
            UkraineAlarmCDS.Append;
            UkraineAlarmCDS.FieldByName('regionId').AsInteger := regionId;
            UkraineAlarmCDS.FieldByName('startDate').AsDateTime := gfXSStrToDate(jValue.FindValue('startDate').Value);
            if jValue.FindValue('isContinue').ClassNameIs('TJSONFalse') then
               UkraineAlarmCDS.FieldByName('endDate').AsDateTime := gfXSStrToDate(jValue.FindValue('endDate').Value)
            else UkraineAlarmCDS.FieldByName('endDate').AsVariant := Null;
            UkraineAlarmCDS.FieldByName('alertType').AsString := jValue.FindValue('alertType').Value;
            UkraineAlarmCDS.Post;
          end;
        end;
      end;
    except
    end
  end;
end;


procedure TMainForm.btnGetHistoryClick(Sender: TObject);
begin
  UkraineAlarmCDS.Close;
  UkraineAlarmCDS.CreateDataSet;

  GetHistory(332);
  GetHistory(351);
  GetHistory(300);
end;

procedure TMainForm.btnProcesAlertsClick(Sender: TObject);
var
  Urgently : boolean; AGraphic: TGraphic; imJPEG : TJPEGImage;
begin
  if not UkraineAlarmCDS.Active then Exit;
  if UkraineAlarmCDS.IsEmpty then Exit;

  try
    ZConnection1.Connect;

    UkraineAlarmCDS.First;
    Add_Log('Начало выгрузки списка тревог: ' + IntToStr(FCount));
    while not UkraineAlarmCDS.EOF do
    begin
      try

        spProcesUkraineAlarm.ParamByName('inregionId').AsInteger :=  UkraineAlarmCDS.FieldByName('regionId').AsInteger;
        spProcesUkraineAlarm.ParamByName('instartDate').AsDateTime := UkraineAlarmCDS.FieldByName('startDate').AsDateTime;
        spProcesUkraineAlarm.ParamByName('inendDate').Value := UkraineAlarmCDS.FieldByName('endDate').AsVariant;
        spProcesUkraineAlarm.ParamByName('inalertType').AsString := UkraineAlarmCDS.FieldByName('alertType').AsString;
        spProcesUkraineAlarm.ExecProc;

      except
        on E:Exception do
        begin
          Add_Log(E.Message);
        end;
      end;

      UkraineAlarmCDS.Delete;
      UkraineAlarmCDS.First;
    end;

    ZConnection1.Disconnect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Timer1.Enabled := true;
      Exit;
    end;
  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ProcesUkraineAlarm.ini');

  try

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.12');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    Token := Ini.ReadString('UkraineAlarm', 'Token', '');
    Ini.WriteString('UkraineAlarm', 'Token', Token);

  finally
    Ini.free;
  end;

  FCount := 0;
  FListAlerts := '';
  FTempListAlerts := '';

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
    ZConnection1.Disconnect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
    end;
  end;


  if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0))) then
  begin
    Application.ShowMainForm:=False;
    Application.MainFormOnTaskBar:=False;
    btnGetAlerts.Enabled := false;
    btnProcesAlerts.Enabled := false;
    btnGetHistory.Enabled := false;
    Timer1.Enabled := true;
  end;
end;

procedure TMainForm.pmCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;

    if True then

    if FCount < 20 then
    begin
      btnGetAlertsClick(Sender);
      btnProcesAlertsClick(Sender);
      Inc(FCount);
    end;

    if FCount >= 20 then
    begin
      btnGetHistoryClick(Sender);
      btnProcesAlertsClick(Sender);
      FCount := 0;
    end;


  finally
    timer1.Enabled := True;
  end;
end;

end.
