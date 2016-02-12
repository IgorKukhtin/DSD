unit WeighingPartnerItemJournal;

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
  dsdGuides, cxButtonEdit;

type
  TWeighingPartnerItemJournalForm = class(TParentForm)
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
    colInvNumberOrder: TcxGridDBColumn;
    colMovementDescName: TcxGridDBColumn;
    colEndWeighing: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    colInvNumber_parent: TcxGridDBColumn;
    bbReCompleteAll: TdxBarButton;
    spMovementReCompleteAll: TdsdStoredProc;
    colUserName: TcxGridDBColumn;
    colStartWeighing: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    colOperDate_parent: TcxGridDBColumn;
    colWeighingNumber: TcxGridDBColumn;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    actMovementProtocol: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    colMovementDescNumber: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    BoxNumber: TcxGridDBColumn;
    BoxName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    RouteSortingName: TcxGridDBColumn;
    edGoodsGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    GuidesGoods: TdsdGuides;
    isBarCode: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingPartnerItemJournalForm);

end.
