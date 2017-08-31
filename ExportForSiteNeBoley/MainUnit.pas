unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, Vcl.StdCtrls,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Vcl.ExtCtrls, ZAbstractConnection, ZConnection, ZAbstractRODataset,
  ZDataset, Vcl.ActnList, cxGridExportLink;

type
  TMainForm = class(TForm)
    ButtonPanel: TPanel;
    ExportGridDBTableView1: TcxGridDBTableView;
    ExportGridLevel1: TcxGridLevel;
    ExportGrid: TcxGrid;
    ExportButton: TButton;
    RunButton: TButton;
    ZConnection: TZConnection;
    ZQuery: TZReadOnlyQuery;
    DataSource: TDataSource;
    ZQuerygoodscode: TIntegerField;
    ZQuerygoodsnameforsite: TWideMemoField;
    ZQueryprice: TFloatField;
    ZQuerygoodsurl: TWideMemoField;
    colGoodsCode: TcxGridDBColumn;
    colGoodsNameForSite: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colGoodsURL: TcxGridDBColumn;
    ActionList: TActionList;
    RunAction: TAction;
    SaveAction: TAction;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure RunActionExecute(Sender: TObject);
    procedure RunActionUpdate(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure SaveActionUpdate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FilePath: string;
    Running, Saving: Boolean;
    procedure AddToLog(S: string);
    procedure ExportRun;
    procedure ExportSave;
    procedure SaveToXML;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.IniFiles;

procedure TMainForm.AddToLog(S: string);
var
  F: TextFile;
  LogFileName: string;
begin
  LogFileName := ChangeFileExt(Application.ExeName, '.log');
  AssignFile(F, LogFileName);

  if FileExists(LogFileName) then
    Append(F)
  else
    Rewrite(F);

  Writeln(F, FormatDateTime('yyyy.mm.dd hh:mm:ss.zzz', Now) + ' ' + S);
  CloseFile(F);
end;

procedure TMainForm.ExportRun;
var
  OldCursor: TCursor;
begin
  AddToLog('Формирование отчета ...');

  Running := True;
  Application.ProcessMessages;
  ZQuery.DisableControls;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try
    ZQuery.Close;

    try
      ZQuery.Open;
    except
      on E: Exception do
        AddToLog(E.Message);
    end;
  finally
    Screen.Cursor := OldCursor;
    ZQuery.EnableControls;
    Running := False;
  end;
end;

procedure TMainForm.ExportSave;
var
  OldDecimalSeparator: Char;
begin
  Saving := True;
  AddToLog('Выгрузка отчета ...');

  if not ForceDirectories(ExtractFilePath(FilePath)) then
  begin
    AddToLog(Format('Не могу создать директорию выгрузки "%s"', [ExtractFilePath(FilePath)]));
    Saving := False;
    Exit;
  end;

  try
    OldDecimalSeparator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';
    ExportGridToText(FilePath, ExportGrid, True, True, ';', '', '', 'CSV');
    SaveToXML;
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
    Saving := False;
  except
    on E: Exception do
    begin
      AddToLog(E.Message);
      Saving := False;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  Running := False;
  Saving := False;
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  try
    FilePath := IniFile.ReadString('Options', 'FilePath', ExtractFilePath(Application.ExeName) + 'neboley.csv');
    IniFile.WriteString('Options', 'FilePath', FilePath);

    ZConnection.HostName := IniFile.ReadString('Connect', 'HostName', '91.210.37.210');
    IniFile.WriteString('Connect', 'HostName', ZConnection.HostName);

    ZConnection.Database := IniFile.ReadString('Connect', 'Database', 'farmacy');
    IniFile.WriteString('Connect', 'Database', ZConnection.Database);

    ZConnection.User := IniFile.ReadString('Connect', 'User', 'postgres');
    IniFile.WriteString('Connect', 'User', ZConnection.User);

    ZConnection.Password := IniFile.ReadString('Connect', 'Password', 'postgres');
    IniFile.WriteString('Connect', 'Password', ZConnection.Password);
  finally
    IniFile.Free;
  end;

  ZConnection.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection.Connect;
  except
    on E: Exception do
    begin
      AddToLog(E.Message);
      Close;
    end;
  end;

  if FindCmdLineSwitch('auto') then
  begin
    ButtonPanel.Visible := False;
    Timer.Enabled := True;
  end;
end;

procedure TMainForm.RunActionExecute(Sender: TObject);
begin
  ExportRun;
end;

procedure TMainForm.RunActionUpdate(Sender: TObject);
begin
  RunAction.Enabled := not Running;
end;

procedure TMainForm.SaveActionExecute(Sender: TObject);
begin
  ExportSave;
end;

procedure TMainForm.SaveActionUpdate(Sender: TObject);
begin
  SaveAction.Enabled := not Saving;
end;

procedure TMainForm.SaveToXML;
var
  XML: TStringList;
begin
  XML := TStringList.Create;

  try
    XML.Add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    XML.Add('<Root>');

    with ZQuery do
    begin
      DisableControls;
      First;

      while not Eof do
      begin
        XML.Add(Format('  <Rest Code="%s" Name="%s" Price="%f" Quantity="1" Url="%s"/>', [
          ZQueryGoodsCode.AsString,
          ZQueryGoodsNameForSite.AsString,
          ZQueryPrice.AsFloat,
          ZQueryGoodsURL.AsString
        ]));

        Next;
      end;

      First;
      EnableControls;
    end;

    XML.Add('</Root>');
    XML.SaveToFile(ChangeFileExt(FilePath, '.xml'), TEncoding.UTF8);
  finally
    XML.Free;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  try
    ExportRun;
    ExportSave;
  finally
    Timer.Enabled := False;
    Close;
  end;
end;

end.
