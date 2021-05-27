unit SearchByCaption;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxNavigator;

type
  TSearchByCaptionForm = class(TForm)
    SearchByCaptionGrid: TcxGrid;
    SearchByCaptionGridDBTableView: TcxGridDBTableView;
    SearchByCaptionGridLevel: TcxGridLevel;
    SearchByCaptionDS: TDataSource;
    colCaption: TcxGridDBColumn;
    SearchByCaptionCDS: TClientDataSet;
    pnl1: TPanel;
    edt1: TEdit;
    ProgressBar1: TProgressBar;
    coPath: TcxGridDBColumn;
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbGridToExcel: TdxBarButton;
    bbOpen: TdxBarButton;
    Timer1: TTimer;
    SearchByCaptionCDSCaption: TStringField;
    SearchByCaptionCDSPath: TStringField;
    SearchByCaptionCDSName: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure edt1Exit(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure colCaptionCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchByCaptionGridDBTableViewDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FOldStr : String;
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  public
    procedure SetFilter(AText : string);
  end;

implementation

{$R *.dfm}

uses StrUtils, CommonData, MainForm, DataModul;


procedure TSearchByCaptionForm.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  Var S,S1:String; k:integer; F:Boolean;
begin
  S1 := Trim(FOldStr);
  if S1 = '' then exit;
  Accept:=true;

  if SearchByCaptionCDS.FieldCount < 2 then exit;

  repeat
    k:=pos(' ',S1);
    if K = 0 then k:=length(S1)+1;
    s := Trim(copy(S1,1,k-1));
    S1 := Trim(copy(S1,k,Length(S1)));

    F := Pos(AnsiUpperCase(s), AnsiUpperCase(DataSet.FieldByName('Caption').AsString)) > 0;

    Accept:=Accept AND F;
  until (S1='') or (Accept = False);
end;

procedure TSearchByCaptionForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action:=caFree;
end;

procedure TSearchByCaptionForm.SearchByCaptionGridDBTableViewDblClick(Sender: TObject);
  var I : integer;
begin
  for I := 0 to MainFormInstance.ComponentCount - 1 do if (MainFormInstance.Components[I].Name = SearchByCaptionCDS.FieldByName('Name').AsString) and
    (MainFormInstance.Components[I] is TMenuItem) then
  begin
    if Assigned(TMenuItem(MainFormInstance.Components[I]).Action) then TMenuItem(MainFormInstance.Components[I]).Action.Execute;
  end;
end;

procedure TSearchByCaptionForm.colCaptionCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var S,S1:string;
  k: Integer;
  OldColor:TColor;
  AText:string;
begin
  S1:=FOldStr;
  if S1 = '' then exit;
  AText:=AViewInfo.GridRecord.Values[AViewInfo.Item.Index];
  ACanvas.FillRect(AViewInfo.Bounds);
  ACanvas.TextOut(AViewInfo.Bounds.Left+2,AViewInfo.Bounds.Top+2, AText);
  repeat
    k:=pos(' ',S1);
    if K = 0 then
      k:=length(S1)+1;
    s:=copy(S1,1,k-1);
    delete(S1,1,k);
    K:=pos(AnsiUpperCase(S),AnsiUpperCase(AText));
    if K <> 0 then
    Begin
      s:=copy(AText,k,length(s));
      OldColor:=ACanvas.Font.Color;
      ACanvas.Font.Color:=clRed;
      ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline];
      ACanvas.TextOut(AViewInfo.Bounds.Left+ACanvas.TextWidth(copy(AText,1,K-1))+1,AViewInfo.Bounds.Top+2,S);
      ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];
      ACanvas.Font.Color:=OldColor;
    End;
  until S1='';
  ADone:= True;
end;

procedure TSearchByCaptionForm.edt1Change(Sender: TObject);
begin
  if Trim(Edt1.text)=FOldStr then exit;
  FOldStr:=Trim(Edt1.text);
  Timer1.Enabled:=False;
  Timer1.Interval:=100;
  Timer1.Enabled:=True;
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=True;
end;

procedure TSearchByCaptionForm.edt1Exit(Sender: TObject);
begin
  Timer1.Enabled:=False;
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=False;
  SearchByCaptionCDS.DisableControls;
  try
    SearchByCaptionCDS.Filtered:=False;
    SearchByCaptionCDS.OnFilterRecord:=Nil;
    if FOldStr <> '' then
    begin
      SearchByCaptionCDS.OnFilterRecord:=FilterRecord;
      SearchByCaptionCDS.Filtered:=True;
    end;
    SearchByCaptionCDS.First;
  finally
    SearchByCaptionCDS.EnableControls
  end;
end;

procedure TSearchByCaptionForm.FormCreate(Sender: TObject);

procedure AddMenuCDS(MI : TMenuItem; Path : String);
  var I : integer;
begin
  if MI.Count = 0 then
  begin
    if MI.Visible and Assigned(MI.Action) then
    begin
      SearchByCaptionCDS.Last;
      SearchByCaptionCDS.Append;
      SearchByCaptionCDS.FieldByName('Caption').AsString := MI.Caption;
      SearchByCaptionCDS.FieldByName('Path').AsString := Path;
      SearchByCaptionCDS.FieldByName('Name').AsString := MI.Name;
      SearchByCaptionCDS.Post;
    end;
  end else for I := 0 to MI.Count - 1 do
    AddMenuCDS(MI.Items[I], Path + IfThen(Path = '', '', ' => ') + MI.Caption);
end;

begin
  FOldStr := '';
  AddMenuCDS(MainFormInstance.MainMenu.Items, '');
end;

procedure TSearchByCaptionForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Return) and (ActiveControl = edt1) then
  begin
    Key := 0;
    SearchByCaptionGrid.SetFocus;
  end else if (Key = VK_ADD) or (Key = VK_Return) then
  Begin
    Key := 0;
    SearchByCaptionGridDBTableViewDblClick(Sender);
  End;
end;

procedure TSearchByCaptionForm.SetFilter(AText : string);
begin
  edt1.Text := AText;
  FOldStr := AText;
  edt1Exit(Nil);
  edt1.SelStart := Length(AText);
end;

procedure TSearchByCaptionForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  Timer1.Enabled:=True;
  ProgressBar1.Position:=ProgressBar1.Position+10;
  if ProgressBar1.Position=100 then edt1Exit(Sender);
end;

initialization
  RegisterClass(TSearchByCaptionForm);

End.
