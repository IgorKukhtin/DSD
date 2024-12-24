unit WeighingPartner_ActDiff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit, dsdCommon;

type
  TWeighingPartner_ActDiffForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    SummPartnerWVAT: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    GoodsKindName: TcxGridDBColumn;
    Price_diff: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edStartWeighing: TcxDateEdit;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    IsErased: TcxGridDBColumn;
    GuidesStatus: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edEndWeighing: TcxDateEdit;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel17: TcxLabel;
    GuidesContract: TdsdGuides;
    edWeighingNumber: TcxCurrencyEdit;
    AmountPartner_income: TcxGridDBColumn;
    Amount_income: TcxGridDBColumn;
    edContractTag: TcxButtonEdit;
    GuidesContractTag: TdsdGuides;
    MeasureName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    spUpdateMI: TdsdStoredProc;
    isReturnOut: TcxGridDBColumn;
    edInvNumberOrder: TcxButtonEdit;
    OrderChoiceGuides: TdsdGuides;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    bbOpenDocument: TdxBarButton;
    actUpdateDocument: TdsdInsertUpdateAction;
    spUpdate_PersonalComlete: TdsdStoredProc;
    ExecuteDialogPersonalComlete: TExecuteDialog;
    actUpdatePersonalComlete: TdsdDataSetRefresh;
    macUpdatePersonalComlete: TMultiAction;
    bbUpdatePersonalComlete: TdxBarButton;
    GuidesSubjectDoc: TdsdGuides;
    cxLabel24: TcxLabel;
    ceComment: TcxTextEdit;
    edInvNumberPartner: TcxTextEdit;
    cxLabel26: TcxLabel;
    Ord: TcxGridDBColumn;
    PriceNoVAT_Income: TcxGridDBColumn;
    SummNoVAT_income: TcxGridDBColumn;
    Amount_income_calc: TcxGridDBColumn;
    Summ_diff: TcxGridDBColumn;
    isReason_2: TcxGridDBColumn;
    isReason_1: TcxGridDBColumn;
    ReasonName: TcxGridDBColumn;
    cbDocPartner: TcxCheckBox;
    actActDiffEdit: TdsdInsertUpdateAction;
    bbActDiffEdit: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint_byPartnerl: TdsdStoredProc;
    actPrint_byPartner: TdsdPrintAction;
    bbPrint_byPartner: TdxBarButton;
    spPrint_Act: TdsdStoredProc;
    actPrintDiff: TdsdPrintAction;
    bbsPrint: TdxBarSubItem;
    bbPrintDiff: TdxBarButton;
    actPrint_all: TdsdPrintAction;
    bbPrint_DiffPartner: TdxBarButton;
    actPrint_AllPartner: TdsdPrintAction;
    spSelectPrint_allPartner: TdsdStoredProc;
    spSelectPrint_diffPartner: TdsdStoredProc;
    actPrint_DiffPartner: TdsdPrintAction;
    bbPrint_AllPartner: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    cxLabel25: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    spMovementComplete: TdsdStoredProc;
    actComplete_del: TdsdChangeMovementStatus;
    mactCompletePrint: TMultiAction;
    actPrint_byPartneê_noPrew: TdsdPrintAction;
    actContinueAction: TdsdContinueAction;
    actPrintDiff_noPrew: TdsdPrintAction;
    bbCompletePrint: TdxBarButton;
    actCompleteMovement_: TChangeGuidesStatus;
    dsdExecStoredProc1: TdsdExecStoredProc;
    spStutusComplete: TdsdStoredProc;
    actInsertDiffEdit: TdsdInsertUpdateAction;
    bbInsertDiffEdit: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingPartner_ActDiffForm);

end.
