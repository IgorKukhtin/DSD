unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  cxLocalization;

type
  TMainForm = class(TAncestorMainForm)
    bbDocuments: TdxBarSubItem;
    actMeasure: TdsdOpenForm;
    bbMeasure: TdxBarButton;
    actJuridicalGroup: TdsdOpenForm;
    bbJuridicalGroup: TdxBarButton;
    actGoodsProperty: TdsdOpenForm;
    bbGoodsProperty: TdxBarButton;
    bbJuridical: TdxBarButton;
    actJuridical: TdsdOpenForm;
    actBusiness: TdsdOpenForm;
    bbBusiness: TdxBarButton;
    bbBranch: TdxBarButton;
    actPartner: TdsdOpenForm;
    actIncome: TdsdOpenForm;
    bbIncome: TdxBarButton;
    bbPartner: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    actPaidKind: TdsdOpenForm;
    actContractKind: TdsdOpenForm;
    actUnitGroup: TdsdOpenForm;
    actUnit: TdsdOpenForm;
    actGoodsGroup: TdsdOpenForm;
    actGoodsMain: TdsdOpenForm;
    actGoodsKind: TdsdOpenForm;
    bbPaidKind: TdxBarButton;
    bbContractKind: TdxBarButton;
    bbUnitGroup: TdxBarButton;
    bbUnit: TdxBarButton;
    bbGoodsGroup: TdxBarButton;
    bbGoodsCommon: TdxBarButton;
    actBank: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    actCash: TdsdOpenForm;
    actCurrency: TdsdOpenForm;
    bbGoodsKind: TdxBarButton;
    actBalance: TdsdOpenForm;
    bbBalance: TdxBarButton;
    bbReports: TdxBarSubItem;
    bbExtraChargeCategories: TdxBarButton;
    actPriceListLoad: TdsdOpenForm;
    bbLoad: TdxBarSubItem;
    bbPriceListLoad: TdxBarButton;
    actContract: TdsdOpenForm;
    bbContract: TdxBarButton;
    actOrderExternal: TdsdOpenForm;
    actOrderInternal: TdsdOpenForm;
    bbOrderExtrnal: TdxBarButton;
    actPriceList: TdsdOpenForm;
    bbPriceList: TdxBarButton;
    bbOrderInternal: TdxBarButton;
    bbNDSKind: TdxBarButton;
    actNDSKind: TdsdOpenForm;
    actRetail: TdsdOpenForm;
    bbRetail: TdxBarButton;
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    bbUser: TdxBarButton;
    bbRole: TdxBarButton;
    actImportType: TdsdOpenForm;
    bbImportType: TdxBarButton;
    actImportSettings: TdsdOpenForm;
    bbImportSettings: TdxBarButton;
    actMovementLoad: TdsdOpenForm;
    bbMovementLoad: TdxBarButton;
    actAdditionalGoods: TdsdOpenForm;
    bbAlternativeGoodsCodeForm: TdxBarButton;
    actTestFormOpen: TdsdOpenForm;
    bbTest: TdxBarButton;
    actSetDefault: TdsdOpenForm;
    bbSetDefault: TdxBarButton;
    actGoods: TdsdOpenForm;
    bbCommon: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

{$R *.dfm}

end.
