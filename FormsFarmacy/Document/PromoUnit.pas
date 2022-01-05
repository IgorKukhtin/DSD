unit PromoUnit;

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
  TPromoUnitForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnitCategory: TcxButtonEdit;
    lblJuridical: TcxLabel;
    edPersonal: TcxButtonEdit;
    GuidesUnitCategory: TdsdGuides;
    GuidesPersonal: TdsdGuides;
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
    actDoLoad: TExecuteImportSettingsAction;
    actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc;
    actGetImportSettingId: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    spInsertUpdate_MI_PromoUnit_Set_Zero: TdsdStoredProc;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    Koeff: TcxGridDBColumn;
    mactUpdateKoeff: TMultiAction;
    actExecuteDialogKoeff: TExecuteDialog;
    bbUpdateKoeff: TdxBarButton;
    spUpdateKoeff: TdsdStoredProc;
    actUpdateKoeff: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoUnitForm);

end.
