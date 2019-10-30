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
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    dsUnit: TDataSource;
    Panel2: TPanel;
    btnSendFTP: TButton;
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
    JuridicalName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    btnAllUnit: TButton;
    Address: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    btnGoods: TButton;
    btnJuridical: TButton;
    IdFTP1: TIdFTP;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendFTPClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnGoodsClick(Sender: TObject);
    procedure btnJuridicalClick(Sender: TObject);
    procedure btnAllUnitClick(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    SavePath: String;
    TypeData: Integer;

    glFTPHost,
    glFTPPath,
    glFTPUser,
    glFTPPassword: String;
    glFTPPort : Integer;

  public
    { Public declarations }
    procedure OpenAndFormatSQL;
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


procedure TMainForm.OpenAndFormatSQL;
  var I, W : integer;
begin
  qryReport_Upload.Close;
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

    if qryReport_Upload.IsEmpty then
    begin
      qryReport_Upload.Close;
      Exit;
    end;

    grtvUnit.ClearItems;

    for I := 0 to qryReport_Upload.FieldCount - 1 do with grtvUnit.CreateColumn do
    begin
      HeaderAlignmentHorz := TAlignment.taCenter;
      Options.Editing := False;
      DataBinding.FieldName := qryReport_Upload.Fields.Fields[I].FieldName;
      if qryReport_Upload.Fields.Fields[I].DataType in [ftString, ftWideString] then
      begin
        W := 10;
        qryReport_Upload.First;
        while not qryReport_Upload.Eof do
        begin
          W := Max(W, LengTh(qryReport_Upload.Fields.Fields[I].AsString));
          if W > 70 then Break;
          qryReport_Upload.Next;
        end;
        qryReport_Upload.First;
        Width := 6 * Min(W, 70) + 2;
      end;
    end;
  finally
    qryReport_Upload.EnableControls;
  end;
end;

procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
    qryUnit.First;
    while not qryUnit.Eof do
    begin


      Add_Log('');
      Add_Log('-------------------');
      Add_Log('Аптека : ' + qryUnit.FieldByName('ID').AsString);

      btnExecuteClick(Nil);
      btnExportClick(Nil);
      btnSendFTPClick(Nil);

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
  if not qryUnit.Active then Exit;

  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Object_Unit_ExportPriceForHelsi (''3'')';
  OpenAndFormatSQL;

  if qryReport_Upload.Active then TypeData := 2;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
begin
  if not qryUnit.Active then Exit;
  if qryUnit.IsEmpty then Exit;

  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_GoodsOnUnitRemains_ForForHelsi (' +
    qryUnit.FieldByName('Id').AsString + ', ''3'')';
  OpenAndFormatSQL;

  if qryReport_Upload.Active then TypeData := 4;
end;

function StrToXML(AStr : string) : string;
begin
  Result := StringReplace(AStr, '<', '&lt;', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll, rfIgnoreCase]);
end;

function CurrToXML(ACurr : Currency) : String;
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
  FileName := '';

  if TypeData = 1 then
  begin

    // Формирование отчет по юр. лицам
    sl := TStringList.Create;
    try
      sl.Add('<?xml version="1.0" encoding="utf-8"?>');
      sl.Add('<Enterprises>');
      qryReport_Upload.First;
      while not qryReport_Upload.Eof do
      begin
        sl.Add('    <Enterprise>');
        sl.Add('        <EnterpriseID>' + qryReport_Upload.FieldByName('JuridicalCode').AsString + '</EnterpriseID>');
        sl.Add('        <TradeMark>' + StrToXML(qryReport_Upload.FieldByName('JuridicalName').AsString) + '</TradeMark>');
        sl.Add('    </Enterprise>');
        qryReport_Upload.Next;
      end;
      sl.Add('</Enterprises>');

      FileName := FormatDateTime('HHHHMMDDhhnnss', Now) + '_Enterprise';
      sl.SaveToFile(SavePath + FileName + '.xml', TEncoding.UTF8)
    finally
      sl.Free;
    end;
  end;

  if TypeData = 2 then
  begin

    // Формирование отчет по аптекам
    sl := TStringList.Create;
    try
      sl.Add('<?xml version="1.0" encoding="utf-8"?>');
      sl.Add('<Branches>');
      qryReport_Upload.First;
      while not qryReport_Upload.Eof do
      begin
        sl.Add('    <Branch>');
        sl.Add('        <BranchID>' + qryReport_Upload.FieldByName('UnitCode').AsString + '</BranchID>');
        sl.Add('        <EnterpriseID>' + qryReport_Upload.FieldByName('JuridicalCode').AsString + '</EnterpriseID>');
        sl.Add('        <TradeMark>' + StrToXML(qryReport_Upload.FieldByName('UnitName').AsString) + '</TradeMark>');
        sl.Add('        <Address>');
        if (qryReport_Upload.FieldByName('Latitude').AsString <> '') AND (qryReport_Upload.FieldByName('Longitude').AsString <> '') then
        begin
          sl.Add('            <Lat>' + StrToXML(qryReport_Upload.FieldByName('Latitude').AsString) + '</Lat>');
          sl.Add('            <Lng>' + StrToXML(qryReport_Upload.FieldByName('Longitude').AsString) + '</Lng>');
        end;
        sl.Add('            <Full>' + StrToXML(qryReport_Upload.FieldByName('Address').AsString) + '</Full>');
        sl.Add('        </Address>');
        sl.Add('        <Phones>');
        sl.Add('            <Phone Value="' + StrToXML(qryReport_Upload.FieldByName('Phone').AsString) + '" />');
        sl.Add('        </Phones>');
        if not qryReport_Upload.FieldByName('MondayStart').IsNull AND not qryReport_Upload.FieldByName('MondayEnd').IsNull then
        begin
          sl.Add('        <Schedule>');
          sl.Add('            <Day>');
          sl.Add('                <Number>1</Number>');
          if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) then
            sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
          else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) + '-' +
                                                     FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) + '</WorkTime>');
          sl.Add('            </Day>');

          sl.Add('            <Day>');
          sl.Add('                <Number>2</Number>');
          if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) then
            sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
          else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) + '-' +
                                                     FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) + '</WorkTime>');
          sl.Add('            </Day>');

          sl.Add('            <Day>');
          sl.Add('                <Number>3</Number>');
          if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) then
            sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
          else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) + '-' +
                                                     FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) + '</WorkTime>');
          sl.Add('            </Day>');

          sl.Add('            <Day>');
          sl.Add('                <Number>4</Number>');
          if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) then
            sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
          else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) + '-' +
                                                     FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) + '</WorkTime>');
          sl.Add('            </Day>');

          sl.Add('            <Day>');
          sl.Add('                <Number>5</Number>');
          if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) then
            sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
          else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayStart').AsDateTime) + '-' +
                                                     FormatDateTime('HH:NN', qryReport_Upload.FieldByName('MondayEnd').AsDateTime) + '</WorkTime>');
          sl.Add('            </Day>');

          if not qryReport_Upload.FieldByName('SaturdayStart').IsNull AND not qryReport_Upload.FieldByName('SaturdayEnd').IsNull then
          begin
            sl.Add('            <Day>');
            sl.Add('                <Number>6</Number>');
            if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SaturdayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SaturdayEnd').AsDateTime) then
              sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
            else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SaturdayStart').AsDateTime) + '-' +
                                                       FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SaturdayEnd').AsDateTime) + '</WorkTime>');
            sl.Add('            </Day>');
          end;

          if not qryReport_Upload.FieldByName('SundayStart').IsNull AND not qryReport_Upload.FieldByName('SundayEnd').IsNull then
          begin
            sl.Add('            <Day>');
            sl.Add('                <Number>7</Number>');
            if FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SundayStart').AsDateTime) = FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SundayEnd').AsDateTime) then
              sl.Add('                <WorkTime>00:00-24:00</WorkTime>')
            else sl.Add('                <WorkTime>' + FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SundayStart').AsDateTime) + '-' +
                                                       FormatDateTime('HH:NN', qryReport_Upload.FieldByName('SundayEnd').AsDateTime) + '</WorkTime>');
            sl.Add('            </Day>');
          end;
          sl.Add('        </Schedule>');
        end;
        sl.Add('    </Branch>');
        qryReport_Upload.Next;
      end;
      sl.Add('</Branches>');

      FileName := FormatDateTime('HHHHMMDDhhnnss', Now) + '_apt';
      sl.SaveToFile(SavePath + FileName + '.xml', TEncoding.UTF8)
    finally
      sl.Free;
    end;
  end;

  if TypeData = 3 then
  begin

    // Формирование отчет по медикаментам
    sl := TStringList.Create;
    try
      sl.Add('<?xml version="1.0" encoding="utf-8"?>');
      sl.Add('<Goods>');
      qryReport_Upload.First;
      while not qryReport_Upload.Eof do
      begin
        sl.Add('    <Offer' +
               ' Code="' + qryReport_Upload.FieldByName('Code').AsString + '"' +
               ' Name="' + StrToXML(qryReport_Upload.FieldByName('Name').AsString) + '"' +
               ' Producer="' + StrToXML(qryReport_Upload.FieldByName('Producer').AsString) + '"' +
               ' Code1="' + qryReport_Upload.FieldByName('Code1').AsString + '"/>');
        qryReport_Upload.Next;
      end;
      sl.Add('</Goods>');

      FileName := FormatDateTime('HHHHMMDDhhnnss', Now) + '_sku';
      sl.SaveToFile(SavePath + FileName + '.xml', TEncoding.UTF8)
    finally
      sl.Free;
    end;
  end;
  if TypeData = 4 then
  begin

    // Формирование отчет по остаткам
    sl := TStringList.Create;
    try
      sl.Add('<?xml version="1.0" encoding="utf-8"?>');
      sl.Add('<Data>');
      sl.Add('    <Branches>');
      sl.Add('        <Branch>');
      sl.Add('            <BranchID>' + qryReport_Upload.FieldByName('UnitCode').AsString + '</BranchID>');
      sl.Add('            <Rests>');
      qryReport_Upload.First;
      while not qryReport_Upload.Eof do
      begin
        sl.Add('                <Rest' +
                                     ' Code="' + qryReport_Upload.FieldByName('GoodsCode').AsString + '"' +
                                     ' Price="' + CurrToXML(qryReport_Upload.FieldByName('Price').AsCurrency) + '"' +
                                     ' PriceReserve="' + CurrToXML(qryReport_Upload.FieldByName('Price').AsCurrency) + '"' +
                                     ' Quantity="' + CurrToXML(qryReport_Upload.FieldByName('Amount').AsCurrency) + '"/>');
        qryReport_Upload.Next;
      end;
      sl.Add('            <Rests>');
      sl.Add('        </Branch>');
      sl.Add('    </Branches>');
      sl.Add('</Data>');

      FileName := FormatDateTime('HHHHMMDDhhnnss', Now) + '_price';
      sl.SaveToFile(SavePath + FileName + '.xml', TEncoding.UTF8)
    finally
      sl.Free;
    end;
  end;
