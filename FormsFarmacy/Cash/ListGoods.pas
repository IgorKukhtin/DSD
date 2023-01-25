unit ListGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, Math,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog,
  DataModul, System.Actions, dxDateRanges;

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
    colPriceDiff: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colDateInput: TcxGridDBColumn;
    colUserName: TcxGridDBColumn;
    ListDiffGridLevel: TcxGridLevel;
    colAmoutDayUser: TcxGridDBColumn;
    ListlDiffNoSendCDS: TClientDataSet;
    colId: TcxGridDBColumn;
    colAmountDiffPrev: TcxGridDBColumn;
    colAmountDiff: TcxGridDBColumn;
    spSelect_CashListDiff: TdsdStoredProc;
    CashListDiffCDS: TClientDataSet;
    pnlLocal: TPanel;
    ListlDiffNoSendCDSID: TIntegerField;
    ListlDiffNoSendCDSAmoutDiffUser: TCurrencyField;
    ListlDiffNoSendCDSAmoutDiff: TCurrencyField;
    ListlDiffNoSendCDSAmountDiffPrev: TCurrencyField;
    colGoodsNDS: TcxGridDBColumn;
    colJuridicalPrice: TcxGridDBColumn;
    colMarginPercent: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    colIsClose: TcxGridDBColumn;
    colisFirst: TcxGridDBColumn;
    colisSecond: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colDiffKindId: TcxGridDBColumn;
    DiffKindCDS: TClientDataSet;
    actSearchGoods: TdsdOpenForm;
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbGridToExcel: TdxBarButton;
    bbOpen: TdxBarButton;
    colContractName: TcxGridDBColumn;
    colAreaName: TcxGridDBColumn;
    colisResolution_224: TcxGridDBColumn;
    colPriceOOC1303: TcxGridDBColumn;
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
    procedure colDiffKindIdGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure mmSearchGoodsClick(Sender: TObject);
    procedure ListGoodsGridDBTableViewStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure ParentFormDestroy(Sender: TObject);
  private
    { Private declarations }
    FOldStr : String;
    FStyle: TcxStyle;
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  public
    procedure SetFilter(AText : string);
    procedure FillingListGoodsCDS(AReLoad : boolean);
    procedure FillingListlDiffNoSendCDS;
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, ListDiff, ListDiffAddGoods, MainCash2;


procedure TListGoodsForm.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  Var S,S1:String; k:integer; F:Boolean;
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
  if not ListDiffCDS.Active then Exit;
  if not ListGoodsCDS.Eof then
    ListDiffCDS.Filter := 'Id = ' + ListGoodsCDS.FieldByName('Id').AsString
  else ListDiffCDS.Filter := 'Id = 0';
end;

procedure TListGoodsForm.ListGoodsGridDBTableViewStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  FStyle.Assign(dmMain.cxContentStyle);
  if (ARecord.Values[colExpirationDate.Index] <> Null) and ((ARecord.Values[colExpirationDate.Index]) < IncYear(Date, 1)) then
    FStyle.TextColor := clRed;
  if (ARecord.Values[colPriceOOC1303.Index] <> Null) and
    (ARecord.Values[colPriceOOC1303.Index] < ARecord.Values[colJuridicalPrice.Index]) and
    ((ARecord.Values[colJuridicalPrice.Index]/ARecord.Values[colPriceOOC1303.Index] * 100.0 - 100) > MainCashForm.UnitConfigCDS.FindField('DeviationsPrice1303').AsCurrency)
     then FStyle.Color := TColor($0083D3FA);
  AStyle := FStyle;
end;

procedure TListGoodsForm.mmSearchGoodsClick(Sender: TObject);
  var i : Integer;
begin
  if actSearchGoods.Execute then
  begin
    for i := 0 to Screen.ActiveForm.ComponentCount - 1 do if Screen.ActiveForm.Components[I].Name = 'edGoodsSearch' then
    begin
      if edt1.Text = '' then
      begin
        if not ListGoodsCDS.IsEmpty then TcxTextEdit(Screen.ActiveForm.Components[I]).Text := ListGoodsCDS.FieldByName('GoodsName').AsString;
      end else  TcxTextEdit(Screen.ActiveForm.Components[I]).Text := edt1.Text;
    end;

    for i := 0 to Screen.ActiveForm.ComponentCount - 1 do if Screen.ActiveForm.Components[I].Name = 'actRefreshSearch' then
    begin
      TdsdExecStoredProc(Screen.ActiveForm.Components[I]).Execute;
    end;
  end;
end;

