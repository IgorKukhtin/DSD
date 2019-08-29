unit Wages;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridBandedTableView, cxGridDBBandedTableView, DataModul,
  dsdExportToXLSAction, cxMemo, cxBlobEdit;

type
  TWagesForm = class(TAncestorDocumentForm)
    bbPrintCheck: TdxBarButton;
    bbGet_SP_Prior: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    actDataDialog: TExecuteDialog;
    actUserNickDialig: TOpenChoiceForm;
    actAddUser: TMultiAction;
    actspInsertUser: TdsdExecStoredProc;
    spInsertUser: TdsdStoredProc;
    UnitName: TcxGridDBBandedColumn;
    dxBarButton4: TdxBarButton;
    Color_Calc: TcxGridDBBandedColumn;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    actPrintCalculationPerson: TMultiAction;
    dxBarButton7: TdxBarButton;
    actOpenChoicePersonal: TOpenChoiceForm;
    actExportPrintCalculationPerson: TdsdExportToXLS;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrintCalculationPerson: TdsdStoredProc;
    actExecSPPrintCalculationPerson: TdsdExecStoredProc;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spSelect_MI_Child: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    DetailDS: TDataSource;
    DetailDCS: TClientDataSet;
    chUnitName: TcxGridDBColumn;
    chPayrollTypeName: TcxGridDBColumn;
    chAmountAccrued: TcxGridDBColumn;
    chSummaBase: TcxGridDBColumn;
    chFormula: TcxGridDBColumn;
    actCalculationAll: TMultiAction;
    actExecCalculationAll: TdsdExecStoredProc;
    dxBarButton8: TdxBarButton;
    spCalculationAll: TdsdStoredProc;
    AmountCard: TcxGridDBBandedColumn;
    AmountHand: TcxGridDBBandedColumn;
    AmountAccrued: TcxGridDBBandedColumn;
    chDateCalculation: TcxGridDBColumn;
    actPrintCalculationAll: TMultiAction;
    actExecSPPrintCalculationAll: TdsdExecStoredProc;
    actExportPrintCalculationAll: TdsdExportToXLS;
    spSelectPrintCalculationAll: TdsdStoredProc;
    dxBarButton9: TdxBarButton;
    actUpdate_isIssuedBy: TdsdExecStoredProc;
    spUpdate_isIssuedBy: TdsdStoredProc;
    isIssuedBy: TcxGridDBBandedColumn;
    dxBarButton10: TdxBarButton;
    actIssuedBy: TMultiAction;
    Marketing: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWagesForm);

end.
