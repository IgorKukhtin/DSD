unit ProductionUnionTechJournal;

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
  TProductionUnionTechJournalForm = class(TAncestorDocumentMCForm)
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
    ChildGoodsKindName: TcxGridDBColumn;
    ChildPartionGoodsDate: TcxGridDBColumn;
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
    ChildMeasureName: TcxGridDBColumn;
    AmountCalc: TcxGridDBColumn;
    CuterCount_order: TcxGridDBColumn;
    GroupNumber: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    Amount: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildAmountReceipt: TcxGridDBColumn;
    ChildPartionGoods: TcxGridDBColumn;
    ChildComment: TcxGridDBColumn;
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
    AmountWeight: TcxGridDBColumn;
    AmountCalcWeight: TcxGridDBColumn;
    AmountReceiptWeight: TcxGridDBColumn;
    bbComplete: TdxBarButton;
    bbUnComplete: TdxBarButton;
    bbSetErased: TdxBarButton;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    InsertName: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    ChildInsertName: TcxGridDBColumn;
    ChildUpdateName: TcxGridDBColumn;
    ChildInsertDate: TcxGridDBColumn;
    ChildUpdateDate: TcxGridDBColumn;
    ChildColor_calc: TcxGridDBColumn;
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
    ChildGoodsKindCompleteName: TcxGridDBColumn;
    actGoodsKindCompleteChoiceChild: TOpenChoiceForm;
    ExecuteDialog: TExecuteDialog;
    isOrderSecond: TcxGridDBColumn;
    DocumentKindName: TcxGridDBColumn;
    CuterWeight: TcxGridDBColumn;
    spSelectPrintCeh: TdsdStoredProc;
    actPrintCeh: TdsdPrintAction;
    bbPrintCeh: TdxBarButton;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spUpdate_Movement_OperDate: TdsdStoredProc;
    actUpdate_OperDate: TdsdExecStoredProc;
    macUpdate_OperDate: TMultiAction;
    macUpdate_OperDateList: TMultiAction;
    ExecuteDialog_operdate: TExecuteDialog;
    bbUpdate_OperDateList: TdxBarButton;
    spPrintDays1: TdsdStoredProc;
    actPrintDays1: TdsdPrintAction;
    bbPrintDays1: TdxBarButton;
    actPrintDays2: TdsdPrintAction;
    actPrintDays3: TdsdPrintAction;
    bbPrintDays2: TdxBarButton;
    bbPrintDays3: TdxBarButton;
    spPrintDays2: TdsdStoredProc;
    spPrintDays3: TdsdStoredProc;
    spPrintDays4: TdsdStoredProc;
    actPrintDays4: TdsdPrintAction;
    bbPrintDays4: TdxBarButton;
    spPrintDays1_cuter: TdsdStoredProc;
    actPrintDays1_cuter: TdsdPrintAction;
    bbPrintDays1_test: TdxBarButton;
    actPrintDays2_cuter: TdsdPrintAction;
    bbPrintDays2_cuter: TdxBarButton;
    OperDate_LakTo: TcxGridDBColumn;
    CountReal_LakTo: TcxGridDBColumn;
    Count_LakTo: TcxGridDBColumn;
    OperDate_LakFrom: TcxGridDBColumn;
    CountReal_LakFrom: TcxGridDBColumn;
    Count_LakFrom: TcxGridDBColumn;
    actOpenFormOrderInternal: TdsdOpenForm;
    bbOpenFormOrderInternal: TdxBarButton;
    Partion: TcxGridDBColumn;
    cbisLak: TcxCheckBox;
    actRefresh_lak: TdsdDataSetRefresh;
    spPrintLak: TdsdStoredProc;
    actPrintLak: TdsdPrintAction;
    bbPrintLak: TdxBarButton;
    spUpdate_AmountForm: TdsdStoredProc;
    actExecuteDialog_AmountForm: TExecuteDialog;
    actUpdate_AmountForm: TdsdUpdateDataSet;
    mactUpdate_AmountForm: TMultiAction;
    bbUpdate_AmountForm: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    dxBarSeparator2: TdxBarSeparator;
    bbsProtoco: TdxBarSubItem;
    spPrint_TaxExitUpdate: TdsdStoredProc;
    actPrint_ReportTaxExit: TdsdPrintAction;
    bbPrint_ReportTaxExit: TdxBarButton;
    actPrintOUT_rep: TdsdPrintAction;
    actPrintCEH_rep: TdsdPrintAction;
    actPrintTRM_rep: TdsdPrintAction;
    bbPrintOUT_rep: TdxBarButton;
    bbPrintCEH_rep: TdxBarButton;
    bbPrintTRM_rep: TdxBarButton;
    spUpdate_MI_AmountNext_out: TdsdStoredProc;
    actUpdate_AmountNext_out: TdsdUpdateDataSet;
    mactUpdate_AmountNext_out: TMultiAction;
    bbUpdate_AmountNext_out: TdxBarButton;
    actPrintDays5: TdsdPrintAction;
    bbPrintDays5: TdxBarButton;
    spPrintDays5: TdsdStoredProc;
    spInsertPrint_byGrid: TdsdStoredProc;
    actPrint_byGrid: TdsdExecStoredProc;
    actPrint_byGrid_list: TMultiAction;
    actPrint_ReportTaxExit_grid: TdsdPrintAction;
    spPrint_TaxExitUpdate_grid: TdsdStoredProc;
    macPrint_ReportTaxExit_grid: TMultiAction;
    bbPrint_ReportTaxExit_grid: TdxBarButton;
    spDelete_Object_Print: TdsdStoredProc;
    actDelete_Object_Print: TdsdExecStoredProc;
    actPrintCEH_rep_grid: TdsdPrintAction;
    actPrintOUT_rep_grid: TdsdPrintAction;
    actPrintTRM_rep_grid: TdsdPrintAction;
    macPrintTRM_rep_grid: TMultiAction;
    macPrintCEH_rep_grid: TMultiAction;
    macPrintOUT_rep_grid: TMultiAction;
    bbPrintCEH_rep_grid: TdxBarButton;
    bbPrintOUT_rep_grid: TdxBarButton;
    bbPrintTRM_rep_grid: TdxBarButton;
    actPrintCEH_Group: TdsdPrintAction;
    bbPrintCEH_Group: TdxBarButton;
    actPrintTRM_Group: TdsdPrintAction;
    bbPrintTRM_Group: TdxBarButton;
    spPrint_TaxExitUpdate_groupTRM: TdsdStoredProc;
    spPrint_TaxExitUpdate_groupCeh: TdsdStoredProc;
    spPrint_TaxExitUpdate_term: TdsdStoredProc;
    spPrint_TaxExitUpdate_grid_term: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionUnionTechJournalForm);

end.

