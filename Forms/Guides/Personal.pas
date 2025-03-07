unit Personal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm,
  DataModul, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCheckBox, dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, ChoicePeriod, cxButtonEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdGuides, dsdCommon;

type
  TPersonalForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    MemberCode: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    DateIn: TcxGridDBColumn;
    DateOut: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PersonalGroupName: TcxGridDBColumn;
    PositionLevelName: TcxGridDBColumn;
    IsOfficial: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    cbPeriod: TcxCheckBox;
    deStart: TcxDateEdit;
    cxlEnd: TcxLabel;
    deEnd: TcxDateEdit;
    IsDateOut: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    IsMain: TcxGridDBColumn;
    spUpdateIsMain: TdsdStoredProc;
    actUpdateIsMain: TdsdExecStoredProc;
    bbUpdateIsMain: TdxBarButton;
    actPositionChoice: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actUnitChoice: TOpenChoiceForm;
    actInsertMask: TdsdInsertUpdateAction;
    bbCopy: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    PersonalServiceListName: TcxGridDBColumn;
    PersonalServiceListOfficialName: TcxGridDBColumn;
    PersonalServiceListOfficialChoice: TOpenChoiceForm;
    SheetWorkTimeName: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    CardSecond: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    BankSecondName: TcxGridDBColumn;
    StorageLineName: TcxGridDBColumn;
    actStorageLine: TOpenChoiceForm;
    PersonalServiceListCardSecondChoice: TOpenChoiceForm;
    isPastMain: TcxGridDBColumn;
    Member_ReferName: TcxGridDBColumn;
    Member_MentorName: TcxGridDBColumn;
    ReasonOutName: TcxGridDBColumn;
    Member_ReferCode: TcxGridDBColumn;
    Member_MentorCode: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    Code1C: TcxGridDBColumn;
    spUpdate_isIrna: TdsdStoredProc;
    actUpdate_isIrna: TdsdExecStoredProc;
    macUpdate_isIrna_list: TMultiAction;
    macUpdate_isIrna: TMultiAction;
    bbUpdate_isIrna: TdxBarButton;
    cxLabel8: TcxLabel;
    cePersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    bcPersonalServiceList: TdxBarControlContainerItem;
    bcPersonalServiceList_text: TdxBarControlContainerItem;
    spUpdate_PersonalServiceList: TdsdStoredProc;
    actUpdate_PersonalServiceList: TdsdExecStoredProc;
    macUpdate_PersonalServiceList_list: TMultiAction;
    macUpdate_PersonalServiceList: TMultiAction;
    bbUpdate_PersonalServiceList: TdxBarButton;
    PositionCode: TcxGridDBColumn;
    PositionLevelCode: TcxGridDBColumn;
    PersonalServiceListAvanceF2: TOpenChoiceForm;
    ServiceListName_AvanceF2: TcxGridDBColumn;
    DepartmentName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TPersonalForm);
end.
