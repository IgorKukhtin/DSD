unit SalePromoGoodsDialog;

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
  TSalePromoGoodsDialogForm = class(TAncestorBaseForm)
    BankPOSTerminalGrid: TcxGrid;
    BankPOSTerminalGridDBTableView: TcxGridDBTableView;
    BankPOSTerminalGridLevel: TcxGridLevel;
    SalePromoGoodsDialoglDS: TDataSource;
    GoodsPresentName: TcxGridDBColumn;
    Panel1: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    GoodsPresentCode: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    AmountSale: TcxGridDBColumn;
    procedure BankPOSTerminalGridDBTableViewDblClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function SalePromoGoodsDialogExecute(ADS : TClientDataSet) : boolean;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData;


function SalePromoGoodsDialogExecute(ADS : TClientDataSet) : boolean;
  var SalePromoGoodsDialogForm : TSalePromoGoodsDialogForm;
begin
  Result := False;

  if ADS.IsEmpty then Exit;

  SalePromoGoodsDialogForm := TSalePromoGoodsDialogForm.Create(Application);
  With SalePromoGoodsDialogForm do
  try
    try
      SalePromoGoodsDialoglDS.DataSet := ADS;
      while True do
        if ShowModal = mrOK then
        begin
          Result := True;
          Break;
        end else ShowMessage('Акционный товар надо выбрать.');;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  finally
    SalePromoGoodsDialogForm.Free;
  end;

end;

procedure TSalePromoGoodsDialogForm.BankPOSTerminalGridDBTableViewDblClick(
  Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

End.
