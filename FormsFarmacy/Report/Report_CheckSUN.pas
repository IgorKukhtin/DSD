unit Report_CheckSUN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdGuides,
  cxButtonEdit, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView, cxGrid, cxPC,
  cxPCdxBarPopupMenu, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox, cxImageComboBox,
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
  dxSkinXmas2008Blue;

type
  TReport_CheckSUNForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actOpenDocument: TdsdOpenForm;
    N2: TMenuItem;
    N3: TMenuItem;
    FormParams: TdsdFormParams;
    spGet_MovementFormClass: TdsdStoredProc;
    actGet_MovementFormClass: TdsdExecStoredProc;
    mactOpenDocument: TMultiAction;
    rgUnit: TRefreshDispatcher;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshIsPartion: TdsdDataSetRefresh;
    actOpenReportForm: TdsdOpenForm;
    cbMovement: TcxCheckBox;
    actRefreshMov: TdsdDataSetRefresh;
    cxLabel19: TcxLabel;
    ceRetail: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    GuidesRetail: TdsdGuides;
    actRefreshList: TdsdDataSetRefresh;
    cbList: TcxCheckBox;
    UnitName: TcxGridDBColumn;
    actOpenReportPartionDateForm: TdsdOpenForm;
    actOpenReportPartionHistoryForm: TdsdOpenForm;
    bbOpenReportPartionDateForm: TdxBarButton;
    bbOpenReportPartionHistoryForm: TdxBarButton;
    MultiAction1: TMultiAction;
    bbOpenDocument: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_CheckSUNForm: TReport_CheckSUNForm;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_CheckSUNForm);
end.
