unit WeighingPartner;

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
  TWeighingPartnerForm = class(TParentForm)
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
    edTo: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    dsdGuidesFrom: TdsdGuides;
    dsdGuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    PriceListName: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    WeightTare: TcxGridDBColumn;
    CountTare: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Count: TcxGridDBColumn;
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
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    PartionGoodsDate: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edEndWeighing: TcxDateEdit;
    cxLabel8: TcxLabel;
    edUser: TcxButtonEdit;
    UserGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    edOperDate_parent: TcxDateEdit;
    cxLabel12: TcxLabel;
    edInvNumber_parent: TcxTextEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    edPartionGoods: TcxTextEdit;
    ContractGuides: TdsdGuides;
    edWeighingNumber: TcxCurrencyEdit;
    BoxCount: TcxGridDBColumn;
    BoxNumber: TcxGridDBColumn;
    LevelNumber: TcxGridDBColumn;
    BoxName: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    Amount_mi: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    AmountPartner_mi: TcxGridDBColumn;
    Count_mi: TcxGridDBColumn;
    HeadCount_mi: TcxGridDBColumn;
    BoxCount_mi: TcxGridDBColumn;
    AmountChangePercent: TcxGridDBColumn;
    edContractTag: TcxButtonEdit;
    ContractTagGuides: TdsdGuides;
    edPriceWithVAT: TcxCheckBox;
    cxLabel19: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    MeasureName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    spUpdateMovement: TdsdStoredProc;
    HeaderSaver2: THeaderSaver;
    isBarCode: TcxGridDBColumn;
    cbPromo: TcxCheckBox;
    edInvNumberOrder: TcxButtonEdit;
    OrderChoiceGuides: TdsdGuides;
    HeaderSaver3: THeaderSaver;
    spUpdateMovement_Order: TdsdStoredProc;
    ChangePercent: TcxGridDBColumn;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    bbOpenDocument: TdxBarButton;
    actUpdateDocument: TdsdInsertUpdateAction;
    cxLabel13: TcxLabel;
    edMovementDescName: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edMovementDescNumber: TcxTextEdit;
    MovementDescGuides: TdsdGuides;
    cxLabel21: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    spUpdate_PersonalComlete: TdsdStoredProc;
    ExecuteDialogPersonalComlete: TExecuteDialog;
    actUpdatePersonalComlete: TdsdDataSetRefresh;
    macUpdatePersonalComlete: TMultiAction;
    bbUpdatePersonalComlete: TdxBarButton;
    cxLabel22: TcxLabel;
    edPersonalGroup: TcxButtonEdit;
    GuidesPersonalGroup: TdsdGuides;
    cxLabel23: TcxLabel;
    ed: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
    cxLabel24: TcxLabel;
    ceComment: TcxTextEdit;
    cbisList: TcxCheckBox;
    PartionGoods: TcxGridDBColumn;
    AssetName_two: TcxGridDBColumn;
    AssetName: TcxGridDBColumn;
    cxLabel25: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    edInvNumberPartner: TcxTextEdit;
    cxLabel26: TcxLabel;
    actWeighingPartner_ActDiffF: TdsdInsertUpdateAction;
    bbactWeighingPartner_ActDiffF: TdxBarButton;
    cbDocPartner: TcxCheckBox;
    cbReason1: TcxCheckBox;
    cbReason2: TcxCheckBox;
    cxLabel27: TcxLabel;
    edChangePercentAmount: TcxCurrencyEdit;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint_diff: TdsdStoredProc;
    spSelectPrint_all: TdsdStoredProc;
    actPrint_all: TdsdPrintAction;
    actPrint_diff: TdsdPrintAction;
    bbPrint_diff: TdxBarButton;
    bbPrint_all: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    spSelectPrint_allPartner: TdsdStoredProc;
    dsdPrintAction1: TdsdPrintAction;
    bbPrintAction1: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    actUpdateBox: TExecuteDialog;
    macUpdateBox: TMultiAction;
    spSelectMIPrintPassport: TdsdStoredProc;
    actSelectMIPrintPassport: TdsdPrintAction;
    actRefreshMI: TdsdDataSetRefresh;
    bbSelectMIPrintPassport: TdxBarButton;
    bbUpdateBox: TdxBarButton;
    PartionNum: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingPartnerForm);

end.
