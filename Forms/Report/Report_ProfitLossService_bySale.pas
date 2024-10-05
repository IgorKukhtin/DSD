unit Report_ProfitLossService_bySale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_ProfitLossService_bySaleForm = class(TAncestorReportForm)
    InvNumber: TcxGridDBColumn;
    ContractChildName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    JuridicalName: TcxGridDBColumn;
    actGetForm: TdsdExecStoredProc;
    actGetFormPromo: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    getMovementFormPromo: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenForm: TdsdOpenForm;
    actOpenFormPromo: TdsdOpenForm;
    mactOpenDocument: TMultiAction;
    mactOpenDocumentPromo: TMultiAction;
    bbOpenDocument: TdxBarButton;
    bbOpenDocumentPromo: TdxBarButton;
    cxLabel6: TcxLabel;
    ceJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    actOpenFormProfitLossService_ContractChild: TdsdOpenForm;
    bbOpenFormProfitLossService_ContractChild: TdxBarButton;
    ContractChildCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyName_Child: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ContractCode_Master: TcxGridDBColumn;
    ContractName_Master: TcxGridDBColumn;
    JuridicalName_baza: TcxGridDBColumn;
    ContractConditionKindName: TcxGridDBColumn;
    BonusKindName: TcxGridDBColumn;
    PartnerName_baza: TcxGridDBColumn;
    BonusValue: TcxGridDBColumn;
    Amount_oth: TcxGridDBColumn;
    Persent_amount: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_ProfitLossService_bySaleForm);

end.
