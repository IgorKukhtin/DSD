unit SPDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxLabel,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

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
    edSPKind: TcxButtonEdit;
    SPKindGuides: TdsdGuides;
    spGet_SPKind_def: TdsdStoredProc;
    bbSP_Prior: TcxButton;
    spGet_SP_Prior: TdsdStoredProc;
    Panel1: TPanel;
    Panel2: TPanel;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    cxLabel26: TcxLabel;
    edMemberSP: TcxButtonEdit;
    edPassport: TcxTextEdit;
    edInn: TcxTextEdit;
    edAddress: TcxTextEdit;
    GuidesMemberSP: TdsdGuides;
    edGroupMemberSP: TcxTextEdit;
    spSelect_Object_MemberSP: TdsdStoredProc;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
    procedure bbSP_PriorClick(Sender: TObject);
    procedure edSPKindPropertiesChange(Sender: TObject);
    procedure cePartnerMedicalPropertiesChange(Sender: TObject);
  private
    { Private declarations }
  public
     function DiscountDialogExecute(var APartnerMedicalId, ASPKindId: Integer; var APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP, ASPKindName: String;
       var AOperDateSP : TDateTime; var ASPTax : Currency; var AMemberSPID: Integer): boolean;
  end;


implementation
{$R *.dfm}
uses IniUtils, DiscountService, MainCash, MainCash2;

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
    // 23.01.2018 - «№ амбулатории»  - убрать эту ячейку , она не нужна
    {if trim (edAmbulance.Text) = '' then
    begin ActiveControl:=edAmbulance;
          ShowMessage ('Ошибка.Значение <№ амбулатории> не определено');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;}
    if trim (edMedicSP.Text) = '' then
    begin ActiveControl:=edMedicSP;
          ShowMessage ('Ошибка.Значение <ФИО врача> не определено');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    //
    try Key:= SPKindGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
    if Key = 0 then
    begin
          ActiveControl:=edSPKind;
          ShowMessage ('Внимание.Значение <Вид соц.проекта> не установлено.');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;
    //
    if Panel2.Visible then
    begin
      try Key:= GuidesMemberSP.Params.ParamByName('Key').Value; except Key:= 0;end;
      if Key = 0 then
      begin
            ActiveControl:=edMemberSP;
            ShowMessage ('Внимание.Значение <ФИО пациента> не установлено.');
            ModalResult:=mrNone; // не надо закрывать
            exit;
      end;
    end;

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

procedure TSPDialogForm.bbSP_PriorClick(Sender: TObject);
var APartnerMedicalId: Integer;
    APartnerMedicalName, AMedicSP : String;
    AOperDateSP : TDateTime;
begin
      ActiveControl:= edInvNumberSP;
      //
      if PartnerMedicalGuides.Params.ParamByName('Key').Value <> 0
      then begin
                ShowMessage ('Ошибка.Медицинское учреждение уже заполнено.Необходимо сначала обнулить значение');
                exit;
          end;
      if edMedicSP.Text <> ''
      then begin
                ShowMessage ('Ошибка.ФИО врача уже заполнено.Необходимо сначала обнулить значение');
                exit;
          end;
      //
      //Сначала ищем в текущем ДБФ
      if isMainForm_OLD = TRUE
      then MainCash.MainCashForm.pGet_OldSP (APartnerMedicalId, APartnerMedicalName, AMedicSP, AOperDateSP)
      else MainCash2.MainCashForm.pGet_OldSP (APartnerMedicalId, APartnerMedicalName, AMedicSP, AOperDateSP);

      //если не нашли - попробуем в базе
      if APartnerMedicalId = 0 then
      begin
          spGet_SP_Prior.Execute;
          if spGet_SP_Prior.ParamByName('outPartnerMedicalId').Value = 0
          then
               ShowMessage('Данные для заполнения не найдены')
          else
          begin
               PartnerMedicalGuides.Params.ParamByName('Key').Value      := spGet_SP_Prior.ParamByName('outPartnerMedicalId').Value;
               PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= spGet_SP_Prior.ParamByName('outPartnerMedicalName').Value;
               cePartnerMedical.Text:= spGet_SP_Prior.ParamByName('outPartnerMedicalName').Value;
               edMedicSP.Text       := spGet_SP_Prior.ParamByName('outMedicSPName').Value;
               //вернуть через строчку, т.к. с TDateTime - ошибка
               AOperDateSP          := StrToDate(spGet_SP_Prior.ParamByName('outOperDateSP').Value);
               edOperDateSP.Date    := AOperDateSP;
          end
      end
      else
      begin
          PartnerMedicalGuides.Params.ParamByName('Key').Value      := APartnerMedicalId;
          PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= APartnerMedicalName;
          cePartnerMedical.Text:= APartnerMedicalName;
          edMedicSP.Text:= AMedicSP;
          edOperDateSP.Date:= AOperDateSP;
      end;

