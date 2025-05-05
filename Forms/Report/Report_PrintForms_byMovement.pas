unit Report_PrintForms_byMovement;

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
  TReport_PrintForms_byMovementForm = class(TAncestorReportForm)
    InvNumber: TcxGridDBColumn;
    FormPrintName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edMovementDesc: TcxButtonEdit;
    GuidesMovementDesc: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbsPrintSale: TdxBarSubItem;
    bbsReturnIn: TdxBarSubItem;
    spGetReportName_Sale: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    spSelectPrint_Sale: TdsdStoredProc;
    actPrint_Sale: TdsdPrintAction;
    actSPPrintSaleProcName_Sale: TdsdExecStoredProc;
    mactPrint_Sale: TMultiAction;
    bbtPrint_Sale: TdxBarButton;
    spGetReportNameTransport: TdsdStoredProc;
    bbPrint_Transport: TdxBarButton;
    spGetReportNameQuality: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actDialog_QualityDoc: TdsdOpenForm;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    mactPrint_QualityDoc: TMultiAction;
    spSelectPrint_Quality: TdsdStoredProc;
    bbPrint_TTN: TdxBarButton;
    bbPrint_QualityDoc: TdxBarButton;
    PrintKindName: TcxGridDBColumn;
    spGetReportName_ReturnIn: TdsdStoredProc;
    actPrint_ReturnIn: TdsdPrintAction;
    actSPPrintProcName_ReturnIn: TdsdExecStoredProc;
    mactPrint_ReturnIn: TMultiAction;
    bbPrint_ReturnIn: TdxBarButton;
    spSelectPrint_returnIn: TdsdStoredProc;
    spGetReporNameTTN: TdsdStoredProc;
    spSelectPrint_TTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    mactPrint_TTN: TMultiAction;
    TotalPage_All: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_PrintForms_byMovementForm);

end.
