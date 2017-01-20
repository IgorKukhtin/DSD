unit UserSettings;

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
  dxSkinsdxBarPainter;

type
  TUserSettingsForm = class(TParentForm)
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
    dsdGridToExcel: TdsdGridToExcel;
    dsdChoiceGuides: TdsdChoiceGuides;
    spSelect: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    spErasedUnErased: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    clMemberName: TcxGridDBColumn;
    cxSplitter: TcxSplitter;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    User_: TcxGridDBColumn;
    spUpdateUser: TdsdStoredProc;
    UpdateDataSetUser: TdsdUpdateDataSet;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    bbProtocolRole: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUserSettingsForm);

end.
