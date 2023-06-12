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
  cxImageComboBox, ChoicePeriod, cxSplitter;

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
    Amount_LakTo: TcxGridDBColumn;
    CuterCount_LakTo: TcxGridDBColumn;
    OperDate_LakFrom: TcxGridDBColumn;
    Amount_LakFrom: TcxGridDBColumn;
    CuterCount_LakFrom: TcxGridDBColumn;
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

