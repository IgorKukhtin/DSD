unit Sale_PartionQEdit;

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
  TSale_PartionQEditForm = class(TParentForm)
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
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    GoodsKindName: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel6: TcxLabel;
    edStartWeighing: TcxDateEdit;
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
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    cxLabel16: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel17: TcxLabel;
    ContractGuides: TdsdGuides;
    AmountPartner: TcxGridDBColumn;
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
    cbPromo: TcxCheckBox;
    OrderChoiceGuides: TdsdGuides;
    spUpdateMI_PartionGoods_Q: TdsdStoredProc;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    PartionGoods: TcxGridDBColumn;
    actPrint_all: TdsdPrintAction;
    actPrint_diff: TdsdPrintAction;
    dsdPrintAction1: TdsdPrintAction;
    actRefreshMI: TdsdDataSetRefresh;
    actPrint_Brutto: TdsdPrintAction;
    BoxCount: TcxGridDBColumn;
    PartionGoodsDate_q_2: TcxGridDBColumn;
    PartionGoodsDate_q_3: TcxGridDBColumn;
    PartionGoodsDate_q_4: TcxGridDBColumn;
    PartionGoodsDate_q_5: TcxGridDBColumn;
    PartionGoodsDate_q_6: TcxGridDBColumn;
    PartionGoodsDate_q_7: TcxGridDBColumn;
    PartionGoodsDate_q_8: TcxGridDBColumn;
    PartionGoodsDate_q_9: TcxGridDBColumn;
    PartionGoodsDate_q_10: TcxGridDBColumn;
    edOperDatePartner: TcxDateEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel18: TcxLabel;
    edInsertDate: TcxDateEdit;
    edInsertName: TcxButtonEdit;
    cxLabel22: TcxLabel;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSale_PartionQEditForm);

end.
