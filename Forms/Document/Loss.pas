unit Loss;

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
  TLossForm = class(TAncestorDocumentForm)
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
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint_Loss: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    Count: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    AssetName: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edArticleLoss: TcxButtonEdit;
    GuidesArticleLoss: TdsdGuides;
    MeasureName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    actGoodsChoiceForm: TOpenChoiceForm;
    spSelectPrint_Sale: TdsdStoredProc;
    actPrint_Sale: TdsdPrintAction;
    bbPrint_Sale: TdxBarButton;
    actAssetChoiceForm: TOpenChoiceForm;
    edIsChecked: TcxCheckBox;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
    actGoodsKindCompleteChoice: TOpenChoiceForm;
    cxLabel27: TcxLabel;
    edInvNumberIncome: TcxButtonEdit;
    GuidesIncomeDoc: TdsdGuides;
    spInsertMIMaster_byIncome: TdsdStoredProc;
    actOpenIncomeJournalChoice: TOpenChoiceForm;
    actInsertMIMaster_byIncome: TdsdExecStoredProc;
    macInsertMI_byIncome: TMultiAction;
    bbcInsertMI_byIncome: TdxBarButton;
    actPartionGoods20202ChoiceForm: TOpenChoiceForm;
    actPartionGoods20202ChoiceFormGrid: TOpenChoiceForm;
    InsertRecord20202: TInsertRecord;
    macInsertRecord20202: TMultiAction;
    bbInsertRecord20202: TdxBarButton;
    cxLabel6: TcxLabel;
    edAsset: TcxButtonEdit;
    GuidesAsset: TdsdGuides;
    cxLabel12: TcxLabel;
    edInvNumberProduction: TcxButtonEdit;
    GuidesProductionDoc: TdsdGuides;
    actOpenProductionForm: TdsdOpenForm;
    bbOpenProductionForm: TdxBarButton;
    actPartionGoodsAssetChoiceForm: TOpenChoiceForm;
    actInsertRecordAsset: TInsertRecord;
    macInsertRecordAsset: TMultiAction;
    bbInsertRecordAsset: TdxBarButton;
    bbPartionGoodsAssetChoiceForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLossForm);

end.
