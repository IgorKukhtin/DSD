unit RoleUnion;

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
  TRoleUnionForm = class(TParentForm)
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
    spAction: TdsdStoredProc;
    ActionDS: TDataSource;
    ActionCDS: TClientDataSet;
    ActionAddOn: TdsdDBViewAddOn;
    UserChoiceForm: TOpenChoiceForm;
    UserUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdateRoleAction: TdsdStoredProc;
    ActionChoiceForm: TOpenChoiceForm;
    ActionUpdateDataSet: TdsdUpdateDataSet;
    ProcessChoiceForm: TOpenChoiceForm;
    ProcessUpdateDataSet: TdsdUpdateDataSet;
    ProcessAccessChoiceForm: TOpenChoiceForm;
    ProcessAccessUpdateDataSet: TdsdUpdateDataSet;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    colProcess_EnumName: TcxGridDBColumn;
    Panel1: TPanel;
    ActionGrid: TcxGrid;
    ActionGridView: TcxGridDBTableView;
    cxGridDBColumn5: TcxGridDBColumn;
    ActionGridLevel: TcxGridLevel;
    cxSplitterTop: TcxSplitter;
    cxSplitterClient: TcxSplitter;
    cldescName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRoleUnionForm);

end.