procedure TListGoodsForm.actListDiffAddGoodsExecute(Sender: TObject);
  var S: String; nCount : currency; nPos : integer;
begin

  if not ListGoodsCDS.Active  then Exit;
  if ListGoodsCDS.RecordCount < 1  then Exit;

  with TListDiffAddGoodsForm.Create(nil) do
  try
    Price := Self.ListGoodsCDS.FieldByName('Price').AsCurrency;
    NDS := Self.ListGoodsCDS.FieldByName('NDS').AsCurrency;
    MCSValue := Self.ListGoodsCDS.FieldByName('MCSValue').AsCurrency;
    NDSKindId := Self.ListGoodsCDS.FieldByName('NDSKindId').AsInteger;

    GoodsId := Self.ListGoodsCDS.FieldByName('Id').AsInteger;
    GoodsCode := Self.ListGoodsCDS.FieldByName('GoodsCode').AsInteger;
    GoodsName := Self.ListGoodsCDS.FieldByName('GoodsName').AsString;

    if ShowModal <> mrOk then Exit;
  finally
     Free;
  end;

  try
    ListGoodsCDS.DisableControls;
    ListDiffCDS.Filtered := False;
    nPos := ListGoodsCDS.RecNo;
    while ListlDiffNoSendCDS.RecordCount > 0 do ListlDiffNoSendCDS.Delete;
    FillingListGoodsCDS(True);
    FillingListlDiffNoSendCDS;
  finally
    ListGoodsCDS.RecNo := nPos;
    ListGoodsCDS.EnableControls;
  end;

  if ListDiffCDS.Active then
  begin
    ListDiffCDS.Filter := 'Id = ' + ListGoodsCDS.FieldByName('Id').AsString;
    ListDiffCDS.Filtered := True;
  end;
end;

procedure TListGoodsForm.colDiffKindIdGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
  var I : Integer;
begin
  if not TryStrToInt(AText, I) then Exit;
  if not DiffKindCDS.Active then Exit;
  if DiffKindCDS.Locate('id', I, []) then
       AText := DiffKindCDS.FieldByName('Name').AsString;
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
      ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline];
      ACanvas.TextOut(AViewInfo.Bounds.Left+ACanvas.TextWidth(copy(AText,1,K-1))+1,AViewInfo.Bounds.Top+2,S);
      ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];
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

  procedure SaveLocalGoods;
  var
    sp : TdsdStoredProc;
    ds : TClientDataSet;
    DateTime: TDateTimeInfoRec;
  begin  //+
    // pr вызываетс€ из обновлени€ остатков
    // ѕровер€ем обновл€ли ли сегодн€

    if FileExists(Goods_lcl) and FileGetDateTimeInfo(Goods_lcl, DateTime) and
      (MinutesBetween(DateTime.TimeStamp, Now) < 15) then Exit;

    sp := TdsdStoredProc.Create(nil);
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_CashGoods';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexGoods');
        WaitForSingleObject(MutexGoods, INFINITE); // только дл€ формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,Goods_lcl);
        finally
          Add_Log('End MutexGoods');
          ReleaseMutex(MutexGoods);
        end;

      finally
        ds.free;
      end;
    finally
      freeAndNil(sp);
    end;
  end;

begin

  FStyle := TcxStyle.Create(nil);

  //ѕолучение товаров
  if not gc_User.Local then SaveLocalGoods;

  if not gc_User.Local then
  begin
    try
      if CashListDiffCDS.Active then CashListDiffCDS.Close;
      spSelect_CashListDiff.Execute;
    except
      pnlLocal.Visible := True;
    end;
  end else pnlLocal.Visible := True;
  Bar.Visible := not pnlLocal.Visible;

  while ListlDiffNoSendCDS.RecordCount > 0 do ListlDiffNoSendCDS.Delete;
  WaitForSingleObject(MutexGoods, INFINITE);
  try
    if FileExists(Goods_lcl) then LoadLocalData(ListGoodsCDS, Goods_lcl);
    if not ListGoodsCDS.Active then ListGoodsCDS.Open;
  finally
    ReleaseMutex(MutexGoods);
  end;

  try
    ListGoodsCDS.DisableControls;
    FillingListGoodsCDS(False);
  finally
    ListGoodsCDS.EnableControls;
  end;

  if FileExists(DiffKind_lcl) then
  begin
    WaitForSingleObject(MutexDiffKind, INFINITE);
    try
      LoadLocalData(DiffKindCDS,DiffKind_lcl);
      if not DiffKindCDS.Active then DiffKindCDS.Open;
    finally
      ReleaseMutex(MutexDiffKind);
    end;
  end;

  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    CheckListDiffCDS;
    ListDiffCDS.Filtered := False;
    if FileExists(ListDiff_lcl) then
    begin
      if not ListDiffCDS.Active then
      begin
        DeleteLocalData(ListDiff_lcl);
        CheckListDiffCDS;
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
      end;
    end;
    FillingListlDiffNoSendCDS;
  finally
    ReleaseMutex(MutexDiffCDS);
  end;

  if ListDiffCDS.Active then
  begin
    ListDiffCDS.Filter := 'Id = ' + ListGoodsCDS.FieldByName('Id').AsString;
    ListDiffCDS.Filtered := True;
  end;

  FOldStr := '';
