unit Sale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox;

type
  TSaleForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnit: TcxButtonEdit;
    lblJuridical: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesJuridical: TdsdGuides;
    cxLabel3: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel4: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edTotalCount: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edTotalSummPrimeCost: TcxCurrencyEdit;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountRemains: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    Remains: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    SummWithVAT: TcxGridDBColumn;
    SummOut: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    Margin: TcxGridDBColumn;
    MarginPercent: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_SalePartion: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cxLabel12: TcxLabel;
    edOperDateSP: TcxDateEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel16: TcxLabel;
    cxLabel8: TcxLabel;
    edPartnerMedical: TcxButtonEdit;
    GuidesPartnerMedical: TdsdGuides;
    isSP: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edGroupMemberSP: TcxButtonEdit;
    GuidesGroupMemberSP: TdsdGuides;
    edMedicSP: TcxButtonEdit;
    edMemberSP: TcxButtonEdit;
    GuidesMemberSP: TdsdGuides;
    GuidesMedicSP: TdsdGuides;
    spSelectPrintCheck: TdsdStoredProc;
    actPrintCheck: TdsdPrintAction;
    PrintDialog: TExecuteDialog;
    macPrintCheck: TMultiAction;
    bbPrintCheck: TdxBarButton;
    cxLabel10: TcxLabel;
    edSPKind: TcxButtonEdit;
    SPKindGuides: TdsdGuides;
    spGet_SP_Prior: TdsdStoredProc;
    actGet_SP_Prior: TdsdExecStoredProc;
    bbGet_SP_Prior: TdxBarButton;
    cxLabel11: TcxLabel;
    edAddress: TcxTextEdit;
    cxLabel17: TcxLabel;
    edPassport: TcxTextEdit;
    cxLabel18: TcxLabel;
    edInn: TcxTextEdit;
    cbisDeferred: TcxCheckBox;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    AmountDeferred: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    PartNDS: TcxGridDBColumn;
    actChoiceNDSKind: TOpenChoiceForm;
    actExec_Update_PriceSale: TdsdExecStoredProc;
    actExecuteDialog_Update_PriceSale: TExecuteDialog;
    spUpdate_PriceSale: TdsdStoredProc;
    bbactUpdatePriceSale: TdxBarButton;
    cbIsNP: TcxCheckBox;
    edInsuranceCompanies: TcxButtonEdit;
    cxLabel19: TcxLabel;
    edMemberIC: TcxButtonEdit;
    cxLabel20: TcxLabel;
    GuidesMemberIC: TdsdGuides;
    edInsuranceCardNumber: TcxTextEdit;
    cxLabel21: TcxLabel;
    GuidesInsuranceCompanies: TdsdGuides;
    actPrintInvoiceIC_0: TdsdPrintAction;
    bbPrintInvoiceIC: TdxBarButton;
    spSelectPrintInvoiceIC: TdsdStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    actPrintInvoiceIC_7: TdsdPrintAction;
    actPrintInvoiceIC_20: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleForm);

end.
