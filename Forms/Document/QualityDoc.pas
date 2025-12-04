unit QualityDoc;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TQualityDocForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    edOperDateOut: TcxDateEdit;
    edInvNumber_Sale: TcxButtonEdit;
    GuideSaleJournalChoice: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    edOperDate_Sale: TcxDateEdit;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    edCar: TcxButtonEdit;
    GuideCar: TdsdGuides;
    cxLabel4: TcxLabel;
    edCarModel: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edTo: TcxButtonEdit;
    GuideCarModel: TdsdGuides;
    cxLabel8: TcxLabel;
    edOperDateIn: TcxDateEdit;
    GuidesTo: TdsdGuides;
    cxLabel5: TcxLabel;
    edQualityNumber: TcxTextEdit;
    cxLabel11: TcxLabel;
    edCertificateNumber: TcxTextEdit;
    cxLabel7: TcxLabel;
    ceOperDateCertificate: TcxDateEdit;
    cxLabel12: TcxLabel;
    edCertificateSeries: TcxTextEdit;
    cxLabel13: TcxLabel;
    edCertificateSeriesNumber: TcxTextEdit;
    bbUpdate_PartionDateQ: TcxButton;
    mactUpdate_PartionDateQ: TMultiAction;
    spUpdate: TdsdStoredProc;
    actUpdateMI_PartionDateQ: TdsdExecStoredProc;
    actUpdateForm_PartionDateQ: TdsdInsertUpdateAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TQualityDocForm);

end.
