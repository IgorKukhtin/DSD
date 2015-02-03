unit LossDebt;

interface

uses
  AncestorDocument, Winapi.Windows, Winapi.Messages, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, dsdGuides, dsdDB,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction,
  System.Classes, Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, Vcl.Controls, cxCurrencyEdit;

type
  TLossDebtForm = class(TAncestorDocumentForm)
    edJuridicalBasis: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesJuridicalBasis: TdsdGuides;
    cxLabel4: TcxLabel;
    cxLabel6: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    bbInsert: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLossDebtForm);

end.
