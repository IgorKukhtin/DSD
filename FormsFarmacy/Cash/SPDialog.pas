unit SPDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxLabel;

type
  TSPDialogForm = class(TAncestorDialogForm)
    cePartnerMedical: TcxButtonEdit;
    PartnerMedicalGuides: TdsdGuides;
    Label1: TLabel;
    Label2: TLabel;
    cxLabel13: TcxLabel;
    edOperDateSP: TcxDateEdit;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel17: TcxLabel;
    edAmbulance: TcxTextEdit;
    edMedicSP: TcxButtonEdit;
    MedicSPGuides: TdsdGuides;
    Label3: TLabel;
    ceSPKind: TcxButtonEdit;
    SPKindGuides: TdsdGuides;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
  private
    { Private declarations }
  public
     function DiscountDialogExecute(var APartnerMedicalId: Integer; var APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP: String; var aOperDateSP : TDateTime): boolean;
  end;


implementation
{$R *.dfm}
uses DiscountService;

procedure TSPDialogForm.bbOkClick(Sender: TObject);
var Key :Integer;
begin
    try StrToDate(edOperDateSP.Text)
    except
          ActiveControl:=edOperDateSP;
          ShowMessage ('Ошибка.Значение <Дата рецепта> не определено');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    if StrToDate(edOperDateSP.Text) < NOW - 30 then
    begin ActiveControl:=edOperDateSP;
          ShowMessage ('Ошибка.Значение <Дата рецепта> не может быть раньше чем <'+DateToStr(NOW - 30)+'>');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    if StrToDate(edOperDateSP.Text) > NOW then
    begin ActiveControl:=edOperDateSP;
          ShowMessage ('Ошибка.Значение <Дата рецепта> не может быть позже чем <'+DateToStr(NOW)+'>');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    if trim (edInvNumberSP.Text) = '' then
    begin ActiveControl:=edInvNumberSP;
          ShowMessage ('Ошибка.Значение <Номер рецепта> не определено');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    if trim (edAmbulance.Text) = '' then
    begin ActiveControl:=edAmbulance;
          ShowMessage ('Ошибка.Значение <№ амбулатории> не определено');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    if trim (edMedicSP.Text) = '' then
    begin ActiveControl:=edMedicSP;
          ShowMessage ('Ошибка.Значение <ФИО врача> не определено');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    //
    try Key:= PartnerMedicalGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
    if Key = 0 then
    begin
          ActiveControl:=cePartnerMedical;
          ShowMessage ('Внимание.Значение <Медицинское учреждение> не установлено.');
          ModalResult:=mrOk; // ??? может не надо закрывать
    end
    // а здесь уже все ОК
    else ModalResult:=mrOk;

end;

function TSPDialogForm.DiscountDialogExecute(var APartnerMedicalId: Integer; var APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP: String; var aOperDateSP : TDateTime): boolean;
Begin
      edAmbulance.Text:= AAmbulance;
      edMedicSP.Text:= AMedicSP;
      edInvNumberSP.Text:= AInvNumberSP;
      edOperDateSP.Text:= DateToStr(aOperDateSP);
      //
      PartnerMedicalGuides.Params.ParamByName('Key').Value      := APartnerMedicalId;
      PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= '';
      if APartnerMedicalId > 0 then
      begin
          cePartnerMedical.Text:= APartnerMedicalName;
          PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= APartnerMedicalName;
      end;
      //
      Result := ShowModal = mrOK;
      //
      if Result then
      begin
        try APartnerMedicalId := PartnerMedicalGuides.Params.ParamByName('Key').Value;
        except
            APartnerMedicalId := 0;
            PartnerMedicalGuides.Params.ParamByName('Key').Value:= 0;
        end;
        APartnerMedicalName   := PartnerMedicalGuides.Params.ParamByName('TextValue').Value;
        AAmbulance:= trim (edAmbulance.Text);
        AMedicSP:= trim (edMedicSP.Text);
        AInvNumberSP:= trim (edInvNumberSP.Text);
        AOperDateSP:= StrToDate (edOperDateSP.Text);
      end
      else begin
            APartnerMedicalId   := 0;
            APartnerMedicalName := '';
            AAmbulance          := '';
            AMedicSP            := '';
            AInvNumberSP        := '';
           end;
end;

procedure TSPDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  ActiveControl:= cePartnerMedical;
  inherited;
end;

End.
