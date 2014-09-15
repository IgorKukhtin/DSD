unit GoodsGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, Vcl.ComCtrls,
  cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit,
  dsdAddOn, cxCheckBox, dxSkinsCore, dxBarExtItems, dxSkinsDefaultPainters,
  dxSkinsdxBarPainter;

type
  TGoodsGroupForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    cxDBTreeList1cxDBTreeListColumn2: TcxDBTreeListColumn;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    cxDBTreeList: TcxDBTreeList;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    cxDBTreeListcxDBTreeListColumn1: TcxDBTreeListColumn;
    cxDBTreeListcxDBTreeListColumn2: TcxDBTreeListColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBTreeAddOn: TdsdDBTreeAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsGroupForm);

end.
