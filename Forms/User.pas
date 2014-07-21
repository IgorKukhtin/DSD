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
  Vcl.ExtCtrls;

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
    dsdStoredProc: TdsdStoredProc;
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
    colRoleName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colPeriod: TcxGridDBColumn;
    ChoiceRole: TOpenChoiceForm;
    PeriodCloseDS: TDataSource;
    PeriodCloseCDS: TClientDataSet;
    PeriodCloseViewAddOn: TdsdDBViewAddOn;
    spPeriodClose: TdsdStoredProc;
    spInsertUpdatePeriodClose: TdsdStoredProc;
    HorSplitter: TcxSplitter;
    ChoiceUnit: TOpenChoiceForm;
    UpdatePeriodClose: TdsdUpdateDataSet;
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
