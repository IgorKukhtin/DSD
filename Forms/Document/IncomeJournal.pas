unit IncomeJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxImageComboBox, Vcl.Menus, dsdAddOn, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarExtItems, cxCurrencyEdit, ChoicePeriod, System.Contnrs, cxLabel,
  dsdGuides, cxButtonEdit, dsdCommon;

type
  TIncomeJournalForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    StatusCode: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    actComplete: TdsdChangeMovementStatus;
    spMovementComplete: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    bbComplete: TdxBarButton;
    actUnComplete: TdsdChangeMovementStatus;
    spMovementUnComplete: TdsdStoredProc;
    bbUnComplete: TdxBarButton;
    N2: TMenuItem;
    bbDelete: TdxBarButton;
    actSetErased: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    PriceWithVAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    PersonalPackerName: TcxGridDBColumn;
    TotalSummPacker: TcxGridDBColumn;
    TotalSummSpending: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    OperDatePartner: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    actReCompleteAll: TdsdExecStoredProc;
    bbReCompleteAll: TdxBarButton;
    spMovementReCompleteAll: TdsdStoredProc;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    TotalCountPartner: TcxGridDBColumn;
    JuridicalName_From: TcxGridDBColumn;
    OKPO_From: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    CurrencyDocumentName: TcxGridDBColumn;
    CurrencyPartnerName: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    ContractCode: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    bbPrint: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    FormParams: TdsdFormParams;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    Comment: TcxGridDBColumn;
    spMovementReComplete: TdsdStoredProc;
    ContractId: TcxGridDBColumn;
    spReCompete: TdsdExecStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    N1: TMenuItem;
    TotalCount_unit: TcxGridDBColumn;
    TotalCount_diff: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    actPrintStickerTermo: TdsdPrintAction;
    bbPrintStickerTermo: TdxBarButton;
    ItemName_from: TcxGridDBColumn;
    ItemName_to: TcxGridDBColumn;
    isCurrencyUser: TcxGridDBColumn;
    isPriceDiff: TcxGridDBColumn;
    spUpdate_PriceDiff: TdsdStoredProc;
    actUpdate_PriceDiff: TdsdUpdateDataSet;
    bbUpdate_PriceDiff: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    actPrintDiff: TdsdPrintAction;
    bbPrintDiff: TdxBarButton;
    Separator: TdxBarSeparator;
    spSelectPrint_diff: TdsdStoredProc;
    spSelectPrint_byPartner: TdsdStoredProc;
    actPrint_byPartner: TdsdPrintAction;
    bbPrint_byPartner: TdxBarButton;
    spSelectPrintSklad: TdsdStoredProc;
    actPrintSklad: TdsdPrintAction;
    bbPrintSklad: TdxBarButton;
    spSelectPrint_reestr: TdsdStoredProc;
    actSelectPrint_reestr: TdsdPrintAction;
    bbSelectPrint_reestr: TdxBarButton;
    spUpdate_TotalLines: TdsdStoredProc;
    actUpdate_TotalLines: TdsdExecStoredProc;
    macUpdate_TotalLines_list: TMultiAction;
    macUpdate_TotalLines: TMultiAction;
    bbUpdate_TotalLines: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeJournalForm);

end.
