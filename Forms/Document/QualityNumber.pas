unit QualityNumber;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TQualityNumberForm = class(TAncestorEditDialogForm)
    GuidesFiller: TGuidesFiller;
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
    cxLabel1: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    edOperDate: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TQualityNumberForm);

end.
