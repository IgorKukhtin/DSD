unit UnnamedEnterprises;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
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
  dsdExportToXLSAction;

type
  TUnnamedEnterprisesForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnit: TcxButtonEdit;
    lblJuridical: TcxLabel;
    edClientsByBank: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesClientsByBank: TdsdGuides;
    cxLabel4: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountRemains: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actPrintScore: TdsdPrintAction;
    bbPrintCheck: TdxBarButton;
    bbGet_SP_Prior: TdxBarButton;
    AmountOrder: TcxGridDBColumn;
    CodeUKTZED: TcxGridDBColumn;
    ExchangeName: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    GoodsNameUkr: TcxGridDBColumn;
    edAmountAccount: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edAmountPayment: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edAccountNumber: TcxTextEdit;
    cxLabel6: TcxLabel;
    edDatePayment: TcxDateEdit;
    cxLabel8: TcxLabel;
    spSelectPrintScore: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    SummOrder: TcxGridDBColumn;
    actAddOrderInternal: TMultiAction;
    actExecspAddOrderInternal: TdsdExecStoredProc;
    spAddOrderInternal: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    actCreateSale: TMultiAction;
    spCreateSale: TdsdStoredProc;
    actExecspCreateSale: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    actExchangeChoice: TOpenChoiceForm;
    actPrintXLS: TdsdExportToXLS;
    actPrintCommercialOffer: TMultiAction;
    actExecSelectPrintScore: TdsdExecStoredProc;
    actExecSelectPrint: TdsdExecStoredProc;
    actPrintXLSScope: TMultiAction;
    actPrintScopeXLS: TdsdExportToXLS;
    PriceUnit: TcxGridDBColumn;
    actChoiceNDSKind: TOpenChoiceForm;
    isResolution_224: TcxGridDBColumn;
    spInsertUpdate_AllGoods: TdsdStoredProc;
    actInsertUpdate_AllGoods: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUnnamedEnterprisesForm);

end.
