unit Income;

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
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit;

type
  TIncomeForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMovementItem: TdsdStoredProc;
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
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    spSelectMovementContainerItem: TdsdStoredProc;
    cxGridEntryDBTableView: TcxGridDBTableView;
    cxGridEntryLevel: TcxGridLevel;
    cxGridEntry: TcxGrid;
    colDebetAccountName: TcxGridDBColumn;
    colDebetAmount: TcxGridDBColumn;
    EntryCDS: TClientDataSet;
    EntryDS: TDataSource;
    colKreditAccountName: TcxGridDBColumn;
    colKreditAmount: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdateMovementItem: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    frxDBDataset: TfrxDBDataset;
    colDebetAccountGroupName: TcxGridDBColumn;
    colDebetAccountDirectionName: TcxGridDBColumn;
    colAccountCode: TcxGridDBColumn;
    colKreditAccountGroupName: TcxGridDBColumn;
    colKreditAccountDirectionName: TcxGridDBColumn;
    colGoodsGroupName: TcxGridDBColumn;
    colByObjectCode: TcxGridDBColumn;
    colByObjectName: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
    colAmountPacker: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colHeadCount: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colLiveWeight: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colAssetName: TcxGridDBColumn;
    colGoodsKindName_comlete: TcxGridDBColumn;
    colAccountOnComplete: TcxGridDBColumn;
    bbBooleanAction: TdxBarButton;
    bbStatic: TdxBarStatic;
    BooleanStoredProcAction: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    EntryViewAddOn: TdsdDBViewAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    edChangePercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    HeaderSaver: THeaderSaver;
    edInvNumberPartner: TcxTextEdit;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    colGoodsCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colInfoMoneyName_Detail: TcxGridDBColumn;
    colObjectCostId: TcxGridDBColumn;
    colPrice_comlete: TcxGridDBColumn;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    EntryToExcel: TdsdGridToExcel;
    bbEntryToGrid: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    edPacker: TcxButtonEdit;
    PackerGuides: TdsdGuides;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    ShowErasedAction: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    ceStatus: TcxButtonEdit;
    cxLabel11: TcxLabel;
    ChangeStatus: TChangeStatus;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeForm);

end.
