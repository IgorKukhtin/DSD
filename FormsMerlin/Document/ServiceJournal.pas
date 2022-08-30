unit ServiceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns,
  cxButtonEdit, dsdGuides, ExternalLoad, dxSkinBlack, dxSkinBlue,
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
  TServiceJournalForm = class(TAncestorJournalForm)
    InfoMoneyName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrintDetail: TdsdPrintAction;
    bbPrintDetail: TdxBarButton;
    bbisCopy: TdxBarButton;
    UnitCode: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actUpdateDataSet: TdsdUpdateDataSet;
    actRefreshStart: TdsdDataSetRefresh;
    bbUpdateMoneyPlace: TdxBarButton;
    isAuto: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    bbmacStartLoad: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    UnitGroupNameFull: TcxGridDBColumn;
    actOpenServiceItem_history: TdsdOpenForm;
    actOpenServiceItemAdd_history: TdsdOpenForm;
    bbOpenServiceItem_history: TdxBarButton;
    bbOpenServiceItemAdd_history: TdxBarButton;
    spInsert_byServiceItem: TdsdStoredProc;
    actInsert_byServiceItem: TdsdExecStoredProc;
    macInsert_byServiceItem: TMultiAction;
    spInsert_byServiceItemAdd: TdsdStoredProc;
    actInsert_byServiceItemAdd: TdsdExecStoredProc;
    macInsert_byServiceItemAdd: TMultiAction;
    bbInsert_byServiceItem: TdxBarButton;
    bbInsert_byServiceItemAdd: TdxBarButton;
    lbSearchName: TcxLabel;
    edSearchUnitName: TcxTextEdit;
    FieldFilter_UnitName: TdsdFieldFilter;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesInfoMoney: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TServiceJournalForm);

end.
