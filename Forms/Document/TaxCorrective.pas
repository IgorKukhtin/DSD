unit TaxCorrective;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dsdCommon;

type
  TTaxCorrectiveForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    GuidesTo: TdsdGuides;
    DocumentTaxKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    edDateRegistered: TcxDateEdit;
    cxLabel10: TcxLabel;
    edIsChecked: TcxCheckBox;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    cxLabel12: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    actSPPrintProcName: TdsdExecStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    edIsDocument: TcxCheckBox;
    edIsElectron: TcxCheckBox;
    HeaderSaverParams: THeaderSaver;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    cxLabel5: TcxLabel;
    edReturnIn: TcxTextEdit;
    cxLabel8: TcxLabel;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    bbPrint_TaxCorrective_Client: TdxBarButton;
    edDocumentTax: TcxButtonEdit;
    DocumentTaxGuides: TdsdGuides;
    HeaderSaverDocChild: THeaderSaver;
    spInsertUpdateMovement_DocChild: TdsdStoredProc;
    cxLabel11: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    GuidesFrom: TdsdGuides;
    HeaderSaverIsDocument: THeaderSaver;
    spInsertUpdateMovement_IsDocument: TdsdStoredProc;
    cxLabel13: TcxLabel;
    edInvNumberBranch: TcxTextEdit;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    cbPartner: TcxCheckBox;
    actChangeSignAmount: TdsdExecStoredProc;
    spUpdateMIAmountSign: TdsdStoredProc;
    bbChangeSignAmount: TdxBarButton;
    actOpenTax: TdsdOpenForm;
    bbOpenTax: TdxBarButton;
    isAuto: TcxGridDBColumn;
    LineNumTaxOld: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    edINN: TcxTextEdit;
    cxLabel14: TcxLabel;
    cbINN: TcxCheckBox;
    spUpdate_INN: TdsdStoredProc;
    actUpdateINN: TdsdDataSetRefresh;
    ExecuteDialogINN: TExecuteDialog;
    macUpdateINN: TMultiAction;
    bbUpdateINN: TdxBarButton;
    LineNumTaxCorr: TcxGridDBColumn;
    LineNumTaxCorr_calc: TcxGridDBColumn;
    AmountTax_calc: TcxGridDBColumn;
    actChangeNPP_calc: TdsdExecStoredProc;
    bbChangeNPP_calc: TdxBarButton;
    spUpdateMI_NPP_calc: TdsdStoredProc;
    cxTabSheet1: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxLineNum: TcxGridDBColumn;
    cxLineNumTaxOld: TcxGridDBColumn;
    cxLineNumTax: TcxGridDBColumn;
    cxisAuto: TcxGridDBColumn;
    cxLineNumTaxCorr_calc: TcxGridDBColumn;
    cxLineNumTaxCorr: TcxGridDBColumn;
    cxAmountTax_calc: TcxGridDBColumn;
    cxGoodsGroupNameFull: TcxGridDBColumn;
    cxGoodsCode: TcxGridDBColumn;
    cxGoodsCodeUKTZED: TcxGridDBColumn;
    cxGoodsName: TcxGridDBColumn;
    cxGoodsKindName: TcxGridDBColumn;
    cxMeasureName: TcxGridDBColumn;
    cxAmount: TcxGridDBColumn;
    cxPrice: TcxGridDBColumn;
    cxCountForPrice: TcxGridDBColumn;
    cxAmountSumm: TcxGridDBColumn;
    cxisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    actUpdateChildDS: TdsdUpdateDataSet;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelectChild: TdsdStoredProc;
    spUpdateMI_NPP: TdsdStoredProc;
    actReport_Check_NPP: TdsdOpenForm;
    bbReport_Check_NPP: TdxBarButton;
    cbNPP_calc: TcxCheckBox;
    cxLabel17: TcxLabel;
    edDateisNPP_calc: TcxDateEdit;
    spUpdateMI_NPP_Null: TdsdStoredProc;
    actUpdateMI_NPP_Null: TdsdExecStoredProc;
    bbUpdateMI_NPP_Null: TdxBarButton;
    cxLabel18: TcxLabel;
    edInvNumberRegistered: TcxTextEdit;
    LineNumTaxNew: TcxGridDBColumn;
    cbIsAuto: TcxCheckBox;
    cxLabel19: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    spUpdate_Branch: TdsdStoredProc;
    actBranchChoiceForm: TOpenChoiceForm;
    actUpdate_Branch: TdsdExecStoredProc;
    macUpdateBranch: TMultiAction;
    bbUpdateBranch: TdxBarButton;
    tsContract: TcxTabSheet;
    DetailDS: TDataSource;
    DetailCDS: TClientDataSet;
    DBViewAddOnDetail: TdsdDBViewAddOn;
    cxGridDetail: TcxGrid;
    cxGridDBTableViewDetail: TcxGridDBTableView;
    ContractCode_ch2: TcxGridDBColumn;
    ContractName_ch2: TcxGridDBColumn;
    ContractTagName_ch2: TcxGridDBColumn;
    ContractKindName_ch2: TcxGridDBColumn;
    StartDate_ch2: TcxGridDBColumn;
    EndDate_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevelDetail: TcxGridLevel;
    actChoiceFormContract: TOpenChoiceForm;
    InsertRecord_Det: TInsertRecord;
    spUnErasedMI_Det: TdsdStoredProc;
    spErasedMI_Det: TdsdStoredProc;
    spInsertUpdateMIDetail: TdsdStoredProc;
    spSelectDetail: TdsdStoredProc;
    SetErased_Det: TdsdUpdateErased;
    SetUnErased_Det: TdsdUpdateErased;
    actGridToExcel_Det: TdsdGridToExcel;
    actShowErased_Det: TBooleanStoredProcAction;
    actUpdateDetailDS: TdsdUpdateDataSet;
    bbShowErased_Det: TdxBarButton;
    bbGridToExcel_Det: TdxBarButton;
    bbInsertRecord_Det: TdxBarButton;
    bbSetErased_Det: TdxBarButton;
    bbSetUnErased_Det: TdxBarButton;
    MIDetailProtocolOpenForm: TdsdOpenForm;
    bbMIDetailProtocolOpenForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxCorrectiveForm: TTaxCorrectiveForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTaxCorrectiveForm);

end.
