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
  frxExportXLS, Vcl.Menus;

type
  TMainForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBar: TdxBar;
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
    bbReportsGoods: TdxBarSubItem;
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
    bbGuideAsset: TdxBarButton;
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
    actCashOperation: TdsdOpenForm;
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
    frxXLSExport: TfrxXLSExport;
    frxXMLExport: TfrxXMLExport;
    frxRTFExport: TfrxRTFExport;
    actPositionLevel: TdsdOpenForm;
    bbPositionLevel: TdxBarButton;
    actStaffListData: TdsdOpenForm;
    bbStaffListData: TdxBarButton;
    actUpdateProgram: TAction;
    bbUpdateProgramm: TdxBarButton;
    actModelService: TdsdOpenForm;
    bbModelService: TdxBarButton;
    actAbout: TAction;
    bbAbout: TdxBarButton;
    actReport_TransportHoursWork: TdsdOpenForm;
    bbReport_TransportHoursWork: TdxBarButton;
    actProtocol: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    actService: TdsdOpenForm;
    bbJuridicalService: TdxBarButton;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actSendTicketFuel: TdsdOpenForm;
    bbSendTicketFuel: TdxBarButton;
    actBankLoad: TdsdOpenForm;
    bbBankLoad: TdxBarButton;
    actArea: TdsdOpenForm;
    bbArea: TdxBarButton;
    actContractArticle: TdsdOpenForm;
    bbContractArticle: TdxBarButton;
    actCalendar: TdsdOpenForm;
    bbCalendar: TdxBarButton;
    actSetUserDefaults: TdsdOpenForm;
    bbSetUserDefaults: TdxBarButton;
    actPersonalAccount: TdsdOpenForm;
    bbPersonalAccount: TdxBarButton;
    actTransportService: TdsdOpenForm;
    bbTransportService: TdxBarButton;
    actJuridical_List: TdsdOpenForm;
    bbJuridical_List: TdxBarButton;
    actUnit_List: TdsdOpenForm;
    bbUnit_List: TdxBarButton;
    actLossDebt: TdsdOpenForm;
    bbLossDebt: TdxBarButton;
    actBankAccountDocument: TdsdOpenForm;
    bbBankAccountDocument: TdxBarButton;
    actCity: TdsdOpenForm;
    bbCity: TdxBarButton;
    bbFinanceDocuments_Separator: TdxBarSeparator;
    actReport_JuridicalSold: TdsdOpenForm;
    bbReport_JuridicalSold: TdxBarButton;
    actReport_JuridicalCollation: TdsdOpenForm;
    bbReport_JuridicalCollation: TdxBarButton;
    actMovementDesc: TdsdOpenForm;
    bbMovementDesc: TdxBarButton;
    actReport_GoodsMISale: TdsdOpenForm;
    bbReport_GoodsMISale: TdxBarButton;
    actSendDebt: TdsdOpenForm;
    bbSendDebt: TdxBarButton;
    actPartner1CLink: TdsdOpenForm;
    actGoodsByGoodsKind1CLink: TdsdOpenForm;
    bbPartner1CLink: TdxBarButton;
    bbGoods1CLink: TdxBarButton;
    actLoad1CSale: TdsdOpenForm;
    bbLoad1CSale: TdxBarButton;
    actReport_GoodsMIReturn: TdsdOpenForm;
    bbReport_GoodsMIReturn: TdxBarButton;
    actReport_GoodsMI_byMovementSale: TdsdOpenForm;
    actReport_GoodsMI_byMovementReturn: TdsdOpenForm;
    bbReport_GoodsMI_byMovementSale: TdxBarButton;
    bbReport_GoodsMI_byMovementReturn: TdxBarButton;
    actReport_GoodsMI_SaleReturnIn: TdsdOpenForm;
    bbReport_GoodsMI_SaleReturnIn: TdxBarButton;
    bbReportsFinance: TdxBarSubItem;
    bbReportMain: TdxBarSubItem;
    bbReportsProduction: TdxBarSubItem;
    actReport_Production_Union: TdsdOpenForm;
    bbGoodsDocuments_Separator: TdxBarSeparator;
    bbReportsProduction_Separator: TdxBarSeparator;
    bbHistory_Separator: TdxBarSeparator;
    bbReportsGoods_Separator: TdxBarSeparator;
    bbReportsFinance_Separator: TdxBarSeparator;
    bbReportMain_Separator: TdxBarSeparator;
    bbService_Separator: TdxBarSeparator;
    bbReportProductionUnion: TdxBarButton;
    actContractConditionValue: TdsdOpenForm;
    bbContractConditionValue: TdxBarButton;
    actReport_GoodsMI_Income: TdsdOpenForm;
    bbReport_GoodsMI_Income: TdxBarButton;
    actReport_GoodsMI_IncomeByPartner: TdsdOpenForm;
    bbReport_GoodsMI_IncomeByPartner: TdxBarButton;
    actReport_JuridicalDefermentPayment: TdsdOpenForm;
    bbReport_JuridicalDefermentPayment: TdxBarButton;
    actTax: TdsdOpenForm;
    bbTax: TdxBarButton;
    actTaxCorrection: TdsdOpenForm;
    bbTaxCorrective: TdxBarButton;
    bbAsset: TdxBarSubItem;
    bbAsset_Separator: TdxBarSeparator;
    actGoods_List: TdsdOpenForm;
    bbGoods_List: TdxBarButton;
    actAssetGroup: TdsdOpenForm;
    bbAssetGroup: TdxBarButton;
    actMaker: TdsdOpenForm;
    actCountry: TdsdOpenForm;
    bbCountry: TdxBarButton;
    bbMaker: TdxBarButton;
    spUserProtocol: TdsdStoredProc;
    actProtocolUser: TdsdOpenForm;
    actProtocolMovement: TdsdOpenForm;
    bbUserProtocol: TdxBarButton;
    bbMovementProtocol: TdxBarButton;
    actReport_CheckTax: TdsdOpenForm;
    bbReport_CheckTax: TdxBarButton;
    actProfitLossService: TdsdOpenForm;
    bbProfitLossService: TdxBarButton;
    actReport_CheckTaxCorrective: TdsdOpenForm;
    bbReport_CheckTaxCorrective: TdxBarButton;
    actPeriodClose: TdsdOpenForm;
    bbPeriodClose: TdxBarButton;
    actSaveTaxDocument: TdsdOpenForm;
    bbSaveTaxDocument: TdxBarButton;
    actToolsWeighingTree: TdsdOpenForm;
    bbToolsWeighingTree: TdxBarButton;
    actGoodsPropertyValue: TdsdOpenForm;
    bbGoodsPropertyValue: TdxBarButton;
    actWeighingPartner: TdsdOpenForm;
    bbWeighingPartner: TdxBarButton;
    actWeighingProduction: TdsdOpenForm;
    bbWeighingProduction: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actUpdateProgramExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure OnException(Sender: TObject; E: Exception);
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

