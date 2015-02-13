unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BankAccountJournal, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxImageComboBox, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC;

type
  TBankAccountJournalForm1 = class(TBankAccountJournalForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BankAccountJournalForm1: TBankAccountJournalForm1;

implementation

{$R *.dfm}

end.
