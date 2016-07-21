unit DiscountDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters;

type
  TDiscountDialogForm = class(TAncestorDialogForm)
    ceDiscountExternal: TcxButtonEdit;
    DiscountExternalGuides: TdsdGuides;
    Label1: TLabel;
    edCardNumber: TcxTextEdit;
    Label2: TLabel;
    procedure bbOkClick(Sender: TObject);
  private
    { Private declarations }
  public
     function DiscountDialogExecute(var ADiscountExternalId: Integer; var ADiscountExternalName, ADiscountCardNumber: String): boolean;
  end;


implementation
{$R *.dfm}
uses DiscountService;

procedure TDiscountDialogForm.bbOkClick(Sender: TObject);
var Key :Integer;
    lMsg:String;
begin
  try Key:= DiscountExternalGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
  //
  if Key > 0
  then
      if trim (edCardNumber.Text) <> ''
      then if DiscountServiceForm.fCheckCard (lMsg
                                             ,DiscountExternalGuides.Params.ParamByName('URL').Value
                                             ,DiscountExternalGuides.Params.ParamByName('Service').Value
                                             ,DiscountExternalGuides.Params.ParamByName('Port').Value
                                             ,DiscountExternalGuides.Params.ParamByName('UserName').Value
                                             ,DiscountExternalGuides.Params.ParamByName('Password').Value
                                             ,trim (edCardNumber.Text)
                                             )
           then ModalResult:=mrOk
           else // ??? еще раз ругнуться
      else begin ActiveControl:=edCardNumber;ShowMessage ('Ошибка.Значение <№ дисконтной карты> не определено');end
  else begin ActiveControl:=ceDiscountExternal;ShowMessage ('Ошибка.Значение <Проект> не определено');
             ModalResult:=mrOk; // ??? может не надо закрывать
       end;

end;

function TDiscountDialogForm.DiscountDialogExecute(var ADiscountExternalId: Integer; var ADiscountExternalName, ADiscountCardNumber: String): boolean;
Begin
      DiscountExternalGuides.Params.ParamByName('Key').Value:= ADiscountExternalId;
      DiscountExternalGuides.Params.ParamByName('TextValue').Value:=ADiscountExternalName;
      edCardNumber.Text:= ADiscountCardNumber;
      if ADiscountExternalId > 0 then
      begin
          ceDiscountExternal.Text:= ADiscountExternalName;
          // так криво восстановим "текущие" параметры
          DiscountExternalGuides.Params.ParamByName('URL').Value       := DiscountServiceForm.gURL;
          DiscountExternalGuides.Params.ParamByName('Service').Value   := DiscountServiceForm.gService;
          DiscountExternalGuides.Params.ParamByName('Port').Value      := DiscountServiceForm.gPort;
          DiscountExternalGuides.Params.ParamByName('UserName').Value  := DiscountServiceForm.gUserName;
          DiscountExternalGuides.Params.ParamByName('Password').Value  := DiscountServiceForm.gPassword;
      end;
      //
      Result := ShowModal = mrOK;
      if Result then
      begin
        try ADiscountExternalId := DiscountExternalGuides.Params.ParamByName('Key').Value;
        except
            ADiscountExternalId := 0;
            DiscountExternalGuides.Params.ParamByName('Key').Value:= 0;
        end;
        ADiscountExternalName:= DiscountExternalGuides.Params.ParamByName('TextValue').Value;
        ADiscountCardNumber := trim (edCardNumber.Text);
      end;
end;

End.
