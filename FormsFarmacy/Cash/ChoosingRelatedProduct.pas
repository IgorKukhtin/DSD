unit ChoosingRelatedProduct;

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
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions,
  cxMemo;

type
  TChoosingRelatedProductForm = class(TForm)
    ChoosingRelatedProductGrid: TcxGrid;
    ChoosingRelatedProductGridDBTableView: TcxGridDBTableView;
    ChoosingRelatedProductGridLevel: TcxGridLevel;
    ChoosingRelatedProductDS: TDataSource;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    ChoosingRelatedProductCDS: TClientDataSet;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    spSelect: TdsdStoredProc;
    colRemains: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    dxBarButton3: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actOk: TAction;
    dxBarButton4: TdxBarButton;
    plMessage: TPanel;
    RelatedProductCDS: TClientDataSet;
    RelatedProductListCDS: TClientDataSet;
    ChoosingRelatedProductCDSGoodsId: TIntegerField;
    ChoosingRelatedProductCDSGoodsCode: TIntegerField;
    ChoosingRelatedProductCDSGoodsName: TStringField;
    ChoosingRelatedProductCDSRemains: TCurrencyField;
    ChoosingRelatedProductCDSAmount: TCurrencyField;
    ChoosingRelatedProductCDSPrice: TCurrencyField;
    ChoosingRelatedProductCDSNDSKindId: TIntegerField;
    ChoosingRelatedProductCDSDivisionPartiesID: TIntegerField;
    ChoosingRelatedProductCDSPartionDateKindId: TIntegerField;
    ChoosingRelatedProductCDSDiscountExternalID: TIntegerField;
    mMessage: TcxMemo;
    procedure actOkExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChoosingRelatedProductGridDBTableViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAmount : Currency;
  public
    function SetRelatedProduct (ARelatedProductId : Integer; ARelatedProductPrice : Currency) : boolean;
    property Amount : Currency read FAmount write FAmount;
  end;


implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, MainCash2;


procedure TChoosingRelatedProductForm.actOkExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TChoosingRelatedProductForm.ChoosingRelatedProductGridDBTableViewDblClick(
  Sender: TObject);
begin
  if ChoosingRelatedProductCDS.IsEmpty then Exit;
  ChoosingRelatedProductCDS.Edit;
  ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency := ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency + 1;
  ChoosingRelatedProductCDS.Post
end;

procedure TChoosingRelatedProductForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult <> mrOk then Exit;
  ChoosingRelatedProductCDS.First;
  while not ChoosingRelatedProductCDS.Eof do
  begin
    if ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency < 0 then
    begin
      ShowMessage('¬ыбранное количество должно быть положительное.');
      Action := caNone;
      Exit;
    end;
    if ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency > ChoosingRelatedProductCDS.FieldByName('Remains').AsCurrency then
    begin
      ShowMessage('¬ыбранное количество превышает остаток.');
      Action := caNone;
      Exit;
    end;
    ChoosingRelatedProductCDS.Next;
  end;
end;

procedure TChoosingRelatedProductForm.FormCreate(Sender: TObject);
begin
  mMessage.Style.Font.Size := mMessage.Style.Font.Size + 4;

  if not gc_User.Local then
  begin
    try
      spSelect.Execute;
      SaveLocalData(RelatedProductCDS, ExtractFilePath(Application.ExeName) + 'RelatedProduct.local');
      SaveLocalData(RelatedProductListCDS, ExtractFilePath(Application.ExeName) + 'RelatedProductList.local');
    except
    end;
  end;

  if not RelatedProductCDS.Active then
  begin
    if FileExists(ExtractFilePath(Application.ExeName) + 'RelatedProduct.local') then
    begin
      try
        LoadLocalData(RelatedProductCDS, ExtractFilePath(Application.ExeName) + 'RelatedProduct.local');
        if not RelatedProductCDS.Active then RelatedProductCDS.Open;
      finally
      end;
    end;
  end;

  if not RelatedProductListCDS.Active then
  begin
    if FileExists(ExtractFilePath(Application.ExeName) + 'RelatedProductList.local') then
    begin
      try
        LoadLocalData(RelatedProductListCDS, ExtractFilePath(Application.ExeName) + 'RelatedProductList.local');
        if not RelatedProductListCDS.Active then RelatedProductListCDS.Open;
      finally
      end;
    end;
  end;

end;

procedure TChoosingRelatedProductForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_SPACE) {or (Key = VK_ADD)}) AND (Shift = []) then
  Begin
    if ChoosingRelatedProductCDS.IsEmpty then Exit;
    ChoosingRelatedProductCDS.Edit;
    ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency := ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency + 1;
    ChoosingRelatedProductCDS.Post
  End;
