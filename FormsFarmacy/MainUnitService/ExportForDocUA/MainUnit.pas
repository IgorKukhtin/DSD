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
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, System.Zip,
  System.JSON;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    dsUnit: TDataSource;
    Panel2: TPanel;
    btnSendSFTP: TButton;
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
    UnitId: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    btnAllUnit: TButton;
    Addr: TcxGridDBColumn;
    Phones: TcxGridDBColumn;
    MedicineId: TcxGridDBColumn;
    Name_ru: TcxGridDBColumn;
    Name_ua: TcxGridDBColumn;
    Marion_Code: TcxGridDBColumn;
    Description: TcxGridDBColumn;
    Schedule: TcxGridDBColumn;
    Head: TcxGridDBColumn;
    Branch_location_lat: TcxGridDBColumn;
    Branch_location_lng: TcxGridDBColumn;
    Reservation_time: TcxGridDBColumn;
    Agent: TcxGridDBColumn;
    UnitCity: TcxGridDBColumn;
    Badm_Code: TcxGridDBColumn;
    Quantity: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendSFTPClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllUnitClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    SavePath: String;

    glFTPHost,
    glFTPPath,
    glFTPUser,
    glFTPPassword: String;

    glFTPPort : Integer;

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

    btnExecuteClick(btnExecute);
    btnExportClick(btnExport);
    btnSendFTPClick(btnSendFTP);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
      // Экспорт аптек
      Application.ProcessMessages;
      btnSendFTPClick(Nil);
      Application.ProcessMessages;

      // Экспорт медикаментов с остатками
      btnExecuteClick(Nil);
      Application.ProcessMessages;
      btnExportClick(Nil);
      Application.ProcessMessages;
      btnSendFTPClick(Nil);
      Application.ProcessMessages;
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
      FileName := qryUnit.FieldByName('ID').AsString;
      if Assigned(Sender) then
        qryReport_Upload.Params.ParamByName('UnitID').AsInteger := qryUnit.FieldByName('ID').AsInteger
      else qryReport_Upload.Params.ParamByName('UnitID').AsInteger := 0;
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

procedure TMainForm.btnExportClick(Sender: TObject);
  var
    jsonReport: TJSONObject;
    jsonTemp: TJSONObject;
    JSONA: TJSONArray;
    SW: TStreamWriter;
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
  Add_Log('Начало выгрузки отчета');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  FileName := SavePath + qryUnit.FieldByName('ID').AsString + '.json';
  jsonReport := TJSONObject.Create;
  SW := TStreamWriter.Create(FileName, False, TEncoding.UTF8);;

  try
    try


      jsonTemp := TJSONObject.Create;
      jsonTemp.AddPair('pharmacy_id', TJSONString.Create(qryUnit.FieldByName('ID').AsString));
      jsonTemp.AddPair('head', TJSONString.Create(qryUnit.FieldByName('Head').AsString));
      jsonTemp.AddPair('name', TJSONString.Create(qryUnit.FieldByName('Name').AsString));
      jsonTemp.AddPair('addr', TJSONString.Create(qryUnit.FieldByName('Addr').AsString));
      jsonTemp.AddPair('agent', TJSONString.Create(qryUnit.FieldByName('Agent').AsString));
      jsonTemp.AddPair('city', TJSONString.Create(qryUnit.FieldByName('City').AsString));
      jsonTemp.AddPair('branch_location_lat', TJSONNumber.Create(qryUnit.FieldByName('Branch_location_lat').AsString));
      jsonTemp.AddPair('branch_location_lng', TJSONNumber.Create(qryUnit.FieldByName('Branch_location_lng').AsString));
      jsonTemp.AddPair('phone', TJSONString.Create(qryUnit.FieldByName('Phones').AsString));
      jsonTemp.AddPair('schedule', TJSONString.Create(qryUnit.FieldByName('Schedule').AsString));
      jsonTemp.AddPair('reservation_time', TJSONNumber.Create(qryUnit.FieldByName('Reservation_time').AsInteger));
      jsonReport.AddPair('meta', jsonTemp);

      JSONA := TJSONArray.Create;
      qryReport_Upload.First;
      while not qryReport_Upload.Eof do
      begin
        jsonTemp := TJSONObject.Create;
        jsonTemp.AddPair('medicine_id', TJSONString.Create(qryReport_Upload.FieldByName('ID').AsString));
        jsonTemp.AddPair('name_ru', TJSONString.Create(qryReport_Upload.FieldByName('Name_ru').AsString));
        jsonTemp.AddPair('name_ua', TJSONString.Create(qryReport_Upload.FieldByName('Name_ua').AsString));
        jsonTemp.AddPair('marion_code', TJSONString.Create(qryReport_Upload.FieldByName('Marion_Code').AsString));
        jsonTemp.AddPair('badm_code', TJSONString.Create(qryReport_Upload.FieldByName('Badm_Code').AsString));
        jsonTemp.AddPair('description', TJSONString.Create(qryReport_Upload.FieldByName('Description').AsString));
        jsonTemp.AddPair('price', TJSONNumber.Create(qryReport_Upload.FieldByName('Price').AsCurrency));
        jsonTemp.AddPair('quantity', TJSONNumber.Create(qryReport_Upload.FieldByName('Quantity').AsCurrency));
        JSONA.AddElement(jsonTemp);
        qryReport_Upload.Next;
      end;
      jsonReport.AddPair('products', JSONA);

       //сохраняем объект в файл
      SW.Write(jsonReport.ToString);
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
      end;
    end;
  finally
    jsonReport.Destroy;
    SW.Free;
  end;
end;

procedure TMainForm.btnSendSFTPClick(Sender: TObject);
  VAR ZipFile: TZipFile;
begin

  if not FileExists(FileName) then Exit;

  Add_Log('Начало отправки прайса: ' + FileName);

//  try
//    ZipFile := TZipFile.Create;
//
//    try
//      ZipFile.Open(SavePath + FileName + '.zip', zmWrite);
//      ZipFile.Add(SavePath + FileName + '.csv');
//      ZipFile.Close;
//
//      DeleteFile(SavePath + FileName + '.csv');
//    finally
//      ZipFile.Free;
//    end;
//  except
//    on E: Exception do
//    begin
//      Add_Log(E.Message);
//      exit;
//    end;
//  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForDocUA.ini');

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

    glFTPHost := Ini.ReadString('FTP','Host','95.217.164.231');
    Ini.WriteString('FTP','Host',glFTPHost);

    glFTPPort := Ini.ReadInteger('FTP','Port',22);
    Ini.WriteInteger('FTP','Port',glFTPPort);

    glFTPPath := Ini.ReadString('FTP','Path','');
    Ini.WriteString('FTP','Path',glFTPPath);

    glFTPUser := Ini.ReadString('FTP','User','ne_boley');
    Ini.WriteString('FTP','User',glFTPUser);

    glFTPPassword := Ini.ReadString('FTP','Password','gCrb4bC7mfeKYo3');
    Ini.WriteString('FTP','Password',glFTPPassword);

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
      Timer1.Enabled := true;
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
        Timer1.Enabled := true;
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
      btnSendFTP.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if qryUnit.Active then btnAllClick(nil);
  finally
    Close;
  end;
end;


end.
