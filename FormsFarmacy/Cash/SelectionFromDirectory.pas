unit SelectionFromDirectory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog,
  DataModul, System.Actions;

type
  TSelectionFromDirectoryForm = class(TAncestorBaseForm)
    SelectionFromDirectoryGrid: TcxGrid;
    SelectionFromDirectoryGridDBTableView: TcxGridDBTableView;
    SelectionFromDirectoryGridLevel: TcxGridLevel;
    SelectionFromDirectoryDS: TDataSource;
    colName: TcxGridDBColumn;
    SelectionFromDirectoryCDS: TClientDataSet;
    Timer1: TTimer;
    pnl1: TPanel;
    edt1: TEdit;
    ProgressBar1: TProgressBar;
    spSelect_SelectionFromDirectory: TdsdStoredProc;
    actRefreshForm: TAction;
    colSecond: TcxGridDBColumn;
    procedure ParentFormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure edt1Exit(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure colNameCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelectionFromDirectoryGridDBTableViewDblClick(Sender: TObject);
    procedure actRefreshFormExecute(Sender: TObject);
    procedure edt1DblClick(Sender: TObject);
  private
    { Private declarations }
    FOldStr : String;
    FDirectory : String;
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  public
    procedure SetFilter(AText : string);
  end;

function ShowSelectionFromDirectory(ACaption, AFieldCaption, ADirectory, AStoredProcName, AFieldName : String; var AName : String) : boolean; overload;
function ShowSelectionFromDirectory(ACaption, AFieldCaption, AFieldSecondCaption,
         ADirectory, AStoredProcName, AFieldName, AFieldSecondName : String;
         var AName, ASecond : String) : boolean; overload;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, EditFromDirectory;


procedure TSelectionFromDirectoryForm.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  Var S,S1:String; k:integer; F:Boolean;
begin
  S1 := Trim(FOldStr);
  if S1 = '' then exit;
  Accept:=true;

  if SelectionFromDirectoryCDS.FieldCount < 2 then exit;

  repeat
    k:=pos(' ',S1);
    if K = 0 then k:=length(S1)+1;
    s := Trim(copy(S1,1,k-1));
    S1 := Trim(copy(S1,k,Length(S1)));

    F := Pos(AnsiUpperCase(s), AnsiUpperCase(DataSet.FieldByName(colName.DataBinding.FieldName).AsString)) > 0;

    Accept:=Accept AND F;
  until (S1='') or (Accept = False);
end;

procedure TSelectionFromDirectoryForm.SelectionFromDirectoryGridDBTableViewDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TSelectionFromDirectoryForm.actRefreshFormExecute(Sender: TObject);
  var FileName : string;
begin

  FileName := ExtractFilePath(Application.ExeName) + FDirectory + '.local';

  if not gc_User.Local then
  begin
    try
      spSelect_SelectionFromDirectory.Execute;
      SaveLocalData(SelectionFromDirectoryCDS, FileName);
    except
    end;
  end;

  if not SelectionFromDirectoryCDS.Active then
  begin
    if FileExists(FileName) then
    begin
      try
        LoadLocalData(SelectionFromDirectoryCDS, FileName);
        if not SelectionFromDirectoryCDS.Active then SelectionFromDirectoryCDS.Open;
      finally
      end;
    end;
  end;
end;

procedure TSelectionFromDirectoryForm.colNameCustomDrawCell(
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

procedure TSelectionFromDirectoryForm.edt1Change(Sender: TObject);
begin
  if Trim(Edt1.text)=FOldStr then exit;
  FOldStr:=Trim(Edt1.text);
  Timer1.Enabled:=False;
  Timer1.Interval:=100;
  Timer1.Enabled:=True;
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=True;
end;

procedure TSelectionFromDirectoryForm.edt1DblClick(Sender: TObject);
begin
    if SelectionFromDirectoryCDS.RecordCount > 0 then SelectionFromDirectoryGrid.SetFocus
    else if edt1.Text <> '' then ModalResult := mrOk;
end;

procedure TSelectionFromDirectoryForm.edt1Exit(Sender: TObject);
begin
  Timer1.Enabled:=False;
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=False;
  SelectionFromDirectoryCDS.DisableControls;
  try
    SelectionFromDirectoryCDS.Filtered:=False;
    SelectionFromDirectoryCDS.OnFilterRecord:=Nil;
    if FOldStr <> '' then
    begin
      SelectionFromDirectoryCDS.OnFilterRecord:=FilterRecord;
      SelectionFromDirectoryCDS.Filtered:=True;
    end;
    SelectionFromDirectoryCDS.First;
  finally
    SelectionFromDirectoryCDS.EnableControls
  end;
end;

procedure TSelectionFromDirectoryForm.ParentFormCreate(Sender: TObject);
begin
  FOldStr := '';
  FDirectory := '';
end;

procedure TSelectionFromDirectoryForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end else if (Key = VK_Return) and (ActiveControl = edt1) then
  begin
    Key := 0;
    if SelectionFromDirectoryCDS.RecordCount > 0 then SelectionFromDirectoryGrid.SetFocus
    else if edt1.Text <> '' then ModalResult := mrOk;;
  end else if (Key = VK_Return) then
  Begin
    Key := 0;
    if SelectionFromDirectoryCDS.RecordCount > 0 then ModalResult := mrOk
    else if edt1.Text <> '' then ModalResult := mrOk;
  End;
end;

procedure TSelectionFromDirectoryForm.SetFilter(AText : string);
begin
  edt1.Text := AText;
  FOldStr := AText;
  edt1Exit(Nil);
  edt1.SelStart := Length(AText);
end;

procedure TSelectionFromDirectoryForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  Timer1.Enabled:=True;
  ProgressBar1.Position:=ProgressBar1.Position+10;
  if ProgressBar1.Position=100 then edt1Exit(Sender);
end;

function ShowSelectionFromDirectory(ACaption, AFieldCaption, AFieldSecondCaption,
         ADirectory, AStoredProcName, AFieldName, AFieldSecondName : String;
         var AName, ASecond  : String) : boolean; overload;
begin
  with TSelectionFromDirectoryForm.Create(nil) do
  try
    if ACaption <> '' then Caption := ACaption;
    if AFieldCaption <> '' then colName.Caption := 'Выбор ' + AFieldCaption;
    if AFieldName <> '' then colName.DataBinding.FieldName := AFieldName;
    if (AFieldSecondCaption <> '') and (AFieldSecondName <> '') then
    begin
      if AFieldSecondCaption <> '' then colSecond.Caption := 'Выбор ' + AFieldSecondCaption;
      if AFieldSecondName <> '' then colSecond.DataBinding.FieldName := AFieldSecondName;
    end else colSecond.Visible := False;

    FDirectory := ADirectory;
    spSelect_SelectionFromDirectory.StoredProcName := AStoredProcName;
    SelectionFromDirectoryCDS.IndexFieldNames := colName.DataBinding.FieldName;

    actRefreshForm.Execute;

    if SelectionFromDirectoryCDS.Active then
    begin

      Result := ShowModal = mrOk;

      if Result then
      begin
        if SelectionFromDirectoryCDS.RecordCount > 0 then
        begin
          AName :=  SelectionFromDirectoryCDS.FieldByName(colName.DataBinding.FieldName).AsString;
        end else AName := edt1.Text;

        if (AFieldSecondCaption <> '') and (AFieldSecondName <> '') then
        begin
          if SelectionFromDirectoryCDS.RecordCount > 0 then
            ASecond := SelectionFromDirectoryCDS.FieldByName(AFieldSecondName).AsString
          else ASecond := '';
          if ASecond = '' then Result := ShowEditFromDirectory(ACaption, AFieldCaption, AFieldSecondCaption, AName, ASecond);
          if not Result then Exit;
        end;

        if Trim(AName) = '' then
        begin
          ShowMessage('Не выбрано или не введено значение из справочника <' + ACaption + '>');
          Result := False;
        end;

      end;
    end else
    begin
      ShowMessage('Ошибка открытия справочника <' + ACaption + '>');
      Result := False;
    end;
  finally
    Free;
  end;
end;

function ShowSelectionFromDirectory(ACaption, AFieldCaption, ADirectory, AStoredProcName, AFieldName : String; var AName : String) : boolean;
  var S : string;
begin
 Result := ShowSelectionFromDirectory(ACaption, AFieldCaption, '',
         ADirectory, AStoredProcName, AFieldName, '', AName, S)
end;

End.
