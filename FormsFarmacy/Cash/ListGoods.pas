unit ListGoods;

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
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit;

type
  TListGoodsForm = class(TAncestorBaseForm)
    ListGoodsGrid: TcxGrid;
    ListGoodsGridDBTableView: TcxGridDBTableView;
    ListGoodsGridLevel: TcxGridLevel;
    ListGoodsDS: TDataSource;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    ListGoodsCDS: TClientDataSet;
    Timer1: TTimer;
    pnl1: TPanel;
    edt1: TEdit;
    ProgressBar1: TProgressBar;
    actListDiffAddGoods: TAction;
    ListDiffDS: TDataSource;
    ListDiffCDS: TClientDataSet;
    ListDiffGrid: TcxGrid;
    ListDiffGridDBTableView: TcxGridDBTableView;
    colIsSend: TcxGridDBColumn;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    cxGridDBColumn1: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colDateInput: TcxGridDBColumn;
    colUserName: TcxGridDBColumn;
    ListDiffGridLevel: TcxGridLevel;
    colAmoutDayUser: TcxGridDBColumn;
    ListlDiffNoSendCDS: TClientDataSet;
    colId: TcxGridDBColumn;
    colAmountDiffPrev: TcxGridDBColumn;
    colAmountDiffCalc: TcxGridDBColumn;
    colAmountDiff: TcxGridDBColumn;
    spSelect_CashListDiff: TdsdStoredProc;
    CashListDiffCDS: TClientDataSet;
    pnlLocal: TPanel;
    ListlDiffNoSendCDSID: TIntegerField;
    ListlDiffNoSendCDSAmoutDiffUser: TCurrencyField;
    ListlDiffNoSendCDSAmoutDiffNoSend: TCurrencyField;
    procedure ParentFormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure edt1Exit(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure colGoodsNameCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure actListDiffAddGoodsExecute(Sender: TObject);
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListGoodsGridDBTableViewDblClick(Sender: TObject);
    procedure ListGoodsGridDBTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure colAmoutDayUserGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure colAmountDiffCalcGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
  private
    { Private declarations }
    FOldStr : String;
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  public
    procedure SetFilter(AText : string);
    procedure FillingListGoodsCDS(AReLoad : boolean);
    procedure FillingListlDiffNoSendCDS;
  end;

  var MutexGoods: THandle;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, ListDiff;


procedure TListGoodsForm.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  Var S,S1:String; i,k:integer; F:Boolean;
begin
  S1 := Trim(FOldStr);
  if S1 = '' then exit;
  Accept:=true;

  if ListGoodsCDS.FieldCount < 2 then exit;

  repeat
    k:=pos(' ',S1);
    if K = 0 then k:=length(S1)+1;
    s := Trim(copy(S1,1,k-1));
    S1 := Trim(copy(S1,k,Length(S1)));

    F := Pos(AnsiUpperCase(s), AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString)) > 0;

    Accept:=Accept AND F;
  until (S1='') or (Accept = False);
end;

procedure TListGoodsForm.ListGoodsGridDBTableViewDblClick(Sender: TObject);
begin
  actListDiffAddGoodsExecute(Sender);
end;

procedure TListGoodsForm.ListGoodsGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if not ListGoodsCDS.Eof then
    ListDiffCDS.Filter := 'Id = ' + ListGoodsCDS.FieldByName('Id').AsString
  else ListDiffCDS.Filter := 'Id = 0';
end;

procedure TListGoodsForm.actListDiffAddGoodsExecute(Sender: TObject);
  var S: String; nCount : currency; nPos : integer;
begin

  if not ListGoodsCDS.Active  then Exit;
  if ListGoodsCDS.RecordCount < 1  then Exit;

  ListDiffAddGoods(ListGoodsCDS);

  try
    ListGoodsCDS.DisableControls;
    ListDiffCDS.Filtered := False;
    nPos := ListGoodsCDS.RecNo;
    WaitForSingleObject(MutexDiffCDS, INFINITE);
    try
      if FileExists(ListDiff_lcl) then LoadLocalData(ListDiffCDS, ListDiff_lcl);
    finally
      ReleaseMutex(MutexDiffCDS);
    end;
    if not ListDiffCDS.Active then ListDiffCDS.Open;
    while ListlDiffNoSendCDS.RecordCount > 0 do ListlDiffNoSendCDS.Delete;
    FillingListGoodsCDS(True);
    FillingListlDiffNoSendCDS;
  finally
    ListGoodsCDS.RecNo := nPos;
    ListGoodsCDS.EnableControls;
  end;

  ListDiffCDS.Filter := 'Id = ' + ListGoodsCDS.FieldByName('Id').AsString;
  ListDiffCDS.Filtered := True;
