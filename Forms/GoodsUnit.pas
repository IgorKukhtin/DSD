unit GoodsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDataSetWrapperUnit, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdActionUnit, FormUnit, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit;

type
  TGoodsForm = class(TParentForm)
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
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    cxDBTreeList: TcxDBTreeList;
    cxDBTreeListcxDBTreeListColumn1: TcxDBTreeListColumn;
    cxDBTreeListcxDBTreeListColumn2: TcxDBTreeListColumn;
    cxDBTreeListcxDBTreeListColumn3: TcxDBTreeListColumn;
    cxDBTreeListcxDBTreeListColumn4: TcxDBTreeListColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsForm);

end.
