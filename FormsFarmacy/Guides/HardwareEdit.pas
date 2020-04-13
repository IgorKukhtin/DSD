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
    edName: TcxTextEdit;
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
