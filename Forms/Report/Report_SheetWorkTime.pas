unit Report_SheetWorkTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxGridBandedTableView, cxGridDBBandedTableView, dsdGuides, cxButtonEdit,
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
  dxSkinXmas2008Blue, cxCurrencyEdit, cxSplitter;

type
  TReport_SheetWorkTimeForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    HeaderCDS: TClientDataSet;
    GuidesUnit: TdsdGuides;
    RefreshDispatcher1: TRefreshDispatcher;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    UnitName: TcxGridDBBandedColumn;
    MemberCode: TcxGridDBBandedColumn;
    MemberName: TcxGridDBBandedColumn;
    PositionName: TcxGridDBBandedColumn;
    PositionLevelName: TcxGridDBBandedColumn;
    PersonalGroupName: TcxGridDBBandedColumn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    Value: TcxGridDBBandedColumn;
    actReport_SheetWorkTimeDialog: TExecuteDialog;
    dxBarButton1: TdxBarButton;
    edMember: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesMember: TdsdGuides;
    TotalCDS: TClientDataSet;
    TotalDS: TDataSource;
    CrossDBViewAddOnTotal: TCrossDBViewAddOn;
    cxGrid1: TcxGrid;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    Name_ch2: TcxGridDBBandedColumn;
    TotalAmount_ch2: TcxGridDBBandedColumn;
    Value_ch2: TcxGridDBBandedColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SheetWorkTimeForm);
end.
