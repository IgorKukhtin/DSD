unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IniFiles, cxGraphics, cxControls, DateUtils,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, cxLabel, cxTextEdit,
  cxMaskEdit, cxSpinEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, cxGridExportLink, System.Zip, cxProgressBar;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ZConnection1: TZConnection;
    dsExportPharmacists: TDataSource;
    grReport: TcxGrid;
    grtvReport: TcxGridDBTableView;
    colRowData: TcxGridDBColumn;
    grlReport: TcxGridLevel;
    Panel1: TPanel;
    qryExportPharmacists: TZQuery;
    btnExportUser: TButton;
    btnLoadResult: TButton;
    qrygpInsertUpdateLoadTestingXML: TZQuery;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExportUserClick(Sender: TObject);
    procedure btnLoadResultClick(Sender: TObject);
  private
    { Private declarations }
    FilePath: string;
  public
    { Public declarations }
    function LoadResult : boolean;
    function ExportUser : boolean;
    procedure Add_Log(AMessage:String);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Add_Log(AMessage: String);
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
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now)+' - '+AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

function TForm1.LoadResult : boolean;
  var sl, so: TStringList; I : integer;
begin
  Add_Log('Начало загрузки результатов');
  Result := False;
  btnExportUser.Enabled := False;
  btnLoadResult.Enabled := False;
  sl := TStringList.Create;
  so:= TStringList.Create;
  try
    try
      if FileExists(FilePath + 'Results.xml') then
      begin
        sl.LoadFromFile(FilePath + 'Results.xml');
        for I := 0 to sl.Count - 1 do
          if (Pos('<Offers', Trim(sl.Strings[I])) = 1) or (Pos('</Offers', Trim(sl.Strings[I])) = 1) or (Pos('<Offer', Trim(sl.Strings[I])) = 1) then so.Add(Trim(sl.Strings[I]));

        qrygpInsertUpdateLoadTestingXML.Params.ParamByName('XMLS').Value := StringReplace(so.Text, ',', '.', [rfReplaceAll]);
        qrygpInsertUpdateLoadTestingXML.ExecSQL;
      end else Add_Log('Файл ' + FilePath + 'Results.xml не найден.');
    except ON E:Exception DO
      Begin
        Add_Log(E.Message);
        Exit;
      End;
    End;
    Result := True;
  finally
    sl.Free;
    so.Free;
    btnExportUser.Enabled := True;
    btnLoadResult.Enabled := True;
  end;
end;

procedure TForm1.btnLoadResultClick(Sender: TObject);
begin
  LoadResult;
end;

function TForm1.ExportUser : boolean;
  var sl : TStringList;
begin
  Add_Log('Начало экспорта сотрудников');
  btnExportUser.Enabled := False;
  btnLoadResult.Enabled := False;
  sl := TStringList.Create;
  try

    if ZConnection1.Connected then
    try
      qryExportPharmacists.Close;
      qryExportPharmacists.Open;
      qryExportPharmacists.First;

      while not qryExportPharmacists.Eof do
      Begin
        sl.Add(qryExportPharmacists.Fields.Fields[0].AsString);
        qryExportPharmacists.Next;
      End;

      if Pos('</Offers>', sl.Strings[sl.Count - 1]) = 0 then
      begin
        Add_Log('Ошибка экпорта нет </Offers>');
        Exit
      end else sl.SaveToFile(FilePath + 'Export.xml', TEncoding.UTF8)
    except ON E:Exception DO
      Begin
        Add_Log(E.Message);
        Exit;
      End;
    End;

  finally
    sl.Free;
    btnExportUser.Enabled := True;
    btnLoadResult.Enabled := True;
  end;
end;

procedure TForm1.btnExportUserClick(Sender: TObject);
begin
  ExportUser;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini: TIniFile;
Begin

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try

    FilePath := ini.readString('Options', 'FilePath', ExtractFilePath(Application.ExeName));
    if FilePath[Length(FilePath)] <> '\' then
      FilePath := FilePath + '\';
    ini.WriteString('Options', 'FilePath', FilePath);

    ZConnection1.Database := ini.ReadString('Connect','DataBase','farmacy');
    ini.WriteString('Connect','DataBase',ZConnection1.Database);

    ZConnection1.HostName := ini.ReadString('Connect','HostName','91.210.37.210');
    ini.WriteString('Connect','HostName',ZConnection1.HostName);

    ZConnection1.User := ini.ReadString('Connect','User','postgres');
    ini.WriteString('Connect','User',ZConnection1.User);

    ZConnection1.Password := ini.ReadString('Connect','Password','postgres');
    ini.WriteString('Connect','Password',ZConnection1.Password);

  finally
    ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
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
    Timer1.Enabled := True;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if not LoadResult then Exit;
    ExportUser;
  finally
    Close;
  end;
end;

end.
