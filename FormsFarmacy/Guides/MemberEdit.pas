unit MemberEdit;

interface

uses
  Winapi.Windows, DataModul, AncestorEditDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxPCdxBarPopupMenu, cxContainer,
  cxEdit, cxCheckBox, cxCurrencyEdit, cxLabel, cxTextEdit, cxPC, Vcl.Controls,
  dsdDB, dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, dsdAddOn,
  Vcl.StdCtrls, cxButtons, cxMemo, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dsdGuides, cxMaskEdit, cxButtonEdit;

type
  TMemberEditForm = class(TAncestorEditDialogForm)
    edMeasureName: TcxTextEdit;
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    ceINN: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    ceDriverCertificate: TcxTextEdit;
    ceComment: TcxTextEdit;
    cbOfficial: TcxCheckBox;
    cxPageControl1: TcxPageControl;
    tsCommon: TcxTabSheet;
    tsContact: TcxTabSheet;
    cxLabel5: TcxLabel;
    edEmail: TcxTextEdit;
    spInsertUpdateContact: TdsdStoredProc;
    spGetMemberContact: TdsdStoredProc;
    cxLabel6: TcxLabel;
    EMailSign: TcxMemo;
    cxLabel7: TcxLabel;
    ceEducation: TcxButtonEdit;
    EducationGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel9: TcxLabel;
    edAddress: TcxTextEdit;
    cxLabel10: TcxLabel;
    Photo: TcxMemo;
    cePosition: TcxButtonEdit;
    cxLabel11: TcxLabel;
    PositionGuides: TdsdGuides;
    ceManagerPharmacy: TcxCheckBox;
    ceUnit: TcxButtonEdit;
    cxLabel12: TcxLabel;
    UnitGuides: TdsdGuides;
    ceNotSchedule: TcxCheckBox;
    cbReleasedMarketingPlan: TcxCheckBox;
    edMeasureNameUkr: TcxTextEdit;
    cxLabel13: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TMemberEditForm);
end.
