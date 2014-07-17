unit ImportSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit;

type
  TImportSettingsForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    clIName: TcxGridDBColumn;
    clIisErased: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    clDirectory: TcxGridDBColumn;
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
    clImportTypeItemsName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clContractName: TcxGridDBColumn;
    clFileTypeName: TcxGridDBColumn;
    clImportTypeName: TcxGridDBColumn;
    clStartRow: TcxGridDBColumn;
    JuridicalChoiceForm: TOpenChoiceForm;
    ImportTypeItemsChoiceForm: TOpenChoiceForm;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    ContractChoiceForm: TOpenChoiceForm;
    FileTypeKindChoiceForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TImportSettingsForm);

end.
