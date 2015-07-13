unit VIPDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase;

type
  TVIPDialogForm = class(TAncestorDialogForm)
    ceMember: TcxButtonEdit;
    MemberGuides: TdsdGuides;
    Label1: TLabel;
    edBayerName: TcxTextEdit;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function VIPDialogExecute(var AManagerID: Integer; var BayerName: String): boolean;

implementation

{$R *.dfm}

function VIPDialogExecute(var AManagerID: Integer; var BayerName: String): boolean;
Begin
With TVIPDialogForm.Create(nil) do
  Begin
    try
      Result := ShowModal = mrOK;
      if Result then
      Begin
        AManagerID := FormParams.ParamByName('MemberId').Value;
        BayerName := edBayerName.Text;
      End;
    finally
      free;
    end;
  End;
End;

end.
