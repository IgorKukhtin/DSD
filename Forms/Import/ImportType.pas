unit ImportType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.ExtCtrls, cxSplitter, cxDropDownEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarBuiltInMenu, cxNavigator;

type
  TImportTypeForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    clIName: TcxGridDBColumn;
    clIisErased: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    clProcedureName: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    spInsertUpdateImportType: TdsdStoredProc;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    spSelectItems: TdsdStoredProc;
    spInsertUpdateImportTypeItems: TdsdStoredProc;
    dsdDBViewAddOnItems: TdsdDBViewAddOn;
    dsdUpdateMaster: TdsdUpdateDataSet;
    dsdUpdateChild: TdsdUpdateDataSet;
    spErasedUnErased: TdsdStoredProc;
    spErasedUnErasedChild: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    dsdSetErasedChild: TdsdUpdateErased;
    dsdUnErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbdsdChoiceGuides: TdxBarButton;
    clParamType: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    clNumber: TcxGridDBColumn;
    clUserParamName: TcxGridDBColumn;
    clEnumName: TcxGridDBColumn;
    clJSONParamName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TImportTypeForm);

end.
