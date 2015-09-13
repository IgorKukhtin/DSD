unit ContractChoicePartnerOrder;

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
  dxSkinXmas2008Blue, cxImageComboBox, cxButtonEdit, cxCurrencyEdit;

type
  TContractChoicePartnerOrderForm = class(TAncestorEnumForm)
    colInvNumber: TcxGridDBColumn;
    colStartDate: TcxGridDBColumn;
    colJuridicalCode: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colisErased: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    clEndDate: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colChangePercent: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    colCode: TcxGridDBColumn;
    colContractComment: TcxGridDBColumn;
    clRouteSortingName: TcxGridDBColumn;
    clRouteName: TcxGridDBColumn;
    MemberTakeName: TcxGridDBColumn;
    actChoiceRoute: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceRouteSorting: TOpenChoiceForm;
    actChoiceMemberTake: TOpenChoiceForm;
    clItemName: TcxGridDBColumn;
    AmountDebet: TcxGridDBColumn;
    AmountKredit: TcxGridDBColumn;
    DelayDay: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    DocumentDayCount: TcxGridDBColumn;
    PrepareDayCount: TcxGridDBColumn;
    actChoiceRoute_30201: TOpenChoiceForm;
    actChoiceMemberTake1: TOpenChoiceForm;
    actChoiceMemberTake2: TOpenChoiceForm;
    actChoiceMemberTake3: TOpenChoiceForm;
    actChoiceMemberTake4: TOpenChoiceForm;
    actChoiceMemberTake5: TOpenChoiceForm;
    actChoiceMemberTake6: TOpenChoiceForm;
    actChoiceMemberTake7: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

registerClass(TContractChoicePartnerOrderForm);

end.
