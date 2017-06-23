unit BankAccountJournalFarmacy;

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
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, Vcl.DBActns,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCheckBox, dsdGuides, cxButtonEdit;

type
  TBankAccountJournalFarmacyForm = class(TBankAccountJournalForm)
    Income_JuridicalName: TcxGridDBColumn;
    Income_OperDate: TcxGridDBColumn;
    Income_InvNumber: TcxGridDBColumn;
    Income_NDSKindName: TcxGridDBColumn;
    Income_SummWithOutVAT: TcxGridDBColumn;
    Income_SummVAT: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    ceBankAccount: TcxButtonEdit;
    BankAccountGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ObjectGuides: TdsdGuides;
    sbIsPartnerDate: TcxCheckBox;
    ceObject: TcxButtonEdit;
    cxLabel3: TcxLabel;
    ceJuridicalCorporate: TcxButtonEdit;
    JuridicalCorporateGuides: TdsdGuides;
    actIsPartnerDate: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass (TBankAccountJournalFarmacyForm)

end.
