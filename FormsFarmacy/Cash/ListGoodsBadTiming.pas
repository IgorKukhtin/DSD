unit ListGoodsBadTiming;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, Math,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox, cxNavigator, RegularExpressions, dxDateRanges,
  System.Actions;

type
  TListGoodsBadTimingForm = class(TAncestorBaseForm)
    ListGoodsBadTimingGrid: TcxGrid;
    ListGoodsBadTimingGridDBTableView: TcxGridDBTableView;
    ListGoodsBadTimingGridLevel: TcxGridLevel;
    ListGoodsBadTimingDS: TDataSource;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountSend: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ListGoodsBadTimingCDS: TClientDataSet;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    actSend: TAction;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    spListGoodsBadTiming: TdsdStoredProc;
    ExpirationDate: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    AmountCheck: TcxGridDBColumn;
    SummaCheck: TcxGridDBColumn;
    actClear: TAction;
    bbClear: TdxBarButton;
    actExportExel: TdsdGridToExcel;
    bbExportExel: TdxBarButton;
    actAddOne: TAction;
    DBViewAddOn: TdsdDBViewAddOn;
    AmountReserve: TcxGridDBColumn;
    CheckList: TcxGridDBColumn;
    procedure ListGoodsBadTimingCDSBeforePost(DataSet: TDataSet);
    procedure ParentFormDestroy(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure ListGoodsBadTimingCDSAfterOpen(DataSet: TDataSet);
    procedure actAddOneExecute(Sender: TObject);
    procedure actSendExecute(Sender: TObject);
  private
    { Private declarations }
    FIsLoad : boolean;
  public
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;

procedure TListGoodsBadTimingForm.actAddOneExecute(Sender: TObject);
begin
  if ListGoodsBadTimingCDS.FieldByName('Remains').AsCurrency > ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency then
  begin
    ListGoodsBadTimingCDS.Edit;
    ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency := ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency +
      Min(1, ListGoodsBadTimingCDS.FieldByName('Remains').AsCurrency - ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency);
    ListGoodsBadTimingCDS.Post;
  end;
end;

procedure TListGoodsBadTimingForm.actClearExecute(Sender: TObject);
  var nPos : integer;
begin
  inherited;
  ListGoodsBadTimingCDS.DisableControls;
  nPos := ListGoodsBadTimingCDS.RecNo;
  try
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency <> 0 then
      begin
        ListGoodsBadTimingCDS.Edit;
        ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency := 0;
        ListGoodsBadTimingCDS.Post;
      end;
      ListGoodsBadTimingCDS.Next;
    end;
  finally
    ListGoodsBadTimingCDS.RecNo := nPos;
    ListGoodsBadTimingCDS.EnableControls;
    if FileExists(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat') then DeleteFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
  end;
end;

procedure TListGoodsBadTimingForm.actSendExecute(Sender: TObject);
  var nPos, nRecNo : integer;
begin
  inherited;
  MainCashForm.ClearAll;

  // Проверим наличие
  ListGoodsBadTimingCDS.DisableControls;
  nRecNo := MainCashForm.RemainsCDS.RecNo;
  MainCashForm.RemainsCDS.DisableControls;
  MainCashForm.RemainsCDS.Filtered := false;
  nPos := ListGoodsBadTimingCDS.RecNo;
  try
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
      begin
        if (ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > ListGoodsBadTimingCDS.FieldByName('Remains').AsCurrency) then
        begin
          ShowMessage('Товар <' + ListGoodsBadTimingCDS.FieldByName('GoodsName').AsString + '> выбрано больше чем есть в наличии...');
          Exit;
        end;

        if (ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > (ListGoodsBadTimingCDS.FieldByName('Remains').AsCurrency -
          ListGoodsBadTimingCDS.FieldByName('AmountSend').AsCurrency - ListGoodsBadTimingCDS.FieldByName('AmountReserve').AsCurrency)) then
        begin
          if ListGoodsBadTimingCDS.FieldByName('AmountSend').AsCurrency > 0 then
            ShowMessage('Товар <' + ListGoodsBadTimingCDS.FieldByName('GoodsName').AsString + '> отложен в перемещении на склад отложки. Необходимо снять его отложку...')
          else ShowMessage('Товар <' + ListGoodsBadTimingCDS.FieldByName('GoodsName').AsString + '> отложен в чеках ' +
          ListGoodsBadTimingCDS.FieldByName('CheckList').AsString + '. Необходимо убрать из чеков...');
          Exit;
        end;

        if not MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                  VarArrayOf([ListGoodsBadTimingCDS.FieldByName('Id').AsInteger,
                              ListGoodsBadTimingCDS.FieldByName('PartionDateKindId').AsVariant,
                              ListGoodsBadTimingCDS.FieldByName('NDSKindId').AsVariant,
                              ListGoodsBadTimingCDS.FieldByName('DiscountExternalID').AsVariant,
                              ListGoodsBadTimingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
          ShowMessage('Товар <' + ListGoodsBadTimingCDS.FieldByName('GoodsName').AsString + '> Не найден в товарах для продажи...');
          Exit;
        end else if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > MainCashForm.RemainsCDS.FieldByName('Remains').AsCurrency then
        begin
          ShowMessage('Товар <' + ListGoodsBadTimingCDS.FieldByName('GoodsName').AsString + '> выбрано больше чем в кассе проверьте возмодно он отложен...');
          Exit;
        end;
      end;

      ListGoodsBadTimingCDS.Next;
    end;
  finally
    MainCashForm.RemainsCDS.Filtered := True;
    MainCashForm.RemainsCDS.RecNo := nRecNo;
    MainCashForm.RemainsCDS.EnableControls;
    ListGoodsBadTimingCDS.RecNo := nPos;
    ListGoodsBadTimingCDS.EnableControls;
  end;

  // Опустим в кассу
  ListGoodsBadTimingCDS.DisableControls;
  nPos := ListGoodsBadTimingCDS.RecNo;
  try
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin

      if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
      begin
        if MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
              VarArrayOf([ListGoodsBadTimingCDS.FieldByName('Id').AsInteger,
                          ListGoodsBadTimingCDS.FieldByName('PartionDateKindId').AsVariant,
                          ListGoodsBadTimingCDS.FieldByName('NDSKindId').AsVariant,
                          ListGoodsBadTimingCDS.FieldByName('DiscountExternalID').AsVariant,
                          ListGoodsBadTimingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
           MainCashForm.SoldRegim := True;
           MainCashForm.edAmount.Text := ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsString;
           MainCashForm.actInsertUpdateCheckItemsExecute(Sender);
        end;
      end;

      ListGoodsBadTimingCDS.Next;
    end;

    MainCashForm.FormParams.ParamByName('isCorrectMarketing').Value := True;
    actClearExecute(Sender);
    MainCashForm.pnlInfo.Visible := True;
    MainCashForm.lblInfo.Caption := 'Корректировка суммы маркетинга в ЗП по подразделению';
    Close;
  finally
    ListGoodsBadTimingCDS.RecNo := nPos;
    ListGoodsBadTimingCDS.EnableControls;
  end;


end;

procedure TListGoodsBadTimingForm.ListGoodsBadTimingCDSAfterOpen(
  DataSet: TDataSet);
  var List : TStringList; I, nRecNo : Integer; Res: TArray<string>;

  function StrToVar(AStr : String) : Variant;
  begin
    if AStr = '' then Result := Null
    else Result := StrToInt(AStr);
  end;

begin
  inherited;

  try
    nRecNo := MainCashForm.RemainsCDS.RecNo;
    MainCashForm.RemainsCDS.DisableControls;
    MainCashForm.RemainsCDS.Filtered := false;
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                VarArrayOf([ListGoodsBadTimingCDS.FieldByName('Id').AsInteger,
                            ListGoodsBadTimingCDS.FieldByName('PartionDateKindId').AsVariant,
                            ListGoodsBadTimingCDS.FieldByName('NDSKindId').AsVariant,
                            ListGoodsBadTimingCDS.FieldByName('DiscountExternalID').AsVariant,
                            ListGoodsBadTimingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
      begin
        ListGoodsBadTimingCDS.Edit;
        if MainCashForm.RemainsCDS.FieldByName('PricePartionDate').AsCurrency = 0 then
          ListGoodsBadTimingCDS.FieldByName('Price').AsVariant := MainCashForm.RemainsCDS.FieldByName('Price').AsVariant
        else ListGoodsBadTimingCDS.FieldByName('Price').AsVariant := MainCashForm.RemainsCDS.FieldByName('PricePartionDate').AsVariant;
        ListGoodsBadTimingCDS.Post;
      end;
      ListGoodsBadTimingCDS.Next;
    end;
  finally
    MainCashForm.RemainsCDS.Filtered := True;
    MainCashForm.RemainsCDS.RecNo := nRecNo;
    MainCashForm.RemainsCDS.EnableControls;
  end;

  if MainCashForm.FormParams.ParamByName('isCorrectMarketing').Value then
  begin
    try
      nRecNo := MainCashForm.CheckCDS.RecNo;
      MainCashForm.CheckCDS.DisableControls;
      MainCashForm.CheckCDS.First;
      while not MainCashForm.CheckCDS.Eof do
      begin
        if ListGoodsBadTimingCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                  VarArrayOf([MainCashForm.CheckCDS.FieldByName('GoodsId').AsInteger,
                              MainCashForm.CheckCDS.FieldByName('PartionDateKindId').AsVariant,
                              MainCashForm.CheckCDS.FieldByName('NDSKindId').AsVariant,
                              MainCashForm.CheckCDS.FieldByName('DiscountExternalID').AsVariant,
                              MainCashForm.CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
          ListGoodsBadTimingCDS.Edit;
          ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsVariant := MainCashForm.CheckCDS.FieldByName('Amount').AsVariant;
          ListGoodsBadTimingCDS.Post;
        end;
        MainCashForm.CheckCDS.Next;
      end;
    finally
      ListGoodsBadTimingCDS.First;
      MainCashForm.CheckCDS.RecNo := nRecNo;
      MainCashForm.CheckCDS.EnableControls;
    end;

  end else
  begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat') then Exit;
    List := TStringList.Create;
    ListGoodsBadTimingCDS.DisableControls;
    try
      FIsLoad := True;
      List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
      for I := 0 to List.Count - 1 do
      begin
         Res := TRegEx.Split(List.Strings[I], ';');
         if High(Res) <> 5 then Continue;
         if ListGoodsBadTimingCDS.Locate('ID;PartionDateKindId;DivisionPartiesID;DiscountExternalID;NDSKindId',
            VarArrayOf([StrToInt(Res[0]), StrToVar(Res[2]), StrToVar(Res[3]), StrToVar(Res[4]), StrToVar(Res[5])]), []) then
         begin
           ListGoodsBadTimingCDS.Edit;
           ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency := Min(ListGoodsBadTimingCDS.FieldByName('Remains').AsCurrency, StrToCurr(Res[1]));
           ListGoodsBadTimingCDS.Post;
         end;
      end;
    finally
      FIsLoad := False;
      ListGoodsBadTimingCDS.First;
      ListGoodsBadTimingCDS.EnableControls;
      List.Free;
    end;
  end;
end;

procedure TListGoodsBadTimingForm.ListGoodsBadTimingCDSBeforePost(
  DataSet: TDataSet);
begin
  inherited;

  if not FIsLoad then
  begin
    if Dataset['AmountCheck'] > Dataset['Remains'] then
    begin
      raise Exception.Create('Количество больше остатка...');
      Exit;
    end;

    if Dataset['AmountCheck'] < 0 then
    begin
      raise Exception.Create('Количество больше или равно 0...');
      Exit;
    end;

    if Dataset['AmountCheck'] > (Dataset['Remains'] - Dataset['AmountSend'] - Dataset['AmountReserve']) then
    begin
      if Dataset['AmountSend'] > 0 then
        ShowMessage('Товар отложен в перемещении на склад отложки перед опуском надо будет отменить отложку...')
      else ShowMessage('Товар отложен в чеках ' + Dataset['CheckList']  + ' перед опуском необходимо убрать из чеков...');
    end;
  end;

  Dataset['SummaCheck'] := Dataset['Price'] * Dataset['AmountCheck'];
end;

procedure TListGoodsBadTimingForm.ParentFormDestroy(Sender: TObject);
  var List : TStringList;
begin
  inherited;

  List := TStringList.Create;
  ListGoodsBadTimingCDS.DisableControls;
  try
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
        List.Add(ListGoodsBadTimingCDS.FieldByName('Id').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('PartionDateKindId').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('DivisionPartiesId').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('DiscountExternalID').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('NDSKindId').AsString);
      ListGoodsBadTimingCDS.Next;
    end;
  finally
    ListGoodsBadTimingCDS.EnableControls;
    if List.Count > 0 then List.SaveToFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
    List.Free;
  end;
end;

initialization
  RegisterClass(TListGoodsBadTimingForm);


End.
