unit SendDebtMember;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue,
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
  TSendDebtMemberForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    ceCarFrom: TcxButtonEdit;
    ceInfoMoneyFrom: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    GuidesCarFrom: TdsdGuides;
    GuidesInfoMoneyFrom: TdsdGuides;
    ceMemberFrom: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel4: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    GuidesMemberFrom: TdsdGuides;
    cxLabel3: TcxLabel;
    ceMemberTo: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceInfoMoneyTo: TcxButtonEdit;
    GuidesInfoMoneyTo: TdsdGuides;
    cxLabel9: TcxLabel;
    ceCarTo: TcxButtonEdit;
    GuidesCarTo: TdsdGuides;
    GuidesMemberTo: TdsdGuides;
    ceJuridicalBasisFrom: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesJuridicalBasisFrom: TdsdGuides;
    ceJuridicalBasisTo: TcxButtonEdit;
    cxLabel13: TcxLabel;
    GuidesJuridicalBasisTo: TdsdGuides;
    ceBranchFrom: TcxButtonEdit;
    cxLabel14: TcxLabel;
    GuidesBranchFrom: TdsdGuides;
    ceBranchTo: TcxButtonEdit;
    cxLabel15: TcxLabel;
    GuidesBranchTo: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshAmountCurr: TdsdDataSetRefresh;
    actCheckRight: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSendDebtMemberForm);

end.
