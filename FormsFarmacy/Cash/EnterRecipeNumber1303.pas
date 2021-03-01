unit EnterRecipeNumber1303;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, LikiDniproReceipt;

type
  TEnterRecipeNumber1303Form = class(TForm)
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

function InputEnterRecipeNumber1303(var ANumber : string) : boolean;

implementation

{$R *.dfm}

procedure TEnterRecipeNumber1303Form.edMaskNumberKeyPress(Sender: TObject;
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

procedure TEnterRecipeNumber1303Form.edMaskNumberPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  Error := not CheckLikiDniproReceipt_Number(StringReplace(DisplayValue, '_', '', [rfReplaceAll]));
end;

function InputEnterRecipeNumber1303(var ANumber : string) : boolean;
  var EnterRecipeNumber1303Form : TEnterRecipeNumber1303Form;
begin
  LoadKeyboardLayout('00000409', KLF_ACTIVATE);
  EnterRecipeNumber1303Form := TEnterRecipeNumber1303Form.Create(Screen.ActiveControl);
  try
    if ANumber <> '' then EnterRecipeNumber1303Form.edMaskNumber.Text := ANumber;

    Result := EnterRecipeNumber1303Form.ShowModal = mrOk;
    ANumber := Trim(StringReplace(EnterRecipeNumber1303Form.edMaskNumber.Text, '_', '', [rfReplaceAll]));
  finally
    EnterRecipeNumber1303Form.Free;
    LoadKeyboardLayout('00000419', KLF_ACTIVATE);
  end;
end;

end.
