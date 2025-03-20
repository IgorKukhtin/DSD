unit Unit_Personal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  dxSkinsdxBarPainter, dsdAddOn, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxSplitter, cxButtonEdit, cxCalendar, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  Vcl.ExtCtrls, ChoicePeriod, dsdCommon, cxCurrencyEdit;

type
  TUnit_PersonalForm = class(TParentForm)
    cxSplitter1: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbChoice: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdSetUnErased: TdsdUpdateErased;
    GridDS: TDataSource;
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    BusinessName: TcxGridDBColumn;
    ProfitLossGroupCode: TcxGridDBColumn;
    ProfitLossGroupName: TcxGridDBColumn;
    ProfitLossDirectionCode: TcxGridDBColumn;
    ProfitLossDirectionName: TcxGridDBColumn;
    ParentName: TcxGridDBColumn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    AreaName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PersonalHeadName: TcxGridDBColumn;
    Address: TcxGridDBColumn;
    actUnitChoiceForm: TOpenChoiceForm;
    actUpdate_HistoryCost: TdsdUpdateDataSet;
    actProtocol: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    actInsertUpdate_PersonalService: TdsdExecStoredProc;
    macInsertUpdate_PersonalService_list: TMultiAction;
    macInsertUpdate_PersonalService: TMultiAction;
    isPersonalService: TcxGridDBColumn;
    PersonalServiceDate: TcxGridDBColumn;
    spUpdate_Unit_Personal: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    gpInsertUpdate_PersonalService_byUnit: TdsdStoredProc;
    bbInsertUpdate_PersonalService: TdxBarButton;
    PeriodChoice: TPeriodChoice;
    spInsert_MessagePersonalService: TdsdStoredProc;
    dxLabel3: TdxBarControlContainerItem;
    bbSessionCode: TdxBarControlContainerItem;
    actInsert_MessagePersonalService: TdsdExecStoredProc;
    actOpenMessagePersonalServiceForm: TdsdOpenForm;
    bbMessagePersonalServiceForm: TdxBarButton;
    PersonalServiceListName: TcxGridDBColumn;
    isError_psl: TcxGridDBColumn;
    DepartmentName: TcxGridDBColumn;
    spGet_Param: TdsdStoredProc;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    edSessionCode: TcxCurrencyEdit;
    spGet_Param_next: TdsdStoredProc;
    actGet_Param_next: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spComplete_Mov: TdsdStoredProc;
    actComplete_Mov: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnit_PersonalForm);
end.
