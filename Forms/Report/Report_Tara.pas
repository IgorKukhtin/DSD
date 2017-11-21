unit Report_Tara;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCheckBox, cxCurrencyEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_TaraForm = class(TAncestorReportForm)
    chkWithSupplier: TcxCheckBox;
    chbWithBayer: TcxCheckBox;
    chbWithPlace: TcxCheckBox;
    chbWithBranch: TcxCheckBox;
    cxLabel3: TcxLabel;
    edObject: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    ObjectGuides: TdsdGuides;
    GoodsGuides: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsGroupCode: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    ObjectCode: TcxGridDBColumn;
    ObjectName: TcxGridDBColumn;
    ObjectDescName: TcxGridDBColumn;
    ObjectType: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    RemainsInActive: TcxGridDBColumn;
    RemainsInPassive: TcxGridDBColumn;
    RemainsIn: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    AmountInventory: TcxGridDBColumn;
    RemainsOutActive: TcxGridDBColumn;
    RemainsOutPassive: TcxGridDBColumn;
    RemainsOut: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    dxBarButton1: TdxBarButton;
    AmountInBay: TcxGridDBColumn;
    AmountOutSale: TcxGridDBColumn;
    AmountLoss: TcxGridDBColumn;
    chkWithMember: TcxCheckBox;
    FormParams: TdsdFormParams;
    spGetTaraMovementDescSets: TdsdStoredProc;
    MovementTara_In_Form: TdsdOpenForm;
    MovementTara_InBay_Form: TdsdOpenForm;
    MovementTara_Out_Form: TdsdOpenForm;
    MovementTara_OutSale_Form: TdsdOpenForm;
    MovementTara_Inventory_Form: TdsdOpenForm;
    MovementTara_Loss_Form: TdsdOpenForm;
    ceAccountGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    AccountGroupGuides: TdsdGuides;
    AccountGroupName: TcxGridDBColumn;
    AccountGroupCode: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    spSelectPrintJuridical: TdsdStoredProc;
    actPrintJuridical: TdsdPrintAction;
    bbPrintJuridical: TdxBarButton;
    actPrintGoods: TdsdPrintAction;
    actPrintJuridicalGoods: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bb: TdxBarButton;
    spSelectPrintGoods: TdsdStoredProc;
    spSelectPrintJuridicalGoods: TdsdStoredProc;
    AmountPartner_out: TcxGridDBColumn;
    AmountPartner_in: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  registerClass(TReport_TaraForm);

end.
