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
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure,
  dxDateRanges, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    Panel2: TPanel;
    btnAll: TButton;
    btnLoadeEchangeRates: TButton;
    spExchangeRates: TZStoredProc;
    Panel3: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView4: TcxGridDBTableView;
    UnitId: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    UnitSerialNumber: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    dsUnit: TDataSource;
    qryUnit: TZQuery;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTClient: TRESTClient;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadeEchangeRatesClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

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
    if Pos('----', AMessage) > 0 then Writeln(F, AMessage)
    else Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.btnAllClick(Sender: TObject);
begin
  Add_Log('-----------------');
  Add_Log('Запуск процессов загрузки.'#13#10);

  btnLoadeEchangeRatesClick(Sender);

end;

procedure TMainForm.btnLoadeEchangeRatesClick(Sender: TObject);
  var jValue : TJSONValue; JSONA: TJSONArray; I : Integer;
begin

  Add_Log('Получение курса доллара.');
  RESTClient.BaseURL := 'https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=11';
  RESTClient.ContentType := 'application/json';

  RESTRequest.ClearBody;
  RESTRequest.Method := TRESTRequestMethod.rmGET;
  RESTRequest.Resource := '';
  // required parameters
  RESTRequest.Params.Clear;

  try
    RESTRequest.Execute;

    if RESTResponse.ContentType = 'application/json' then
    begin
      JSONA := RESTResponse.JSONValue.GetValue<TJSONArray>;
      for I := 0 to JSONA.Count - 1 do
      begin
        jValue := JSONA.Items[I];
        if (jValue.FindValue('ccy').Value = 'USD') and (jValue.FindValue('base_ccy').Value = 'UAH') then
        begin
          spExchangeRates.ParamByName('inOperDate').Value := Date;
          spExchangeRates.ParamByName('inExchange').Value := Ceil(StrToCurr(StringReplace(jValue.FindValue('sale').Value, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])));
          spExchangeRates.ParamByName('inSession').Value := '3';
          spExchangeRates.ExecProc;
          Break;
        end;
      end;
    end else Add_Log('Ошибка загрузки курса: '#13#10 + RESTResponse.Content);

  except on E: Exception do
     Begin
       Add_Log('Ошибка загрузки курса: '#13#10 + E.Message);
       Exit;
     End;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'LoadingDataFarmacy.ini');

  try

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.5');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
      Application.ShowMainForm := False;
      Add_Log(E.Message);
      Timer1.Enabled := true;
      Exit;
    end;
  end;


//  if ZConnection1.Connected then
//  begin
//    qryUnit.Close;
//    try
//      qryUnit.Open;
//    except
//      on E: Exception do
//      begin
//        Add_Log(E.Message);
//        ZConnection1.Disconnect;
//      end;
//    end;
//  end;

  if ZConnection1.Connected then
  begin

    if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
    begin
      Application.ShowMainForm := False;
      btnAll.Enabled := false;
      btnLoadeEchangeRates.Enabled := false;
      btnLoadeEchangeRates.Enabled := false;
      Timer1.Enabled := true;
    end;
  end else
  begin
    Application.ShowMainForm := False;
    Timer1.Enabled := true;
    Exit;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    Timer1.Enabled := False;
    btnAllClick(Sender);
  finally
    Close;
  end;
end;

end.
