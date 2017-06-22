unit Report_UploadBaDM;

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
  TReport_UploadBaDMForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    OperDate: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    lUnitName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    OperCode: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Segment1: TcxGridDBColumn;
    Segment2: TcxGridDBColumn;
    Segment3: TcxGridDBColumn;
    Segment4: TcxGridDBColumn;
    Segment5: TcxGridDBColumn;
    GridToCSV: TdsdGridToExcel;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_UploadBaDMForm);
end.
