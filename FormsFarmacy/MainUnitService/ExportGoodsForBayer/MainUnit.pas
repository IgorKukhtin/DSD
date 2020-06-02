unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls, System.Zip,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  IdHTTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxExport, uBayer;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    Panel2: TPanel;
    btnSendHTTPS: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    grtvUnit: TcxGridDBTableView;
    grReportUnitLevel1: TcxGridLevel;
    grReportUnit: TcxGrid;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    goodsID: TcxGridDBColumn;
    goodsDrugName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    UnitName: TcxGridDBColumn;
    Token: TcxGridDBColumn;
    Barcode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    CodeRazom: TcxGridDBColumn;
    sdGoods: TDataSource;
    goodsDrugBarcode: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnSendHTTPSClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExecuteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    FBayerAPI : TBayerAPI;
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);

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

procedure TMainForm.btnAllClick(Sender: TObject);
begin
  Add_Log('Начало отправки остатков ао всем подразделениям.');

  try
     btnExecuteClick(Sender);
     qryReport_Upload.First;
     while not qryReport_Upload.Eof do
     begin
       btnSendHTTPSClick(Sender);
       qryReport_Upload.Next;
       Application.ProcessMessages;
     end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
begin

  qryReport_Upload.Close;
  Add_Log('Начало формирования отчета.');

  qryReport_Upload.DisableControls;
  try
    try
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

procedure TMainForm.btnSendHTTPSClick(Sender: TObject);
  VAR ZipFile: TZipFile;
begin

  if qryReport_Upload.IsEmpty then Exit;

  Add_Log('Начало отправки: ' + qryReport_Upload.FieldByName('UnitName').AsString);

  if not FBayerAPI.LoadDrugs(qryReport_Upload.FieldByName('Token').AsString) then
  begin
    Add_Log(FBayerAPI.ErrorsText);
    Exit;
  end;

  Application.ProcessMessages;

  if FBayerAPI.DrugsCDS.Locate('DrugBarcode', qryReport_Upload.FieldByName('Barcode').AsString, []) then
  begin
    if not FBayerAPI.SendRemnants(qryReport_Upload.FieldByName('Token').AsString,
                                  FBayerAPI.DrugsCDS.FieldByName('ID').AsInteger,
                                  qryReport_Upload.FieldByName('CodeRazom').AsInteger,
                                  qryReport_Upload.FieldByName('Amount').AsInteger) then
    begin
      Add_Log(FBayerAPI.ErrorsText);
      Exit;
    end;

  end else Add_Log('Не найден товар: ' + qryReport_Upload.FieldByName('Barcode').AsString + ' - ' + qryReport_Upload.FieldByName('GoodsName').AsString);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportGoodsForBayer.ini');

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
      Add_Log(E.Message);
      Close;
      Exit;
    end;
  end;

  if ZConnection1.Connected then
  begin

    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnAll.Enabled := false;
      btnExecute.Enabled := false;
      btnSendHTTPS.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;

  FBayerAPI := TBayerAPI.Create;
  sdGoods.DataSet :=  FBayerAPI.DrugsCDS;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FBayerAPI.Free;
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
