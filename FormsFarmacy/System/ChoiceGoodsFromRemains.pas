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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

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
    colPriceSite: TcxGridDBColumn;
    actUpdate_PriceSale: TdsdExecStoredProc;
    actExecuteDialog_Update_PriceSite: TExecuteDialog;
    spSetGoodsObjectPriceSite: TdsdStoredProc;
    bbUpdate_PriceSale: TdxBarButton;
    DateChange: TcxGridDBColumn;
    DateChangeSite: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
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
