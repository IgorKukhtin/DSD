unit WagesAdditionalExpenses;

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
  TWagesAdditionalExpensesForm = class(TAncestorDocumentForm)
    bbPrintCheck: TdxBarButton;
    bbGet_SP_Prior: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    UnitName: TcxGridDBBandedColumn;
    SummaCleaning: TcxGridDBBandedColumn;
    SummaSP: TcxGridDBBandedColumn;
    SummaOther: TcxGridDBBandedColumn;
    SummaTotal: TcxGridDBBandedColumn;
    isIssuedBy: TcxGridDBBandedColumn;
    Comment: TcxGridDBBandedColumn;
    MIDateIssuedBy: TcxGridDBBandedColumn;
    actCopySumm: TdsdExecStoredProc;
    spCopySumm: TdsdStoredProc;
    dxBarButton11: TdxBarButton;
    SummaValidationResults: TcxGridDBBandedColumn;
    SummaSUN1: TcxGridDBBandedColumn;
    actWagesTechnicalRediscount: TdsdOpenForm;
    dxBarButton12: TdxBarButton;
    SummaTechnicalRediscount: TcxGridDBBandedColumn;
    SummaMoneyBox: TcxGridDBBandedColumn;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    SummaFullCharge: TcxGridDBBandedColumn;
    SummaMoneyBoxUsed: TcxGridDBBandedColumn;
    SummaFullChargeFact: TcxGridDBBandedColumn;
    Color_Calc: TcxGridDBBandedColumn;
    actClearSummaFullChargeFact: TdsdExecStoredProc;
    spClearSummaFullChargeFact: TdsdStoredProc;
    dxBarButton13: TdxBarButton;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    SummaMoneyBoxResidual: TcxGridDBBandedColumn;
    SummaFine: TcxGridDBBandedColumn;
    actReport_FoundPositionsSUN: TdsdOpenForm;
    dxBarButton14: TdxBarButton;
    SummaIntentionalPeresort: TcxGridDBBandedColumn;
    SummaPercentIC: TcxGridDBBandedColumn;
    SummaOrderConfirmation: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWagesAdditionalExpensesForm);

end.
