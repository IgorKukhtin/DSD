unit PromoJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxImageComboBox,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC;

type
  TPromoJournalForm = class(TAncestorJournalForm)
    colPromoKindName: TcxGridDBColumn;
    colPriceListName: TcxGridDBColumn;
    colStartPromo: TcxGridDBColumn;
    colEndPromo: TcxGridDBColumn;
    colStartSale: TcxGridDBColumn;
    colEndSale: TcxGridDBColumn;
    colCostPromo: TcxGridDBColumn;
    colAdvertisingName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colPersonalTradeName: TcxGridDBColumn;
    colPersonalName: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    PrintHead: TClientDataSet;
    actPrint: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoJournalForm);

end.
