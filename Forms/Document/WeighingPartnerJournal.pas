unit WeighingPartnerJournal;

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
  TWeighingPartnerJournalForm = class(TParentForm)
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
    lToName: TcxGridDBColumn;
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
    InvNumberOrder: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    EndWeighing: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    InvNumber_parent: TcxGridDBColumn;
    bbReCompleteAll: TdxBarButton;
    spMovementReCompleteAll: TdsdStoredProc;
    UserName: TcxGridDBColumn;
    RouteSorting: TcxGridDBColumn;
    StartWeighing: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    OperDate_parent: TcxGridDBColumn;
    WeighingNumber: TcxGridDBColumn;
    PersonalName1: TcxGridDBColumn;
    PersonalName2: TcxGridDBColumn;
    PersonalName3: TcxGridDBColumn;
    PersonalName4: TcxGridDBColumn;
    PersonalCode1: TcxGridDBColumn;
    PersonalCode2: TcxGridDBColumn;
    PersonalCode3: TcxGridDBColumn;
    PersonalCode4: TcxGridDBColumn;
    PositionName1: TcxGridDBColumn;
    PositionName2: TcxGridDBColumn;
    PositionName3: TcxGridDBColumn;
    PositionName4: TcxGridDBColumn;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    actMovementProtocol: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    InvNumberPartner_Tax: TcxGridDBColumn;
    OperDate_Tax: TcxGridDBColumn;
    MovementDescNumber: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    FormParams: TdsdFormParams;
    StartBegin: TcxGridDBColumn;
    EndBegin: TcxGridDBColumn;
    diffBegin_sec: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    PersonalCode1_Stick: TcxGridDBColumn;
    PersonalName1_Stick: TcxGridDBColumn;
    PositionName1_Stick: TcxGridDBColumn;
    ExecuteDialogPersonalComlete: TExecuteDialog;
    actUpdatePersonalComlete: TdsdDataSetRefresh;
    macUpdatePersonalComlete: TMultiAction;
    spUpdate_PersonalComlete: TdsdStoredProc;
    bbUpdatePersonalComlete: TdxBarButton;
    UnitName_PersonalGroup: TcxGridDBColumn;
    IP: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    isDocPartner: TcxGridDBColumn;
    isReason2: TcxGridDBColumn;
    isReason1: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint_diff: TdsdStoredProc;
    actPrint_diff: TdsdPrintAction;
    spSelectPrint_all: TdsdStoredProc;
    actPrint_all: TdsdPrintAction;
    bbPrint_diff: TdxBarButton;
    bbPrint_all: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    actWeighingPartner_ActDiffF: TdsdInsertUpdateAction;
    bbWeighingPartner_ActDiffF: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingPartnerJournalForm);

end.
