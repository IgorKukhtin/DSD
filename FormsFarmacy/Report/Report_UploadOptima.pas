unit Report_UploadOptima;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, dsdGuides, cxButtonEdit, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC;

type
  TReport_UploadOptimaForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    colRowData: TcxGridDBColumn;
    actExportGrid: TExportGrid;
    dxBarButton1: TdxBarButton;
    spGet_UploadFileName_Optima: TdsdStoredProc;
    actExport: TMultiAction;
    actGet_UploadFileName_Optima: TdsdExecStoredProc;
    grtvUnit: TcxGridDBTableView;
    grlUnit: TcxGridLevel;
    grUnit: TcxGrid;
    spSelect_Object_UnitForUpload: TdsdStoredProc;
    cdsUnit: TClientDataSet;
    dsUnit: TDataSource;
    actShowAll: TBooleanStoredProcAction;
    NeedUpload: TcxGridDBColumn;
    UnitId: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitCodePartner: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    actSelect_Object_UnitForUpload: TdsdExecStoredProc;
    DBViewAddOnUnit: TdsdDBViewAddOn;
    dxBarButton2: TdxBarButton;
    actSelect: TdsdExecStoredProc;
    actStartExport: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_UploadOptimaForm: TReport_UploadOptimaForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_UploadOptimaForm);
end.