end;

procedure TSPDialogForm.cePartnerMedicalPropertiesChange(Sender: TObject);
begin
  inherited;
  if PartnerMedicalGuides.Params.ParamByName('Key').Value <> 0 then
     GuidesMemberSP.DisableGuidesOpen := False
  else GuidesMemberSP.DisableGuidesOpen := True;
end;

function TSPDialogForm.DiscountDialogExecute(var APartnerMedicalId, ASPKindId: Integer; var APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP, ASPKindName: String;
  var AOperDateSP : TDateTime; var ASPTax : Currency; var AMemberSPID: Integer): boolean;
Begin
      edAmbulance.Text:= AAmbulance;
      edMedicSP.Text:= AMedicSP;
      edInvNumberSP.Text:= AInvNumberSP;
      edOperDateSP.Text:= DateToStr(aOperDateSP);
      edSPKind.Text:= AInvNumberSP;
      FormParams.ParamByName('MasterUnitId').Value  :=IniUtils.gUnitId;
      FormParams.ParamByName('MasterUnitName').Value:=IniUtils.gUnitName;
      //
      PartnerMedicalGuides.Params.ParamByName('Key').Value      := APartnerMedicalId;
      PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= '';
      if APartnerMedicalId > 0 then
      begin
          cePartnerMedical.Text:= APartnerMedicalName;
          PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= APartnerMedicalName;
      end;
      //
      SPKindGuides.Params.ParamByName('Key').Value      := ASPKindId;
      SPKindGuides.Params.ParamByName('TextValue').Value:= '';
      SPKindGuides.Params.ParamByName('Tax').Value:= 0;
      FormParams.ParamByName('SPTax').Value:=ASPTax;

      if ASPKindId > 0 then
      begin
          edSPKind.Text:= ASPKindName;
          SPKindGuides.Params.ParamByName('TextValue').Value:= ASPKindName;
      end
      else begin
                spGet_SPKind_def.Execute;
                SPKindGuides.Params.ParamByName('Tax').Value:= 0
      end;

      if AMemberSPID <> 0 then
      begin
          GuidesMemberSP.Params.ParamByName('Key').Value      := AMemberSPID;
          try
            spSelect_Object_MemberSP.Execute;
          except
          end;
      end;

      GuidesMemberSP.DisableGuidesOpen := True;

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

        ASPTax:=FormParams.ParamByName('SPTax').Value;
        try ASPKindId := SPKindGuides.Params.ParamByName('Key').Value;
        except
            ASPKindId := 0;
            SPKindGuides.Params.ParamByName('Key').Value:= 0;
        end;
        ASPKindName   := SPKindGuides.Params.ParamByName('TextValue').Value;
        if Panel2.Visible then
          AMemberSPID := GuidesMemberSP.Params.ParamByName('Key').Value
        else AMemberSPID := 0;
      end
      else begin
              APartnerMedicalId   := 0;
              APartnerMedicalName := '';
              AAmbulance          := '';
              AMedicSP            := '';
              AInvNumberSP        := '';
              ASPTax              := 0;
              ASPKindId           := 0;
              ASPKindName         := '';
              AMemberSPID         := 0;
           end;
end;

procedure TSPDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  ActiveControl:= cePartnerMedical;
  inherited;
end;

procedure TSPDialogForm.edSPKindPropertiesChange(Sender: TObject);
begin
  inherited;
  if SPKindGuides.Params.ParamByName('Key').Value <> '' then
     Panel2.Visible := SPKindGuides.Params.ParamByName('Key').Value = 4823010
  else Panel2.Visible := False;
end;

End.
