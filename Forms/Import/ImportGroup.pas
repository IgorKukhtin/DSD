unit ImportGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, cxSplitter, Vcl.StdActns, cxDropDownEdit,
  ExternalLoad, cxBlobEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TImportGroupForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    clIisErased: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    spInsertUpdateImportGroup: TdsdStoredProc;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    spSelectItems: TdsdStoredProc;
    spInsertUpdateImportGroupItems: TdsdStoredProc;
    dsdDBViewAddOnItems: TdsdDBViewAddOn;
    dsdUpdateMaster: TdsdUpdateDataSet;
    dsdUpdateChild: TdsdUpdateDataSet;
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
    bbChoiceGuides: TdxBarButton;
    ImportSettingsChoiceForm: TOpenChoiceForm;
    cxSplitter1: TcxSplitter;
    ExecuteImportSettingsAction: TExecuteImportSettingsAction;
    bbExecuteImportSettings: TdxBarButton;
    mactLoadPrice: TMultiAction;
    bbLoadAllPrice: TdxBarButton;
    colName: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    actProtocol: TdsdExecStoredProc;
    spUpdate_Protocol_LoadPriceList: TdsdStoredProc;
    macExecuteImportSettings_Protocol: TMultiAction;
    spRefreshMovementItemLastPriceList_View: TdsdStoredProc;
    actRefreshMovementItemLastPriceList_View: TdsdExecStoredProc;
    macGUILoadPrice: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TImportGroupForm);

end.
