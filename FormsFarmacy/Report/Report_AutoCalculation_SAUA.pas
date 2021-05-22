unit Report_AutoCalculation_SAUA;

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
  dxSkinXmas2008Blue, cxDBEdit, cxMemo, cxGridBandedTableView,
  cxGridDBBandedTableView;

type
  TReport_AutoCalculation_SAUAForm = class(TAncestorReportForm)
    bbGoodsPartyReport: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actOpenSalesOfTermDrugsUnit: TdsdInsertUpdateAction;
    dxBarButton1: TdxBarButton;
    cxLabel3: TcxLabel;
    edRecipient: TcxTextEdit;
    cxLabel6: TcxLabel;
    edAssortment: TcxMemo;
    ceDaysStock: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel7: TcxLabel;
    ceThreshold: TcxCurrencyEdit;
    ceCountPharmacies: TcxCurrencyEdit;
    cbAssortmentRound: TcxCheckBox;
    cbNeedRound: TcxCheckBox;
    cbNotCheckNoMCS: TcxCheckBox;
    cbMCSIsClose: TcxCheckBox;
    cbGoodsClose: TcxCheckBox;
    FormParams: TdsdFormParams;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    GoodsCode: TcxGridDBBandedColumn;
    GoodsName: TcxGridDBBandedColumn;
    Remains: TcxGridDBBandedColumn;
    Need: TcxGridDBBandedColumn;
    AmountCheck: TcxGridDBBandedColumn;
    CountUnit: TcxGridDBBandedColumn;
    Assortment: TcxGridDBBandedColumn;
    spUpdateAutoUnit: TdsdStoredProc;
    actChoiceUnit: TOpenChoiceForm;
    actChangeAutoUnit: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    actUnitAutoSUAForm: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_AutoCalculation_SAUAForm);

end.
