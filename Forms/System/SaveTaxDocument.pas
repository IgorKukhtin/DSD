unit SaveTaxDocument;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, ExternalSave, Data.DB,
  Datasnap.DBClient;

type
  TSaveTaxDocumentForm = class(TAncestorDialogForm)
    cxDateEdit1: TcxDateEdit;
    cxDateEdit2: TcxDateEdit;
    MultiAction: TMultiAction;
    spTaxBillList: TdsdStoredProc;
    TaxBillList: TClientDataSet;
    ExternalSaveAction: TExternalSaveAction;
    actClose: TdsdFormClose;
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