end;

procedure TListGoodsForm.colAmountDiffCalcGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if ListlDiffNoSendCDS.Locate('Id', ARecord.Values[colId.Index], []) and
    (ListlDiffNoSendCDS.FieldByName('AmoutDiffNoSend').AsCurrency <> 0) then
  begin
    if ARecord.Values[colAmountDiff.Index] <> Null then
      AText := FormatCurr('0.000', ARecord.Values[colAmountDiff.Index] + ListlDiffNoSendCDS.FieldByName('AmoutDiffNoSend').AsCurrency)
    else AText := FormatCurr('0.000', ListlDiffNoSendCDS.FieldByName('AmoutDiffNoSend').AsCurrency);
  end else if ARecord.Values[colAmountDiff.Index] <> Null then AText := FormatCurr('0.000', ARecord.Values[colAmountDiff.Index]);
end;

procedure TListGoodsForm.colAmoutDayUserGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if ListlDiffNoSendCDS.Locate('Id', ARecord.Values[colId.Index], []) and
    (ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency <> 0) then
    AText := FormatCurr('0.000', ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency);
end;

procedure TListGoodsForm.colGoodsNameCustomDrawCell(
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
      ACanvas.TextOut(AViewInfo.Bounds.Left+ACanvas.TextWidth(copy(AText,1,K-1))+2,AViewInfo.Bounds.Top+2,S);
      ACanvas.Font.Color:=OldColor;
    End;
  until S1='';
  ADone:= True;
end;

procedure TListGoodsForm.edt1Change(Sender: TObject);
begin
  if Trim(Edt1.text)=FOldStr then exit;
  FOldStr:=Trim(Edt1.text);
  Timer1.Enabled:=False;
  Timer1.Interval:=100;
  Timer1.Enabled:=True;
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=True;
end;

procedure TListGoodsForm.edt1Exit(Sender: TObject);
begin
  Timer1.Enabled:=False;
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=False;
  ListGoodsCDS.DisableControls;
  try
    ListGoodsCDS.Filtered:=False;
    ListGoodsCDS.OnFilterRecord:=Nil;
    if FOldStr <> '' then
    begin
      ListGoodsCDS.OnFilterRecord:=FilterRecord;
      ListGoodsCDS.Filtered:=True;
    end;
    ListGoodsCDS.First;
  finally
    ListGoodsCDS.EnableControls
  end;
end;

procedure TListGoodsForm.ParentFormCreate(Sender: TObject);
begin

  try
    if CashListDiffCDS.Active then CashListDiffCDS.Close;
    spSelect_CashListDiff.Execute;
  except
    pnlLocal.Visible := True;
  end;

  while ListlDiffNoSendCDS.RecordCount > 0 do ListlDiffNoSendCDS.Delete;
  WaitForSingleObject(MutexGoods, INFINITE);
  try
    if FileExists(Goods_lcl) then LoadLocalData(ListGoodsCDS, Goods_lcl);
    if not ListGoodsCDS.Active then ListGoodsCDS.Open;
  finally
    ReleaseMutex(MutexGoods);
  end;

  FillingListGoodsCDS(False);

  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    ListDiffCDS.Filtered := False;
    if FileExists(ListDiff_lcl) then LoadLocalData(ListDiffCDS, ListDiff_lcl);
    if not ListDiffCDS.Active then ListDiffCDS.Open;
    FillingListlDiffNoSendCDS;
  finally
    ReleaseMutex(MutexDiffCDS);
  end;

  ListDiffCDS.Filter := 'Id = ' + ListGoodsCDS.FieldByName('Id').AsString;
  ListDiffCDS.Filtered := True;

  FOldStr := '';
end;

procedure TListGoodsForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Return) and (ActiveControl = edt1) then
  begin
    Key := 0;
    ListGoodsGrid.SetFocus;
  end else if (Key = VK_ADD) or (Key = VK_Return) then
  Begin
    Key := 0;
    actListDiffAddGoodsExecute(Sender);
  End;
