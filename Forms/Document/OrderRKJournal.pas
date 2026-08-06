unit OrderRKJournal;

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
  TOrderRKJournalForm = class(TAncestorJournalForm)
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    FromName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    OperDate_Print: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    isPrint: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    mactPrint_Order: TMultiAction;
    actPrintSilent: TdsdPrintAction;
    mactSilentList: TMultiAction;
    mactSilentPrint: TMultiAction;
    N13: TMenuItem;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
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
    bbUpdateMIChild_Amount: TdxBarButton;
    spUpdateMIChild_AmountSecond: TdsdStoredProc;
    spUpdateMIChild_Amount: TdsdStoredProc;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    macUpdateMIChild_Amount_list: TMultiAction;
    macUpdateMIChild_Amount: TMultiAction;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    spUpdateMIChild_AmountNull: TdsdStoredProc;
    spUpdateMIChild_AmountSecondNull: TdsdStoredProc;
    actUpdateMIChild_AmountNull: TdsdExecStoredProc;
    macUpdateMIChild_AmountNull_list: TMultiAction;
    macUpdateMIChild_AmountNull: TMultiAction;
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
    mactPrint_Order3: TMultiAction;
    actPrint_3: TdsdPrintAction;
    bbPrint_Order3: TdxBarButton;
    actPrintCell_pak_copy2: TdsdPrintAction;
    actPrintCell_pak_copy3: TdsdPrintAction;
    mactPrint_OrderCell_pac_copy2: TMultiAction;
    mactPrint_OrderCell_pac_copy3: TMultiAction;
    mactPrint_OrderCellPak_list2: TMultiAction;
    mactPrint_OrderCellPak_list3: TMultiAction;
    mactPrint_OrderCell_Pak_copy2: TMultiAction;
    mactPrint_OrderCell_Pak_copy3: TMultiAction;
    bbPrint_OrderCell_Pak_copy2: TdxBarButton;
    bbPrint_OrderCell_Pak_copy3: TdxBarButton;
    InvNumber_OrderExternal: TcxGridDBColumn;
    OperDate_OrderExternal: TcxGridDBColumn;
    OperDatePartner_OrderExternal: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderRKJournalForm);
end.
