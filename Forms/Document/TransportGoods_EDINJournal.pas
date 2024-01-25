unit TransportGoods_EDINJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, EDI;

type
  TTransportGoods_EDINJournalForm = class(TAncestorJournalForm)
    TotalCountSh: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    CarModelName: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    CarTrailerName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    InvNumber_Sale: TcxGridDBColumn;
    OperDate_Sale: TcxGridDBColumn;
    InvNumberPartner_Sale: TcxGridDBColumn;
    OperDatePartner_Sale: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    CarJuridicalName: TcxGridDBColumn;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    mactPrint_TTN: TMultiAction;
    isExternal: TcxGridDBColumn;
    spGet_DefaultEDIN: TdsdStoredProc;
    spSelect_eTTN_Send: TdsdStoredProc;
    mactSendETTN: TMultiAction;
    actSendETTN: TdsdEDINAction;
    actExecSelect_eTTN_Send: TdsdExecStoredProc;
    actGet_DefaultEDIN: TdsdExecStoredProc;
    mactSignConsignorETTN: TMultiAction;
    actSignConsignorETTN: TdsdEDINAction;
    mactSignCarrierETTN: TMultiAction;
    actSignCarrierETTN: TdsdEDINAction;
    actDialog_TTN: TdsdOpenForm;
    bbSendETTN: TdxBarButton;
    bsSignETTN: TdxBarSubItem;
    bbSignConsignorETTN: TdxBarButton;
    bbSignCarrierETTN: TdxBarButton;
    isSend_eTTN: TcxGridDBColumn;
    Uuid: TcxGridDBColumn;
    GLN_car: TcxGridDBColumn;
    GLN_from: TcxGridDBColumn;
    GLN_Unloading: TcxGridDBColumn;
    GLN_to: TcxGridDBColumn;
    GLN_Driver: TcxGridDBColumn;
    KATOTTG_Unloading: TcxGridDBColumn;
    KATOTTG_Unit: TcxGridDBColumn;
    spSelect_eTTN_Sing: TdsdStoredProc;
    actExecSelect_eTTN_Sign: TdsdExecStoredProc;
    MemberSignConsignorName: TcxGridDBColumn;
    SignConsignorDate: TcxGridDBColumn;
    MemberSignCarrierName: TcxGridDBColumn;
    SignCarrierDate: TcxGridDBColumn;
    spUpdate_Uuid: TdsdStoredProc;
    spUpdate_Sign_Consignor: TdsdStoredProc;
    spUpdate_Sign_Carrier: TdsdStoredProc;
    GLN_Unit: TcxGridDBColumn;
    PlaceOf: TcxGridDBColumn;
    DeliveryInstructionsName: TcxGridDBColumn;
    OKPO_car: TcxGridDBColumn;
    OKPO_To: TcxGridDBColumn;
    DriverINN: TcxGridDBColumn;
    DriverCertificate: TcxGridDBColumn;
    spUpdate_CommentError: TdsdStoredProc;
    CommentError: TcxGridDBColumn;
    CityFromName: TcxGridDBColumn;
    CityToName: TcxGridDBColumn;
    spUpdate_Partner_KATOTTG: TdsdStoredProc;
    PersonalDriverItemName: TcxGridDBColumn;
    Address_Unit: TcxGridDBColumn;
    CarBrandName: TcxGridDBColumn;
    CarColorName: TcxGridDBColumn;
    CarTypeName: TcxGridDBColumn;
    CarTrailerModelName: TcxGridDBColumn;
    CarTrailerBrandName: TcxGridDBColumn;
    CarTrailerColorName: TcxGridDBColumn;
    CarTrailerTypeName: TcxGridDBColumn;
    isWeCar: TcxGridDBColumn;
    mactSendSingETTN: TMultiAction;
    actSendSignETTN: TdsdEDINAction;
    bbSendSingETTN: TdxBarButton;
    isSignConsignor_eTTN: TcxGridDBColumn;
    isSignCarrier_eTTN: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTransportGoods_EDINJournalForm);
end.
