unit SheetWorkTimeCloseEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TSheetWorkTimeCloseEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceOperDate: TcxDateEdit;
    GuidesFiller: TGuidesFiller;
    edInvNumber: TcxTextEdit;
    cxLabel5: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    cxLabel6: TcxLabel;
    edTimeClose: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSheetWorkTimeCloseEditForm);

end.
