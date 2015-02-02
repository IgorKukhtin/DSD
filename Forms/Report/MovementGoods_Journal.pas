unit MovementGoods_Journal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdGuides, cxButtonEdit;

type
  TMovementGoodsJournalForm = class(TAncestorJournalForm)
    colDescName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    actOpenDocument: TMultiAction;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    bbOpenDocument: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    cxLabel4: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
    GoodsPartionGuides: TdsdGuides;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edPartionGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    edLocation: TcxButtonEdit;
    LocationGuides: TdsdGuides;
    cxLabel6: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TMovementGoodsJournalForm)

end.
