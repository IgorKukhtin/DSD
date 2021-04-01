unit Invoice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, dsdGuides, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxCurrencyEdit, cxLabel, dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TInvoiceForm = class(TAncestorEditDialogForm)
    Код: TcxLabel;
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceAmountIn: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceAmountOut: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    ceObject: TcxButtonEdit;
    GuidesObject: TdsdGuides;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel9: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    edInvNumber: TcxTextEdit;
    ceUnit: TcxButtonEdit;
    cxLabel14: TcxLabel;
    GuidesUnit: TdsdGuides;
    cxLabel15: TcxLabel;
    ceProduct: TcxButtonEdit;
    GuidesProduct: TdsdGuides;
    cxLabel17: TcxLabel;
    cePlanDate: TcxDateEdit;
    cxLabel18: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel19: TcxLabel;
    edReceiptNumber: TcxTextEdit;
    RefreshDispatcher: TRefreshDispatcher;
    spGetPlanDate: TdsdStoredProc;
    actGetPlanDate: TdsdDataSetRefresh;
    cxLabel2: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceParent: TcxButtonEdit;
    GuidesParent: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInvoiceForm);

end.
