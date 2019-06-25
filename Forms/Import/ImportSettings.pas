unit ImportSettings;

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
  ExternalLoad, cxBlobEdit, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxTimeEdit,
  cxCurrencyEdit;

type
  TImportSettingsForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    clParamName: TcxGridDBColumn;
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
    colParamValue: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clContractName: TcxGridDBColumn;
    clFileTypeName: TcxGridDBColumn;
    clImportTypeName: TcxGridDBColumn;
    clStartRow: TcxGridDBColumn;
    LoadObjectChoiceForm: TOpenChoiceForm;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    ContractChoiceForm: TOpenChoiceForm;
    FileTypeKindChoiceForm: TOpenChoiceForm;
    cxSplitter1: TcxSplitter;
    colParamNumber: TcxGridDBColumn;
    FileDialogAction: TFileDialogAction;
    ImportType: TOpenChoiceForm;
    clHDR: TcxGridDBColumn;
    colDefaultValue: TcxGridDBColumn;
    clQuery: TcxGridDBColumn;
    colUserParamName: TcxGridDBColumn;
    actAfterScroll: TdsdDataSetRefresh;
    clStartTime: TcxGridDBColumn;
    clEndTime: TcxGridDBColumn;
    clCheckTime: TcxGridDBColumn;
    clContactPersonName: TcxGridDBColumn;
    ContactPersonChoiceForm: TOpenChoiceForm;
    clContactPersonMail: TcxGridDBColumn;
    actProtocolMaster: TdsdOpenForm;
    bbProtocolMaster: TdxBarButton;
    clEmailKindName: TcxGridDBColumn;
    EmailChoiceForm: TOpenChoiceForm;
    isMultiLoad: TcxGridDBColumn;
    colConvertFormatInExcel: TcxGridDBColumn;
    actProtocolChild: TdsdOpenForm;
    bbProtocolChild: TdxBarButton;
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
