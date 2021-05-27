unit PromoJournal;

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
  TPromoJournalForm = class(TAncestorJournalForm)
    spGet_Movement_Promo: TdsdStoredProc;
    MakerName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    StartPromo: TcxGridDBColumn;
    EndPromo: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actOpenReportMinPriceForm: TdsdOpenForm;
    bbReportMinPriceForm: TdxBarButton;
    actOpenReportMinPrice_All: TdsdOpenForm;
    bbOpenReportMinPrice_All: TdxBarButton;
    Prescribe: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    isSupplement: TcxGridDBColumn;
    macUpdate_Supplement: TMultiAction;
    actUpdate_Supplement: TdsdExecStoredProc;
    spUpdate_Supplement: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
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
