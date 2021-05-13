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
  dxSkinsdxBarPainter, cxCurrencyEdit;

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
