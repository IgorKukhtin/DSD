unit CashRegisterEdit;

interface

uses
  Winapi.Windows, DataModul, AncestorEditDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxPCdxBarPopupMenu, cxContainer,
  cxEdit, cxCheckBox, cxCurrencyEdit, cxLabel, cxTextEdit, cxPC, Vcl.Controls,
  dsdDB, dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, dsdAddOn,
  Vcl.StdCtrls, cxButtons, cxMemo, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar;

type
  TCashRegisterEditForm = class(TAncestorEditDialogForm)
    edMeasureName: TcxTextEdit;
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    CashRegisterKindGuides: TdsdGuides;
    edTimePUSHFinal2: TcxDateEdit;
    cxLabel21: TcxLabel;
    edTimePUSHFinal1: TcxDateEdit;
    cxLabel20: TcxLabel;
    edSerialNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    cbGetHardwareData: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TCashRegisterEditForm);
end.
