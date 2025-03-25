unit ProductionSeparate;

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
  cxCheckBox, dsdCommon;

type
  TProductionSeparateForm = class(TAncestorDocumentMCForm)
    cePartionGoods: TcxTextEdit;
    cxLabel10: TcxLabel;
    actUpdateChildDS: TdsdUpdateDataSet;
    HeadCount: TcxGridDBColumn;
    ChildHeadCount: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildPartionGoods: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    CholdGoodsGroupNameFull: TcxGridDBColumn;
    CholdMeasureName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    colLiveWeight: TcxGridDBColumn;
    ChildLiveWeight: TcxGridDBColumn;
    actPrint_Ceh: TdsdPrintAction;
    spSelectPrintCeh: TdsdStoredProc;
    bbPrint_Ceh: TdxBarButton;
    actGoodsKindChoice: TOpenChoiceForm;
    actGoodsKindChoiceChild: TOpenChoiceForm;
    actStorageLine: TOpenChoiceForm;
    actStorageLineChild: TOpenChoiceForm;
    PrintItemsTwoCDS: TClientDataSet;
    cbCalculated: TcxCheckBox;
    spCalculated: TdsdStoredProc;
    actCalculated: TdsdExecStoredProc;
    bbCalculated: TdxBarButton;
    spUpdate_MI_Calculated: TdsdStoredProc;
    actUpdate_MI_Calculated: TdsdExecStoredProc;
    bbUpdate_MI_Calculated: TdxBarButton;
    PriceIn: TcxGridDBColumn;
    SummIn: TcxGridDBColumn;
    chPriceIn: TcxGridDBColumn;
    chSummIn: TcxGridDBColumn;
    chPriceIn_hist: TcxGridDBColumn;
    gpUpdate_StorageLineByChild: TdsdStoredProc;
    actUpdate_StorageLineByChild: TdsdExecStoredProc;
    macUpdate_StorageLineByChild: TMultiAction;
    bbUpdate_StorageLineByChild: TdxBarButton;
    edIsAuto: TcxCheckBox;
    chSummIn_hist: TcxGridDBColumn;
    actGridChildToExcel: TdsdGridToExcel;
    dxBarButton1: TdxBarButton;
    actPrint_4001: TdsdPrintAction;
    bbPrint_4001: TdxBarButton;
    GoodsGroupCode: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionSeparateForm);

end.