end;

procedure TListGoodsForm.SetFilter(AText : string);
begin
  edt1.Text := AText;
  FOldStr := AText;
  edt1Exit(Nil);
  edt1.SelStart := Length(AText);
end;

procedure TListGoodsForm.FillingListGoodsCDS(AReLoad : boolean);
  var bSave : boolean;
begin

  if AReLoad then
  try
    if CashListDiffCDS.Active then CashListDiffCDS.Close;
    spSelect_CashListDiff.Execute;
    pnlLocal.Visible := False;
  except
    pnlLocal.Visible := True;
  end;

  if not CashListDiffCDS.Active then Exit;

  bSave := False;
  CashListDiffCDS.First;
  while not CashListDiffCDS.Eof do
  begin
    if ListGoodsCDS.Locate('Id', CashListDiffCDS.FieldByName('Id').AsInteger, []) and
      ((ListGoodsCDS.FieldByName('AmountDiff').AsVariant <> CashListDiffCDS.FieldByName('AmountDiff').AsVariant) or
      (ListGoodsCDS.FieldByName('AmountDiffPrev').AsVariant <> CashListDiffCDS.FieldByName('AmountDiffPrev').AsVariant)) then
    begin
       ListGoodsCDS.Edit;
       ListGoodsCDS.FieldByName('AmountDiff').AsVariant := CashListDiffCDS.FieldByName('AmountDiff').AsVariant;
       ListGoodsCDS.FieldByName('AmountDiffPrev').AsVariant := CashListDiffCDS.FieldByName('AmountDiffPrev').AsVariant;
       ListGoodsCDS.Post;
       bSave := True;
    end;

    if CashListDiffCDS.FieldByName('AmountDiffUser').AsCurrency <> 0 then
    begin
      if not ListlDiffNoSendCDS.Locate('Id', CashListDiffCDS.FieldByName('Id').AsInteger, []) then
      begin
         ListlDiffNoSendCDS.Append;
         ListlDiffNoSendCDS.FieldByName('Id').AsInteger := CashListDiffCDS.FieldByName('Id').AsInteger;
      end else ListlDiffNoSendCDS.Edit;

      ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency + CashListDiffCDS.FieldByName('AmountDiffUser').AsCurrency;

      ListlDiffNoSendCDS.Post;
    end;

    CashListDiffCDS.Next;
  end;

  if bSave then
  begin
    WaitForSingleObject(MutexGoods, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
    try
      SaveLocalData(ListGoodsCDS,Goods_lcl);
    finally
      ReleaseMutex(MutexGoods);
    end;
  end;

end;

procedure TListGoodsForm.FillingListlDiffNoSendCDS;
begin
  ListDiffCDS.First;
  while not ListDiffCDS.Eof do
  begin
    if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) and
      not ListDiffCDS.FieldByName('IsSend').AsBoolean then
    begin
      if not ListlDiffNoSendCDS.Locate('Id', ListDiffCDS.FieldByName('Id').AsInteger, []) then
      begin
         ListlDiffNoSendCDS.Append;
         ListlDiffNoSendCDS.FieldByName('Id').AsInteger := ListDiffCDS.FieldByName('Id').AsInteger;
      end else ListlDiffNoSendCDS.Edit;

      if ListDiffCDS.FieldByName('UserID').AsString = gc_User.Session then
        ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency + ListDiffCDS.FieldByName('Amount').AsCurrency;
      ListlDiffNoSendCDS.FieldByName('AmoutDiffNoSend').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiffNoSend').AsCurrency + ListDiffCDS.FieldByName('Amount').AsCurrency;

      ListlDiffNoSendCDS.Post;
    end;
    ListDiffCDS.Next;
  end;
end;

procedure TListGoodsForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  Timer1.Enabled:=True;
  ProgressBar1.Position:=ProgressBar1.Position+10;
  if ProgressBar1.Position=100 then edt1Exit(Sender);
end;

End.
