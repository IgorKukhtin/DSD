unit UnitTree;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  ParentForm, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu, cxImageComboBox,
  cxCheckBox, dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar,
  cxPropertiesStore, Datasnap.DBClient, cxGrid, cxSplitter, cxInplaceContainer,
  cxDBTL, cxTLData;

type
  TUnitTreeForm = class(TParentForm)
    TreeDS: TDataSource;
    TreeDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    spTree: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    cxDBTreeList: TcxDBTreeList;
    ceParentName: TcxDBTreeListColumn;
    cxSplitter1: TcxSplitter;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    GridDS: TDataSource;
    ClientDataSet: TClientDataSet;
    spGrid: TdsdStoredProc;
    ceCode: TcxGridDBColumn;
    ceName: TcxGridDBColumn;
    ceBranchName: TcxGridDBColumn;
    ceisErased: TcxGridDBColumn;
    dsdDBTreeAddOn: TdsdDBTreeAddOn;
    dsdFormParams: TdsdFormParams;
    bbChoice: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dxBarStatic: TdxBarStatic;
    ceTreeState: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    bbUnitChoiceForm: TdxBarButton;
    dsdOpenUnitForm: TdsdOpenForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUnitTreeForm);

end.
