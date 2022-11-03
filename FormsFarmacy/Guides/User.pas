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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

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
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoice: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
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
    cxGridDBColumn5: TcxGridDBColumn;
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
    Foto: TcxGridDBColumn;
    InDate: TcxGridDBColumn;
    FarmacyCashDate: TcxGridDBColumn;
    isSite: TcxGridDBColumn;
    bbOpenUserHelsiEdit: TdxBarButton;
    OpenUserHelsiEditForm: TdsdOpenForm;
    spClearDefaultUnit: TdsdStoredProc;
    actClearDefaultUnit: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    isNewUser: TcxGridDBColumn;
    isDismissedUser: TcxGridDBColumn;
    isInternshipCompleted: TcxGridDBColumn;
    InternshipConfirmation: TcxGridDBColumn;
    DateInternshipConfirmation: TcxGridDBColumn;
    dxBarSubItem1: TdxBarSubItem;
    spUpdate_InternshipConfirmation: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actUpdate_InternshipConfirmation_0: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    DateInternshipCompleted: TcxGridDBColumn;
    Language: TcxGridDBColumn;
    EducationName: TcxGridDBColumn;
    isPhotosOnSite: TcxGridDBColumn;
    isActive: TcxGridDBColumn;
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
