unit SaveDocumentTo1C;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, ExternalSave, Data.DB,
  Datasnap.DBClient, cxLabel, ChoicePeriod, dsdGuides, cxButtonEdit;

type
  TSaveDocumentTo1CForm = class(TAncestorDialogForm)
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    MultiAction: TMultiAction;
    spBillList: TdsdStoredProc;
    BillList: TClientDataSet;
    ExternalSaveAction: TExternalSaveAction;
    actClose: TdsdFormClose;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PeriodChoice: TPeriodChoice;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TSaveDocumentTo1CForm);

end.
