unit PriceListMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxCurrencyEdit, cxCalendar,
  dsdAddOn, dsdAction, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, ExternalLoad;

type
  TPriceListMovementForm = class(TAncestorDocumentForm)
    edPartner: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesPartner: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsChoice: TOpenChoiceForm;
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
    CatalogPage: TcxGridDBColumn;
    MeasureMult: TcxGridDBColumn;
    actOpenPriceListLoad: TdsdInsertUpdateAction;
    bbOpenPriceListLoad: TdxBarButton;
    spUpdate_Price: TdsdStoredProc;
    macUpdatePrice: TMultiAction;
    actUpdatePrice: TdsdExecStoredProc;
    bbUpdatePrice: TdxBarButton;
    isOutlet: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    spGetImportSettingId_SkiDoo: TdsdStoredProc;
    spGetImportSettingId_Osculati: TdsdStoredProc;
    actDoLoad_SkiDoo: TExecuteImportSettingsAction;
    actDoLoad_Osculati: TExecuteImportSettingsAction;
    actGetImportSetting_Osculati: TdsdExecStoredProc;
    actGetImportSetting_SkiDoo: TdsdExecStoredProc;
    mactStartLoad_Osculati: TMultiAction;
    mactStartLoad_SkiDoo: TMultiAction;
    bbStartLoad_SkiDoo: TdxBarButton;
    bbStartLoad_Osculati: TdxBarButton;
    cxLabel3: TcxLabel;
    edLanguage: TcxButtonEdit;
    GuidesLanguage: TdsdGuides;
    GoodsName_translate: TcxGridDBColumn;
    actDiscountPartnerChoice: TOpenChoiceForm;
    actMeasureChoice: TOpenChoiceForm;
    actMeasureParentChoice: TOpenChoiceForm;
    spGetImportSettingId_Gotthardt: TdsdStoredProc;
    mactStartLoad_Gotthardt: TMultiAction;
    actDoLoad_Gotthardt: TExecuteImportSettingsAction;
    actGetImportSetting_Gotthardt: TdsdExecStoredProc;
    bbStartLoad_Gotthardt: TdxBarButton;
    Article: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    spGetImportSettingId_Uflex1: TdsdStoredProc;
    spGetImportSettingId_Uflex2: TdsdStoredProc;
    actGetImportSettingId_Uflex1: TdsdExecStoredProc;
    actGetImportSettingId_Uflex2: TdsdExecStoredProc;
    actDoLoad_Uflex1: TExecuteImportSettingsAction;
    actDoLoad_Uflex2: TExecuteImportSettingsAction;
    mactStartLoad_Uflex1: TMultiAction;
    mactStartLoad_Uflex2: TMultiAction;
    bbStartLoad_Uflex1: TdxBarButton;
    bbStartLoad_Uflex2: TdxBarButton;
    spGetImportSettingId_GoodsArticle: TdsdStoredProc;
    actDoLoad_Uflex3: TExecuteImportSettingsAction;
    mactStartLoad_Uflex3: TMultiAction;
    actGetImportSettingId_Uflex3: TdsdExecStoredProc;
    bbStartLoad_Uflex3: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListMovementForm);

end.
