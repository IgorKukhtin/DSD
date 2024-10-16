unit ContractChoicePartner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  Vcl.Menus, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxImageComboBox, cxButtonEdit, cxCurrencyEdit,
  cxContainer, dsdGuides, cxLabel, cxTextEdit, cxMaskEdit, dsdCommon;

type
  TContractChoicePartnerForm = class(TAncestorEnumForm)
    InvNumber: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Code: TcxGridDBColumn;
    ContractComment: TcxGridDBColumn;
    actChoiceRoute: TOpenChoiceForm;
    actChoiceRouteSorting: TOpenChoiceForm;
    actChoicePersonalTake: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    DelayDay: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    AmountDebet: TcxGridDBColumn;
    AmountKredit: TcxGridDBColumn;
    ContainerId: TcxGridDBColumn;
    PrepareDayCount: TcxGridDBColumn;
    DocumentDayCount: TcxGridDBColumn;
    actChoiceRoute_30201: TOpenChoiceForm;
    RouteName: TcxGridDBColumn;
    ChangePercentPartner: TcxGridDBColumn;
    actChoiceMemberTake1: TOpenChoiceForm;
    actChoiceMemberTake2: TOpenChoiceForm;
    actChoiceMemberTake3: TOpenChoiceForm;
    actChoiceMemberTake4: TOpenChoiceForm;
    actChoiceMemberTake5: TOpenChoiceForm;
    actChoiceMemberTake6: TOpenChoiceForm;
    actChoiceMemberTake7: TOpenChoiceForm;
    actShowCurPartnerOnMap: TdsdPartnerMapAction;
    bbShowCurPartnerOnMap: TdxBarButton;
    ProtocolOpenFormContract: TdsdOpenForm;
    ProtocolOpenFormPartner: TdsdOpenForm;
    bbProtocolOpenFormContract: TdxBarButton;
    bbProtocolOpenFormPartner: TdxBarButton;
    edJuridical: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesJuridical: TdsdGuides;
    FormParams: TdsdFormParams;
    bbText: TdxBarControlContainerItem;
    bbJuridical: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

registerClass(TContractChoicePartnerForm);

end.
