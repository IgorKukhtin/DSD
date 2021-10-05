unit TransportServiceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit,
  cxButtonEdit, cxBlobEdit, frxClass, dsdGuides, dxSkinBlack, dxSkinBlue,
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
  TTransportServiceJournalForm = class(TAncestorJournalForm)
    Distance: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountPoint: TcxGridDBColumn;
    TrevelTime: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    ContractConditionKindName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    CarChoiceForm: TOpenChoiceForm;
    RouteChoiceForm: TOpenChoiceForm;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    PaidKindChoiceForm: TOpenChoiceForm;
    ContractName: TcxGridDBColumn;
    ContractChoiceForm: TOpenChoiceForm;
    InfoMoneyCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    UnitForwardingName: TcxGridDBColumn;
    StartRun: TcxGridDBColumn;
    StartRunPlan: TcxGridDBColumn;
    WeightTransport: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    SummTotal: TcxGridDBColumn;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    Cost_Info: TcxGridDBColumn;
    MemberExternalName: TcxGridDBColumn;
    DriverCertificate: TcxGridDBColumn;
    spUpdate_SummReestr: TdsdStoredProc;
    ExecuteDialogSummReestr: TExecuteDialog;
    actUpdate_SummReestr: TdsdExecStoredProc;
    macUpdate_SummReestr: TMultiAction;
    isSummReestr: TcxGridDBColumn;
    bbUpdate_SummReestr: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrintCost: TdsdStoredProc;
    bbPrintCost: TdxBarButton;
    actPrintCost: TdsdPrintAction;
    CarTrailerChoiceForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTransportServiceJournalForm);

end.
