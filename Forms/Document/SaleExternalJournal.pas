 unit SaleExternalJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
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
  ExternalLoad;

type
  TSaleExternalJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbPrint: TdxBarButton;
    actPrint: TdsdPrintAction;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actPrintGroup: TdsdPrintAction;
    actPrintSaleOrder: TdsdPrintAction;
    actPrintSaleOrderTax: TdsdPrintAction;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    GoodsPropertyName: TcxGridDBColumn;
    PartnerName_from: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    spGet_Exception: TdsdStoredProc;
    actGet_Exception: TdsdExecStoredProc;
    spGetImportSettingId_Novus: TdsdStoredProc;
    spGetImportSettingId_Fora: TdsdStoredProc;
    spGetImportSettingId_Metro: TdsdStoredProc;
    actGetImportSettingNovus: TdsdExecStoredProc;
    actStartLoadNovus: TMultiAction;
    actGetImportSettingFora: TdsdExecStoredProc;
    actStartLoadFora: TMultiAction;
    actGetImportSettingMetro: TdsdExecStoredProc;
    actStartLoadMetro: TMultiAction;
    bbStartLoadNovus: TdxBarButton;
    bbStartLoadMetro: TdxBarButton;
    bbStartLoadFora: TdxBarButton;
    spGetImportSettingId_Silpo: TdsdStoredProc;
    actGetImportSettingSilpo: TdsdExecStoredProc;
    actStartLoadSilpo: TMultiAction;
    bbStartLoadSilpo: TdxBarButton;
    spDelete_Movement: TdsdStoredProc;
    actDelete_Movement: TdsdExecStoredProc;
    actGetImportSettingVarus: TdsdExecStoredProc;
    actStartLoadVarus: TMultiAction;
    spGetImportSettingId_Varus: TdsdStoredProc;
    bb: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSaleExternalJournalForm);
end.
