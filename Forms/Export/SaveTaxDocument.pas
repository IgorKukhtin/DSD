unit SaveTaxDocument;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, ExternalSave, Data.DB,
  Datasnap.DBClient, cxLabel, ChoicePeriod, dsdGuides, cxButtonEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TSaveTaxDocumentForm = class(TAncestorDialogForm)
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    MultiAction: TMultiAction;
    spTaxBillList: TdsdStoredProc;
    TaxBillList: TClientDataSet;
    ExternalSaveAction: TExternalSaveAction;
    actClose: TdsdFormClose;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PeriodChoice: TPeriodChoice;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    PaidKindGuides: TdsdGuides;
    edPaidKind: TcxButtonEdit;
    deStartReg: TcxDateEdit;
    deEndReg: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cbTaxCorrectiveOnly: TcxCheckBox;
    PeriodChoiceReg: TPeriodChoice;
    cbRegisterOnly: TcxCheckBox;
    cbNotRegisterOnly: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TSaveTaxDocumentForm);

end.
