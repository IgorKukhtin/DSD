unit Report_Sale_BankAccount;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox,
  cxImageComboBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TReport_Sale_BankAccountForm = class(TAncestorReportForm)
    OperDate: TcxGridDBColumn;
    StatusCode: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    InvNumber: TcxGridDBColumn;
    bbPrint_byType: TdxBarButton;
    HeaderCDS: TClientDataSet;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actisDataAll: TdsdDataSetRefresh;
    edContract: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    ContractName: TcxGridDBColumn;
    actRefreshContract: TdsdDataSetRefresh;
    ContractCode: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    TotalSumm_calc: TcxGridDBColumn;
    Summ_debt: TcxGridDBColumn;
    Summ_ReturnIn: TcxGridDBColumn;
    TotalSumm_ReturnIn: TcxGridDBColumn;
    TotalSumm_debt: TcxGridDBColumn;
    Summ_calc: TcxGridDBColumn;
    Ord: TcxGridDBColumn;
    Ord_ReturnIn: TcxGridDBColumn;
    TotalSumm_debt_end: TcxGridDBColumn;
    actOpenFormProfitLossService_ContractChild: TdsdOpenForm;
    bbProfitLossService_ContractChild: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Sale_BankAccountForm);

end.
