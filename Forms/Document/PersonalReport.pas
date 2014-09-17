unit PersonalReport;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TPersonalReportForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceAmountDebet: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    UnitGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    ceAmountKredit: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel6: TcxLabel;
    ceMember: TcxButtonEdit;
    MemberGuides: TdsdGuides;
    edCar: TcxButtonEdit;
    cxLabel2: TcxLabel;
    GuidesCar: TdsdGuides;
    ceMoneyPlace: TcxButtonEdit;
    cxLabel8: TcxLabel;
    MoneyPlaceGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPersonalReportForm);

end.
