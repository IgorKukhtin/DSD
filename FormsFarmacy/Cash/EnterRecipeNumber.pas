
unit EnterRecipeNumber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, Helsi;

type
  TEnterRecipeNumberForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    edMaskNumber: TcxMaskEdit;
    Label1: TLabel;
    pn1: TPanel;
    pn2: TPanel;
    procedure edMaskNumberPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure edMaskNumberKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function InputEnterRecipeNumber(var ANumber : string) : boolean;

implementation

{$R *.dfm}

procedure TEnterRecipeNumberForm.edMaskNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, ['a'..'z','A'..'Z','0'..'9',#8,#3,#22,'-']) then
  begin
    ShowMessage(IntToStr(Ord(Key)));
    ShowMessage('Ошибка.<Регистрационный номер рецепта>'#13#10#13#10 +
      'Номер должен содержать только цыфры и буквы латинского алфовита');
    Key := #0;
  end;
end;

procedure TEnterRecipeNumberForm.edMaskNumberPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  Error := not CheckRequest_Number(DisplayValue);
end;

function InputEnterRecipeNumber(var ANumber : string) : boolean;
  var EnterRecipeNumberForm : TEnterRecipeNumberForm;
begin
  LoadKeyboardLayout('00000409', KLF_ACTIVATE);
  EnterRecipeNumberForm := TEnterRecipeNumberForm.Create(Screen.ActiveControl);
  try
    Result := EnterRecipeNumberForm.ShowModal = mrOk;
    ANumber := EnterRecipeNumberForm.edMaskNumber.Text;
  finally
    EnterRecipeNumberForm.Free;
    LoadKeyboardLayout('00000419', KLF_ACTIVATE);
  end;
end;

end.
