unit Report_SaleSP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_SaleSPForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    UnitName: TcxGridDBColumn;
    MemberSP: TcxGridDBColumn;
    PriceSP: TcxGridDBColumn;
    actRefreshIsPartion: TdsdDataSetRefresh;
    OperDateSP: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    MedicSP: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    NumLine: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    ceHospital: TcxButtonEdit;
    HospitalGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    edGroupMemberSP: TcxButtonEdit;
    GroupMemberSPGuides: TdsdGuides;
    cbGroupMemberSP: TcxCheckBox;
    actRefresh1: TdsdDataSetRefresh;
    MedicFIO: TcxGridDBColumn;
    Contract_StartDate: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    Unit_Address: TcxGridDBColumn;
    License: TcxGridDBColumn;
    actPrintInvoice: TdsdPrintAction;
    bbPrintInvoice: TdxBarButton;
    cxLabel7: TcxLabel;
    edDateInvoice: TcxDateEdit;
    cxLabel8: TcxLabel;
    edInvoice: TcxTextEdit;
    CountSP: TcxGridDBColumn;
    cxLabel11: TcxLabel;
    cePercentSP: TcxCurrencyEdit;
    cbisInsert: TcxCheckBox;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    spSavePrintMovement: TdsdStoredProc;
    actSaveMovement: TdsdExecStoredProc;
    macPrintInvoice: TMultiAction;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    isListSP: TcxGridDBColumn;
    spUpdateDS: TdsdStoredProc;
    actUpdateDS: TdsdUpdateDataSet;
    HospitalId: TcxGridDBColumn;
    actPrintBill: TdsdPrintAction;
    bbPrintInvoice2: TdxBarButton;
    actPrintInvoice2: TdsdPrintAction;
    bbPrintBill: TdxBarButton;
    AmbulantClinicSP: TcxGridDBColumn;
    SummaCompWithOutVat: TcxGridDBColumn;
    edNDSKind: TcxButtonEdit;
    cxLabel9: TcxLabel;
    GuidesNDSKind: TdsdGuides;
    spGetNDS: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actGetNDS: TdsdExecStoredProc;
    actPrintMemberSP: TdsdPrintAction;
    bbPrintMemberSP: TdxBarButton;
    isManual: TcxGridDBColumn;
    PriceOOC: TcxGridDBColumn;
    SumCompOOC: TcxGridDBColumn;
    DSummaSP: TcxGridDBColumn;
    Color_DSummaSP: TcxGridDBColumn;
    isUsePriceOOC: TcxGridDBColumn;
    PriceRegistry: TcxGridDBColumn;
    SummaRegistry: TcxGridDBColumn;
    GoodsNameUkr: TcxGridDBColumn;
    spUpdate_MI_CalculationSaleSP: TdsdStoredProc;
    actCalculationSaleSP: TdsdExecStoredProc;
    actDataToJson: TdsdDataToJsonAction;
    bbCalculationSaleSP: TdxBarButton;
    edInvNumber: TcxTextEdit;
    cxTextEdit1: TcxTextEdit;
    cxTextEdit2: TcxTextEdit;
    cxTextEdit3: TcxTextEdit;
    actPrintCalculation: TdsdPrintAction;
    dxBarButton2: TdxBarButton;
    PriceRegistryFull: TcxGridDBColumn;
    SummaRegistryFull: TcxGridDBColumn;
    IntenalSP_1303Name: TcxGridDBColumn;
    BrandSPName: TcxGridDBColumn;
    KindOutSP_1303Name: TcxGridDBColumn;
    Dosage_1303Name: TcxGridDBColumn;
    CountSP_1303Name: TcxGridDBColumn;
    MakerCountrySP_1303Name: TcxGridDBColumn;
    PriceOptSP: TcxGridDBColumn;
    actPrint3: TdsdPrintAction;
    dxBarButton3: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_SaleSPForm: TReport_SaleSPForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_SaleSPForm)
end.
