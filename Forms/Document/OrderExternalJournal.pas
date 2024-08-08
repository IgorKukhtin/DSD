unit OrderExternalJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TOrderExternalJournalForm = class(TAncestorJournalForm)
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    FromName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    OperDateMark: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    RouteSortingName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    PriceListName: TcxGridDBColumn;
    isPrinted: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    mactPrint_Order: TMultiAction;
    actPrintSilent: TdsdPrintAction;
    mactSilentList: TMultiAction;
    mactSilentPrint: TMultiAction;
    N13: TMenuItem;
    PartnerName: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    OperDatePartner_sale: TcxGridDBColumn;
    isPromo: TcxGridDBColumn;
    MovementPromo: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    UpdateMobileDate: TcxGridDBColumn;
    PeriodSecMobile: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actPrintTotal: TdsdPrintAction;
    spSelectPrintTotal: TdsdStoredProc;
    bbPrintTotal: TdxBarButton;
    actPrint_2: TdsdPrintAction;
    mactPrint_Order2: TMultiAction;
    bbPrint_Order2: TdxBarButton;
    actInsertMaskMulti: TMultiAction;
    spGetReporNameBill: TdsdStoredProc;
    spSelectPrintBill: TdsdStoredProc;
    actPrint_Account: TdsdPrintAction;
    actPrint_Account_ReportName: TdsdExecStoredProc;
    mactPrint_Account: TMultiAction;
    bbPrint_Account: TdxBarButton;
    OperDate_CarInfo: TcxGridDBColumn;
    CarInfoName: TcxGridDBColumn;
    bbUpdateMIChild_Amount: TdxBarButton;
    spUpdateMIChild_AmountSecond: TdsdStoredProc;
    spUpdateMIChild_Amount: TdsdStoredProc;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    actUpdateMIChild_AmountSecond: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecond_list: TMultiAction;
    macUpdateMIChild_Amount_list: TMultiAction;
    macUpdateMIChild_Amount: TMultiAction;
    macUpdateMIChild_AmountSecond: TMultiAction;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    spUpdateMIChild_AmountNull: TdsdStoredProc;
    spUpdateMIChild_AmountSecondNull: TdsdStoredProc;
    actUpdateMIChild_AmountNull: TdsdExecStoredProc;
    macUpdateMIChild_AmountNull_list: TMultiAction;
    macUpdateMIChild_AmountNull: TMultiAction;
    actUpdateMIChild_AmountSecondNull: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecondNull_list: TMultiAction;
    macUpdateMIChild_AmountSecondNull: TMultiAction;
    bbUpdateMIChild_AmountNull: TdxBarButton;
    bbUpdateMIChild_AmountSecondNull: TdxBarButton;
    actOpenFormOrderExternalChild: TdsdInsertUpdateAction;
    bbOpenFormOrderExternalChild: TdxBarButton;
    bbPrintSort: TdxBarButton;
    actPrintSort: TdsdPrintAction;
    bbsPrint: TdxBarSubItem;
    bbSeparator: TdxBarSeparator;
    bbtSilentList: TdxBarButton;
    bbsUpdate: TdxBarSubItem;
    mactPrint_OrderCell: TMultiAction;
    actPrintCell: TdsdPrintAction;
    bbPrint_OrderCell: TdxBarButton;
    mactPrint_OrderCellPak_list: TMultiAction;
    mactPrint_OrderCell_Pak: TMultiAction;
    bbPrint_OrderCell_Paket: TdxBarButton;
    actPrintCell_pak: TdsdPrintAction;
    mactPrint_OrderCell_pac: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderExternalJournalForm);
end.