end;

procedure TListGoodsForm.ParentFormDestroy(Sender: TObject);
begin
  inherited;
  FStyle.Free;
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
begin

  if AReLoad and not pnlLocal.Visible then
  try
    if CashListDiffCDS.Active then CashListDiffCDS.Close;
    spSelect_CashListDiff.Execute;
    pnlLocal.Visible := False;
  except
    pnlLocal.Visible := True;
  end;

  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    if FileExists(ListDiff_lcl) then
    begin
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if not ListDiffCDS.Active then
      begin
        DeleteLocalData(ListDiff_lcl);
        CheckListDiffCDS;
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
      end;
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
  end;

  if not CashListDiffCDS.Active then Exit;

  CashListDiffCDS.First;
  while not CashListDiffCDS.Eof do
  begin

    if not ListlDiffNoSendCDS.Locate('Id', CashListDiffCDS.FieldByName('Id').AsInteger, []) then
    begin
       ListlDiffNoSendCDS.Append;
       ListlDiffNoSendCDS.FieldByName('Id').AsInteger := CashListDiffCDS.FieldByName('Id').AsInteger;
    end else ListlDiffNoSendCDS.Edit;

    ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency + CashListDiffCDS.FieldByName('AmountDiffUser').AsCurrency;
    ListlDiffNoSendCDS.FieldByName('AmoutDiff').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiff').AsCurrency + CashListDiffCDS.FieldByName('AmountDiff').AsCurrency;
    ListlDiffNoSendCDS.FieldByName('AmountDiffPrev').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmountDiffPrev').AsCurrency + CashListDiffCDS.FieldByName('AmountDiffPrev').AsCurrency;

    ListlDiffNoSendCDS.Post;
    CashListDiffCDS.Next;
  end;

  ListlDiffNoSendCDS.First;
  while not ListlDiffNoSendCDS.Eof do
  begin

    if ListGoodsCDS.Locate('Id', ListlDiffNoSendCDS.FieldByName('Id').AsInteger, []) then
    begin
      ListGoodsCDS.Edit;
      ListGoodsCDS.FieldByName('AmoutDiffUser').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency;
      ListGoodsCDS.FieldByName('AmoutDiff').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiff').AsCurrency;
      ListGoodsCDS.FieldByName('AmountDiffPrev').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmountDiffPrev').AsCurrency;
      ListGoodsCDS.Post;
    end;

    ListlDiffNoSendCDS.Next;
  end;

end;

procedure TListGoodsForm.FillingListlDiffNoSendCDS;
begin
  if not ListDiffCDS.Active then Exit;
  ListDiffCDS.First;
  while not ListDiffCDS.Eof do
  begin
    if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) and
      (not CashListDiffCDS.Active or not ListDiffCDS.FieldByName('IsSend').AsBoolean) then
    begin
      if not ListlDiffNoSendCDS.Locate('Id', ListDiffCDS.FieldByName('Id').AsInteger, []) then
      begin
         ListlDiffNoSendCDS.Append;
         ListlDiffNoSendCDS.FieldByName('Id').AsInteger := ListDiffCDS.FieldByName('Id').AsInteger;
      end else ListlDiffNoSendCDS.Edit;

      if (ListDiffCDS.FieldByName('UserID').AsString = gc_User.Session) and (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) then
        ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiffUser').AsCurrency + ListDiffCDS.FieldByName('Amount').AsCurrency;
      if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) then
        ListlDiffNoSendCDS.FieldByName('AmoutDiff').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmoutDiff').AsCurrency + ListDiffCDS.FieldByName('Amount').AsCurrency;
      if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = IncDay(Date, - 1)) then
        ListlDiffNoSendCDS.FieldByName('AmountDiffPrev').AsCurrency := ListlDiffNoSendCDS.FieldByName('AmountDiffPrev').AsCurrency + ListDiffCDS.FieldByName('Amount').AsCurrency;

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
