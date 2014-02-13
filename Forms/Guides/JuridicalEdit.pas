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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxImageComboBox;

type
  TJuridicalEditForm = class(TAncestorDialogForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    spInsertUpdate: TdsdStoredProc;
    spGet: TdsdStoredProc;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edGLNCode: TcxTextEdit;
    cbisCorporate: TcxCheckBox;
    cxLabel3: TcxLabel;
    JuridicalGroupGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    GoodsPropertyGuides: TdsdGuides;
    ceJuridicalGroup: TcxButtonEdit;
    ceGoodsProperty: TcxButtonEdit;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    JuridicalDetailTS: TcxTabSheet;
    PartnerTS: TcxTabSheet;
    Panel: TPanel;
    dxBarManager: TdxBarManager;
    PartnerBar: TdxBar;
    PartnerDockControl: TdxBarDockControl;
    edFullName: TcxDBTextEdit;
    edJuridicalAddress: TcxDBTextEdit;
    edOKPO: TcxDBTextEdit;
    JuridicalDetailsGridDBTableView: TcxGridDBTableView;
    JuridicalDetailsGridLevel: TcxGridLevel;
    JuridicalDetailsGrid: TcxGrid;
    JuridicalDetailsDS: TDataSource;
    JuridicalDetailsCDS: TClientDataSet;
    colJDData: TcxGridDBColumn;
    PartnerDS: TDataSource;
    PartnerCDS: TClientDataSet;
    ContractDS: TDataSource;
    ContractCDS: TClientDataSet;
    PartnerGridDBTableView: TcxGridDBTableView;
    PartnerGridLevel: TcxGridLevel;
    PartnerGrid: TcxGrid;
    ContractGridDBTableView: TcxGridDBTableView;
    ContractGridLevel: TcxGridLevel;
    ContractGrid: TcxGrid;
    actPartnerRefresh: TdsdDataSetRefresh;
    actContractRefresh: TdsdDataSetRefresh;
    spJuridicalDetails: TdsdStoredProc;
    spPartner: TdsdStoredProc;
    spContract: TdsdStoredProc;
    JuridicalDetailsAddOn: TdsdDBViewAddOn;
    PartnerAddOn: TdsdDBViewAddOn;
    ContractAddOn: TdsdDBViewAddOn;
    PageControl: TcxPageControl;
    bbPartnerRefresh: TdxBarButton;
    bbContractRefresh: TdxBarButton;
    ContractBar: TdxBar;
    colPartnerCode: TcxGridDBColumn;
    colPartnerAddress: TcxGridDBColumn;
    colPartnerisErased: TcxGridDBColumn;
    spJuridicalDetailsIU: TdsdStoredProc;
    edINN: TcxDBTextEdit;
    edAccounterName: TcxDBTextEdit;
    edNumberVAT: TcxDBTextEdit;
    edBankAccount: TcxDBTextEdit;
    JuridicalDetailsUDS: TdsdUpdateDataSet;
    bbStatic: TdxBarStatic;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    edBank: TcxDBButtonEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    actSave: TdsdExecStoredProc;
    actChoiceBank: TOpenChoiceForm;
    actContractInsert: TdsdInsertUpdateAction;
    actContractUpdate: TdsdInsertUpdateAction;
    bbContractInsert: TdxBarButton;
    bbContractUpdate: TdxBarButton;
    actMultiContractInsert: TMultiAction;
    actMultiPartnerInsert: TMultiAction;
    clEndDate: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    cxLabel14: TcxLabel;
    cePriceList: TcxButtonEdit;
    dsdPriceListGuides: TdsdGuides;
    cxLabel15: TcxLabel;
    cePriceListPromo: TcxButtonEdit;
    dsdPriceListPromoGuides: TdsdGuides;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edEndPromo: TcxDateEdit;
    edStartPromo: TcxDateEdit;
    spClearDefaluts: TdsdStoredProc;
    clCode: TcxGridDBColumn;
    clInvNumberArchive: TcxGridDBColumn;
    clPersonalName: TcxGridDBColumn;
    clAreaName: TcxGridDBColumn;
    clContractArticleName: TcxGridDBColumn;
    clContractStateKindCode: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    cxLabel18: TcxLabel;
    edPhone: TcxDBTextEdit;
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
