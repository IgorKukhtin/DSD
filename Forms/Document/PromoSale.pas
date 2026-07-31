unit PromoSale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxSplitter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, cxEditRepositoryItems, cxImageComboBox, dsdCommon;

type
  TPromoSaleForm = class(TAncestorDocumentForm)
    GuidesPriceList: TdsdGuides;
    edPriceList: TcxButtonEdit;
    cxLabel11: TcxLabel;
    cxLabel5: TcxLabel;
    deStartPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEndPromo: TcxDateEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    deEndSale: TcxDateEdit;
    cxLabel9: TcxLabel;
    deOperDateStart: TcxDateEdit;
    cxLabel10: TcxLabel;
    deOperDateEnd: TcxDateEdit;
    cxLabel13: TcxLabel;
    edComment: TcxTextEdit;
    GuidesPersonalTrade: TdsdGuides;
    cxLabel14: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edPersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    PriceWithOutVAT: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    AmountReal: TcxGridDBColumn;
    AmountPlanMin: TcxGridDBColumn;
    AmountPlanMax: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    actGoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    actGoodsKindChoiceForm: TOpenChoiceForm;
    bbInsertRecord: TdxBarButton;
    cxGridPartner: TcxGrid;
    cxGridDBTableViewPartner: TcxGridDBTableView;
    isErased: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PartnerDescName: TcxGridDBColumn;
    cxGridLevelPartner: TcxGridLevel;
    PartnerCDS: TClientDataSet;
    PartnerDS: TDataSource;
    actInsertRecordPartner: TInsertRecord;
    actErasedPartner: TdsdUpdateErased;
    actUnErasedPartner: TdsdUpdateErased;
    spErasedMIPartner: TdsdStoredProc;
    spUnErasedMIPartner: TdsdStoredProc;
    spInsertUpdateMIPartner: TdsdStoredProc;
    dsdDBViewAddOnPartner: TdsdDBViewAddOn;
    bbInsertRecordPartner: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    actUpdateDSPartner: TdsdUpdateDataSet;
    Panel1: TPanel;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
    bbInsertCondition: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    pmPartner: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PrintHead: TClientDataSet;
    Juridical_Name: TcxGridDBColumn;
    Retail_Name: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    actContractChoiceForm: TOpenChoiceForm;
    Comment: TcxGridDBColumn;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    GoodComment: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMark: TcxGridDBColumn;
    AmountRealWeight: TcxGridDBColumn;
    AmountPlanMinWeight: TcxGridDBColumn;
    AmountPlanMaxWeight: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    dxBarButton11: TdxBarButton;
    grPartnerList: TcxGrid;
    grtvPartnerList: TcxGridDBTableView;
    PartnerListRetailName: TcxGridDBColumn;
    PartnerListJuridicalName: TcxGridDBColumn;
    PartnerListCode: TcxGridDBColumn;
    PartnerListName: TcxGridDBColumn;
    PartnerListAreaName: TcxGridDBColumn;
    grlPartnerList: TcxGridLevel;
    PartnerListCDS: TClientDataSet;
    PartnerListContractCode: TcxGridDBColumn;
    PartnerListContractName: TcxGridDBColumn;
    PartnerListContractTagName: TcxGridDBColumn;
    PartnerListIsErased: TcxGridDBColumn;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    dxBarButton12: TdxBarButton;
    actPartnerProtocolOpenForm: TdsdOpenForm;
    bbPartnerProtocol: TdxBarButton;
    bbPartnerListProtocol: TdxBarButton;
    spInsertUpdate_MI_Param: TdsdStoredProc;
    RetailName_inf: TcxGridDBColumn;
    actRefresh_Get: TdsdDataSetRefresh;
    actPrint_Calc: TdsdPrintAction;
    AmountRetInWeight: TcxGridDBColumn;
    AmountRetIn: TcxGridDBColumn;
    GoodsKindName_List: TcxGridDBColumn;
    actGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    cxSplitter4: TcxSplitter;
    actUpdateCalcDS2: TdsdUpdateDataSet;
    actPrint_Calc2: TdsdPrintAction;
    actUpdate_Movement_isTaxPromo: TdsdExecStoredProc;
    bsGoods: TdxBarSubItem;
    bsPartner: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem;
    cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem;
    cxLabel24: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    macChangePercent: TMultiAction;
    actUpdateChangePercent: TdsdUpdateDataSet;
    spUpdate_Movement_ChangePercent: TdsdStoredProc;
    actChangePercentDialog: TExecuteDialog;
    bbChangePercent: TdxBarButton;
    actRefreshCalc: TdsdDataSetRefresh;
    CountForPrice: TcxGridDBColumn;
    actChoiceTradeMark: TOpenChoiceForm;
    actChoiceGoodsGroupPropertyP: TOpenChoiceForm;
    actChoiceGoodsGroupDirection: TOpenChoiceForm;
    cxSplitter5: TcxSplitter;
    cxPageControl4: TcxPageControl;
    cxTabSheetInfoMoney: TcxTabSheet;
    cxGridInfoMoney: TcxGrid;
    cxGridDBTableViewInfoMoney: TcxGridDBTableView;
    InfoMoneyCode_ch5: TcxGridDBColumn;
    Name_ch5: TcxGridDBColumn;
    InfoMoneyName_ch5: TcxGridDBColumn;
    cxGridLevelInfoMoney: TcxGridLevel;
    InfoMoneyDS: TDataSource;
    InfoMoneyCDS: TClientDataSet;
    dsdDBViewAddOnInfoMoney: TdsdDBViewAddOn;
    spSelect_PromoInfoMoney: TdsdStoredProc;
    actChoiceInfoMoneyMarket: TOpenChoiceForm;
    actUpdateDSInfoMoney: TdsdUpdateDataSet;
    spErasedInfoMoney: TdsdStoredProc;
    spUnErasedInfoMoney: TdsdStoredProc;
    actInsertRecordInfoMoney: TInsertRecord;
    actErasedInfoMoney: TdsdUpdateErased;
    actunErasedInfoMoney: TdsdUpdateErased;
    bbsInfoMoney: TdxBarSubItem;
    bbErasedInfoMoney: TdxBarButton;
    bbInsertRecordInfoMoney: TdxBarButton;
    bbunErasedInfoMoney: TdxBarButton;
    actInfoMoneyProtocolOpenForm: TdsdOpenForm;
    bbInfoMoneyProtocolOpen: TdxBarButton;
    ddsUpdate: TdxBarSubItem;
    Separator: TdxBarSeparator;
    InsertRecordTM: TInsertRecord;
    InsertRecordGGP: TInsertRecord;
    InsertRecordGD: TInsertRecord;
    InsertRecordGGPP: TInsertRecord;
    actChoiceGoodsGroupPropertyParent: TOpenChoiceForm;
    bbInsertRecordTM: TdxBarButton;
    actChoiceGoodsGroupProperty: TOpenChoiceForm;
    bb: TdxBarButton;
    cxLabel28: TcxLabel;
    cbOperDateOrder_text: TcxTextEdit;
    actGoodsOutChoiceForm: TOpenChoiceForm;
    actGoodsKindOutChoiceForm: TOpenChoiceForm;
    actPromoDiscountKindChoiceForm: TOpenChoiceForm;
    spInsertUpdateMIMaster_out: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    cbNotBudgPromo: TcxCheckBox;
    cxLabel30: TcxLabel;
    GuidesNotBudgPromo: TdsdGuides;
    edNotBudgPromo: TcxButtonEdit;
    PartnerLisrDS: TDataSource;
    deStartSale: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoSaleForm);

end.
