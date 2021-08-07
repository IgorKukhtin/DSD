unit Member;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  DataModul, cxButtonEdit, cxContainer, cxTextEdit, cxMaskEdit, cxLabel,
  dsdGuides, ExternalLoad;

type
  TMemberForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
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
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    INN: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    DriverCertificate: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    IsOfficial: TcxGridDBColumn;
    bbUpdateIsOfficial: TdxBarButton;
    spUpdateIsOfficial: TdsdStoredProc;
    actUpdateIsOfficial: TdsdExecStoredProc;
    InfoMoneyName_all: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    actChoiceInfoMoneyForm: TOpenChoiceForm;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    isDateOut: TcxGridDBColumn;
    CardSecond: TcxGridDBColumn;
    BankChildName: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    BankSecondName: TcxGridDBColumn;
    spUpdateBank: TdsdStoredProc;
    cxLabel6: TcxLabel;
    edBank: TcxButtonEdit;
    BankGuides: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    actUpdateBank: TdsdExecStoredProc;
    macUpdateBank: TMultiAction;
    actUpdateBankSecond: TdsdExecStoredProc;
    macUpdateBankSecond: TMultiAction;
    bbUpdateBank: TdxBarButton;
    bbUpdateBankSecond: TdxBarButton;
    spUpdateBankSecond: TdsdStoredProc;
    macUpdateBankSecondAll: TMultiAction;
    macUpdateBankAll: TMultiAction;
    actChoiceBankForm: TOpenChoiceForm;
    actChoiceBankSecondForm: TOpenChoiceForm;
    actChoiceBankChildForm: TOpenChoiceForm;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    actGetImportSetting: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    macStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    spGetImportSettingIdSecond: TdsdStoredProc;
    actGetImportSettingSecond: TdsdExecStoredProc;
    macStartLoadSecond: TMultiAction;
    bbStartLoadSecond: TdxBarButton;
    macStartLoadIBAN: TMultiAction;
    actGetImportSettingIBAN: TdsdExecStoredProc;
    spGetImportSettingIdIBAN: TdsdStoredProc;
    spGetImportSettingIdIBANSecond: TdsdStoredProc;
    macStartLoadIBANSecond: TMultiAction;
    actGetImportSettingIBANSecond: TdsdExecStoredProc;
    bbStartLoadIBAN: TdxBarButton;
    bbStartLoadIBANSecond: TdxBarButton;
    GenderName: TcxGridDBColumn;
    MemberSkillName: TcxGridDBColumn;
    JobSourceName: TcxGridDBColumn;
    RegionName: TcxGridDBColumn;
    RegionName_Real: TcxGridDBColumn;
    CityName: TcxGridDBColumn;
    CityName_Real: TcxGridDBColumn;
    Street: TcxGridDBColumn;
    Street_Real: TcxGridDBColumn;
    Children1: TcxGridDBColumn;
    Children2: TcxGridDBColumn;
    Children3: TcxGridDBColumn;
    Children4: TcxGridDBColumn;
    Children5: TcxGridDBColumn;
    Birthday_Date: TcxGridDBColumn;
    Children1_Date: TcxGridDBColumn;
    Children2_Date: TcxGridDBColumn;
    Children3_Date: TcxGridDBColumn;
    Children4_Date: TcxGridDBColumn;
    Children5_Date: TcxGridDBColumn;
    PSP_StartDate: TcxGridDBColumn;
    PSP_EndDate: TcxGridDBColumn;
    Dekret_StartDate: TcxGridDBColumn;
    Dekret_EndDate: TcxGridDBColumn;
    Law: TcxGridDBColumn;
    DriverCertificateAdd: TcxGridDBColumn;
    PSP_S: TcxGridDBColumn;
    PSP_N: TcxGridDBColumn;
    PSP_W: TcxGridDBColumn;
    PSP_D: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

initialization
  RegisterClass(TMemberForm);

end.
