unit SheetWorkTimeAddRecord;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, dsdGuides,
  cxLabel, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  dxSkinsCore, dxSkinsDefaultPainters;

type

  TSheetWorkTimeAddRecordForm = class(TAncestorEditDialogForm)
    cePersonal: TcxButtonEdit;
    cePosition: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    cepersonalgroup: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    PersonalGuides: TdsdGuides;
    PositionGuides: TdsdGuides;
    UnitGuides: TdsdGuides;
    PersonalGroupGuides: TdsdGuides;
    GuidesFiller: TGuidesFiller;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSheetWorkTimeAddRecordForm);

end.
