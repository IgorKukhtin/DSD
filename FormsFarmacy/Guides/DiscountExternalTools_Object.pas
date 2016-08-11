unit DiscountExternalTools_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TDiscountExternalTools_ObjectForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clCode: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clErased: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    clUserName: TcxGridDBColumn;
    clPassword: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    DiscountExternalCode: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TDiscountExternalTools_ObjectForm);
end.
