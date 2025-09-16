unit StaffListMember;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, ChoicePeriod, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, dsdCommon;

type
  TStaffListMemberForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    lbInvNumber: TcxLabel;
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
    GuideMember: TdsdGuides;
    GuideUpdate: TdsdGuides;
    edInsertDate: TcxDateEdit;
    cxLabel10: TcxLabel;
    edReasonOut: TcxButtonEdit;
    GuidesReasonOut: TdsdGuides;
    cbMain: TcxCheckBox;
    cbOfficial: TcxCheckBox;
    cxLabel7: TcxLabel;
    ceUnit: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cePosition: TcxButtonEdit;
    cxLabel4: TcxLabel;
    cePositionLevel: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesPosition: TdsdGuides;
    GuidesPositionLevel: TdsdGuides;
    GuidesPositionLevel_old: TdsdGuides;
    cePositionLevel_old: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesPosition_old: TdsdGuides;
    cePosition_old: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesUnit_old: TdsdGuides;
    ceUnit_old: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edStaffListKind: TcxButtonEdit;
    GuidesStaffListKind: TdsdGuides;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    ceComment: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TStaffListMemberForm);

end.
