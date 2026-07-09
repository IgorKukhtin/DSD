unit Report_CommercBonus;

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
  cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TReport_CommercBonusForm = class(TAncestorReportForm)
    PaidKindName: TcxGridDBColumn;
    ContractConditionKindName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    bbDocBonus: TdxBarButton;
    actDocBonus: TdsdExecStoredProc;
    spInsertUpdate: TdsdStoredProc;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel3: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    actRefreshMovement: TdsdDataSetRefresh;
    cbMovement: TcxCheckBox;
    cxLabel6: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    RetailName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    spUpdateSend_No: TdsdStoredProc;
    spUpdateSend_Yes: TdsdStoredProc;
    actUpdateSend_Yes: TdsdExecStoredProc;
    actUpdateSend_No: TdsdExecStoredProc;
    macUpdateSend_Yes: TMultiAction;
    macUpdateSend_No: TMultiAction;
    bbUpdateSend_Yes: TdxBarButton;
    bbUpdateSend_No: TdxBarButton;
    actInsertByReportGrid: TdsdExecStoredProc;
    macInsertByReportGrid: TMultiAction;
    bbInsertByReportGrid: TdxBarButton;
    spInsertByReportGrid: TdsdStoredProc;
    spUpdateSend: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actOpenReportDetailForm: TdsdOpenForm;
    bbOpenReportDetail: TdxBarButton;
    actPrintSing: TdsdPrintAction;
    bbPrintSing: TdxBarButton;
    actPrintGroup: TdsdPrintAction;
    bbPrintGroup: TdxBarButton;
    ProtocolReportBonusForm: TdsdOpenForm;
    bbProtocolReportBonusForm: TdxBarButton;
    macInsertUpdate_ByGrid: TMultiAction;
    spInsertUpdate_ByGrid: TdsdStoredProc;
    actInsertUpdate_ByGrid: TdsdExecStoredProc;
    macInsertUpdate_ByGrid_list: TMultiAction;
    bbInsertUpdate_ByGrid: TdxBarButton;
    cxLabel8: TcxLabel;
    GuidesMember: TdsdGuides;
    edMember: TcxButtonEdit;
    actPrintSingDetail: TdsdPrintAction;
    bbPrintSingDetail: TdxBarButton;
    spGet_Check: TdsdStoredProc;
    actGet_Check: TdsdExecStoredProc;
    actOpenReportJuridicalCollationForm: TdsdOpenForm;
    bbReportJuridicalCollation: TdxBarButton;
    spInsertUpdate_ByGrid_1_2: TdsdStoredProc;
    macInsertUpdate_ByGrid_koeff: TMultiAction;
    macInsertUpdate_ByGrid_list_Koeff: TMultiAction;
    actInsertUpdate_ByGrid_Koeff: TdsdExecStoredProc;
    bbInsertUpdate_ByGrid_koeff: TdxBarButton;
    FormParams: TdsdFormParams;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    actOpenMovementForm: TdsdOpenForm;
    mactOpenDocument: TMultiAction;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_CommercBonusForm);

end.
