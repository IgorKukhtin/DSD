unit Role;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore,
  Datasnap.DBClient, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxSplitter, Vcl.ExtCtrls,
  cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TRoleForm = class(TParentForm)
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
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLeftSplitter: TcxSplitter;
    ProcessDS: TDataSource;
    ProcessCDS: TClientDataSet;
    ProcessAddOn: TdsdDBViewAddOn;
    spAction: TdsdStoredProc;
    Panel1: TPanel;
    UserGrid: TcxGrid;
    UserView: TcxGridDBTableView;
    colCodeUser: TcxGridDBColumn;
    colNameUser: TcxGridDBColumn;
    UserLevel: TcxGridLevel;
    ActionDS: TDataSource;
    ActionCDS: TClientDataSet;
    ActionAddOn: TdsdDBViewAddOn;
    spProcess: TdsdStoredProc;
    ActionGrid: TcxGrid;
    ActionGridView: TcxGridDBTableView;
    cxGridDBColumn5: TcxGridDBColumn;
    ActionGridLevel: TcxGridLevel;
    ProcessGrid: TcxGrid;
    ProcessView: TcxGridDBTableView;
    cxGridDBColumn8: TcxGridDBColumn;
    ProcessLevel: TcxGridLevel;
    UserCDS: TClientDataSet;
    UserDS: TDataSource;
    spRoleUser: TdsdStoredProc;
    UserAddOn: TdsdDBViewAddOn;
    UserChoiceForm: TOpenChoiceForm;
    spInsertUpdateUserRole: TdsdStoredProc;
    UserUpdateDataSet: TdsdUpdateDataSet;
    cxSplitterTop: TcxSplitter;
    cxSplitterClient: TcxSplitter;
    spInsertUpdateRoleAction: TdsdStoredProc;
    ActionChoiceForm: TOpenChoiceForm;
    ActionUpdateDataSet: TdsdUpdateDataSet;
    ProcessChoiceForm: TOpenChoiceForm;
    ProcessUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdateRoleProcess: TdsdStoredProc;
    clProcess_EnumName: TcxGridDBColumn;
    ProcessAccessViewAddOn: TdsdDBViewAddOn;
    ProcessAccessCDS: TClientDataSet;
    ProcessAccessDS: TDataSource;
    spProcessAccess: TdsdStoredProc;
    spInsertUpdateProcessAccess: TdsdStoredProc;
    AccessGrid: TcxGrid;
    AccessGridDBTableView: TcxGridDBTableView;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    AccessGridLevel: TcxGridLevel;
    ProcessAccessChoiceForm: TOpenChoiceForm;
    ProcessAccessUpdateDataSet: TdsdUpdateDataSet;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    colisErased: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    actProtocolActionForm: TdsdOpenForm;
    actProtocolProcessForm: TdsdOpenForm;
    bbProtocolAction: TdxBarButton;
    bbProtocolProcess: TdxBarButton;
    actProtocolProcessAccessForm: TdsdOpenForm;
    bbProtocolProcessAccess: TdxBarButton;
    actProtocolUserForm: TdsdOpenForm;
    bbProtocolUser: TdxBarButton;
    cxSplitter1: TcxSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRoleForm);

end.
