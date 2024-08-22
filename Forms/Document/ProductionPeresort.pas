unit ProductionPeresort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
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
  TProductionPeresortForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    Comment: TcxGridDBColumn;
    actGoodsChildChoiceForm: TOpenChoiceForm;
    actPartionGoodsChoiceForm: TOpenChoiceForm;
    GoodsChildName: TcxGridDBColumn;
    PartionGoodsChild: TcxGridDBColumn;
    GoodsKindChildName: TcxGridDBColumn;
    actGoodsKindChildChoice: TOpenChoiceForm;
    PartionGoodsDate: TcxGridDBColumn;
    PartionGoodsDateChild: TcxGridDBColumn;
    GoodsChildCode: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    MeasureChildName: TcxGridDBColumn;
    GoodsChildGroupNameFull: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    cxLabel19: TcxLabel;
    edInvNumberSale: TcxButtonEdit;
    GuidesSaleChoice: TdsdGuides;
    GoodsKindName_Complete: TcxGridDBColumn;
    GoodsKindName_Complete_child: TcxGridDBColumn;
    actGoodsKind_CompleteChoice: TOpenChoiceForm;
    actGoodsKind_Complete_childChoice: TOpenChoiceForm;
    actMovementForm: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    actOpenForm: TdsdOpenForm;
    spGet_checkopen: TdsdStoredProc;
    actGet_checkopen: TdsdExecStoredProc;
    macOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    isPeresort: TcxGridDBColumn;
    actPartionGoodsAssetChoiceForm: TOpenChoiceForm;
    actInsertRecordAsset: TInsertRecord;
    macInsertRecordAsset: TMultiAction;
    bbInsertRecordAsset: TdxBarButton;
    bbPartionGoodsAssetChoiceForm: TdxBarButton;
    actStorageChoiceForm_child: TOpenChoiceForm;
    actStorageChoiceForm: TOpenChoiceForm;
    cbisEtiketka: TcxCheckBox;
    spUpdate_Etiketka: TdsdStoredProc;
    actUpdate_Etiketka: TdsdExecStoredProc;
    bbUpdate_Etiketka: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionPeresortForm);

end.
