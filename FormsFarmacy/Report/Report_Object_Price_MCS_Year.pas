unit Report_Object_Price_MCS_Year;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox, cxImageComboBox;

type
  TReport_Object_Price_MCS_YearForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    N2: TMenuItem;
    N3: TMenuItem;
    FormParams: TdsdFormParams;
    spUpdate_MCS_ReportDay: TdsdStoredProc;
    actUpdate_MCS_ReportDay: TdsdExecStoredProc;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbOpenReportForm: TdxBarButton;
    MCSValueProc: TcxGridDBColumn;
    MCSValueNew: TcxGridDBColumn;
    mactCopyMCSValueYear: TMultiAction;
    actCopyMCSValueYear: TdsdSetDefaultParams;
    dxBarButton1: TdxBarButton;
    mactUpdate_MCS_ReportDay: TMultiAction;
    dxBarButton2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Object_Price_MCS_YearForm: TReport_Object_Price_MCS_YearForm;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_Object_Price_MCS_YearForm);
end.
