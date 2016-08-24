unit IncomeFuelJournal;

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
  dxBarExtItems, cxCurrencyEdit, ChoicePeriod, System.Contnrs, cxLabel;

type
  TIncomeFuelJournalForm = class(TParentForm)
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
    colStatus: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalSummPVAT: TcxGridDBColumn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    actComplete: TdsdChangeMovementStatus;
    spMovementComplete: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    bbComplete: TdxBarButton;
    actUnComplete: TdsdChangeMovementStatus;
    spMovementUnComplete: TdsdStoredProc;
    bbUnComplete: TdxBarButton;
    N2: TMenuItem;
    bbDelete: TdxBarButton;
    actSetErased: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    colPriceWithVAT: TcxGridDBColumn;
    colVATPercent: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalSummMVAT: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colTotalSummVAT: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colPersonalDriverName: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    colRouteName: TcxGridDBColumn;
    colInvNumberPartner: TcxGridDBColumn;
    colInvNumberMaster: TcxGridDBColumn;
    colOperDateMaster: TcxGridDBColumn;
    colChangePrice: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    colOperDatePartner: TcxGridDBColumn;
    actReCompleteAll: TdsdExecStoredProc;
    bbReCompleteAll: TdxBarButton;
    colGoodsName: TcxGridDBColumn;
    colFuelName: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colFuelCode: TcxGridDBColumn;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colTotalCountPartner: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    clStartOdometre: TcxGridDBColumn;
    clEndOdometre: TcxGridDBColumn;
    clAmountFuel: TcxGridDBColumn;
    clReparation: TcxGridDBColumn;
    clLimitMoney: TcxGridDBColumn;
    clLimitDistance: TcxGridDBColumn;
    clLimitMoneyChange: TcxGridDBColumn;
    clLimitDistanceChange: TcxGridDBColumn;
    clDistance: TcxGridDBColumn;
    clDistanceReal: TcxGridDBColumn;
    clFuelCalc: TcxGridDBColumn;
    clPriceCalc: TcxGridDBColumn;
    clSummReal: TcxGridDBColumn;
    clFuelReal: TcxGridDBColumn;
    clFuelRealCalc: TcxGridDBColumn;
    clFuelDiff: TcxGridDBColumn;
    clFuelSummDiff: TcxGridDBColumn;
    clSummDiff: TcxGridDBColumn;
    clSummDiffTotal: TcxGridDBColumn;
    clSummReparation: TcxGridDBColumn;
    clSummPersonal: TcxGridDBColumn;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    spCompete: TdsdExecStoredProc;
    actSimpleCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    N3: TMenuItem;
    N4: TMenuItem;
    spUncomplete: TdsdExecStoredProc;
    actSimpleUncompleteList: TMultiAction;
    actUnCompleteList: TMultiAction;
    N5: TMenuItem;
    spErased: TdsdExecStoredProc;
    actSimpleErased: TMultiAction;
    actSetErasedList: TMultiAction;
    N6: TMenuItem;
    spMovementReComplete: TdsdStoredProc;
    spReCompete: TdsdExecStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    N7: TMenuItem;
    ExecuteDialog: TExecuteDialog;
    spUpdate_ChangePrice: TdsdStoredProc;
    actUpdate_ChangePrice: TdsdExecStoredProc;
    macSUpdate_ChangePrice: TMultiAction;
    bbUpdate_ChangePrice: TdxBarButton;
    macUpdate_ChangePrice: TMultiAction;
    clstrSign: TcxGridDBColumn;
    clstrSignNo: TcxGridDBColumn;
    spInsertUpdateMISign: TdsdStoredProc;
    actInsertUpdateMISign0: TdsdExecStoredProc;
    actInsertUpdateMISign1: TMultiAction;
    actInsertUpdateMISignList: TMultiAction;
    bb: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeFuelJournalForm);

end.
