unit Report_InventoryErrorRemains;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxImageComboBox, cxSplitter;

type
  TReport_InventoryErrorRemainsForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    actOpenPartionReport: TdsdOpenForm;
    bbGoodsPartyReport: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshJuridical: TdsdDataSetRefresh;
    actRefreshList: TdsdDataSetRefresh;
    ListCDS: TClientDataSet;
    ListDS: TDataSource;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    FullInvent: TcxGridDBColumn;
    DeficitSumm: TcxGridDBColumn;
    ProficitSumm: TcxGridDBColumn;
    Diff: TcxGridDBColumn;
    DiffSumm: TcxGridDBColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colRemains: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colIsErased: TcxGridDBColumn;
    colRemainsSave: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    colPrice: TcxGridDBColumn;
    cplRemainsDiff: TcxGridDBColumn;
    colRemainsDiff_Summa: TcxGridDBColumn;
    actOpenDocForm: TdsdOpenForm;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_InventoryErrorRemainsForm);

end.
