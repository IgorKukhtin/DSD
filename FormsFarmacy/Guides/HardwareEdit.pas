unit HardwareEdit;

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
  THardwareEditForm = class(TAncestorEditDialogForm)
    edComputerName: TcxTextEdit;
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    edBaseBoardProduct: TcxTextEdit;
    cxLabel2: TcxLabel;
    edProcessorName: TcxTextEdit;
    cxLabel3: TcxLabel;
    edDiskDriveModel: TcxTextEdit;
    cxLabel4: TcxLabel;
    edPhysicalMemory: TcxTextEdit;
    cxLabel5: TcxLabel;
    ceCashRegister: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesCashRegister: TdsdGuides;
    edComment: TcxTextEdit;
    cxLabel8: TcxLabel;
    edIdentifier: TcxTextEdit;
    cxLabel9: TcxLabel;
    cxPropertiesStore1: TcxPropertiesStore;
    cbLicense: TcxCheckBox;
    cbSmartphone: TcxCheckBox;
    cbModem: TcxCheckBox;
    cbBarcodeScanner: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(THardwareEditForm);
end.
