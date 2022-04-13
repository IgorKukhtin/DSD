unit Report_PaperRecipeSP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, cxCustomPivotGrid,
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, dsdPivotGrid,
  cxDBEdit, dsdGuides, cxButtonEdit;

type
  TReport_PaperRecipeSPForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    spGetBalanceParam: TdsdStoredProc;
    FormParams: TdsdFormParams;
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bbcbTotal: TdxBarControlContainerItem;
    bbOpenReport_AccountMotion: TdxBarButton;
    bbReport_Account: TdxBarButton;
    bbPrint3: TdxBarButton;
    bbGroup: TdxBarControlContainerItem;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    BrandSPName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    KindOutSPName: TcxGridDBColumn;
    PriceSP: TcxGridDBColumn;
    SummSP: TcxGridDBColumn;
    actUpdate: TdsdInsertUpdateAction;
    bbUpdate: TdxBarButton;
    CommentSendName: TcxGridDBColumn;
    MakerSP: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    CountSP: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    cbisInsert: TcxCheckBox;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    edDateInvoice: TcxDateEdit;
    edInvoice: TcxTextEdit;
    cxLabel8: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edJuridicalMedic: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesJuridical: TdsdGuides;
    GuidesJuridicalMedic: TdsdGuides;
    InvNumber_Invoice: TcxGridDBColumn;
    macPrintInvoice: TMultiAction;
    spSavePrintMovement: TdsdStoredProc;
    actSaveMovement: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    actPrintDepartment: TdsdPrintAction;
    HospitalName: TcxGridDBColumn;
    isPrintLast: TcxGridDBColumn;
    IntenalSPName: TcxGridDBColumn;
    JuridicalFullName: TcxGridDBColumn;
    JuridicalAddress: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    MainName: TcxGridDBColumn;
    MainName_Cut: TcxGridDBColumn;
    AccounterName: TcxGridDBColumn;
    INN: TcxGridDBColumn;
    NumberVAT: TcxGridDBColumn;
    BankAccount: TcxGridDBColumn;
    Phone: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    MFO: TcxGridDBColumn;
    NumLine: TcxGridDBColumn;
    SummaSP: TcxGridDBColumn;
    PartnerMedical_MainName: TcxGridDBColumn;
    PartnerMedical_FullName: TcxGridDBColumn;
    Department_FullName: TcxGridDBColumn;
    Department_MainName: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PaperRecipeSPForm);

end.
