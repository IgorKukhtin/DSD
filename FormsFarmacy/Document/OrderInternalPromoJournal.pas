unit OrderInternalPromoJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCalc, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TOrderInternalPromoJournalForm = class(TAncestorJournalForm)
    spGet_Movement_OrderInternalPromo: TdsdStoredProc;
    RetailName: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    StartSale: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actOpenReportMinPriceForm: TdsdOpenForm;
    bbReportMinPriceForm: TdxBarButton;
    actOpenReportMinPrice_All: TdsdOpenForm;
    bbOpenReportMinPrice_All: TdxBarButton;
    TotalAmount: TcxGridDBColumn;
    Distributed: TcxGridDBColumn;
    DistributedSumma: TcxGridDBColumn;
    DaysGrace: TcxGridDBColumn;
    DatePayment: TcxGridDBColumn;
    DateInsert: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalPromoJournalForm);

end.
