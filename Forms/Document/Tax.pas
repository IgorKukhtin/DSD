unit Tax;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels,  cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  MeDOC, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TTaxForm = class(TAncestorDocumentForm)
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
    GuidesFrom: TdsdGuides;
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
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    spGetReportName: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    mactPrint_Tax: TMultiAction;
    actPrintTax: TdsdPrintAction;
    spGetReporNameTax: TdsdStoredProc;
    actSPPrintTaxProcName: TdsdExecStoredProc;
    PrintItemsCDS: TClientDataSet;
    edIsDocument: TcxCheckBox;
    edIsElectron: TcxCheckBox;
    HeaderSaver2: THeaderSaver;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    spSelectTax_Client: TdsdStoredProc;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    bbPrint_Us: TdxBarButton;
    edPartner: TcxButtonEdit;
    cxLabel5: TcxLabel;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel8: TcxLabel;
    edInvNumberBranch: TcxTextEdit;
    spTax: TdsdStoredProc;
    GuidesPartner: TdsdGuides;
    bbMeDoc: TdxBarButton;
    spUpdateIsMedoc: TdsdStoredProc;
    actUpdateIsMedoc: TdsdExecStoredProc;
    actInsertMaskDoc: TdsdInsertUpdateAction;
    actInsertMaskMulti: TMultiAction;
    bbInsertMask: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    actShowMessage: TShowMessageAction;
    cxLabel22: TcxLabel;
    edStartDateTax: TcxDateEdit;
    cxLabel26: TcxLabel;
    edReestrKind: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edINN: TcxTextEdit;
    cbINN: TcxCheckBox;
    macUpdateINN: TMultiAction;
    ExecuteDialogINN: TExecuteDialog;
    spUpdate_INN: TdsdStoredProc;
    actUpdateINN: TdsdDataSetRefresh;
    bbUpdateINN: TdxBarButton;
    cxLabel13: TcxLabel;
    edInvNumberRegistered: TcxTextEdit;
    cbDisableNPP_auto: TcxCheckBox;
    spUpdateTax_DisableNPP_auto: TdsdStoredProc;
    actDisableNPP_auto: TdsdExecStoredProc;
    bbDisableNPP_auto: TdxBarButton;
    isName_new: TcxGridDBColumn;
    cbIsAuto: TcxCheckBox;
    cxLabel14: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    spUpdate_Branch: TdsdStoredProc;
    actBranchChoiceForm: TOpenChoiceForm;
    macUpdateBranch: TMultiAction;
    actUpdate_Branch: TdsdExecStoredProc;
    bbUpdateBranch: TdxBarButton;
    cxTabSheet1: TcxTabSheet;
    DetailDS: TDataSource;
    DetailCDS: TClientDataSet;
    DBViewAddOnDetail: TdsdDBViewAddOn;
    spSelectDetail: TdsdStoredProc;
    cxGridDetail: TcxGrid;
    cxGridDBTableViewDetail: TcxGridDBTableView;
    ContractCode_ch2: TcxGridDBColumn;
    ContractName_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevelDetail: TcxGridLevel;
    actChoiceFormContract: TOpenChoiceForm;
    InsertRecord_Det: TInsertRecord;
    SetErased_Det: TdsdUpdateErased;
    SetUnErased_Det: TdsdUpdateErased;
    spUnErasedMI_Det: TdsdStoredProc;
    spErasedMI_Det: TdsdStoredProc;
    bbInsertRecord_Det: TdxBarButton;
    bbSetErased_Det: TdxBarButton;
    bbSetUnErased_Det: TdxBarButton;
    actShowErased_Det: TBooleanStoredProcAction;
    actGridToExcel_Det: TdsdGridToExcel;
    bbGridToExcel_Det: TdxBarButton;
    bbShowErased_Det: TdxBarButton;
    MIDetailProtocolOpenForm: TdsdOpenForm;
    bbMIDetailProtocolOpenForm: TdxBarButton;
    actUpdateDetailDS: TdsdUpdateDataSet;
    spInsertUpdateMIDetail: TdsdStoredProc;
    cxTabSheetPrior: TcxTabSheet;
    GoodsName_its: TcxGridDBColumn;
    cxGridGoodsName: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    LineNum_ch3: TcxGridDBColumn;
    GoodsGroupNameFull_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsCodeUKTZED_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    GoodsName_its_ch3: TcxGridDBColumn;
    GoodsKindName_ch3: TcxGridDBColumn;
    MeasureName_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    Price_ch3: TcxGridDBColumn;
    CountForPrice_ch3: TcxGridDBColumn;
    AmountSumm_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    isName_new_ch3: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    spUpdate_MI_GoodsName_its: TdsdStoredProc;
    actUpdateNameDS: TdsdUpdateDataSet;
    DBViewAddOnGoodsName: TdsdDBViewAddOn;
    MovementItemProtocolOpenFormName: TdsdOpenForm;
    bbProtocolOpenFormName: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxForm: TTaxForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTaxForm);

end.