end;

procedure TMainForm.btnGoodsClick(Sender: TObject);
begin
  if not qryUnit.Active then Exit;

  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Goods_ForForHelsi (''3'')';
  OpenAndFormatSQL;

  if qryReport_Upload.Active then TypeData := 3;
end;

procedure TMainForm.btnJuridicalClick(Sender: TObject);
begin
  if not qryUnit.Active then Exit;

  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Object_Juridical_ExportPriceForHelsi (''3'')';
  OpenAndFormatSQL;

  if qryReport_Upload.Active then TypeData := 1;
end;

procedure TMainForm.btnSendFTPClick(Sender: TObject);
  var ZipFile: TZipFile;
begin

  if not FileExists(SavePath + FileName + '.xml') then Exit;

  try

    Add_Log('Начало архивирования файла: ' + SavePath + FileName);

    ZipFile := TZipFile.Create;
    try
      ZipFile.Open(SavePath + FileName + '.zip', zmWrite);
      ZipFile.Add(SavePath + FileName + '.xml');
      ZipFile.Close;
    finally
      ZipFile.Free;
    end;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;
    Add_Log('Начало отправки файла: ' + SavePath + FileName);

  try
    IdFTP1.Disconnect;
    if glFTPPort <> 0 then IdFTP1.Host := glFTPHost;
    IdFTP1.Port := glFTPPort;
    idFTP1.Username := glFTPUser;
    idFTP1.Password := glFTPPassword;
    try
      idFTP1.Connect;
    Except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
    if glFTPPath <> '' then
    try
      idFTP1.ChangeDir(glFTPPath);
    except ON E: Exception DO
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
    try
      idFTP1.Put(SavePath + FileName + '.zip', FileName + '.zip');
      DeleteFile(SavePath + FileName + '.zip');
    except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
  finally
    idFTP1.Disconnect;
  end;

  DeleteFile(SavePath + FileName + '.zip');
  DeleteFile(SavePath + FileName + '.xml');
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  TypeData := 0;
  FileName := '';

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForHelsi.ini');

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

    glFTPHost := Ini.ReadString('FTP','Host','');
    Ini.WriteString('FTP','Host',glFTPHost);

    glFTPPort := Ini.ReadInteger('FTP','Port',0);
    Ini.WriteInteger('FTP','Port',glFTPPort);

    glFTPPath := Ini.ReadString('FTP','Path','');
    Ini.WriteString('FTP','Path',glFTPPath);

    glFTPUser := Ini.ReadString('FTP','User','');
    Ini.WriteString('FTP','User',glFTPUser);

    glFTPPassword := Ini.ReadString('FTP','Password','');
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

    if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
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
    btnAllClick(nil);
  finally
    Close;
  end;
end;


end.
