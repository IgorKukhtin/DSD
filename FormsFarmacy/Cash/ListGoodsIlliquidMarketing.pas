unit ListGoodsIlliquidMarketing;

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
  TListGoodsIlliquidMarketingForm = class(TAncestorBaseForm)
    ListGoodsIlliquidMarketingGrid: TcxGrid;
    ListGoodsIlliquidMarketingGridDBTableView: TcxGridDBTableView;
    ListGoodsIlliquidMarketingGridLevel: TcxGridLevel;
    ListGoodsIlliquidMarketingDS: TDataSource;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountSend: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ListGoodsIlliquidMarketingCDS: TClientDataSet;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    actSend: TAction;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    spListGoodsIlliquidMarketing: TdsdStoredProc;
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
    FormParams: TdsdFormParams;
    dxBarContainerItem1: TdxBarContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    edMarketing: TcxCurrencyEdit;
    Label12: TLabel;
    actCheckSumm: TAction;
    procedure ListGoodsIlliquidMarketingCDSBeforePost(DataSet: TDataSet);
    procedure ParentFormDestroy(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure ListGoodsIlliquidMarketingCDSAfterOpen(DataSet: TDataSet);
    procedure actAddOneExecute(Sender: TObject);
    procedure actSendExecute(Sender: TObject);
    procedure actCheckSummExecute(Sender: TObject);
  private
    { Private declarations }
    FIsLoad : boolean;
  public
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;

procedure TListGoodsIlliquidMarketingForm.actAddOneExecute(Sender: TObject);
begin
  if ListGoodsIlliquidMarketingCDS.FieldByName('Remains').AsCurrency > ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency then
  begin
    ListGoodsIlliquidMarketingCDS.Edit;
    ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency := ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency +
      Min(1, ListGoodsIlliquidMarketingCDS.FieldByName('Remains').AsCurrency - ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency);
    ListGoodsIlliquidMarketingCDS.Post;
  end;
end;

procedure TListGoodsIlliquidMarketingForm.actCheckSummExecute(Sender: TObject);
begin
  inherited;

  if FormParams.ParamByName('IlliquidAssets').Value >= 0 then
    raise Exception.Create('Погашение чеками можно только на сумму штрафа...');

end;

procedure TListGoodsIlliquidMarketingForm.actClearExecute(Sender: TObject);
  var nPos : integer;
begin
  inherited;
  ListGoodsIlliquidMarketingCDS.DisableControls;
  nPos := ListGoodsIlliquidMarketingCDS.RecNo;
  try
    ListGoodsIlliquidMarketingCDS.First;
    while not ListGoodsIlliquidMarketingCDS.Eof do
    begin
      if ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency <> 0 then
      begin
        ListGoodsIlliquidMarketingCDS.Edit;
        ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency := 0;
        ListGoodsIlliquidMarketingCDS.Post;
      end;
      ListGoodsIlliquidMarketingCDS.Next;
    end;
  finally
    ListGoodsIlliquidMarketingCDS.RecNo := nPos;
    ListGoodsIlliquidMarketingCDS.EnableControls;
    if FileExists(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat') then DeleteFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
  end;
end;

procedure TListGoodsIlliquidMarketingForm.actSendExecute(Sender: TObject);
  var nPos, nRecNo : integer;
begin
  inherited;
  MainCashForm.ClearAll;

  // Проверим наличие
  ListGoodsIlliquidMarketingCDS.DisableControls;
  nRecNo := MainCashForm.RemainsCDS.RecNo;
  MainCashForm.RemainsCDS.DisableControls;
  MainCashForm.RemainsCDS.Filtered := false;
  nPos := ListGoodsIlliquidMarketingCDS.RecNo;
  try
    ListGoodsIlliquidMarketingCDS.First;
    while not ListGoodsIlliquidMarketingCDS.Eof do
    begin
      if ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
      begin
        if (ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency > ListGoodsIlliquidMarketingCDS.FieldByName('Remains').AsCurrency) then
        begin
          ShowMessage('Товар <' + ListGoodsIlliquidMarketingCDS.FieldByName('GoodsName').AsString + '> выбрано больше чем есть в наличии...');
          Exit;
        end;

        if (ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency > (ListGoodsIlliquidMarketingCDS.FieldByName('Remains').AsCurrency -
          ListGoodsIlliquidMarketingCDS.FieldByName('AmountSend').AsCurrency - ListGoodsIlliquidMarketingCDS.FieldByName('AmountReserve').AsCurrency)) then
        begin
          if ListGoodsIlliquidMarketingCDS.FieldByName('AmountSend').AsCurrency > 0 then
            ShowMessage('Товар <' + ListGoodsIlliquidMarketingCDS.FieldByName('GoodsName').AsString + '> отложен в перемещении на склад отложки. Необходимо снять его отложку...')
          else ShowMessage('Товар <' + ListGoodsIlliquidMarketingCDS.FieldByName('GoodsName').AsString + '> отложен в чеках ' +
          ListGoodsIlliquidMarketingCDS.FieldByName('CheckList').AsString + '. Необходимо убрать из чеков...');
          Exit;
        end;

        if not MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                  VarArrayOf([ListGoodsIlliquidMarketingCDS.FieldByName('Id').AsInteger,
                              ListGoodsIlliquidMarketingCDS.FieldByName('PartionDateKindId').AsVariant,
                              ListGoodsIlliquidMarketingCDS.FieldByName('NDSKindId').AsVariant,
                              ListGoodsIlliquidMarketingCDS.FieldByName('DiscountExternalID').AsVariant,
                              ListGoodsIlliquidMarketingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
          ShowMessage('Товар <' + ListGoodsIlliquidMarketingCDS.FieldByName('GoodsName').AsString + '> Не найден в товарах для продажи...');
          Exit;
        end else if ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency > MainCashForm.RemainsCDS.FieldByName('Remains').AsCurrency then
        begin
          ShowMessage('Товар <' + ListGoodsIlliquidMarketingCDS.FieldByName('GoodsName').AsString + '> выбрано больше чем в кассе проверьте возмодно он отложен...');
          Exit;
        end;
      end;

      ListGoodsIlliquidMarketingCDS.Next;
    end;
  finally
    MainCashForm.RemainsCDS.Filtered := True;
    MainCashForm.RemainsCDS.RecNo := nRecNo;
    MainCashForm.RemainsCDS.EnableControls;
    ListGoodsIlliquidMarketingCDS.RecNo := nPos;
    ListGoodsIlliquidMarketingCDS.EnableControls;
  end;

  // Опустим в кассу
  ListGoodsIlliquidMarketingCDS.DisableControls;
  nPos := ListGoodsIlliquidMarketingCDS.RecNo;
  try
    ListGoodsIlliquidMarketingCDS.First;
    while not ListGoodsIlliquidMarketingCDS.Eof do
    begin

      if ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
      begin
        if MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
              VarArrayOf([ListGoodsIlliquidMarketingCDS.FieldByName('Id').AsInteger,
                          ListGoodsIlliquidMarketingCDS.FieldByName('PartionDateKindId').AsVariant,
                          ListGoodsIlliquidMarketingCDS.FieldByName('NDSKindId').AsVariant,
                          ListGoodsIlliquidMarketingCDS.FieldByName('DiscountExternalID').AsVariant,
                          ListGoodsIlliquidMarketingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
           MainCashForm.SoldRegim := True;
           MainCashForm.edAmount.Text := ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsString;
           MainCashForm.actInsertUpdateCheckItemsExecute(Sender);
        end;
      end;

      ListGoodsIlliquidMarketingCDS.Next;
    end;

    MainCashForm.FormParams.ParamByName('isCorrectIlliquidAssets').Value := True;
    actClearExecute(Sender);
    MainCashForm.pnlInfo.Visible := True;
    MainCashForm.lblInfo.Caption := 'Корректировка суммы неликвидов в ЗП по сотруднику';
    if ((RoundTo(ListGoodsIlliquidMarketingGridDBTableView.DataController.Summary.FooterSummaryValues[ListGoodsIlliquidMarketingGridDBTableView.DataController.Summary.FooterSummaryItems.IndexOfItemLink(SummaCheck)], -2) +
      edMarketing.Value) >= 0) then ShowMessage('Достигнут 0 в сумме штрафа по неликвидам.');
    Close;
  finally
    ListGoodsIlliquidMarketingCDS.RecNo := nPos;
    ListGoodsIlliquidMarketingCDS.EnableControls;
  end;


end;

procedure TListGoodsIlliquidMarketingForm.ListGoodsIlliquidMarketingCDSAfterOpen(
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
    ListGoodsIlliquidMarketingCDS.First;
    while not ListGoodsIlliquidMarketingCDS.Eof do
    begin
      if MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                VarArrayOf([ListGoodsIlliquidMarketingCDS.FieldByName('Id').AsInteger,
                            ListGoodsIlliquidMarketingCDS.FieldByName('PartionDateKindId').AsVariant,
                            ListGoodsIlliquidMarketingCDS.FieldByName('NDSKindId').AsVariant,
                            ListGoodsIlliquidMarketingCDS.FieldByName('DiscountExternalID').AsVariant,
                            ListGoodsIlliquidMarketingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
      begin
        ListGoodsIlliquidMarketingCDS.Edit;
        if MainCashForm.RemainsCDS.FieldByName('PricePartionDate').AsCurrency = 0 then
          ListGoodsIlliquidMarketingCDS.FieldByName('Price').AsVariant := MainCashForm.RemainsCDS.FieldByName('Price').AsVariant
        else ListGoodsIlliquidMarketingCDS.FieldByName('Price').AsVariant := MainCashForm.RemainsCDS.FieldByName('PricePartionDate').AsVariant;
        ListGoodsIlliquidMarketingCDS.Post;
      end;
      ListGoodsIlliquidMarketingCDS.Next;
    end;
  finally
    MainCashForm.RemainsCDS.Filtered := True;
    MainCashForm.RemainsCDS.RecNo := nRecNo;
    MainCashForm.RemainsCDS.EnableControls;
  end;

  if MainCashForm.FormParams.ParamByName('isCorrectIlliquidAssets').Value then
  begin
    try
      nRecNo := MainCashForm.CheckCDS.RecNo;
      MainCashForm.CheckCDS.DisableControls;
      MainCashForm.CheckCDS.First;
      while not MainCashForm.CheckCDS.Eof do
      begin
        if ListGoodsIlliquidMarketingCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                  VarArrayOf([MainCashForm.CheckCDS.FieldByName('GoodsId').AsInteger,
                              MainCashForm.CheckCDS.FieldByName('PartionDateKindId').AsVariant,
                              MainCashForm.CheckCDS.FieldByName('NDSKindId').AsVariant,
                              MainCashForm.CheckCDS.FieldByName('DiscountExternalID').AsVariant,
                              MainCashForm.CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
          ListGoodsIlliquidMarketingCDS.Edit;
          ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsVariant := MainCashForm.CheckCDS.FieldByName('Amount').AsVariant;
          ListGoodsIlliquidMarketingCDS.Post;
        end;
        MainCashForm.CheckCDS.Next;
      end;
    finally
      ListGoodsIlliquidMarketingCDS.First;
      MainCashForm.CheckCDS.RecNo := nRecNo;
      MainCashForm.CheckCDS.EnableControls;
    end;

  end else
  begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat') then Exit;
    List := TStringList.Create;
    ListGoodsIlliquidMarketingCDS.DisableControls;
    try
      FIsLoad := True;
      List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
      for I := 0 to List.Count - 1 do
      begin
         Res := TRegEx.Split(List.Strings[I], ';');
         if High(Res) <> 5 then Continue;
         if ListGoodsIlliquidMarketingCDS.Locate('ID;PartionDateKindId;DivisionPartiesID;DiscountExternalID;NDSKindId',
            VarArrayOf([StrToInt(Res[0]), StrToVar(Res[2]), StrToVar(Res[3]), StrToVar(Res[4]), StrToVar(Res[5])]), []) then
         begin
           ListGoodsIlliquidMarketingCDS.Edit;
           ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency := Min(ListGoodsIlliquidMarketingCDS.FieldByName('Remains').AsCurrency, StrToCurr(Res[1]));
           ListGoodsIlliquidMarketingCDS.Post;
         end;
      end;
    finally
      FIsLoad := False;
      ListGoodsIlliquidMarketingCDS.First;
      ListGoodsIlliquidMarketingCDS.EnableControls;
      List.Free;
    end;
  end;
end;

procedure TListGoodsIlliquidMarketingForm.ListGoodsIlliquidMarketingCDSBeforePost(
  DataSet: TDataSet);
begin
  inherited;

  if Dataset['AmountCheck'] = Null then Dataset['AmountCheck'] := 0;

  if Dataset['AmountCheck'] < 0 then
  begin
    raise Exception.Create('Количество должно быть положительное...');
    Exit;
  end;

  if not FIsLoad and (Dataset['AmountCheck'] > 0) then
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

  Dataset['SummaCheck'] := GetSumm(Dataset['AmountCheck'], Dataset['Price'] ,
                           MainCashForm.FormParams.ParamByName('RoundingDown').Value);
end;

procedure TListGoodsIlliquidMarketingForm.ParentFormDestroy(Sender: TObject);
  var List : TStringList;
begin
  inherited;

  if not ListGoodsIlliquidMarketingCDS.Active then Exit;

  List := TStringList.Create;
  ListGoodsIlliquidMarketingCDS.DisableControls;
  try
    ListGoodsIlliquidMarketingCDS.First;
    while not ListGoodsIlliquidMarketingCDS.Eof do
    begin
      if ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
        List.Add(ListGoodsIlliquidMarketingCDS.FieldByName('Id').AsString + ';' +
                 ListGoodsIlliquidMarketingCDS.FieldByName('AmountCheck').AsString + ';' +
                 ListGoodsIlliquidMarketingCDS.FieldByName('PartionDateKindId').AsString + ';' +
                 ListGoodsIlliquidMarketingCDS.FieldByName('DivisionPartiesId').AsString + ';' +
                 ListGoodsIlliquidMarketingCDS.FieldByName('DiscountExternalID').AsString + ';' +
                 ListGoodsIlliquidMarketingCDS.FieldByName('NDSKindId').AsString);
      ListGoodsIlliquidMarketingCDS.Next;
    end;
  finally
    ListGoodsIlliquidMarketingCDS.EnableControls;
    if List.Count > 0 then List.SaveToFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
    List.Free;
  end;
end;

initialization
  RegisterClass(TListGoodsIlliquidMarketingForm);


End.
