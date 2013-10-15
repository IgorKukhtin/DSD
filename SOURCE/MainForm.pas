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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, dsdAddOn, cxPropertiesStore, frxClass,
  dsdDB, Data.DB, Datasnap.DBClient, frxExportRTF, frxExportPDF, frxExportXML,
  frxExportXLS;

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
    bbGuides_Separator: TdxBarSeparator;
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
    actPriceList: TdsdOpenForm;
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
    actRole: TdsdOpenForm;
    bbRole: TdxBarButton;
    bbService: TdxBarSubItem;
    actAction: TdsdOpenForm;
    bbAction: TdxBarButton;
    actUser: TdsdOpenForm;
    bbUser: TdxBarButton;
    actProcess: TdsdOpenForm;
    bbProcess: TdxBarButton;
    StoredProc: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    bbTransportDocuments: TdxBarSubItem;
    bbTransport: TdxBarButton;
    bbFuel: TdxBarButton;
    actTransport: TdsdOpenForm;
    actFuel: TdsdOpenForm;
    actRateFuelKind: TdsdOpenForm;
    bbRateFuelKind: TdxBarButton;
    actIncomeFuel: TdsdOpenForm;
    bbIncomeFuel: TdxBarButton;
    bbTransportDocuments_Separator: TdxBarSeparator;
    actPersonalSendCash: TdsdOpenForm;
    bbPersonalSendCash: TdxBarButton;
    bbRateFuel: TdxBarButton;
    actRateFuel: TdsdOpenForm;
    bbFreight: TdxBarButton;
    actFreight: TdsdOpenForm;
    bbReport_Fuel: TdxBarButton;
    bbtReport_Transport: TdxBarButton;
    actReport_Transport: TdsdOpenForm;
    actReport_Fuel: TdsdOpenForm;
    actPersonalGroup: TdsdOpenForm;
    actWorkTimeKind: TdsdOpenForm;
    actSheetWorkTime: TdsdOpenForm;
    actPersonalService: TdsdOpenForm;
    bbPersonalDocuments: TdxBarSubItem;
    bbWorkTimeKind: TdxBarButton;
    bbPersonalGroup: TdxBarButton;
    bbPersonalDocuments_Separator: TdxBarSeparator;
    bbSheetWorkTime: TdxBarButton;
    bbPersonalService: TdxBarButton;
    actReport_Account: TdsdOpenForm;
    bbAccountReport: TdxBarButton;
    actCardFuel: TdsdOpenForm;
    actTicketFuel: TdsdOpenForm;
    bbCardFuel: TdxBarButton;
    bbTicketFuel: TdxBarButton;
    actFrom_byIncomeFuel: TdsdOpenForm;
    bbFrom_byIncomeFuel: TdxBarButton;
    frxXLSExport: TfrxXLSExport;
    frxXMLExport: TfrxXMLExport;
    frxRTFExport: TfrxRTFExport;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure OnException(Sender: TObject; E: Exception);
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

uses ParentForm, Storage, CommonData, MessagesUnit;

{$R DevExpressRus.res}

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Локализуем сообщения DevExpress
  cxLocalizer.Active:= True;
  cxLocalizer.Locale:= 1049;
  Application.OnException := OnException;
end;

procedure TMainForm.FormShow(Sender: TObject);
var i: integer;
begin
  StoredProc.Execute;
  ClientDataSet.IndexFieldNames := 'ActionName';
  for I := 0 to ActionList.ActionCount - 1 do
      // Проверяем только открытие формы
      if ActionList.Actions[i] is TdsdOpenForm then
         if not ClientDataSet.Locate('ActionName', ActionList.Actions[i].Name, []) then begin
            TCustomAction(ActionList.Actions[i]).Enabled := false;
            TCustomAction(ActionList.Actions[i]).Visible := false;
         end;

  ClientDataSet.EmptyDataSet;
  // Отображаем видимые пункты меню
end;

procedure TMainForm.OnException(Sender: TObject; E: Exception);
var TextMessage: String;
begin
  if E is ESortException then begin

  end
  else begin
     if (E is EStorageException) then
        // Выбрасываем все что после Context
        TextMessage := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1)
     else
        TextMessage := E.Message;
     TMessagesForm.Create(nil).Execute(TextMessage, E.Message);
  end;
end;

end.
