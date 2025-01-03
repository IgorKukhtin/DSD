unit PretensionJournalIncome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCurrencyEdit, dsdAction, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, ExternalSave,
  dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns;

type
  TPretensionJournalIncomeForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalDeficit: TcxGridDBColumn;
    bbTax: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    TotalProficit: TcxGridDBColumn;
    bbSendData: TdxBarButton;
    NDSKindName: TcxGridDBColumn;
    mactInsert: TMultiAction;
    spInsertMovement: TdsdStoredProc;
    JuridicalName: TcxGridDBColumn;
    IncomeOperDate: TcxGridDBColumn;
    IncomeInvNumber: TcxGridDBColumn;
    spUpdatePretension_BranchDate: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    BranchUser: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    isDeferred: TcxGridDBColumn;
    bbPrintOptima: TdxBarButton;
    CheckedName: TcxGridDBColumn;
    GoodsReceiptsDate: TcxGridDBColumn;
    SentDate: TcxGridDBColumn;
    TotalSubstandard: TcxGridDBColumn;
    TotalSummActual: TcxGridDBColumn;
    TotalSummNotActual: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPretensionJournalIncomeForm);
end.