//  if (Key = VK_SUBTRACT) AND (Shift = []) then
//  Begin
//    if ChoosingRelatedProductCDS.IsEmpty then Exit;
//    if ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency >= 1 then
//    begin
//      ChoosingRelatedProductCDS.Edit;
//      ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency := ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency - 1;
//      ChoosingRelatedProductCDS.Post
//    end;
//  End;
end;

function TChoosingRelatedProductForm.SetRelatedProduct (ARelatedProductId : Integer; ARelatedProductPrice : Currency) : boolean;
  var nID : Integer; cFilter : string;
begin
  Result := False;
  if not RelatedProductCDS.Active or not RelatedProductListCDS.Active then Exit;
  if not RelatedProductCDS.Locate('Id', ARelatedProductId, []) then Exit;
  if ARelatedProductPrice < RelatedProductCDS.FieldByName('PriceMin').AsCurrency then Exit;

  mMessage.Lines.Text := RelatedProductCDS.FieldByName('Message').AsString;

  RelatedProductListCDS.Filter := 'MovementId = ' + IntToStr(ARelatedProductId);
  RelatedProductListCDS.Filtered := True;

  nID := MainCashForm.CheckCDS.RecNo;
  try
    MainCashForm.CheckCDS.DisableControls;
    RelatedProductListCDS.First;
    while not RelatedProductListCDS.Eof do
    begin
      if MainCashForm.CheckCDS.Locate('GoodsId', RelatedProductListCDS.FieldByName('GoodsId').AsInteger, []) then Exit;

      RelatedProductListCDS.Next;
    end;

  finally
    MainCashForm.CheckCDS.RecNo := nID;
    MainCashForm.CheckCDS.EnableControls;
  end;

  nID := MainCashForm.RemainsCDS.RecNo;
  cFilter := MainCashForm.RemainsCDS.Filter;
  try
    MainCashForm.RemainsCDS.DisableControls;

    RelatedProductListCDS.First;
    while not RelatedProductListCDS.Eof do
    begin

      MainCashForm.RemainsCDS.Filtered := false;
      MainCashForm.RemainsCDS.Filter := 'Remains <> 0 and Id = ' + RelatedProductListCDS.FieldByName('GoodsId').AsString;
      MainCashForm.RemainsCDS.Filtered := True;
      MainCashForm.RemainsCDS.First;
      while not MainCashForm.RemainsCDS.Eof do
      begin

        ChoosingRelatedProductCDS.Last;
        ChoosingRelatedProductCDS.Append;
        ChoosingRelatedProductCDS.FieldByName('GoodsId').AsInteger := MainCashForm.RemainsCDS.FieldByName('Id').AsInteger;
        ChoosingRelatedProductCDS.FieldByName('GoodsCode').AsInteger := MainCashForm.RemainsCDS.FieldByName('GoodsCode').AsInteger;
        ChoosingRelatedProductCDS.FieldByName('GoodsName').AsString := MainCashForm.RemainsCDS.FieldByName('GoodsName').AsString;
        ChoosingRelatedProductCDS.FieldByName('Remains').AsCurrency := MainCashForm.RemainsCDS.FieldByName('Remains').AsCurrency;
        ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency := 0;
        ChoosingRelatedProductCDS.FieldByName('Price').AsCurrency := MainCashForm.RemainsCDS.FieldByName('Price').AsCurrency;

        ChoosingRelatedProductCDS.FieldByName('NDSKindId').AsVariant := MainCashForm.RemainsCDS.FieldByName('NDSKindId').AsVariant;
        ChoosingRelatedProductCDS.FieldByName('DivisionPartiesID').AsVariant := MainCashForm.RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
        ChoosingRelatedProductCDS.FieldByName('PartionDateKindId').AsVariant := MainCashForm.RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
        ChoosingRelatedProductCDS.FieldByName('DiscountExternalID').AsVariant := MainCashForm.RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
        ChoosingRelatedProductCDS.Post;

        MainCashForm.RemainsCDS.Next;
      end;

      RelatedProductListCDS.Next;
    end;

  finally
    MainCashForm.RemainsCDS.Filter := cFilter;
    MainCashForm.RemainsCDS.Filtered := True;
    MainCashForm.RemainsCDS.RecNo := nID;
    MainCashForm.RemainsCDS.EnableControls;
  end;

  Result := ChoosingRelatedProductCDS.RecordCount > 0;
end;


End.
