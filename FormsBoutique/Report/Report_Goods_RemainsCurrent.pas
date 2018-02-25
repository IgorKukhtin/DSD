unit Report_Goods_RemainsCurrent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_Goods_RemainsCurrentForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    dxBarButton1: TdxBarButton;
    actRefreshStart: TdsdDataSetRefresh;
    UnitName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshIsSize: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    cbPartion: TcxCheckBox;
    cbSize: TcxCheckBox;
    cbPartner: TcxCheckBox;
    actRefreshIsPartner: TdsdDataSetRefresh;
    CountForPrice: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    cxLabel6: TcxLabel;
    edPeriod: TcxButtonEdit;
    GuidesPeriod: TdsdGuides;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel4: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    cxLabel9: TcxLabel;
    edGoodsPrint: TcxButtonEdit;
    GuidesGoodsPrint: TdsdGuides;
    spInsertUpdate_GoodsPrint: TdsdStoredProc;
    mactGoodsPrintList_Rem: TMultiAction;
    FormParams: TdsdFormParams;
    Amount_GoodsPrint: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    bbGoodsPrintList: TdxBarButton;
    spUpdate_FloatValue_DS: TdsdStoredProc;
    actUpdate_FloatValue_DS: TdsdExecStoredProc;
    spDelete_Object_GoodsPrint: TdsdStoredProc;
    actDeleteGoodsPrint: TdsdExecStoredProc;
    bbDeleteGoodsPrint: TdxBarButton;
    spGet_User_curr: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrintSticker: TdsdStoredProc;
    mactGoodsPrintList_Print: TMultiAction;
    bb: TdxBarButton;
    cbYear: TcxCheckBox;
    UnitName_in: TcxGridDBColumn;
    Amount_in: TcxGridDBColumn;
    RemainsDebt: TcxGridDBColumn;
    SummDebt: TcxGridDBColumn;
    SummDebt_profit: TcxGridDBColumn;
    actRefreshIsPeriodYear: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    edStartYear: TcxButtonEdit;
    edEndYear: TcxButtonEdit;
    GuidesStartYear: TdsdGuides;
    GuidesEndYear: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Goods_RemainsCurrentForm: TReport_Goods_RemainsCurrentForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Goods_RemainsCurrentForm)
end.
