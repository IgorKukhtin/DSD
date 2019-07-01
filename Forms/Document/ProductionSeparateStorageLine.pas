unit ProductionSeparateStorageLine;

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
  cxCheckBox;

type
  TProductionSeparateStorageLineForm = class(TAncestorDocumentMCForm)
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
    gpUpdate_StorageLineByChild: TdsdStoredProc;
    actUpdate_StorageLineByChild: TdsdExecStoredProc;
    bbUpdate_StorageLineByChild: TdxBarButton;
    macUpdate_StorageLineByChild: TMultiAction;
    edIsAuto: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionSeparateStorageLineForm);

end.
