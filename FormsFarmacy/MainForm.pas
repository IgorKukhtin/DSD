unit MainForm;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar,
  cxClasses, Vcl.ActnList, Vcl.StdActns, Vcl.StdCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, dsdAction, cxLocalization,
  AncestorMain, frxExportXML, frxExportXLS, frxClass, frxExportRTF, Data.DB,
  Datasnap.DBClient, dsdDB, dsdAddOn;

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
    actExtraChargeCategories: TdsdOpenForm;
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
    actGoods: TdsdOpenForm;
    actGoodsKind: TdsdOpenForm;
    bbPaidKind: TdxBarButton;
    bbContractKind: TdxBarButton;
    bbUnitGroup: TdxBarButton;
    bbUnit: TdxBarButton;
    bbGoodsGroup: TdxBarButton;
    bbGoods: TdxBarButton;
    actBank: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    actCash: TdsdOpenForm;
    actCurrency: TdsdOpenForm;
    bbGoodsKind: TdxBarButton;
    actBalance: TdsdOpenForm;
    bbBalance: TdxBarButton;
    bbReports: TdxBarSubItem;
    bbExtraChargeCategories: TdxBarButton;
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
