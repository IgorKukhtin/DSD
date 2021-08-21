unit MemberHoliday;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, ChoicePeriod;

type
  TMemberHolidayForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    edInvNumber: TcxTextEdit;
    edUpdateDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel9: TcxLabel;
    edInsert: TcxButtonEdit;
    GuideInsert: TdsdGuides;
    cxLabel8: TcxLabel;
    edUpdate: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edMember: TcxButtonEdit;
    GuideMemberHoliday: TdsdGuides;
    GuideUpdate: TdsdGuides;
    edMemberMain: TcxButtonEdit;
    cxLabel15: TcxLabel;
    GuideMemberMain: TdsdGuides;
    edInsertDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    edOperDateStart: TcxDateEdit;
    cxLabel4: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    cxLabel5: TcxLabel;
    edBeginDateStart: TcxDateEdit;
    cxLabel7: TcxLabel;
    edBeginDateEnd: TcxDateEdit;
    PeriodChoiceOperDate: TPeriodChoice;
    PeriodChoiceBeginDate: TPeriodChoice;
    cxLabel10: TcxLabel;
    edWorkTimeKind: TcxButtonEdit;
    GuidesWorkTimeKind: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TMemberHolidayForm);

end.
