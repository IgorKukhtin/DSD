unit OrderExternal;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dsdInternetAction, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack,
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
  TOrderExternalForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    Summ: TcxGridDBColumn;
    PartnerGoodsCode: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    actGetDocumentDataForEmail: TdsdExecStoredProc;
    spGetDocumentDataForEmail: TdsdStoredProc;
    mactSMTPSend: TMultiAction;
    bbSendEMail: TdxBarButton;
    cxGridExportDBTableView: TcxGridDBTableView;
    cxGridExportLevel1: TcxGridLevel;
    cxGridExport: TcxGrid;
    spSelectExport: TdsdStoredProc;
    ExportDS: TDataSource;
    actExportStoredproc: TdsdExecStoredProc;
    spGetExportParam: TdsdStoredProc;
    actExportToPartner: TExportGrid;
    Comment: TcxGridDBColumn;
    edComment: TcxTextEdit;
    cxLabel7: TcxLabel;
    cxLabel6: TcxLabel;
    edOrderInternal: TcxButtonEdit;
    OrderInternalGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edOrderKind: TcxButtonEdit;
    GuidesOrderKind: TdsdGuides;
    spUpdateMovementUserSend: TdsdStoredProc;
    actUpdateUserSend: TdsdExecStoredProc;
    edisDeferred: TcxCheckBox;
    cxLabel9: TcxLabel;
    edZakaz_Text: TcxTextEdit;
    cxLabel10: TcxLabel;
    edDostavka_Text: TcxTextEdit;
    cxLabel11: TcxLabel;
    edOrderSumm: TcxTextEdit;
    cxLabel12: TcxLabel;
    edOrderTime: TcxTextEdit;
    PartionGoodsDateColor: TcxGridDBColumn;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    cxLabel13: TcxLabel;
    edOrderSummComment: TcxTextEdit;
    actPUSH: TdsdShowPUSHMessage;
    spPUSHInfo: TdsdStoredProc;
    actPUSHInfo: TdsdShowPUSHMessage;
    spPUSHError: TdsdStoredProc;
    cbDifferent: TcxCheckBox;
    NDS_PriceList: TcxGridDBColumn;
    edLetterSubject: TcxTextEdit;
    cxLabel14: TcxLabel;
    OrderShedule_Color: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    edPhone: TcxTextEdit;
    edAddress: TcxTextEdit;
    edTimeWork: TcxTextEdit;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    edPharmacyManager: TcxTextEdit;
    cxLabel19: TcxLabel;
    cbUseSubject: TcxCheckBox;
    MinimumLot: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderExternalForm);

end.
