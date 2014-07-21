unit GoodsKind_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dsdAddOn, dxBarExtItems,
  dxSkinsCore;

type
  TGoodsKind_ObjectForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    clName: TcxGridDBColumn;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    clErased: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dxBarStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    bbChoiceGuide: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsKind_ObjectForm);

end.
