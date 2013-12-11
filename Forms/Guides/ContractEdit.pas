unit ContractEdit;

interface

uses
  DataModul, AncestorEditDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, Data.DB, cxDBData, cxButtonEdit, dxBar, Datasnap.DBClient,
  dsdGuides, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, Vcl.ExtCtrls,
  cxCurrencyEdit, cxDropDownEdit, cxCalendar, cxMaskEdit, cxLabel, Vcl.Controls,
  cxTextEdit, dsdDB, dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore,
  dsdAddOn, Vcl.StdCtrls, cxButtons, cxInplaceContainer, cxVGrid, cxDBVGrid,
  Document;

type
  TContractEditForm = class(TAncestorEditDialogForm)
    edInvNumber: TcxTextEdit;
    LbInvNumber: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel5: TcxLabel;
    edContractKind: TcxButtonEdit;
    edJuridical: TcxButtonEdit;
    edSigningDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edStartDate: TcxDateEdit;
    edEndDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    cxLabel9: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    ContractKindGuides: TdsdGuides;
    edPaidKind: TcxButtonEdit;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edInvNumberArchive: TcxTextEdit;
    cxLabel7: TcxLabel;
    edPersonal: TcxButtonEdit;
    PersonalGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edArea: TcxButtonEdit;
    AreaGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    edContractArticle: TcxButtonEdit;
    ContractArticleGuides: TdsdGuides;
    cxLabel14: TcxLabel;
    edContractStateKind: TcxButtonEdit;
    ContractStateKindGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    ContractConditionDS: TDataSource;
    ContractConditionCDS: TClientDataSet;
    spInsertUpdateContractCondition: TdsdStoredProc;
    spSelectContractCondition: TdsdStoredProc;
    Panel: TPanel;
    cxGridContractCondition: TcxGrid;
    cxGridDBTableViewContractCondition: TcxGridDBTableView;
    cContractConditionKindName: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clsfcisErased: TcxGridDBColumn;
    cxGridContractConditionLevel: TcxGridLevel;
    dxBarDockControl1: TdxBarDockControl;
    BarManager: TdxBarManager;
    BarManagerBar1: TdxBar;
    BarManagerBar2: TdxBar;
    dxBarDockControl2: TdxBarDockControl;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    spDocumentSelect: TdsdStoredProc;
    DocumentDS: TDataSource;
    DocumentCDS: TClientDataSet;
    Document: TDocument;
    spInsertDocument: TdsdStoredProc;
    spGetDocument: TdsdStoredProc;
    colFileName: TcxDBEditorRow;
    actInsertDocument: TdsdExecStoredProc;
    bbAddDocument: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TContractEditForm);

end.
