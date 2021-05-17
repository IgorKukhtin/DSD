unit Report_KilledCodeRecovery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxDBEdit;

type
  TReport_KilledCodeRecoveryForm = class(TAncestorReportForm)
    bbGoodsPartyReport: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actOpenSalesOfTermDrugsUnit: TdsdInsertUpdateAction;
    dxBarButton1: TdxBarButton;
    edSalesThreshold: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edPercePharmaciesd: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    edRangeOfDays: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    CountSelling: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    cxDBTextEdit1: TcxDBTextEdit;
    cxDBTextEdit2: TcxDBTextEdit;
    cxLabel7: TcxLabel;
    Remains: TcxGridDBColumn;
    Price_min: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    SummaOrder: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_KilledCodeRecoveryForm);

end.
