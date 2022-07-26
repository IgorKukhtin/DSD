unit ChoiceGoodsSPSearch_1303;

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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar;

type
  TChoiceGoodsSPSearch_1303Form = class(TAncestorEnumForm)
    edCodeSearch: TcxTextEdit;
    colBrandSPName: TcxGridDBColumn;
    colKindOutSP_1303Name: TcxGridDBColumn;
    colPriceOptSP: TcxGridDBColumn;
    ChoiceGoodsForm: TOpenChoiceForm;
    UpdateDataSet: TdsdUpdateDataSet;
    actSetGoodsLink: TdsdExecStoredProc;
    bbGoodsPriceListLink: TdxBarButton;
    mactChoiceGoodsForm: TMultiAction;
    actRefreshSearch: TdsdExecStoredProc;
    Panel1: TPanel;
    cxLabel3: TcxLabel;
    actClearFilter: TMultiAction;
    btnClearFilter: TcxButton;
    cxLabel2: TcxLabel;
    dxBarButton1: TdxBarButton;
    FormParams: TdsdFormParams;
    colColor_Count: TcxGridDBColumn;
    bbUpdate_PriceSale: TdxBarButton;
    colDosage_1303Name: TcxGridDBColumn;
    colCountSP_1303Name: TcxGridDBColumn;
    colMakerCountrySP_1303Name: TcxGridDBColumn;
    edOperDateEnd: TcxDateEdit;
    cxLabel4: TcxLabel;
    edOperDateStart: TcxDateEdit;
    cxLabel1: TcxLabel;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    spGet: TdsdStoredProc;
    GoodsCode: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    PriceOOC: TcxGridDBColumn;
    spSetGoods: TdsdStoredProc;
    spClearGoods: TdsdStoredProc;
    actGoodsMain: TOpenChoiceForm;
    actClearGoods: TdsdExecStoredProc;
    actSetGoods: TdsdExecStoredProc;
    bbSetGoods: TdxBarButton;
    bbClearGoods: TdxBarButton;
    actSetVisible: TdsdSetVisibleAction ;
    actSetEnabled: TdsdSetEnabledAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TChoiceGoodsSPSearch_1303Form);

end.
