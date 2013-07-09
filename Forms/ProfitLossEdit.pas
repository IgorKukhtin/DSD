unit ProfitLossEdit;

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
  dsdGuides, Data.DB, Datasnap.DBClient, dsdDB, dsdAction, Vcl.ActnList,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit;

type
  TProfitLossEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceProfitLossGroup: TcxLookupComboBox;
    cxLabel2: TcxLabel;
    ceProfitLossDirection: TcxLookupComboBox;
    cxLabel4: TcxLabel;
    ceInfoMoneyDestination: TcxLookupComboBox;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxLookupComboBox;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdExecStoredProc: TdsdExecStoredProc;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    ProfitLossGroupDataSet: TClientDataSet;
    spGetProfitLossGroup: TdsdStoredProc;
    ProfitLossGroupDS: TDataSource;
    dsdProfitLossGroup: TdsdGuides;
    ProfitLossDirectionDataSet: TClientDataSet;
    spGetProfitLossDirection: TdsdStoredProc;
    ProfitLossDirectionDS: TDataSource;
    dsdProfitLossDirectionGuides: TdsdGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    InfoMoneyDestinationDataSet: TClientDataSet;
    spGetInfoMoneyDestination: TdsdStoredProc;
    InfoMoneyDestinationDS: TDataSource;
    dsdInfoMoneyDestinationGuides: TdsdGuides;
    InfoMoneyDataSet: TClientDataSet;
    spGetInfoMoney: TdsdStoredProc;
    InfoMoneyDS: TDataSource;
    dsdInfoMoney: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}
  initialization
  RegisterClass(TProfitLossEditForm);
end.
