unit PersonalServiceListEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit,
  cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TPersonalServiceListEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    cePaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    ceBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    cxLabel16: TcxLabel;
    edBankId: TcxButtonEdit;
    BankGuides: TdsdGuides;
    ceisSecond: TcxCheckBox;
    cxLabel6: TcxLabel;
    edMemberHeadManager: TcxButtonEdit;
    GuidesMemberHeadManager: TdsdGuides;
    cxLabel7: TcxLabel;
    edMemberManager: TcxButtonEdit;
    GuidesMemberManager: TdsdGuides;
    cxLabel8: TcxLabel;
    edMemberBookkeeper: TcxButtonEdit;
    GuidesMemberBookkeeper: TdsdGuides;
    cxLabel33: TcxLabel;
    edCompensation: TcxCurrencyEdit;
    cbRecalc: TcxCheckBox;
    edisBankOut: TcxCheckBox;
    cxLabel12: TcxLabel;
    edBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    GuidesPSLExportKind: TdsdGuides;
    cxLabel9: TcxLabel;
    edPSLExportKind: TcxButtonEdit;
    edContentType: TcxTextEdit;
    cxLabel10: TcxLabel;
    edOnFlowType: TcxTextEdit;
    cxLabel11: TcxLabel;
    cbDetail: TcxCheckBox;
    edKoeffSummCardSecond: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    cePersonalHead: TcxButtonEdit;
    GuidesPersonalHead: TdsdGuides;
    cxLabel15: TcxLabel;
    edSummAvance: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edSummAvanceMax: TcxCurrencyEdit;
    edHourAvance: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    cbAvanceNot: TcxCheckBox;
    cxLabel19: TcxLabel;
    edPersonalServiceList_AvanceF2: TcxButtonEdit;
    GuidesPersonalServiceList_AvanceF2: TdsdGuides;
    cbCompensationNot: TcxCheckBox;
    cbBankNot: TcxCheckBox;
    cbisNotAuto: TcxCheckBox;
    cbisNotRound: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalServiceListEditForm);

end.
