unit ProductionUnionTechReceiptJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocumentMC, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue,
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
  cxImageComboBox, ChoicePeriod, cxSplitter, cxCheckBox, dsdCommon;

type
  TProductionUnionTechReceiptJournalForm = class(TAncestorDocumentMCForm)
    actUpdateChildDS: TdsdUpdateDataSet;
    Count: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    IsPartionClose: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    CuterCount: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    actGoodsKindChoiceChild: TOpenChoiceForm;
    actGoodsKindChoiceMaster: TOpenChoiceForm;
    colChildGoodsKindName: TcxGridDBColumn;
    colChildPartionGoodsDate: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEnd: TcxDateEdit;
    RefreshDispatcher: TRefreshDispatcher;
    OperDate: TcxGridDBColumn;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    Amount_order: TcxGridDBColumn;
    GoodsKindName_Complete: TcxGridDBColumn;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    colChildMeasureName: TcxGridDBColumn;
    colChildAmountCalc: TcxGridDBColumn;
    CuterCount_order: TcxGridDBColumn;
    colChildGroupNumber: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    Amount: TcxGridDBColumn;
    colChildAmount: TcxGridDBColumn;
    colChildAmountReceipt: TcxGridDBColumn;
    colChildPartionGoods: TcxGridDBColumn;
    colChildComment: TcxGridDBColumn;
    PrintMasterCDS: TClientDataSet;
    spReport_TaxExit: TdsdStoredProc;
    isTaxExit: TcxGridDBColumn;
    isWeightMain: TcxGridDBColumn;
    actPrintReceipt: TdsdPrintAction;
    spPrintReceipt: TdsdStoredProc;
    bbPrintReceipt: TdxBarButton;
    actReceiptChoice: TOpenChoiceForm;
    LineNum: TcxGridDBColumn;
    spReport_TaxLoss: TdsdStoredProc;
    bbReport_TaxLoss: TdxBarButton;
    actReport_TaxLoss: TdsdPrintAction;
    actReport_TaxExit_Loss: TdsdPrintAction;
    bbReport_TaxExit_Loss: TdxBarButton;
    spMovementUnComplete: TdsdStoredProc;
    spMovementSetErased: TdsdStoredProc;
    spMovementComplete: TdsdStoredProc;
    actUnComplete: TdsdChangeMovementStatus;
    actComplete: TdsdChangeMovementStatus;
    actSetErased: TdsdChangeMovementStatus;
    colChildAmountWeight: TcxGridDBColumn;
    colChildAmountCalcWeight: TcxGridDBColumn;
    colChildAmountReceiptWeight: TcxGridDBColumn;
    bbComplete: TdxBarButton;
    bbUnComplete: TdxBarButton;
    bbSetErased: TdxBarButton;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    InsertName: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    colChildInsertName: TcxGridDBColumn;
    colChildUpdateName: TcxGridDBColumn;
    colChildInsertDate: TcxGridDBColumn;
    colChildUpdateDate: TcxGridDBColumn;
    colChildColor_calc: TcxGridDBColumn;
    Amount_calc: TcxGridDBColumn;
    IsMain: TcxGridDBColumn;
    Comment_receipt: TcxGridDBColumn;
    TermProduction: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    PartionGoodsDateClose: TcxGridDBColumn;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    spMovementReComplete: TdsdStoredProc;
    spReCompete: TdsdExecStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    N13: TMenuItem;
    spCompete: TdsdExecStoredProc;
    actSimpleCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    N14: TMenuItem;
    spUncomplete: TdsdExecStoredProc;
    actSimpleUncompleteList: TMultiAction;
    actUnCompleteList: TMultiAction;
    N15: TMenuItem;
    spErased: TdsdExecStoredProc;
    actSimpleErased: TMultiAction;
    actSetErasedList: TMultiAction;
    N16: TMenuItem;
    colChildGoodsKindCompleteName: TcxGridDBColumn;
    actGoodsKindCompleteChoiceChild: TOpenChoiceForm;
    ExecuteDialog: TExecuteDialog;
    isOrderSecond: TcxGridDBColumn;
    DocumentKindName: TcxGridDBColumn;
    CuterWeight: TcxGridDBColumn;
    spSelectPrintCeh: TdsdStoredProc;
    actPrintCeh: TdsdPrintAction;
    bbPrintCeh: TdxBarButton;
    edJuridicalBasis: TcxButtonEdit;
    cxLabel27: TcxLabel;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spUpdate_Movement_OperDate: TdsdStoredProc;
    ExecuteDialog_operdate: TExecuteDialog;
    actUpdate_OperDate: TdsdExecStoredProc;
    macUpdate_OperDate: TMultiAction;
    macUpdate_OperDateList: TMultiAction;
    bbUpdate_OperDateList: TdxBarButton;
    spPrintDays1: TdsdStoredProc;
    spPrintDays2: TdsdStoredProc;
    spPrintDays3: TdsdStoredProc;
    spPrintDays4: TdsdStoredProc;
    actPrintDays1: TdsdPrintAction;
    actPrintDays2: TdsdPrintAction;
    actPrintDays4: TdsdPrintAction;
    actPrintDays3: TdsdPrintAction;
    bbPrintDays1: TdxBarButton;
    bbactPrintDays2: TdxBarButton;
    bbactPrintDays3: TdxBarButton;
    bbactPrintDays4: TdxBarButton;
    actPrintDays1_cuter: TdsdPrintAction;
    bbPrintDays1_test: TdxBarButton;
    spPrintDays1_cuter: TdsdStoredProc;
    actPrintDays2_cuter: TdsdPrintAction;
    bbPrintDays2_cuter: TdxBarButton;
    CountReal: TcxGridDBColumn;
    cbisLak: TcxCheckBox;
    actRefresh_lak: TdsdDataSetRefresh;
    spPrintLak: TdsdStoredProc;
    actPrintLak: TdsdPrintAction;
    bbactPrintLak: TdxBarButton;
    spUpdate_AmountForm: TdsdStoredProc;
    actExecuteDialog_AmountForm: TExecuteDialog;
    actUpdate_AmountForm: TdsdUpdateDataSet;
    mactUpdate_AmountForm: TMultiAction;
    bbUpdate_AmountForm: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    bbsProtocol: TdxBarSubItem;
    dxBarSeparator2: TdxBarSeparator;
    spPrint_TaxExitUpdate: TdsdStoredProc;
    actPrint_ReportTaxExit: TdsdPrintAction;
    actPrintCEH_rep: TdsdPrintAction;
    actPrintOUT_rep: TdsdPrintAction;
    actPrintTRM_rep: TdsdPrintAction;
    bbPrint_ReportTaxExit: TdxBarButton;
    bbPrintCEH_rep: TdxBarButton;
    bbPrintTRM_rep: TdxBarButton;
    bbPrintOUT_rep: TdxBarButton;
    spUpdate_MI_AmountNext_out: TdsdStoredProc;
    actUpdate_AmountNext_out: TdsdUpdateDataSet;
    mactUpdate_AmountNext_out: TMultiAction;
    bbUpdate_AmountNext_out: TdxBarButton;
    spPrintDays5: TdsdStoredProc;
    actPrintDays5: TdsdPrintAction;
    bbPrintDays5: TdxBarButton;
    spInsertPrint_byGrid: TdsdStoredProc;
    spDelete_Object_Print: TdsdStoredProc;
    spPrint_TaxExitUpdate_grid: TdsdStoredProc;
    actPrint_byGrid: TdsdExecStoredProc;
    actPrint_byGrid_list: TMultiAction;
    actDelete_Object_Print: TdsdExecStoredProc;
    actPrint_ReportTaxExit_grid: TdsdPrintAction;
    macPrint_ReportTaxExit_grid: TMultiAction;
    actPrintCEH_rep_grid: TdsdPrintAction;
    actPrintOUT_rep_grid: TdsdPrintAction;
    actPrintTRM_rep_grid: TdsdPrintAction;
    macPrintOUT_rep_grid: TMultiAction;
    macPrintTRM_rep_grid: TMultiAction;
    macPrintCEH_rep_grid: TMultiAction;
    bbPrint_ReportTaxExit_grid: TdxBarButton;
    bbPrintCEH_rep_grid: TdxBarButton;
    bbPrintOUT_rep_grid: TdxBarButton;
    bbPrintTRM_rep_grid: TdxBarButton;
    spPrint_TaxExitUpdate_groupTRM: TdsdStoredProc;
    spPrint_TaxExitUpdate_groupCeh: TdsdStoredProc;
    actPrintCEH_Group: TdsdPrintAction;
    actPrintTRM_Group: TdsdPrintAction;
    bbPrintTRM_Group: TdxBarButton;
    bbPrintCEH_Group: TdxBarButton;
    spPrint_TaxExitUpdate_term: TdsdStoredProc;
    spPrint_TaxExitUpdate_grid_term: TdsdStoredProc;
    spUpdate_isWeightMain: TdsdStoredProc;
    actUpdate_isWeightMain: TdsdUpdateDataSet;
    macUpdate_isWeightMain: TMultiAction;
    bbUpdate_isWeightMain: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionUnionTechReceiptJournalForm);

end.

