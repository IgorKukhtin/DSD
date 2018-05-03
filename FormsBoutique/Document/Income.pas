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
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxImageComboBox, ChoicePeriod;

type
  TIncomeForm = class(TParentForm)
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
    GuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    CountForPrice: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
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
    actUnCompleteMovement: TChangeGuidesStatus;
    actCompleteMovement: TChangeGuidesStatus;
    actDeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    MeasureName: TcxGridDBColumn;
    GuidesFrom: TdsdGuides;
    spGetTotalSumm: TdsdStoredProc;
    cxLabel12: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edCurrencyDocument: TcxButtonEdit;
    GuidesCurrencyDocument: TdsdGuides;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    actMIProtocol: TdsdOpenForm;
    bbMIProtocol: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbAddMask: TdxBarButton;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecord: TdxBarButton;
    cxLabel7: TcxLabel;
    ceParValue: TcxCurrencyEdit;
    bbUpdateRecord1: TdxBarButton;
    actInsertAction: TdsdInsertUpdateAction;
    actUpdateAction: TdsdInsertUpdateAction;
    mactInsertAction: TMultiAction;
    actRefreshMI: TdsdDataSetRefresh;
    mactUpdateAction: TMultiAction;
    JuridicalName: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    actPrintIn: TdsdPrintAction;
    actPrintSticker: TdsdPrintAction;
    dxBarButton2: TdxBarButton;
    spSelectPrintSticker: TdsdStoredProc;
    TotalSummBalance: TcxGridDBColumn;
    actInsertMaskAction: TdsdInsertUpdateAction;
    mactInsertMaskAction: TMultiAction;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actPrintInSecond: TdsdPrintAction;
    bbPrintInSecond: TdxBarButton;
    isProtocol: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edGoodsPrint: TcxButtonEdit;
    GuidesGoodsPrint: TdsdGuides;
    spGet_GoodsPrint_Null: TdsdStoredProc;
    spSelectPrintStickerList: TdsdStoredProc;
    spGet_User_curr: TdsdStoredProc;
    spInsertUpdate_GoodsPrint: TdsdStoredProc;
    spUpdate_FloatValue_DS: TdsdStoredProc;
    actPrintStickerList: TdsdPrintAction;
    actGet_GoodsPrint_Null: TdsdExecStoredProc;
    actUpdate_FloatValue_DS: TdsdExecStoredProc;
    actInsertUpdate_GoodsPrint: TdsdExecStoredProc;
    macAddGoodsPrintList_Rem: TMultiAction;
    mactGoodsPrintList_Print: TMultiAction;
    bbGoodsPrintList_Print: TdxBarButton;
    spGet_PrinterByUser: TdsdStoredProc;
    actGet_PrinterByUser: TdsdExecStoredProc;
    macPrintSticker: TMultiAction;
    ExecuteDialogDiscount: TExecuteDialog;
    spInsertUpdate_Discount: TdsdStoredProc;
    spUpdatePersent: TdsdExecStoredProc;
    macUpdatePersent: TMultiAction;
    macUpdateAll: TMultiAction;
    bbUpdateAll: TdxBarButton;
    cxLabel5: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    spGet_Current_Date: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeForm);

end.
