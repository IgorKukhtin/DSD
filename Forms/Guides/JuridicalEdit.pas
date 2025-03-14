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
  dxCore, cxDateUtils, cxDropDownEdit, cxImageComboBox, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

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
    StartDate: TcxGridDBColumn;
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
    Code: TcxGridDBColumn;
    Address: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
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
    EndDate: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
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
    InvNumberArchive: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    ContractArticleName: TcxGridDBColumn;
    ContractStateKindCode: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxLabel18: TcxLabel;
    edPhone: TcxDBTextEdit;
    cxLabel19: TcxLabel;
    ceRetailReport: TcxButtonEdit;
    RetailReportGuides: TdsdGuides;
    cxLabel20: TcxLabel;
    ceRetail: TcxButtonEdit;
    RetailGuides: TdsdGuides;
    cbisTaxSummary: TcxCheckBox;
    edDayTaxSummary: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    cxLabel22: TcxLabel;
    edMainName: TcxDBTextEdit;
    cbisDiscountPrice: TcxCheckBox;
    edInvNumberBranch: TcxDBTextEdit;
    cxLabel23: TcxLabel;
    cbisPriceWithVAT: TcxCheckBox;
    spCheckOKPO: TdsdStoredProc;
    cbisNotRealGoods: TcxCheckBox;
    cxLabel24: TcxLabel;
    edName_history: TcxDBTextEdit;
    GuidesSection: TdsdGuides;
    cxLabel25: TcxLabel;
    edSection: TcxButtonEdit;
    actShowErasedContract: TBooleanStoredProcAction;
    actShowErasedPartner: TBooleanStoredProcAction;
    bbShowErasedContract: TdxBarButton;
    bbShowErasedPartner: TdxBarButton;
    spErasedUnErasedContract: TdsdStoredProc;
    spErasedUnErasedPartner: TdsdStoredProc;
    dsdSetUnErasedContract: TdsdUpdateErased;
    dsdSetErasedContract: TdsdUpdateErased;
    dsdSetErasedPartner: TdsdUpdateErased;
    dsdSetUnErasedPartner: TdsdUpdateErased;
    ProtocolOpenFormContract: TdsdOpenForm;
    ProtocolOpenFormPartner: TdsdOpenForm;
    bbSetErasedContract: TdxBarButton;
    bbSetErasedPartner: TdxBarButton;
    bbSetUnErasedContract: TdxBarButton;
    bbSetUnErasedPartner: TdxBarButton;
    bbProtocolOpenFormContract: TdxBarButton;
    bbProtocolOpenFormPartner: TdxBarButton;
    cbVchasnoEdi: TcxCheckBox;
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
