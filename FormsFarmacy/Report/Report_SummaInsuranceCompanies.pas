unit Report_SummaInsuranceCompanies;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxGridBandedTableView, cxGridDBBandedTableView, Vcl.Grids, Vcl.DBGrids,
  cxSplitter, cxTimeEdit, ChoicePeriod, AncestorBase;

type
  TReport_SummaInsuranceCompaniesForm = class(TAncestorBaseForm)
    FormParams: TdsdFormParams;
    spSelect: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edDateStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    bbPrint: TdxBarButton;
    bbStatic: TdxBarStatic;
    bbGridToExel: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    deEnd: TcxDateEdit;
    cxLabel7: TcxLabel;
    bbExecuteDialog: TdxBarButton;
    bbShowAll: TdxBarButton;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    cxLabel6: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel1: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesJuridicalOur: TdsdGuides;
    PeriodChoice: TPeriodChoice;
    GridToExcel: TdsdGridToExcel;
    ExecuteDialog: TExecuteDialog;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SummaInsuranceCompaniesForm);

end.
