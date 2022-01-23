unit CashChildJournal;

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
  dsdGuides, cxButtonEdit, cxSplitter;

type
  TCashChildJournalForm = class(TParentForm)
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
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    StatusCode: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
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
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    InsertDate: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    spSelectPrint: TdsdStoredProc;
    bbPrint: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    FormParams: TdsdFormParams;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    spMovementReComplete: TdsdStoredProc;
    spReCompete: TdsdExecStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    N1: TMenuItem;
    ExecuteDialog: TExecuteDialog;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    actRefreshStart: TdsdDataSetRefresh;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    ceKindName: TcxTextEdit;
    isSign: TcxGridDBColumn;
    cxTopSplitter: TcxSplitter;
    cxGridChild: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    StatusCode_ch: TcxGridDBColumn;
    InvNumber_ch: TcxGridDBColumn;
    OperDate_ch: TcxGridDBColumn;
    isSign_ch: TcxGridDBColumn;
    ServiceDate_ch: TcxGridDBColumn;
    CashCode_ch: TcxGridDBColumn;
    CashName_ch: TcxGridDBColumn;
    UnitCode_ch: TcxGridDBColumn;
    UnitName_ch: TcxGridDBColumn;
    Amount_ch: TcxGridDBColumn;
    InfoMoneyCode_ch: TcxGridDBColumn;
    InfoMoneyName_ch: TcxGridDBColumn;
    InfoMoneyDetailName_ch: TcxGridDBColumn;
    CommentInfoMoneyName_ch: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DataSourceChild: TDataSource;
    ClientDataSetChild: TClientDataSet;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
    spSelectChild: TdsdStoredProc;
    spInsertUpdate_Sign: TdsdStoredProc;
    spUpdate_Sign_isErased: TdsdStoredProc;
    actUpdate_Sign_isErased: TdsdExecStoredProc;
    actInsertUpdate_Sign: TdsdExecStoredProc;
    bbInsertUpdate_Sign: TdxBarButton;
    bbUpdate_Sign_isErased: TdxBarButton;
    UserName_1: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashChildJournalForm);

end.
