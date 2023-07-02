unit WagesVIP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TWagesVIPForm = class(TAncestorDocumentForm)
    MemberCode: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    HoursWork: TcxGridDBColumn;
    DateIssuedBy: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    bbactStartLoad: TdxBarButton;
    AmountAccrued: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceTotalSummPhone: TcxCurrencyEdit;
    ceTotalSummSale: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceHoursWork: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    deDateCalculation: TcxDateEdit;
    cxLabel6: TcxLabel;
    actCalculationAll: TMultiAction;
    actExecCalculationAll: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    spCalculationAll: TdsdStoredProc;
    ceTotalSummSaleNP: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    spCalculationAllDay: TdsdStoredProc;
    actCalculationAllDay: TMultiAction;
    actExecCalculationAllDay: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    ceTotalSumm: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    actReport_CalcMonthForm: TdsdOpenForm;
    bbReport_CalcMonthForm: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colName: TcxGridDBColumn;
    colPercentPhone: TcxGridDBColumn;
    colPercentOther: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    PayrollTypeVIPDS: TDataSource;
    PayrollTypeVIPCDS: TClientDataSet;
    spSelect_PayrollTypeVIP: TdsdStoredProc;
    ApplicationAward: TcxGridDBColumn;
    TotalSum: TcxGridDBColumn;
    colRate: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWagesVIPForm);

end.
