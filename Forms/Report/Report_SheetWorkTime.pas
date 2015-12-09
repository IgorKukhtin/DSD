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
  cxGridBandedTableView, cxGridDBBandedTableView, dsdGuides, cxButtonEdit;

type
  TReport_SheetWorkTimeForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    HeaderCDS: TClientDataSet;
    GuidesUnit: TdsdGuides;
    RefreshDispatcher1: TRefreshDispatcher;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    colUnitName: TcxGridDBBandedColumn;
    colMemberCode: TcxGridDBBandedColumn;
    colMemberName: TcxGridDBBandedColumn;
    colPositionName: TcxGridDBBandedColumn;
    colPositionLevelName: TcxGridDBBandedColumn;
    colPersonalGroupName: TcxGridDBBandedColumn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    TemplateColumn: TcxGridDBBandedColumn;
    actReport_SheetWorkTimeDialog: TExecuteDialog;
    dxBarButton1: TdxBarButton;
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
