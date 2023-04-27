unit PersonalEdit;

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
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, dsdAddOn, cxPropertiesStore, dsdDB, dsdAction,
  Vcl.ActnList, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel,
  cxTextEdit, cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  cxCheckBox, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxPC;

type
  TPersonalEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceMemberCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cePosition: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceMember: TcxButtonEdit;
    edDateIn: TcxDateEdit;
    edDateOut: TcxDateEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cePersonalGroup: TcxButtonEdit;
    cxLabel1: TcxLabel;
    UnitGuides: TdsdGuides;
    MemberGuides: TdsdGuides;
    PersonalGroupGuides: TdsdGuides;
    PositionGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    cePositionLevel: TcxButtonEdit;
    PositionLevelGuides: TdsdGuides;
    cbDateOut: TcxCheckBox;
    cbMain: TcxCheckBox;
    cxLabel8: TcxLabel;
    cePersonalServiceList: TcxButtonEdit;
    PersonalServiceListGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    cePersonalServiceListOfficial: TcxButtonEdit;
    PersonalServiceListOfficialGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    ceSheetWorkTime: TcxButtonEdit;
    SheetWorkTimeGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    ceStorageLine: TcxButtonEdit;
    StorageLineGuides: TdsdGuides;
    cxLabel12: TcxLabel;
    cePersonalServiceListCardSecond: TcxButtonEdit;
    GuidesPersonalServiceListCardSecond: TdsdGuides;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxLabel14: TcxLabel;
    edMember_Mentor: TcxButtonEdit;
    cxLabel15: TcxLabel;
    edReasonOut: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edMember_Refer: TcxButtonEdit;
    GuidesMember_Refer: TdsdGuides;
    GuidesMember_Mentor: TdsdGuides;
    GuidesReasonOut: TdsdGuides;
    edComment: TcxTextEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edDateSend: TcxDateEdit;
    cbDateSend: TcxCheckBox;
    cePersonalServiceListAvanceF2: TcxButtonEdit;
    cxLabel18: TcxLabel;
    GuidesPersonalServiceListAvanceF2: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPersonalEditForm);
end.
