unit MemberEdit;

interface

uses
  Winapi.Windows, DataModul, AncestorEditDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxPCdxBarPopupMenu, cxContainer,
  cxEdit, cxCheckBox, cxCurrencyEdit, cxLabel, cxTextEdit, cxPC, Vcl.Controls,
  dsdDB, dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, dsdAddOn,
  Vcl.StdCtrls, cxButtons, cxMemo, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TMemberEditForm = class(TAncestorEditDialogForm)
    edName: TcxTextEdit;
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
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceCard: TcxTextEdit;
    cxLabel9: TcxLabel;
    ceCardSecond: TcxTextEdit;
    cxLabel10: TcxLabel;
    ceCardChild: TcxTextEdit;
    cxLabel11: TcxLabel;
    ceBank: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ceBankSecond: TcxButtonEdit;
    cxLabel13: TcxLabel;
    ceBankChild: TcxButtonEdit;
    GuidesBank: TdsdGuides;
    GuidesBankSecond: TdsdGuides;
    BankChildGuides: TdsdGuides;
    cxLabel14: TcxLabel;
    edCardIBAN: TcxTextEdit;
    cxLabel15: TcxLabel;
    edCardIBANSecond: TcxTextEdit;
    cxTabSheet1: TcxTabSheet;
    GuidesGender: TdsdGuides;
    cxLabel17: TcxLabel;
    edPSP_S: TcxTextEdit;
    cxLabel16: TcxLabel;
    edGender: TcxButtonEdit;
    cxLabel18: TcxLabel;
    edPSP_N: TcxTextEdit;
    cxLabel19: TcxLabel;
    edPSP_W: TcxTextEdit;
    cxLabel20: TcxLabel;
    edPSP_D: TcxTextEdit;
    cxLabel21: TcxLabel;
    edPSP_Start: TcxDateEdit;
    edPSP_End: TcxDateEdit;
    cxLabel22: TcxLabel;
    edBirthday: TcxDateEdit;
    cxLabel21Birthday: TcxLabel;
    cxLabel24: TcxLabel;
    edRegion_Real: TcxButtonEdit;
    GuidesRegion_Real: TdsdGuides;
    cxLabel25: TcxLabel;
    edCity: TcxButtonEdit;
    GuidesCity: TdsdGuides;
    cxLabel26: TcxLabel;
    edCity_real: TcxButtonEdit;
    GuidesCity_real: TdsdGuides;
    cxLabel27: TcxLabel;
    edStreet: TcxTextEdit;
    cxLabel28: TcxLabel;
    edStreet_Real: TcxTextEdit;
    cxTabSheet2: TcxTabSheet;
    cxLabel29: TcxLabel;
    edBirthdayChildren1: TcxDateEdit;
    cxLabel30: TcxLabel;
    edChildren1: TcxTextEdit;
    cxLabel31: TcxLabel;
    edChildren2: TcxTextEdit;
    edBirthdayChildren2: TcxDateEdit;
    cxLabel32: TcxLabel;
    edChildren3: TcxTextEdit;
    cxLabel33: TcxLabel;
    edBirthdayChildren3: TcxDateEdit;
    cxLabel34: TcxLabel;
    cxLabel35: TcxLabel;
    edChildren4: TcxTextEdit;
    edBirthdayChildren4: TcxDateEdit;
    cxLabel36: TcxLabel;
    cxLabel37: TcxLabel;
    edChildren5: TcxTextEdit;
    edBirthdayChildren5: TcxDateEdit;
    cxLabel38: TcxLabel;
    cxLabel39: TcxLabel;
    edDekret_Start: TcxDateEdit;
    cxLabel40: TcxLabel;
    edDekret_End: TcxDateEdit;
    cxTabSheet3: TcxTabSheet;
    cxLabel41: TcxLabel;
    edMemberSkill: TcxButtonEdit;
    GuidesMemberSkill: TdsdGuides;
    cxLabel42: TcxLabel;
    edJobSource: TcxButtonEdit;
    GuidesJobSource: TdsdGuides;
    cxLabel43: TcxLabel;
    edLaw: TcxTextEdit;
    cxLabel44: TcxLabel;
    edDriverCertificateAdd: TcxTextEdit;
    spInsertUpdateIts: TdsdStoredProc;
    GuidesRegion: TdsdGuides;
    cxLabel23: TcxLabel;
    edRegion: TcxButtonEdit;
    cxLabel45: TcxLabel;
    cxLabel46: TcxLabel;
    ceCardBank: TcxTextEdit;
    ceCardBankSecond: TcxTextEdit;
    cxLabel47: TcxLabel;
    edUnitMobile: TcxButtonEdit;
    GuidesUnitMobile: TdsdGuides;
    cxLabel48: TcxLabel;
    cxLabel49: TcxLabel;
    cxLabel50: TcxLabel;
    cxLabel51: TcxLabel;
    ceCardBankSecondTwo: TcxTextEdit;
    edCardIBANSecondTwo: TcxTextEdit;
    ceCardSecondTwo: TcxTextEdit;
    ceBankSecondTwo: TcxButtonEdit;
    cxLabel52: TcxLabel;
    cxLabel53: TcxLabel;
    cxLabel54: TcxLabel;
    cxLabel55: TcxLabel;
    ceCardBankSecondDiff: TcxTextEdit;
    edCardIBANSecondDiff: TcxTextEdit;
    ceCardSecondDiff: TcxTextEdit;
    cedBankSecondDiff: TcxButtonEdit;
    GuidesBankSecondTwo: TdsdGuides;
    GuidesBankSecondDiff: TdsdGuides;
    cxLabel56: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel57: TcxLabel;
    edRouteNum: TcxButtonEdit;
    GuidesRouteNum: TdsdGuides;
    cxLabel58: TcxLabel;
    ceCode1C: TcxTextEdit;
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
