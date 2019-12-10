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
  IdHTTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    dsUnit: TDataSource;
    Panel2: TPanel;
    btnSendHTTPS: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    grtvUnit: TcxGridDBTableView;
    grReportUnitLevel1: TcxGridLevel;
    grReportUnit: TcxGrid;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    UnitCode: TcxGridDBColumn;
    Head: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    btnAllUnit: TButton;
    Address: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Quant: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendHTTPSClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllUnitClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }

    UnitFile: String;
    SavePath: String;
    Subject: String;

    FURL : String;
    FAccessKey : String;
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);

    procedure AllUnit;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function GetThousandSeparator : string;
begin
  if FormatSettings.ThousandSeparator = #160 then Result := ' '
  else Result := FormatSettings.ThousandSeparator;
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

procedure TMainForm.AllUnit;
begin
  try

    Add_Log('');
    Add_Log('-------------------');
    Add_Log('Аптека : ' + qryUnit.FieldByName('ID').AsString);

    btnExecuteClick(Nil);
    btnExportClick(Nil);
    btnSendHTTPSClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
    qryUnit.First;
    while not qryUnit.Eof do
    begin

      AllUnit;

      qryUnit.Next;
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;

  qryUnit.Close;
  qryUnit.Open;
end;

procedure TMainForm.btnAllUnitClick(Sender: TObject);
begin
  AllUnit;
  qryUnit.Close;
  qryUnit.Open;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
begin

  if not qryUnit.Active then Exit;
  qryReport_Upload.Close;

  qryReport_Upload.DisableControls;
  try
    try
      Subject := 'Данные по подразделению: ' + qryUnit.FieldByName('Address').AsString;
      qryReport_Upload.Params.ParamByName('UnitID').AsInteger := qryUnit.FieldByName('ID').AsInteger;
      qryReport_Upload.Open;
    except
      on E:Exception do
      begin
        Add_Log(E.Message);
        Exit;
      end;
    end;

  finally
    qryReport_Upload.EnableControls;
  end;
end;

function StrToJSON(AStr : string) : string;
begin
  Result := StringReplace(AStr, '\', '\\', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll, rfIgnoreCase]);
end;

function CurrToJSON(ACurr : currency) : string;
begin
  Result := CurrToStr(ACurr);
  Result := StringReplace(Result, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TMainForm.btnExportClick(Sender: TObject);
  var sl : TStringList;
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
  Add_Log('Начало выгрузки отчета');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  // Формирование отчет
  sl := TStringList.Create;
  try
    sl.Add('{');
    sl.Add('  "Meta": {');
    sl.Add('    "id": "' + qryUnit.FieldByName('UnitCode').AsString + '",');
    sl.Add('    "head": "' + StrToJSON(qryUnit.FieldByName('Head').AsString) + '",');
    sl.Add('    "name": "' + StrToJSON(qryUnit.FieldByName('UnitName').AsString) + '",');
    sl.Add('    "addr": "' + StrToJSON(qryUnit.FieldByName('Address').AsString) + '",');
    sl.Add('    "code": "' + qryUnit.FieldByName('Code').AsString + '"');
    sl.Add('  },');
    sl.Add('  "Data": [');
    qryReport_Upload.First;
    while not qryReport_Upload.Eof do
    begin
      sl.Add('    {');
      sl.Add('      "id": "' + qryReport_Upload.FieldByName('GoodsCode').AsString + '",');
      sl.Add('      "name": "' + StrToJSON(qryReport_Upload.FieldByName('GoodsName').AsString) + '",');
      sl.Add('      "quant": ' + CurrToJSON(qryReport_Upload.FieldByName('Quant').AsCurrency) + ',');
      sl.Add('      "price": ' + CurrToJSON(qryReport_Upload.FieldByName('Price').AsCurrency) + '');
      qryReport_Upload.Next;
      if qryReport_Upload.Eof then sl.Add('    }') else sl.Add('    },');
    end;
    sl.Add('  ]');
    sl.Add('}');

    sl.SaveToFile(UnitFile, TEncoding.UTF8)
  finally
    sl.Free;
  end;
end;

procedure TMainForm.btnSendHTTPSClick(Sender: TObject);
  var sResponse : string;
begin

  if not FileExists(UnitFile) then Exit;

  Add_Log('Начало отправки прайса: ' + UnitFile);

  begin
    try

        IdHTTP.Request.ContentType := 'application/json';
        IdHTTP.Request.CustomHeaders.Clear;
        IdHTTP.Request.CustomHeaders.FoldLines := False;
        IdHTTP.Request.CustomHeaders.Values['X-Morion-Skynet-Tag'] := 'data.geoapt.ua';
        IdHTTP.Request.CustomHeaders.Values['X-Morion-Skynet-Key'] := FAccessKey;

        try
           sResponse := IdHTTP.Post(FURL, UnitFile);
        except ON E: Exception DO
          Begin
            Add_Log(E.Message);
            exit;
          End;
        end;

        if IdHTTP.ResponseCode <> 200 then
        begin
            Add_Log(IntToStr(IdHTTP.ResponseCode) + ' ' + IdHTTP.ResponseText + '. ' + sResponse);
        end;

      DeleteFile(UnitFile);
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
      end;
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForGeoApteka.ini');

  try
    SavePath := Trim(Ini.ReadString('Options', 'Path', ExtractFilePath(Application.ExeName)));
    if SavePath[Length(SavePath)] <> '\' then SavePath := SavePath + '\';
    Ini.WriteString('Options', 'Path', SavePath);

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.5');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    UnitFile := SavePath + 'data.json';

    FURL := Ini.ReadString('HTTP','URL', 'https://skynet.morion.ua/data/add');
    Ini.WriteString('HTTP','URL',FURL);

    FAccessKey := Ini.ReadString('HTTP','AccessKey','90de624965f010447e663517922a42bed1446a99');
    Ini.WriteString('HTTP','AccessKey',FAccessKey);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Close;
      Exit;
    end;
  end;

  if ZConnection1.Connected then
  begin
    qryUnit.Close;
    try
      qryUnit.Open;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        Close;
        Exit;
      end;
    end;

    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnAll.Enabled := false;
      btnAllUnit.Enabled := false;
      btnExecute.Enabled := false;
      btnExport.Enabled := false;
      btnSendHTTPS.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    btnAllClick(nil);
  finally
    Close;
  end;
end;


end.
