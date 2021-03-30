unit ProductEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxDropDownEdit, cxCalendar, cxCheckBox, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxClasses, Vcl.ExtCtrls;

type
  TProductEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actDataSetRefresh: TdsdDataSetRefresh;
    actInsertUpdateGuides: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel6: TcxLabel;
    edHours: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel9: TcxLabel;
    edDateStart: TcxDateEdit;
    edDateBegin: TcxDateEdit;
    edDateSale: TcxDateEdit;
    edCIN: TcxTextEdit;
    cxLabel10: TcxLabel;
    edEngineNum: TcxTextEdit;
    cxLabel11: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    cxLabel12: TcxLabel;
    edModel: TcxButtonEdit;
    GuidesModel: TdsdGuides;
    cxLabel13: TcxLabel;
    edEngine: TcxButtonEdit;
    GuidesProdEngine: TdsdGuides;
    cbBasicConf: TcxCheckBox;
    cbProdColorPattern: TcxCheckBox;
    cxLabel14: TcxLabel;
    edReceiptProdModel: TcxButtonEdit;
    GuidesReceiptProdModel: TdsdGuides;
    edDiscountNextTax: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edClienttext: TcxLabel;
    edClient: TcxButtonEdit;
    GuidesClient: TdsdGuides;
    edDiscountTax: TcxCurrencyEdit;
    RefreshDispatcher: TRefreshDispatcher;
    spGetCIN: TdsdStoredProc;
    actGetCIN: TdsdDataSetRefresh;
    spChangeStatus: TdsdStoredProc;
    cxLabel8: TcxLabel;
    GuidesStatus: TdsdGuides;
    cxLabel17: TcxLabel;
    edInvNumberOrderClient: TcxTextEdit;
    cxLabel18: TcxLabel;
    edOperDateOrderClient: TcxDateEdit;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    Panel1: TPanel;
    dxBarDockControl3: TdxBarDockControl;
    BarManager: TdxBarManager;
    BarManagerBar1: TdxBar;
    bbCompleteMovement: TdxBarButton;
    bbDeleteMovement: TdxBarButton;
    bbDeleteDocument: TdxBarButton;
    actUnComplete: TdsdChangeMovementStatus;
    actComplete: TdsdChangeMovementStatus;
    actSetErased: TdsdChangeMovementStatus;
    ceStatus: TcxButtonEdit;
    cxLabel19: TcxLabel;
    edTotalSummPVAT: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    edTotalSummMVAT: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    edTotalSummVAT: TcxCurrencyEdit;
    ceStatusInvoice: TcxButtonEdit;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    edOperDateInvoice: TcxDateEdit;
    cxLabel24: TcxLabel;
    edInvNumberInvoice: TcxTextEdit;
    cxLabel25: TcxLabel;
    ceAmountInInvoice: TcxCurrencyEdit;
    ceAmountInInvoiceAll: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    cxLabel27: TcxLabel;
    ceAmountInBankAccount: TcxCurrencyEdit;
    ceAmountInBankAccountAll: TcxCurrencyEdit;
    cxLabel28: TcxLabel;
    GuidesStatusInvoice: TdsdGuides;
    spChangeStatusInvoice: TdsdStoredProc;
    UnCompleteMovementInvoice: TChangeGuidesStatus;
    CompleteMovementInvoice: TChangeGuidesStatus;
    DeleteMovementInvoice: TChangeGuidesStatus;
    cxLabel29: TcxLabel;
    edVATPercentOrderClient: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductEditForm);

end.
