unit OrderFinanceEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdAddOn, cxPropertiesStore,
  dsdDB, dsdAction, Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons,
  cxLabel, cxTextEdit, dsdGuides, cxMaskEdit, cxButtonEdit, dsdCommon,
  cxCheckBox;

type
  TOrderFinanceEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    Код: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel2: TcxLabel;
    edBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    cxLabel3: TcxLabel;
    edBank: TcxButtonEdit;
    GuidesBank: TdsdGuides;
    cxLabel4: TcxLabel;
    ceMember_1: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ceMember_2: TcxButtonEdit;
    GuidesMember1: TdsdGuides;
    GuidesMember2: TdsdGuides;
    cxLabel5: TcxLabel;
    edInsertUser: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel6: TcxLabel;
    edInsertUser_2: TcxButtonEdit;
    GuidesInsert_2: TdsdGuides;
    cxLabel8: TcxLabel;
    edInsertUser_3: TcxButtonEdit;
    GuidesInsert_3: TdsdGuides;
    cxLabel9: TcxLabel;
    edInsertUser_4: TcxButtonEdit;
    GuidesInsert_4: TdsdGuides;
    cxLabel11: TcxLabel;
    edInsertUser_5: TcxButtonEdit;
    GuidesInsert_5: TdsdGuides;
    cbisStatus_off: TcxCheckBox;
    cbisOperDate: TcxCheckBox;
    cbisPlan_1: TcxCheckBox;
    cbisPlan_2: TcxCheckBox;
    cbisPlan_3: TcxCheckBox;
    cbisPlan_4: TcxCheckBox;
    cbisPlan_5: TcxCheckBox;
    cbSB: TcxCheckBox;
    cbisInvNumber_Invoice: TcxCheckBox;
    cbisInvNumber: TcxCheckBox;
    cxLabel13: TcxLabel;
    edInsertUser_6: TcxButtonEdit;
    GuidesInsert_6: TdsdGuides;
    cxLabel14: TcxLabel;
    edInsertUser_7: TcxButtonEdit;
    GuidesInsert_7: TdsdGuides;
    cxLabel15: TcxLabel;
    edInsertUser_8: TcxButtonEdit;
    GuidesInsert_8: TdsdGuides;
    cxLabel16: TcxLabel;
    edInsertUser_9: TcxButtonEdit;
    GuidesInsert_9: TdsdGuides;
    cxLabel17: TcxLabel;
    edInsertUser_10: TcxButtonEdit;
    GuidesInsert_10: TdsdGuides;
    cxLabel18: TcxLabel;
    edInsertUser_11: TcxButtonEdit;
    GuidesInsert_11: TdsdGuides;
    edInsertUser_12: TcxButtonEdit;
    GuidesInsert_12: TdsdGuides;
    cxLabel19: TcxLabel;
    edInsertUser_13: TcxButtonEdit;
    GuidesInsert_13: TdsdGuides;
    cxLabel20: TcxLabel;
    edInsertUser_14: TcxButtonEdit;
    GuidesInsert_14: TdsdGuides;
    cxLabel21: TcxLabel;
    edInsertUser_15: TcxButtonEdit;
    GuidesInsert_15: TdsdGuides;
    cxLabel22: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TOrderFinanceEditForm);
end.
