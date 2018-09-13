unit Report_AccountMotionDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_AccountMotionDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    cxLabel20: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    GuidesAccount: TdsdGuides;
    cxLabel5: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    cxLabel4: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    ceProfitLossGroup: TcxButtonEdit;
    AccountGroupGuides: TdsdGuides;
    ProfitLossGroupGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    ceAccountDirection: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ceProfitLossDirection: TcxButtonEdit;
    AccountDirectionGuides: TdsdGuides;
    ProfitLossDirectionGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    ceProfitLoss: TcxButtonEdit;
    ProfitLossGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    ceBusiness: TcxButtonEdit;
    BusinessGuides: TdsdGuides;
    cbMovement: TcxCheckBox;
    cbGoods: TcxCheckBox;
    cbDetail: TcxCheckBox;
    cbGoodskind: TcxCheckBox;
    cxLabel2: TcxLabel;
    edMovementDesc: TcxButtonEdit;
    GuidesMovementDesc: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_AccountMotionDialogForm);

end.
