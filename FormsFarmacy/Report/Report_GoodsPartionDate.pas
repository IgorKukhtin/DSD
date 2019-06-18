unit Report_GoodsPartionDate;

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
  TReport_GoodsPartionDateForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountRemains: TcxGridDBColumn;
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
    cbDetail: TcxCheckBox;
    ContractName_Income: TcxGridDBColumn;
    DescName_Income: TcxGridDBColumn;
    StatusCode_SendPartionDate: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_GoodsPartionDateForm: TReport_GoodsPartionDateForm;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_GoodsPartionDateForm);
end.
