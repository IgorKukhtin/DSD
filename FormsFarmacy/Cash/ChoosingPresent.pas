unit ChoosingPresent;

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
  dxDateRanges;

type
  TChoosingPresentForm = class(TForm)
    ChoosingPresentGrid: TcxGrid;
    ChoosingPresentGridDBTableView: TcxGridDBTableView;
    ChoosingPresentGridLevel: TcxGridLevel;
    ChoosingPresentDS: TDataSource;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    ChoosingPresentCDS: TClientDataSet;
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
    Label10: TLabel;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actOk: TAction;
    dxBarButton4: TdxBarButton;
    procedure actOkExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChoosingPresentGridDBTableViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FAmount : Currency;
  public
    property Amount : Currency read FAmount write FAmount;
  end;


implementation

{$R *.dfm}

uses CommonData;


procedure TChoosingPresentForm.actOkExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TChoosingPresentForm.ChoosingPresentGridDBTableViewDblClick(
  Sender: TObject);
begin
  if ChoosingPresentCDS.IsEmpty then Exit;
  ChoosingPresentCDS.Edit;
  ChoosingPresentCDS.FieldByName('Amount').AsCurrency := ChoosingPresentCDS.FieldByName('Amount').AsCurrency + 1;
  ChoosingPresentCDS.Post
end;

procedure TChoosingPresentForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var nAmount, nRemains : Currency;
begin
  if ModalResult <> mrOk then Exit;
  nAmount := 0; nRemains := 0;
  ChoosingPresentCDS.First;
  while not ChoosingPresentCDS.Eof do
  begin
    if ChoosingPresentCDS.FieldByName('Amount').AsCurrency < 0 then
    begin
      ShowMessage('¬ыбранное количество должно быть положительное.');
      Action := caNone;
      Exit;
    end;
    if ChoosingPresentCDS.FieldByName('Amount').AsCurrency > ChoosingPresentCDS.FieldByName('Remains').AsCurrency then
    begin
      ShowMessage('¬ыбранное количество превышает остаток.');
      Action := caNone;
      Exit;
    end;
    nRemains := nRemains + ChoosingPresentCDS.FieldByName('Remains').AsCurrency;
    nAmount := nAmount + ChoosingPresentCDS.FieldByName('Amount').AsCurrency;
    ChoosingPresentCDS.Next;
  end;

  if nAmount > Amount then
  begin
    ShowMessage('¬ыбрано больше товара чем нужно по промокоду.');

    Action := caNone;
  end else if (nAmount < Amount) and (nRemains > Amount) then
  begin
    if Amount > nRemains then ShowMessage('¬ыбирите весь товар дл€ вставки в документ.')
    else ShowMessage(Label10.Caption);
    Action := caNone;
  end;
end;

procedure TChoosingPresentForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_SPACE) {or (Key = VK_ADD)}) AND (Shift = []) then
  Begin
    if ChoosingPresentCDS.IsEmpty then Exit;
    ChoosingPresentCDS.Edit;
    ChoosingPresentCDS.FieldByName('Amount').AsCurrency := ChoosingPresentCDS.FieldByName('Amount').AsCurrency + 1;
    ChoosingPresentCDS.Post
  End;
//  if (Key = VK_SUBTRACT) AND (Shift = []) then
//  Begin
//    if ChoosingPresentCDS.IsEmpty then Exit;
//    if ChoosingPresentCDS.FieldByName('Amount').AsCurrency >= 1 then
//    begin
//      ChoosingPresentCDS.Edit;
//      ChoosingPresentCDS.FieldByName('Amount').AsCurrency := ChoosingPresentCDS.FieldByName('Amount').AsCurrency - 1;
//      ChoosingPresentCDS.Post
//    end;
//  End;
end;

End.
