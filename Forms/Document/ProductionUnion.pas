unit ProductionUnion;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TProductionUnionForm = class(TAncestorDocumentMCForm)
    actUpdateChildDS: TdsdUpdateDataSet;
    Count: TcxGridDBColumn;
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
    GoodsKindName_Complete: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    colChildMeasureName: TcxGridDBColumn;
    colChildAmount: TcxGridDBColumn;
    colChildGroupNumber: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    colChildAmountReceipt: TcxGridDBColumn;
    colChildPartionGoods: TcxGridDBColumn;
    colChildComment: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    colChildGoodsGroupNameFull: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    spSelectPrint1: TdsdStoredProc;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    actGoodsKindCompleteChoiceMaster: TOpenChoiceForm;
    edIsAuto: TcxCheckBox;
    cxLabel5: TcxLabel;
    isAuto: TcxGridDBColumn;
    edInsert: TcxDateEdit;
    colChildGoodsKindCompleteName: TcxGridDBColumn;
    actGoodsKindCompleteChoiceChild: TOpenChoiceForm;
    colchildCount_onCount: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edDocumentKind: TcxButtonEdit;
    GuidesDocumentKind: TdsdGuides;
    actPrintCeh: TdsdPrintAction;
    spSelectPrintCeh: TdsdStoredProc;
    bbPrintCeh: TdxBarButton;
    colChildIsAuto: TcxGridDBColumn;
    cxLabel17: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    OrderGuides: TdsdGuides;
    spUpdateOrder: TdsdStoredProc;
    HeaderSaver3: THeaderSaver;
    edJuridicalFrom: TcxButtonEdit;
    JuridicalFromGuides: TdsdGuides;
    spSelectPrintNoGroup: TdsdStoredProc;
    actPrintNoGroup: TdsdPrintAction;
    bbPrintNoGroup: TdxBarButton;
    cbisPeresort: TcxCheckBox;
    actPersonalChoiceForm: TOpenChoiceForm;
    cbClosed: TcxCheckBox;
    spUpdate_Closed: TdsdStoredProc;
    actUpdate_Closed: TdsdExecStoredProc;
    bbUpdate_Closed: TdxBarButton;
    isClose: TcxGridDBColumn;
    spUpdate_MI_Close: TdsdStoredProc;
    actUpdateMI_Closed: TdsdExecStoredProc;
    bbUpdateMI_Closed: TdxBarButton;
    Amount_Remains: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edProductionMov: TcxButtonEdit;
    GuidesProduction: TdsdGuides;
    actMovementForm: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    actOpenForm: TdsdOpenForm;
    macOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    spGet_checkopen: TdsdStoredProc;
    actGet_checkopen: TdsdExecStoredProc;
    actPartionGoodsAssetChoiceForm: TOpenChoiceForm;
    actInsertRecordAsset: TInsertRecord;
    macInsertRecordAsset: TMultiAction;
    bbInsertRecordAsset: TdxBarButton;
    bbPartionGoodsAssetChoice: TdxBarButton;
    actPartionGoodsAssetChoiceMaster: TOpenChoiceForm;
    CountReal_LAK: TcxGridDBColumn;
    cxLabel30: TcxLabel;
    edSubjectDoc: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
    spUpdate_AmountForm: TdsdStoredProc;
    actUpdate_AmountForm: TdsdUpdateDataSet;
    actExecuteDialog_AmountForm: TExecuteDialog;
    mactUpdate_AmountForm: TMultiAction;
    bbUpdate_AmountForm: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    dxBarSeparator2: TdxBarSeparator;
    actRefreshMI: TdsdDataSetRefresh;
    AmountNext_out: TcxGridDBColumn;
    spUpdate_MI_AmountNext_out: TdsdStoredProc;
    actUpdate_AmountNext_out: TdsdUpdateDataSet;
    mactUpdate_AmountNext_out: TMultiAction;
    bbUpdate_AmountNext_out: TdxBarButton;
    bbsUpdate: TdxBarSubItem;
    cbisEtiketka: TcxCheckBox;
    actExecuteDialog_AmountForm_two: TExecuteDialog;
    actUpdate_AmountForm_two: TdsdUpdateDataSet;
    spUpdate_AmountForm_two: TdsdStoredProc;
    mactUpdate_AmountForm_two: TMultiAction;
    bbUpdate_AmountForm_two: TdxBarButton;
    cxLabel27: TcxLabel;
    edInvNumberPeresort: TcxButtonEdit;
    GuidesProductionPeresort: TdsdGuides;
    actOpenProductionPeresortForm: TdsdOpenForm;
    bbOpenProductionPeresortForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionUnionForm);

end.
