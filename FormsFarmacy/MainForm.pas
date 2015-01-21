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
    miJuridicalSettingsPriceList: TMenuItem;
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
    procedure actSaveDataExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses UploadUnloadData, Dialogs, Forms, SysUtils, IdGlobal;
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

end.
