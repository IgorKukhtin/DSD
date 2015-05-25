unit QualityParams;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxMemo, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TQualityParamsForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    cxLabel4: TcxLabel;
    edQuality: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    GuidesQuality: TdsdGuides;
    GuidesFiller: TGuidesFiller;
    cxLabel9: TcxLabel;
    ceOperDateCertificate: TcxDateEdit;
    edCertificateNumber: TcxTextEdit;
    cxLabel11: TcxLabel;
    edInvNumber: TcxTextEdit;
    ceComment: TcxMemo;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    edCertificateSeries: TcxTextEdit;
    edCertificateSeriesNumber: TcxTextEdit;
    cxLabel6: TcxLabel;
    edExpertPrior: TcxTextEdit;
    cxLabel7: TcxLabel;
    edExpertLast: TcxTextEdit;
    cxLabel8: TcxLabel;
    edQualityNumber: TcxTextEdit;
    cxLabel5: TcxLabel;
    cxLabel22: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TQualityParamsForm);

end.
