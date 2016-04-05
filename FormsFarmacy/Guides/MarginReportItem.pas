unit MarginReportItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, cxLabel, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit;

type
  TMarginReportItemForm = class(TAncestorEnumForm)
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdUpdateDataSet;
    colPercent1: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    UnitChoiceForm: TOpenChoiceForm;
    ceMarginReport: TcxButtonEdit;
    MarginReportGuides: TdsdGuides;
    textMarginReport: TdxBarControlContainerItem;
    cxLabel1: TcxLabel;
    bbMarginReport: TdxBarControlContainerItem;
    colMarginReportName: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMarginReportItemForm)


end.
