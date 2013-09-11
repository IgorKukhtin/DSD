unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar, cxClasses, Vcl.ActnList,
  Vcl.StdActns, Vcl.StdCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  dsdAction, cxLocalization, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, dsdAddOn, cxPropertiesStore, frxClass;

type
  TMainForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    bbExit: TdxBarButton;
    bbGoodsDocuments: TdxBarSubItem;
    bbGuides: TdxBarSubItem;
    ActionList: TActionList;
    actExit: TFileExit;
    actMeasure: TdsdOpenForm;
    bbMeasure: TdxBarButton;
    cxLocalizer: TcxLocalizer;
    actJuridicalGroup: TdsdOpenForm;
    bbJuridicalGroup: TdxBarButton;
    actGoodsProperty: TdsdOpenForm;
    bbGoodsProperty: TdxBarButton;
    bbJuridical: TdxBarButton;
    actJuridical: TdsdOpenForm;
    actBusiness: TdsdOpenForm;
    bbBusiness: TdxBarButton;
    actBranch: TdsdOpenForm;
    bbBranch: TdxBarButton;
    actPartner: TdsdOpenForm;
    actIncome: TdsdOpenForm;
    bbIncome: TdxBarButton;
    bbPartner: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    actPaidKind: TdsdOpenForm;
    actContractKind: TdsdOpenForm;
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
    actReport_Balance: TdsdOpenForm;
    bbReportBalance: TdxBarButton;
    bbReports: TdxBarSubItem;
    bbBank: TdxBarButton;
    actPrisceList: TdsdOpenForm;
    bbPriceList: TdxBarButton;
    bbCash: TdxBarButton;
    bbCurrency: TdxBarButton;
    actInfoMoneyGroup: TdsdOpenForm;
    actInfoMoneyDestination: TdsdOpenForm;
    actInfoMoney: TdsdOpenForm;
    actAccountGroup: TdsdOpenForm;
    actAccountDirection: TdsdOpenForm;
    actProfitLossGroup: TdsdOpenForm;
    actProfitLossDirection: TdsdOpenForm;
    bbInfoMoneyGroup: TdxBarButton;
    bbInfoMoneyDestination: TdxBarButton;
    bbInfoMoney: TdxBarButton;
    bbAccountGroup: TdxBarButton;
    bbAccountDirection: TdxBarButton;
    bbProfitLossGroup: TdxBarButton;
    bbProfitLossDirection: TdxBarButton;
    dxBarSubItem: TdxBarSubItem;
    actAccount: TdsdOpenForm;
    actProfitLoss: TdsdOpenForm;
    bbAccount: TdxBarButton;
    bbProfitLoss: TdxBarButton;
    actTradeMark: TdsdOpenForm;
    actAsset: TdsdOpenForm;
    actRoute: TdsdOpenForm;
    actRouteSorting: TdsdOpenForm;
    actMember: TdsdOpenForm;
    actPosition: TdsdOpenForm;
    actPersonal: TdsdOpenForm;
    actCar: TdsdOpenForm;
    actCarModel: TdsdOpenForm;
    dxBarSubItem1: TdxBarSubItem;
    bbCar: TdxBarButton;
    bbCarModel: TdxBarButton;
    bbPersonal: TdxBarButton;
    bbRoute: TdxBarButton;
    bbRouteSorting: TdxBarButton;
    bbTradeMark: TdxBarButton;
    bbAsset: TdxBarButton;
    bbPosition: TdxBarButton;
    bbMember: TdxBarButton;
    actSend: TdsdOpenForm;
    bbSend: TdxBarButton;
    actSale: TdsdOpenForm;
    bbSale: TdxBarButton;
    actReturnOut: TdsdOpenForm;
    actReturnIn: TdsdOpenForm;
    actLoss: TdsdOpenForm;
    bbLoss: TdxBarButton;
    bbReturnIn: TdxBarButton;
    bbReturnOut: TdxBarButton;
    actSendOnPrice: TdsdOpenForm;
    bbSendOnPrice: TdxBarButton;
    actInventory: TdsdOpenForm;
    actProductionSeparate: TdsdOpenForm;
    actProductionUnion: TdsdOpenForm;
    bbInventory: TdxBarButton;
    bbProductionSeparate: TdxBarButton;
    bbProductionUnion: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    actReport_HistoryCost: TdsdOpenForm;
    bbReportProfitLoss: TdxBarButton;
    bbReportHistoryCost: TdxBarButton;
    actReport_ProfitLoss: TdsdOpenForm;
    actContract: TdsdOpenForm;
    bbContract: TdxBarButton;
    actPriceListItem: TdsdOpenForm;
    bbHistory: TdxBarSubItem;
    bbPriceListItem: TdxBarButton;
    actZakazExternal: TdsdOpenForm;
    bbZakazExternal: TdxBarButton;
    bbZakazInternal: TdxBarButton;
    actZakazInternal: TdsdOpenForm;
    bbFinanceDocuments: TdxBarSubItem;
    bbIncomeCash: TdxBarButton;
    actIncomeCash: TdsdOpenForm;
    actOutcomeCash: TdsdOpenForm;
    bbBankAccount: TdxBarButton;
    actReport_MotionGoods: TdsdOpenForm;
    bbReport_MotionGoods: TdxBarButton;
    Action2: TAction;
    procedure FormCreate(Sender: TObject);
  private
    procedure OnException(Sender: TObject; E: Exception);
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

uses ParentForm, dsdDB, Storage, CommonData;

{$R DevExpressRus.res}

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Локализуем сообщения DevExpress
  cxLocalizer.Active:= True;
  cxLocalizer.Locale:= 1049;
//  Application.OnException := OnException;
end;

procedure TMainForm.OnException(Sender: TObject; E: Exception);
begin
  if E is ESortException then
  else
     ShowMessage(E.Message);
end;

end.
