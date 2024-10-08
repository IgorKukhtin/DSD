unit HardwareDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, Helsi, cxCheckBox;

type
  THardwareDialogForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    edMaskIdentifier: TcxMaskEdit;
    Label1: TLabel;
    pn1: TPanel;
    pn2: TPanel;
    cbLicense: TcxCheckBox;
    cbSmartphone: TcxCheckBox;
    cbModem: TcxCheckBox;
    cbBarcodeScanner: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function InputHardwareDialog(var AIdentifier : string; var ALicense, ASmartphone, AModem, ABarcodeScanner : boolean) : boolean;

implementation

{$R *.dfm}

function InputHardwareDialog(var AIdentifier : string; var ALicense, ASmartphone, AModem, ABarcodeScanner : boolean) : boolean;
  var HardwareDialogForm : THardwareDialogForm;
begin
  LoadKeyboardLayout('00000409', KLF_ACTIVATE);
  HardwareDialogForm := THardwareDialogForm.Create(Screen.ActiveControl);
  try
    HardwareDialogForm.edMaskIdentifier.Text := AIdentifier;
    HardwareDialogForm.cbLicense.Checked := ALicense;
    HardwareDialogForm.cbSmartphone.Checked := ASmartphone;
    HardwareDialogForm.cbModem.Checked := AModem;
    HardwareDialogForm.cbBarcodeScanner.Checked := ABarcodeScanner;
    Result := HardwareDialogForm.ShowModal = mrOk;
    AIdentifier := HardwareDialogForm.edMaskIdentifier.Text;
    ALicense := HardwareDialogForm.cbLicense.Checked;
    ASmartphone := HardwareDialogForm.cbSmartphone.Checked;
    AModem := HardwareDialogForm.cbModem.Checked;
    ABarcodeScanner := HardwareDialogForm.cbBarcodeScanner.Checked;
  finally
    HardwareDialogForm.Free;
    LoadKeyboardLayout('00000419', KLF_ACTIVATE);
  end;
end;

end.
