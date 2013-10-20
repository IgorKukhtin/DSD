unit ContractEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, dxSkinsCore, dxSkinsDefaultPainters, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxCalendar, cxButtonEdit, dxSkinBlack, dxSkinBlue,
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
  TContractEditForm = class(TParentForm)
    edInvNumber: TcxTextEdit;
    LbInvNumber: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel5: TcxLabel;
    edContractKind: TcxButtonEdit;
    edJuridical: TcxButtonEdit;
    edSigningDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edStartDate: TcxDateEdit;
    edEndDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceChangePercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceChangePrice: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    ContractKindGuides: TdsdGuides;
    edPaidKind: TcxButtonEdit;
    cxLabel10: TcxLabel;
    PaidKindGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TContractEditForm);

end.
