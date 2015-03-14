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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TProductionUnionTechJournalForm = class(TAncestorDocumentMCForm)
    actUpdateChildDS: TdsdUpdateDataSet;
    colCount: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    colPartionClose: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colRealWeight: TcxGridDBColumn;
    colCuterCount: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colReceiptName: TcxGridDBColumn;
    actGoodsKindChoiceChild: TOpenChoiceForm;
    actGoodsKindChoiceMaster: TOpenChoiceForm;
    colChildGoodsName: TcxGridDBColumn;
    colChildGoodsKindName: TcxGridDBColumn;
    colChildPartionGoodsDate: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEnd: TcxDateEdit;
    cxLabel7: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    OperDate: TcxGridDBColumn;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    colAmount_order: TcxGridDBColumn;
    colGoodsKindCompleteName: TcxGridDBColumn;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    colMeasureName: TcxGridDBColumn;
    colReceiptCode: TcxGridDBColumn;
    colChildMeasureName: TcxGridDBColumn;
    colChildAmountCalc: TcxGridDBColumn;
    colCuterCount_order: TcxGridDBColumn;
    colChildGroupNumber: TcxGridDBColumn;
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