uses ParentForm, Storage, CommonData, MessagesUnit, UtilConst, Math,
     AboutBoxUnit, UtilConvert;

{$R DevExpressRus.res}

{$R *.dfm}

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  TAboutBox.Create(Self).ShowModal;
end;

procedure TMainForm.actUpdateProgramExecute(Sender: TObject);
var Index: integer;
    AllParentFormFree: boolean;
begin
  AllParentFormFree := false;
  while not AllParentFormFree do begin
    AllParentFormFree := true;
    for Index := 0 to Screen.FormCount - 1 do
        if Screen.Forms[Index] is TParentForm then begin
           AllParentFormFree := false;
           Screen.Forms[Index].Free;
           break;
        end;
  end;
  ShowMessage('Программа обновлена');
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Здесь поверяем
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Локализуем сообщения DevExpress
  cxLocalizer.Active:= True;
  cxLocalizer.Locale:= 1049;
  Application.OnException := OnException;
  dsdUserSettingsStorageAddOn.LoadUserSettings;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Ctrl + Shift + S
  if ShortCut(Key, Shift) = 24659 then begin
     gc_isDebugMode := not gc_isDebugMode;
     if gc_isDebugMode then
        ShowMessage('Установлен режим отладки')
      else
        ShowMessage('Снят режим отладки');
  end;
  // Ctrl + Shift + T
  if ShortCut(Key, Shift) = 24660 then begin
     gc_isShowTimeMode := not gc_isShowTimeMode;
     if gc_isShowTimeMode then
        ShowMessage('Установлен режим проверки времени')
      else
        ShowMessage('Снят режим проверки времени');
  end;
  // Ctrl + Shift + D
  if ShortCut(Key, Shift) = 24644 then begin
     gc_isSetDefault := not gc_isSetDefault;
     if gc_isSetDefault then
        ShowMessage('Установки пользователя не загружаются')
      else
        ShowMessage('Установки пользователя загружаются');
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var i, j, k: integer;
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
  for i := 0 to dxBarManager.ItemCount - 1 do
      if dxBarManager.Items[i] is TdxBarButton then
         if Assigned(dxBarManager.Items[i].Action) then
            if not TCustomAction(dxBarManager.Items[i].Action).Enabled then
               dxBarManager.Items[i].Visible := ivNever;

  for k := 1 to 3 do
    // А теперь бы пройтись по группам меню и отрубить те, у которых нет видимых чайлдов
    for i := 0 to dxBarManager.ItemCount - 1 do
        if dxBarManager.Items[i] is TdxBarSubItem then begin
           dxBarManager.Items[i].Visible := ivNever;
           for j := 0 to TdxBarSubItem(dxBarManager.Items[i]).ItemLinks.Count - 1 do
               if (TdxBarSubItem(dxBarManager.Items[i]).ItemLinks[j].Item.Visible = ivAlways)
                  and not (TdxBarSubItem(dxBarManager.Items[i]).ItemLinks[j].Item is TdxBarSeparator) then begin
                  dxBarManager.Items[i].Visible := ivAlways;
                  break;
               end;
        end;

end;

procedure TMainForm.OnException(Sender: TObject; E: Exception);
var TextMessage: String;
    isMessage: boolean;
begin

  if E is ESortException then begin

  end
  else begin
     isMessage := false;
     if (E is EStorageException) then begin
        isMessage := (E as EStorageException).ErrorCode = 'P0001';

        if pos('context', AnsilowerCase(E.Message)) = 0 then
           TextMessage := E.Message
         else
           // Выбрасываем все что после Context
           TextMessage := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1)
     end
     else
        TextMessage := E.Message;
     if not isMessage then begin
        // Сохраняем протокол в базе
        try
          spUserProtocol.ParamByName('inProtocolData').Value := gfStrToXmlStr(E.Message);
          spUserProtocol.Execute;
        except

        end;
     end;

     TMessagesForm.Create(nil).Execute(TextMessage, E.Message);
  end;
end;

end.
