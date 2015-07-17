unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, dxSkinsdxBarPainter;

type
  TMainForm = class(TAncestorMainForm)
    actMeasure: TdsdOpenForm;
    actJuridicalGroup: TdsdOpenForm;
    actGoodsProperty: TdsdOpenForm;
    actJuridical: TdsdOpenForm;
    actBusiness: TdsdOpenForm;
    actPartner: TdsdOpenForm;
    actIncome: TdsdOpenForm;
    actPaidKind: TdsdOpenForm;
    actContractKind: TdsdOpenForm;
    actUnitGroup: TdsdOpenForm;
    actUnit: TdsdOpenForm;
    actGoodsGroup: TdsdOpenForm;
    actGoodsMain: TdsdOpenForm;
    actGoodsKind: TdsdOpenForm;
    actBank: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    actCash: TdsdOpenForm;
    actCurrency: TdsdOpenForm;
    actBalance: TdsdOpenForm;
    actPriceListLoad: TdsdOpenForm;
    actContract: TdsdOpenForm;
    actOrderExternal: TdsdOpenForm;
    actOrderInternal: TdsdOpenForm;
    actPriceList: TdsdOpenForm;
    actNDSKind: TdsdOpenForm;
    actRetail: TdsdOpenForm;
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    actMovementLoad: TdsdOpenForm;
    actAdditionalGoods: TdsdOpenForm;
    actTestFormOpen: TdsdOpenForm;
    actSetDefault: TdsdOpenForm;
    actGoods: TdsdOpenForm;
    actGoodsPartnerCode: TdsdOpenForm;
    actGoodsPartnerCodeMaster: TdsdOpenForm;
    actPriceGroupSettings: TdsdOpenForm;
    actJuridicalSettings: TdsdOpenForm;
    actSaveData: TAction;
    actContactPerson: TdsdOpenForm;
    actJuridicalSettingsPriceList: TdsdOpenForm;
    actSearchGoods: TdsdOpenForm;
    actReportGoodsOrder: TdsdOpenForm;
    actOrderKind: TdsdOpenForm;
    actOrderInternalLite: TdsdOpenForm;
    miCommon: TMenuItem;
    miAdditionalGoods: TMenuItem;
    N1: TMenuItem;
    miGoodsPartnerCode: TMenuItem;
    miGoodsPartnerCodeMaster: TMenuItem;
    N4: TMenuItem;
    miUnit: TMenuItem;
    miJuridical: TMenuItem;
    N5: TMenuItem;
    miContract: TMenuItem;
    miContactPerson: TMenuItem;
    miLoad: TMenuItem;
    miImportGroup: TMenuItem;
    miMovementLoad: TMenuItem;
    miPriceListLoad: TMenuItem;
    miReports: TMenuItem;
    miBalance: TMenuItem;
    miReportGoodsOrder: TMenuItem;
    miSearchGoods: TMenuItem;
    miGoodsCommon: TMenuItem;
    miUser: TMenuItem;
    N6: TMenuItem;
    miRole: TMenuItem;
    miSetDefault: TMenuItem;
    N7: TMenuItem;
    miSaveData: TMenuItem;
    miPriceGroupSettings: TMenuItem;
    miJuridicalSettings: TMenuItem;
    N8: TMenuItem;
    miMeasure: TMenuItem;
    miNDSKind: TMenuItem;
    miRetail: TMenuItem;
    miOrderKind: TMenuItem;
    miImportType: TMenuItem;
    N9: TMenuItem;
    miImportSettings: TMenuItem;
    miImportExportLink: TMenuItem;
    N10: TMenuItem;
    miTest: TMenuItem;
    miDocuments: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    actReturnType: TdsdOpenForm;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    actLossDebt: TdsdOpenForm;
    N35: TMenuItem;
    N36: TMenuItem;
    N32: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    actSendOnPrice: TdsdOpenForm;
    N42: TMenuItem;
    N43: TMenuItem;
    actMarginCategory: TdsdOpenForm;
    actMarginCategoryItem: TdsdOpenForm;
    dsdOpenForm2: TdsdOpenForm;
    actMarginCategoryLink: TdsdOpenForm;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    actIncomePharmacy: TdsdOpenForm;
    N48: TMenuItem;
    actCheck: TdsdOpenForm;
    N49: TMenuItem;
    actCashRegister: TdsdOpenForm;
    N50: TMenuItem;
    actReport_GoodRemains: TdsdOpenForm;
    N51: TMenuItem;
    actPrice: TdsdOpenForm;
    N52: TMenuItem;
    actAlternativeGroup: TdsdOpenForm;
    N53: TMenuItem;
    miReprice: TMenuItem;
    actPaidType: TdsdOpenForm;
    N54: TMenuItem;
    actInventoryJournal: TdsdOpenForm;
    N55: TMenuItem;
    procedure actSaveDataExecute(Sender: TObject);
    procedure miRepriceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses UploadUnloadData, Dialogs, Forms, SysUtils, IdGlobal, RepriceUnit;
{$R *.dfm}

procedure TMainForm.actSaveDataExecute(Sender: TObject);
begin
  with TdmUnloadUploadData.Create(nil) do
     try
       UnloadData;
     finally
       Free;
     end;

  Application.ProcessMessages;
  ShowMessage('Выгрузили');
end;

procedure TMainForm.miRepriceClick(Sender: TObject);
begin
  with TRepriceUnitForm.Create(nil) do
  try
     ShowModal;
  finally
     Free;
  end;
end;

end.
