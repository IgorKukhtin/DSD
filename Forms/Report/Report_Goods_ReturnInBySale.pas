unit Report_Goods_ReturnInBySale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxImageComboBox,
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
  TReport_Goods_ReturnInBySaleForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    cePartner: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    UnitName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel10: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
    cxLabel25: TcxLabel;
    edSale: TcxButtonEdit;
    SaleChoiceGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    cePrice: TcxCurrencyEdit;
    StatusCode: TcxGridDBColumn;
    spMovementComplete: TdsdStoredProc;
    spMovementUnComplete: TdsdStoredProc;
    actComplete: TdsdChangeMovementStatus;
    actUnComplete: TdsdChangeMovementStatus;
    spCompete: TdsdExecStoredProc;
    spUncomplete: TdsdExecStoredProc;
    actSimpleCompleteList: TMultiAction;
    actSimpleUncompleteList: TMultiAction;
    spReCompete: TdsdExecStoredProc;
    spMovementReComplete: TdsdStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    actUnCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    actShowMessage: TShowMessageAction;
    bbComplete: TdxBarButton;
    bbUnComplete: TdxBarButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    MovementDescName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Goods_ReturnInBySaleForm);

end.
