unit ChoiceGoodsFromRemains;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorEnum, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  dxBarBuiltInMenu, cxNavigator, Vcl.StdCtrls, cxButtons, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox;

type
  TChoiceGoodsFromRemainsForm = class(TAncestorEnumForm)
    edCodeSearch: TcxTextEdit;
    cxLabel1: TcxLabel;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colPriceSale: TcxGridDBColumn;
    ChoiceGoodsForm: TOpenChoiceForm;
    UpdateDataSet: TdsdUpdateDataSet;
    actSetGoodsLink: TdsdExecStoredProc;
    bbGoodsPriceListLink: TdxBarButton;
    mactChoiceGoodsForm: TMultiAction;
    colNDS: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    Panel1: TPanel;
    actDeleteLink: TdsdExecStoredProc;
    colAmount: TcxGridDBColumn;
    actRefreshSearch2: TdsdExecStoredProc;
    cxLabel3: TcxLabel;
    actClearFilter: TMultiAction;
    btnClearFilter: TcxButton;
    cxLabel2: TcxLabel;
    edGoodsSearch: TcxTextEdit;
    cxLabel4: TcxLabel;
    AreaName: TcxGridDBColumn;
    actGoodsObjectPrice: TMultiAction;
    actExecuteDialogPrice: TExecuteDialog;
    actExecSetGoodsObjectPrice: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    spSetGoodsObjectPrice: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actViewSetGoodsObjectPrice: TMultiAction;
    colDailyCheck: TcxGridDBColumn;
    colDailySale: TcxGridDBColumn;
    colColor_calc: TcxGridDBColumn;
    colDeferredSend: TcxGridDBColumn;
    colDeferredSendIn: TcxGridDBColumn;
    cbisRetail: TcxCheckBox;
    RetailName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TChoiceGoodsFromRemainsForm);

end.
