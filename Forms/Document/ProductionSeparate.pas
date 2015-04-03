unit ProductionSeparate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocumentMC, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter;

type
  TProductionSeparateForm = class(TAncestorDocumentMCForm)
    cePartionGoods: TcxTextEdit;
    cxLabel10: TcxLabel;
    actUpdateChildDS: TdsdUpdateDataSet;
    colHeadCount: TcxGridDBColumn;
    colChildHeadCount: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colChildAmount: TcxGridDBColumn;
    colChildPartionGoods: TcxGridDBColumn;
    colGoodsGroupNameFull: TcxGridDBColumn;
    colCholdGoodsGroupNameFull: TcxGridDBColumn;
    colCholdMeasureName: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    actPrint_Obval: TdsdPrintAction;
    spSelectPrint: TdsdStoredProc;
    bbPrint_obval: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionSeparateForm);

end.
