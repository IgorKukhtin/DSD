unit User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore,
  Datasnap.DBClient, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxButtonEdit, cxSplitter,
  Vcl.ExtCtrls, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TUserForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clCode: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoice: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    actGridToExcel: TdsdGridToExcel;
    dsdChoiceGuides: TdsdChoiceGuides;
    spSelect: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    spErasedUnErased: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    clMemberName: TcxGridDBColumn;
    RoleAddOn: TdsdDBViewAddOn;
    spUserRole: TdsdStoredProc;
    spInsertUpdateUserRole: TdsdStoredProc;
    RoleDS: TDataSource;
    RoleCDS: TClientDataSet;
    RoleGrid: TcxGrid;
    RoleGridView: TcxGridDBTableView;
    Name_ch1: TcxGridDBColumn;
    RoleGridLevel: TcxGridLevel;
    cxSplitter: TcxSplitter;
    UpdateDataSet: TdsdUpdateDataSet;
    OpenChoiceForm: TOpenChoiceForm;
    Panel: TPanel;
    RoleName: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    CloseDate_excl: TcxGridDBColumn;
    ChoiceRole: TOpenChoiceForm;
    PeriodCloseDS: TDataSource;
    PeriodCloseCDS: TClientDataSet;
    PeriodCloseViewAddOn: TdsdDBViewAddOn;
    spPeriodClose: TdsdStoredProc;
    spInsertUpdatePeriodClose: TdsdStoredProc;
    HorSplitter: TcxSplitter;
    ChoiceUnit: TOpenChoiceForm;
    UpdatePeriodClose: TdsdUpdateDataSet;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    User_: TcxGridDBColumn;
    spInsertUpdateUser: TdsdStoredProc;
    UpdateDataSetUser: TdsdUpdateDataSet;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    actProtocolRoleForm: TdsdOpenForm;
    bbProtocolRole: TdxBarButton;
    clProjectMobile: TcxGridDBColumn;
    clisProjectMobile: TcxGridDBColumn;
    BillNumberMobile: TcxGridDBColumn;
    clUpdateMobileFrom: TcxGridDBColumn;
    clUpdateMobileTo: TcxGridDBColumn;
    MobileModel: TcxGridDBColumn;
    MobileVesion: TcxGridDBColumn;
    MobileVesionSDK: TcxGridDBColumn;
    Code_ch1: TcxGridDBColumn;
    spUpdate_PhoneAuthent: TdsdStoredProc;
    macUpdate_PhoneAuthent: TMultiAction;
    actUpdate_PhoneAuthent: TdsdExecStoredProc;
    bbUpdate_PhoneAuthent: TdxBarButton;
    FormParams: TdsdFormParams;
    spUpdate_UserRole_byMask: TdsdStoredProc;
    actUpdate_UserRole_byMask: TdsdExecStoredProc;
    macUpdate_UserRole_byMask: TMultiAction;
    bbUpdate_UserRole_forMask: TdxBarButton;
    actRefresh_Role: TdsdDataSetRefresh;
    isKeyAuthent: TcxGridDBColumn;
    spUpdate_KeyAuthent: TdsdStoredProc;
    bbUpdate_KeyAuthent: TdxBarButton;
    actUpdate_KeyAuthent: TdsdExecStoredProc;
    actGridToExcel_Role: TdsdGridToExcel;
    bbGridToExcel_Role: TdxBarButton;
    macPrintUser_Badge_list: TMultiAction;
    bbPrintUser_Badge: TdxBarButton;
    bbPrintUser_Badge_list: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    PrintUser_BadgeCDS: TClientDataSet;
    spPrintUser_Badge: TdsdStoredProc;
    actPrintUser_Badge: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUserForm);

end.

    OpenChoiceForm1: TOpenChoiceForm;
