unit JuridicalEdit;

interface

uses
  DataModul, AncestorDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  cxControls, cxContainer, cxEdit, dsdGuides, dsdDB, cxMaskEdit, cxButtonEdit,
  cxCheckBox, cxCurrencyEdit, cxLabel, Vcl.Controls, cxTextEdit, System.Classes,
  Vcl.ActnList, dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxPCdxBarPopupMenu, cxPC, Vcl.ExtCtrls, dxBar, cxClasses, cxDBEdit, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dxBarExtItems, cxCalendar, dxSkinsCore,
  dxSkinsDefaultPainters, cxImageComboBox;

type
  TJuridicalEditForm = class(TAncestorDialogForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    spInsertUpdate: TdsdStoredProc;
    spGet: TdsdStoredProc;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cbisCorporate: TcxCheckBox;
    Panel: TPanel;
    dxBarManager: TdxBarManager;
    JuridicalDetailsDS: TDataSource;
    JuridicalDetailsCDS: TClientDataSet;
    ContractDS: TDataSource;
    ContractCDS: TClientDataSet;
    actContractRefresh: TdsdDataSetRefresh;
    spJuridicalDetails: TdsdStoredProc;
    spContract: TdsdStoredProc;
    JuridicalDetailsAddOn: TdsdDBViewAddOn;
    ContractAddOn: TdsdDBViewAddOn;
    ContractBar: TdxBar;
    spJuridicalDetailsIU: TdsdStoredProc;
    JuridicalDetailsUDS: TdsdUpdateDataSet;
    bbStatic: TdxBarStatic;
    actSave: TdsdExecStoredProc;
    actChoiceBank: TOpenChoiceForm;
    actContractInsert: TdsdInsertUpdateAction;
    actContractUpdate: TdsdInsertUpdateAction;
    bbContractInsert: TdxBarButton;
    bbContractUpdate: TdxBarButton;
    actMultiContractInsert: TMultiAction;
    spClearDefaluts: TdsdStoredProc;
    cxLabel19: TcxLabel;
    ceRetail: TcxButtonEdit;
    RetailGuides: TdsdGuides;
    PageControl: TcxPageControl;
    JuridicalDetailTS: TcxTabSheet;
    edFullName: TcxDBTextEdit;
    edJuridicalAddress: TcxDBTextEdit;
    edOKPO: TcxDBTextEdit;
    edINN: TcxDBTextEdit;
    edAccounterName: TcxDBTextEdit;
    edNumberVAT: TcxDBTextEdit;
    edBankAccount: TcxDBTextEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    edBank: TcxDBButtonEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    cxLabel18: TcxLabel;
    edPhone: TcxDBTextEdit;
    ContractTS: TcxTabSheet;
    ContractDockControl: TdxBarDockControl;
    ContractGrid: TcxGrid;
    ContractGridDBTableView: TcxGridDBTableView;
    clName: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    ContractGridLevel: TcxGridLevel;
    JuridicalDetailsGrid: TcxGrid;
    JuridicalDetailsGridDBTableView: TcxGridDBTableView;
    colJDData: TcxGridDBColumn;
    JuridicalDetailsGridLevel: TcxGridLevel;
    colDeferment: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalEditForm);

end.
