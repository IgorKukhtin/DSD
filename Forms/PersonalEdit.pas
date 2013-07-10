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
  cxTextEdit;

type
  TPersonalEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    ceMember: TcxLookupComboBox;
    cxLabel5: TcxLabel;
    cePosition: TcxLookupComboBox;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdExecStoredProc: TdsdExecStoredProc;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    MemberDataSet: TClientDataSet;
    spGetMember: TdsdStoredProc;
    MemberDS: TDataSource;
    MemberGuides: TdsdGuides;
    PositionDataSet: TClientDataSet;
    spGetPosition: TdsdStoredProc;
    PositionDS: TDataSource;
    dsdPosition: TdsdGuides;
    edDateIn: TcxTextEdit;
    edDateOut: TcxTextEdit;
    cxLabel6: TcxLabel;
    ceUnit: TcxLookupComboBox;
    UnitDS: TDataSource;
    dsdUnit: TdsdGuides;
    spGetUnit: TdsdStoredProc;
    UnitDataSet: TClientDataSet;
    cxLabel7: TcxLabel;
    JuridicalDS: TDataSource;
    JuridicalDataSet: TClientDataSet;
    spGetJuridical: TdsdStoredProc;
    cxLabel8: TcxLabel;
    ceJuridical: TcxLookupComboBox;
    dsdJuridical: TdsdGuides;
    ceBusiness: TcxLookupComboBox;
    BusinessDataSet: TClientDataSet;
    dsdBusiness: TdsdGuides;
    spGetBusiness: TdsdStoredProc;
    BusinessDS: TDataSource;
    cxLabel9: TcxLabel;
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
