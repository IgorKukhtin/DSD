unit IlliquidUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad;

type
  TIlliquidUnitForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxSplitter1: TcxSplitter;
    spInsertUpdate_MI_IlliquidUnit_Set_Zero: TdsdStoredProc;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    GuidesUnit: TdsdGuides;
    edUnitName: TcxButtonEdit;
    cxLabel6: TcxLabel;
    ceNotSalePastDay: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceProcGoods: TcxCurrencyEdit;
    ceProcUnit: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cePenalty: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    actFormationUnit: TdsdExecStoredProc;
    spFormationUnit: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    AmountSale: TcxGridDBColumn;
    SummSale: TcxGridDBColumn;
    ProcSale: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIlliquidUnitForm);

end.
