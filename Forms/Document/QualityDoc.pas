unit QualityDoc;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

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
