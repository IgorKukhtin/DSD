unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IniFiles, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, cxLabel, cxTextEdit,
  cxMaskEdit, cxSpinEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, cxGridExportLink;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ZConnection1: TZConnection;
    qryReport: TZQuery;
    dsReport: TDataSource;
    grReport: TcxGrid;
    grtvReport: TcxGridDBTableView;
    colRowData: TcxGridDBColumn;
    grlReport: TcxGridLevel;
    Panel1: TPanel;
    btnExecute: TButton;
    UnitId: TcxSpinEdit;
    cxLabel4: TcxLabel;
    btnExport: TButton;
    FileName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    SavePath: String;
  public
    { Public declarations }
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

procedure TForm1.btnExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета БаДМ');
  qryReport.Close;
  qryReport.Params.ParamByName('inUnitId').Value := UnitId.Value;
  try
    qryReport.Open;
  except ON E:Exception DO
    Begin
      Add_Log(E.Message);
      Exit;
    end;
  end;
end;

procedure TForm1.btnExportClick(Sender: TObject);
var
  sl : TStringList;
begin
  Add_Log('Начало выгрузки отчета');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  try
    ExportGridToText(SavePath+FileName.Text,grReport,true,true,'','','','XML');
    sl := TStringList.Create;
    try
      sl.LoadFromFile(SavePath+FileName.Text);
      sl.SaveToFile(SavePath+FileName.Text,TEncoding.UTF8);
    finally
      sl.Free;
    end;
  except ON E: Exception DO
    Begin
      Add_Log(E.Message);
      exit;
    End;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  function GetCorrectNameFile(AName: String): String;
  var
    j: Integer;
  Begin
    for j := 1 to length(AName) do
      if CharInSet(AName[j],[' ','\','/',':','*','?','''','"','<','>','|']) then
        AName[j] := '_';
    Result := AName;
  End;
Begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    SavePath := ini.readString('Options','Path',ExtractFilePath(Application.ExeName));
    if SavePath[length(SavePath)]<> '\' then
      SavePath := SavePath+'\';
    ini.WriteString('Options','Path',SavePath);

    UnitId.Value := ini.ReadInteger('Options','UnitId',183292);
    ini.WriteInteger('Options','UnitId',UnitID.Value);

    ZConnection1.Database := ini.ReadString('Connect','DataBase','farmacy');
    ini.WriteString('Connect','DataBase',ZConnection1.Database);

    ZConnection1.HostName := ini.ReadString('Connect','HostName','91.210.37.210');
    ini.WriteString('Connect','HostName',ZConnection1.HostName);

    ZConnection1.User := ini.ReadString('Connect','User','postgres');
    ini.WriteString('Connect','User',ZConnection1.User);

    ZConnection1.Password := ini.ReadString('Connect','Password','postgres');
    ini.WriteString('Connect','Password',ZConnection1.Password);

    FileName.Text := ini.ReadString('Export','FileName','pricelistForTabletki_Pravda_6.xml');
    ini.WriteString('Export','FileName',FileName.Text);

  finally
    ini.free;
  end;
  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName)+'libpq.dll';
  try
    ZConnection1.Connect;
  Except ON E:Exception do
    Begin
      Add_Log(E.Message);
      Close;
      Exit;
    End;
  end;
  if not((ParamCount>=1) AND (CompareText(ParamStr(1),'manual')=0)) then
  Begin
    btnExecute.Enabled := false;
    btnExport.Enabled := false;
    Timer1.Enabled := true;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    btnExecuteClick(nil);
    btnExportClick(nil);
  finally
    Close;
  end;
end;

end.
