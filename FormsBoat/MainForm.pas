unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, frxBarcode, dxSkinsdxBarPainter, dxSkinBlack,
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
  Vcl.StdCtrls, cxButtons;

type
  TMainForm = class(TAncestorMainForm)
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    miUser: TMenuItem;
    miRole: TMenuItem;
    miGuide_Basis: TMenuItem;
    miAccountGroup: TMenuItem;
    miAccountDirection: TMenuItem;
    miAccount: TMenuItem;
    miLine8001: TMenuItem;
    miInfoMoneyGroup: TMenuItem;
    miInfoMoneyDestination: TMenuItem;
    miInfoMoney: TMenuItem;
    miLine8002: TMenuItem;
    miProfitLossGroup: TMenuItem;
    miProfitLossDirection: TMenuItem;
    miProfitLoss: TMenuItem;
    actForms: TdsdOpenForm;
    miForms: TMenuItem;
    actMeasure: TdsdOpenForm;
    miMeasure: TMenuItem;
    actCountry: TdsdOpenForm;
    miCountryBrand: TMenuItem;
    actBrand: TdsdOpenForm;
    actGoodsSize: TdsdOpenForm;
    miGoodsSize: TMenuItem;
    actGoodsGroup: TdsdOpenForm;
    miGoodsGroup: TMenuItem;
    actCurrency: TdsdOpenForm;
    miCurrency: TMenuItem;
    actMember: TdsdOpenForm;
    miMember: TMenuItem;
    actPartner: TdsdOpenForm;
    miPartner: TMenuItem;
    actUnit: TdsdOpenForm;
    miUnit: TMenuItem;
    actClient: TdsdOpenForm;
    miClient: TMenuItem;
    actGoods: TdsdOpenForm;
    miGoods: TMenuItem;
    actGoodsTree: TdsdOpenForm;
    miGoodsTree: TMenuItem;
    actPartionGoods: TdsdOpenForm;
    miPartionGoods: TMenuItem;
    actPosition: TdsdOpenForm;
    miPosition: TMenuItem;
    actPersonal: TdsdOpenForm;
    miPersonal: TMenuItem;
    actIncome: TdsdOpenForm;
    miMovement: TMenuItem;
    miIncome: TMenuItem;
    actSend: TdsdOpenForm;
    actLoss: TdsdOpenForm;
    miSend: TMenuItem;
    miLoss: TMenuItem;
    actCurrencyMovement: TdsdOpenForm;
    miCurrencyMovement: TMenuItem;
    miLine41_: TMenuItem;
    actPriceList: TdsdOpenForm;
    miPriceList: TMenuItem;
    actPriceListItem: TdsdOpenForm;
    miHistory: TMenuItem;
    miPriceListItem: TMenuItem;
    actDiscountItem: TdsdOpenForm;
    miDiscountItem: TMenuItem;
    actInventory: TdsdOpenForm;
    miInventory: TMenuItem;
    actCash: TdsdOpenForm;
    miCash: TMenuItem;
    actBank: TdsdOpenForm;
    miBank: TMenuItem;
    actSale: TdsdOpenForm;
    miSale: TMenuItem;
    actBankAccount: TdsdOpenForm;
    miBankAccount: TMenuItem;
    miBankAccountJournal: TMenuItem;
    actReport_Income: TdsdOpenForm;
    miReport: TMenuItem;
    miReport_Income: TMenuItem;
    actReport_Send: TdsdOpenForm;
    miReport_Send: TMenuItem;
    actReport_Loss: TdsdOpenForm;
    miReport_Loss: TMenuItem;
    actReport_Balance: TdsdOpenForm;
    actReport_ProfitLoss: TdsdOpenForm;
    actReport_Cash: TdsdOpenForm;
    miFinance: TMenuItem;
    miLine13: TMenuItem;
    miLine51_: TMenuItem;
    miReport_Basis: TMenuItem;
    miReport_Balance: TMenuItem;
    miReport_Finance: TMenuItem;
    miReport_Cash: TMenuItem;
    miReport_ProfitLoss: TMenuItem;
    miLine10_1: TMenuItem;
    miLine10_2: TMenuItem;
    miLine10_4: TMenuItem;
    miLine10_5: TMenuItem;
    actReport_Remains_curr: TdsdOpenForm;
    miLine71: TMenuItem;
    miReport_Remains_curr_: TMenuItem;
    miReport_GoodsCode: TMenuItem;
    actReport_Account: TdsdOpenForm;
    miReport_ProductionOLAP: TMenuItem;
    miLine81_: TMenuItem;
    actReport_MotionByClient: TdsdOpenForm;
    miReport_MotionByPartner: TMenuItem;
    miProduction: TMenuItem;
    actReport_CollationByPartner: TdsdOpenForm;
    miReport_CollationByPartner: TMenuItem;
    miReport_SaleOLAP: TMenuItem;
    actReport_SaleOLAP: TdsdOpenForm;
    miReport_Unit: TMenuItem;
    miLine12: TMenuItem;
    miLine61: TMenuItem;
    miLine92_: TMenuItem;
    actReport_Sale: TdsdOpenForm;
    miReport_Sale: TMenuItem;
    miLine803: TMenuItem;
    miLine804: TMenuItem;
    actReport_GoodsCode: TdsdOpenForm;
    miReport_SaleOLAP_Analysis: TMenuItem;
    actCashJournal: TdsdOpenForm;
    miCashJournal: TMenuItem;
    miLine42_: TMenuItem;
    miReport_Sale_Analysis: TMenuItem;
    miLine93_: TMenuItem;
    actReport_ProfitLossPeriod: TdsdOpenForm;
    miReport_ProfitLossPeriod: TMenuItem;
    miLine91_: TMenuItem;
    miImportType: TMenuItem;
    miImportSettings: TMenuItem;
    miLine805: TMenuItem;
    actReport_Remains_onDate: TdsdOpenForm;
    miReport_Remains_onDate_: TMenuItem;
    actBankAccountJournal: TdsdOpenForm;
    miLine11: TMenuItem;
    actOrderClient: TdsdOpenForm;
    actOrderPartner: TdsdOpenForm;
    miOrderPartner: TMenuItem;
    miOrderClient: TMenuItem;
    miOrderInternal: TMenuItem;
    actProductionUnion: TdsdOpenForm;
    miProductionUnion: TMenuItem;
    actReport_ProductionOLAP: TdsdOpenForm;
    miLine72: TMenuItem;
    miReport_Remains_curr: TMenuItem;
    miReport_Remains_onDate: TMenuItem;
    actLanguage: TdsdOpenForm;
    actTranslateWord: TdsdOpenForm;
    miLanguage: TMenuItem;
    miTranslateWord: TMenuItem;
    miBoat: TMenuItem;
    miLine21_: TMenuItem;
    miProdColorItems: TMenuItem;
    miLine33_: TMenuItem;
    miProdOptions: TMenuItem;
    miProdOptItems: TMenuItem;
    actProduct: TdsdOpenForm;
    actProdColorGroup: TdsdOpenForm;
    actProdColor: TdsdOpenForm;
    actProdColorItems: TdsdOpenForm;
    actProdOptions: TdsdOpenForm;
    actProdOptItems: TdsdOpenForm;
    actProdModel: TdsdOpenForm;
    actProdGroup: TdsdOpenForm;
    actProdEngine: TdsdOpenForm;
    miProduct: TMenuItem;
    miProdGroup: TMenuItem;
    miLine32_: TMenuItem;
    miProdColorGroup: TMenuItem;
    miProdColor: TMenuItem;
    miBrand: TMenuItem;
    miProdModel: TMenuItem;
    miProdEngine: TMenuItem;
    actProdColorPattern: TdsdOpenForm;
    actProdOptPattern: TdsdOpenForm;
    miProdColorPattern: TMenuItem;
    miProdOptPattern: TMenuItem;
    actPLZ: TdsdOpenForm;
    miPLZ: TMenuItem;
    actModelEtiketen: TdsdOpenForm;
    miModelEtiketen: TMenuItem;
    miLine10_3: TMenuItem;
    actReceiptProdModel: TdsdOpenForm;
    miReceiptProdModel: TMenuItem;
    actReceiptGoods: TdsdOpenForm;
    miReceiptGoods: TMenuItem;
    miLine22_: TMenuItem;
    actProdColorKind: TdsdOpenForm;
    miBoatStructure: TMenuItem;
    actColorPattern: TdsdOpenForm;
    miColorPattern: TMenuItem;
    actReceiptLevel: TdsdOpenForm;
    miReceiptLevel: TMenuItem;
    miLine23_: TMenuItem;
    actReceiptService: TdsdOpenForm;
    miReceiptService: TMenuItem;
    actTranslateMessage: TdsdOpenForm;
    miTranslateMessage: TMenuItem;
    actInvoiceJournal: TdsdOpenForm;
    miInvoiceJournal: TMenuItem;
    miLine43_: TMenuItem;
    actTaxKindEdit: TdsdOpenForm;
    miTaxKindEdit: TMenuItem;
    N13: TMenuItem;
    actIncomeCost: TdsdOpenForm;
    miIncomeCost: TMenuItem;
    actReport_Goods: TdsdOpenForm;
    miReport_Goods: TMenuItem;
    actReport_OrderClient: TdsdOpenForm;
    miReport_OrderClient: TMenuItem;
    actDocTag: TdsdOpenForm;
    N16: TMenuItem;
    N17: TMenuItem;
    actProductionPersonal: TdsdOpenForm;
    miProductionPersonal: TMenuItem;
    actReport_ProductionPersonal: TdsdOpenForm;
    miReport_ProductionPersonal: TMenuItem;
    miLine62_: TMenuItem;
    actMeasureCode: TdsdOpenForm;
    miMeasureCode: TMenuItem;
    actTranslateObject: TdsdOpenForm;
    miTranslateObject: TMenuItem;
    actPriceListJournal: TdsdOpenForm;
    miPriceListJournal: TMenuItem;
    N21: TMenuItem;
    actReport_GoodsMotion: TdsdOpenForm;
    miReport_GoodsMotion: TMenuItem;
    spGet_Object_Form_HelpFile: TdsdStoredProc;
    actHelp: TShellExecuteAction;
    actGet_Object_Form_HelpFile: TdsdExecStoredProc;
    mactHelp: TMultiAction;
    miHelp: TMenuItem;
    FormParams: TdsdFormParams;
    N20: TMenuItem;
    actReport_Movement_PriceList: TdsdOpenForm;
    miReport_Movement_PriceList: TMenuItem;
    actMaterialOptions: TdsdOpenForm;
    miMaterialOptions: TMenuItem;
    miLine31_: TMenuItem;
    miLine34_: TMenuItem;
    actOrderInternal: TdsdOpenForm;
    actReceiptGoodsLine: TdsdOpenForm;
    miReceiptGoodsLine: TMenuItem;
    actReport_OrderInternal: TdsdOpenForm;
    miReport_OrderInternal: TMenuItem;
    actReport_PriceList: TdsdOpenForm;
    miReport_PriceList: TMenuItem;
    actProductionUnionMaster: TdsdOpenForm;
    miProductionUnionMaster: TMenuItem;
    actReport_Personal: TdsdOpenForm;
    miReport_Personal: TMenuItem;
    actReport_OrderClient_byBoat: TdsdOpenForm;
    miReport_OrderClient_byBoat: TMenuItem;
    actReport_Partner: TdsdOpenForm;
    miReport_Partner: TMenuItem;
    actGoodsGroup_List: TdsdOpenForm;
    miGoodsGroupList: TMenuItem;
    actReport_Client: TdsdOpenForm;
    miReport_Client: TMenuItem;
    miLine24_: TMenuItem;
    btnIncome: TcxButton;
    btnSend: TcxButton;
    btnOrderPartner: TcxButton;
    btnProduct: TcxButton;
    btnOrderInternal: TcxButton;
    btnProductionUnion: TcxButton;
    btnSale: TcxButton;
    btnExit: TcxButton;
    btnInvoiceJournal: TcxButton;
    btnBankAccountJournal: TcxButton;
    btnProdOptions: TcxButton;
    btnReceiptProdModel: TcxButton;
    btnReceiptGoods: TcxButton;
    actExit_btn: TAction;
    actSale_noDialog: TdsdOpenForm;
    actIncome_noDialog: TdsdOpenForm;
    actSend_noDialog: TdsdOpenForm;
    actOrderPartner_noDialog: TdsdOpenForm;
    actProduct_noDialog: TdsdOpenForm;
    actOrderInternal_noDialog: TdsdOpenForm;
    actProductionUnion_noDialog: TdsdOpenForm;
    actInvoiceJournal_noDialog: TdsdOpenForm;
    actBankAccountJournal_noDialog: TdsdOpenForm;
    actInvoiceKindEdit: TdsdOpenForm;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure actExit_btnExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses Dialogs, Forms, SysUtils, IdGlobal, UnilWin;
{$R *.dfm}

procedure TMainForm.actExit_btnExecute(Sender: TObject);
begin
  inherited;

  if MessageDlg('Ïðîãðàììà áóäåò çàêðûòà.Ïðîäîëæèòü?',mtConfirmation,mbYesNoCancel,0) <> 6
  then exit
  else Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  //
  if GetFilePlatfotm64(ParamStr(0))
  then Caption:= '«ProjectBoat» - 64bit'
  else Caption:= '«ProjectBoat» - 32bit';
end;

end.
