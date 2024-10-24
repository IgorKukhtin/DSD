unit CashSettingsHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdDB, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGrid, cxPC,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCurrencyEdit, cxGridBandedTableView,
  cxGridDBBandedTableView;

type
  TCashSettingsHistoryForm = class(TAncestorEnumForm)
    FormParams: TdsdFormParams;
    StartDate: TcxGridDBBandedColumn;
    FixedPercent: TcxGridDBBandedColumn;
    spInsertUpdate_ObjectHistory_CashSettings: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    PenMobApp: TcxGridDBBandedColumn;
    PrizeThreshold: TcxGridDBBandedColumn;
    MarkPlanThreshol: TcxGridDBBandedColumn;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    FixedPercentB: TcxGridDBBandedColumn;
    FixedPercentC: TcxGridDBBandedColumn;
    FixedPercentD: TcxGridDBBandedColumn;
    PercPlanMobileApp: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CashSettingsHistoryForm: TCashSettingsHistoryForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashSettingsHistoryForm);
end.
