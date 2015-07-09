unit SendOnPrice;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TSendOnPriceForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colAmountChangePercent: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
    colChangePercentAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    cxLabel11: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    colMeasureName: TcxGridDBColumn;
    PrintItemsSverkaCDS: TClientDataSet;
    actPrintOut: TdsdPrintAction;
    bbPrintOut: TdxBarButton;
    spSelectPrintOut: TdsdStoredProc;
    clGoodsGroupNameFull: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    UnitChoiceForm: TOpenChoiceForm;
    actPrintUnit: TdsdPrintAction;
    bbPrintUnit: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel5: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    GuidesInvNumberOrder: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendOnPriceForm);

end.
