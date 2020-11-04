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
  dxSkinsDefaultPainters, cxImageComboBox, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

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
    cePercent: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cePayOrder: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    edMainName: TcxDBTextEdit;
    cxLabel16: TcxLabel;
    edReestr: TcxDBTextEdit;
    cxLabel17: TcxLabel;
    edDecision: TcxDBTextEdit;
    cxLabel20: TcxLabel;
    edDecisionDate: TcxDBTextEdit;
    cxLabel21: TcxLabel;
    edLicense: TcxDBTextEdit;
    chisLoadBarcode: TcxCheckBox;
    cbisDeferred: TcxCheckBox;
    cxLabel4: TcxLabel;
    edMainName_cut: TcxDBTextEdit;
    cxTabSheet1: TcxTabSheet;
    cxLabel5: TcxLabel;
    cxLabel14: TcxLabel;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    edCBName: TcxTextEdit;
    edCBMFO: TcxTextEdit;
    edCBAccount: TcxTextEdit;
    edCBPurposePayment: TcxTextEdit;
    edCBAccountOld: TcxTextEdit;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    ceCodeRazom: TcxCurrencyEdit;
    ceCodeMedicard: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    isPartialPay: TcxGridDBColumn;
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
