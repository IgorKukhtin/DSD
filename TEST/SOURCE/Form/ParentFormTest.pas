unit ParentFormTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, dsdAddOn, cxPropertiesStore, dsdAction,
  Vcl.ActnList, Vcl.Menus, dxBarExtItems, dxBar, Datasnap.DBClient, dsdDB;

type
  TTestForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clCode: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clNDSKindName: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    Excel1: TMenuItem;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actGridToExcel: TdsdGridToExcel;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetUnErased: TdsdUpdateErased;
    dsdSetErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    MasterCDS: TClientDataSet;
    MasterDS: TDataSource;
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbGridToExcel: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    spSelect: TdsdStoredProc;
    spErasedUnErased: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TTestForm);

end.
