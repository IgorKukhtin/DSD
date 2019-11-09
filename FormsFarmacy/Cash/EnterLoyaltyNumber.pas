unit EnterLoyaltyNumber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, System.RegularExpressions;

type
  TEnterLoyaltyNumberForm = class(TForm)
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

function InputEnterLoyaltyNumber(var ANumber : string) : boolean;

implementation

{$R *.dfm}

procedure TEnterLoyaltyNumberForm.edMaskNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, ['a'..'f','A'..'F','0'..'9',#8,#3,#22,'-']) then
  begin
    ShowMessage(IntToStr(Ord(Key)));
    ShowMessage('Ошибка.<Ввода промокода>'#13#10#13#10 +
      'Промокод должен содержать только цыфры и буквы латинского алфовита от A до F');
    Key := #0;
  end;
end;

procedure TEnterLoyaltyNumberForm.edMaskNumberPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);

  function CheckRequest_Number(ANumber : string) : boolean;
    var Res: TArray<string>; I, J : Integer;
  begin
    Result := False;
    try
      if Length(ANumber) <> 19 then exit;

      Res := TRegEx.Split(ANumber, '-');

      if High(Res) <> 3 then exit;

      for I := 0 to High(Res) do
      begin
        if Length(Res[I]) <> 4 then exit;

        for J := 1 to 4 do if not CharInSet(Res[I][J], ['0'..'9','A'..'F']) then exit;
      end;
      Result := True;
    finally
      if not Result then ShowMessage ('Ошибка.<Промокод>'#13#10#13#10 +
        'Просокод должен содержать 19 символов в 4 блока по 4 символа разделенных символом "-"'#13#10 +
        'Cодержать только цыфры и буквы латинского алфовита от A до F'#13#10 +
        'В виде XXXX-XXXX-XXXX-XXXX ...');
    end;
  end;

begin
  Error := not CheckRequest_Number(DisplayValue);
end;

function InputEnterLoyaltyNumber(var ANumber : string) : boolean;
  var EnterLoyaltyNumberForm : TEnterLoyaltyNumberForm;
begin
  LoadKeyboardLayout('00000409', KLF_ACTIVATE);
  EnterLoyaltyNumberForm := TEnterLoyaltyNumberForm.Create(Screen.ActiveControl);
  try
    Result := EnterLoyaltyNumberForm.ShowModal = mrOk;
    ANumber := EnterLoyaltyNumberForm.edMaskNumber.Text;
  finally
    EnterLoyaltyNumberForm.Free;
    LoadKeyboardLayout('00000419', KLF_ACTIVATE);
  end;
end;

end.
