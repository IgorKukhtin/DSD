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
    colCount: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colIsPartionClose: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colRealWeight: TcxGridDBColumn;
    colCuterCount: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colReceiptName: TcxGridDBColumn;
    actGoodsKindChoiceChild: TOpenChoiceForm;
    actGoodsKindChoiceMaster: TOpenChoiceForm;
    colChildGoodsKindName: TcxGridDBColumn;
    colChildPartionGoodsDate: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEnd: TcxDateEdit;
    RefreshDispatcher: TRefreshDispatcher;
    colOperDate: TcxGridDBColumn;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    colAmount_order: TcxGridDBColumn;
    colGoodsKindName_Complete: TcxGridDBColumn;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    colMeasureName: TcxGridDBColumn;
    colReceiptCode: TcxGridDBColumn;
    colChildMeasureName: TcxGridDBColumn;
    colChildAmountCalc: TcxGridDBColumn;
    colCuterCount_order: TcxGridDBColumn;
    colChildGroupNumber: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    colAmount: TcxGridDBColumn;
    colChildAmount: TcxGridDBColumn;
    colChildAmountReceipt: TcxGridDBColumn;
    colChildPartionGoods: TcxGridDBColumn;
    colChildComment: TcxGridDBColumn;
    PrintMasterCDS: TClientDataSet;
    PrintChildCDS: TClientDataSet;
    spReport_TaxExit: TdsdStoredProc;
    isTaxExit: TcxGridDBColumn;
    isWeightMain: TcxGridDBColumn;
    actPrintReceipt: TdsdPrintAction;
    spPrintReceipt: TdsdStoredProc;
    spPrintReceiptChild: TdsdStoredProc;
    bbPrintReceipt: TdxBarButton;
    actReceiptChoice: TOpenChoiceForm;
    colLineNum: TcxGridDBColumn;
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
    colInsertName: TcxGridDBColumn;
    colUpdateName: TcxGridDBColumn;
    colInsertDate: TcxGridDBColumn;
    colUpdateDate: TcxGridDBColumn;
    colChildInsertName: TcxGridDBColumn;
    colChildUpdateName: TcxGridDBColumn;
    colChildInsertDate: TcxGridDBColumn;
    colChildUpdateDate: TcxGridDBColumn;
    colChildColor_calc: TcxGridDBColumn;
    colAmount_calc: TcxGridDBColumn;
    colIsMain: TcxGridDBColumn;
    colComment_receipt: TcxGridDBColumn;
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

