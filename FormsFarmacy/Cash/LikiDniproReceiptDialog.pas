unit LikiDniproReceiptDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, dsdAction,
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
  dxSkinXmas2008Blue, System.Actions;

type
  TLikiDniproReceiptDialogForm = class(TAncestorBaseForm)
    cePartnerMedical: TcxButtonEdit;
    GuidesPartnerMedical: TdsdGuides;
    Label1: TLabel;
    Label2: TLabel;
    cxLabel13: TcxLabel;
    edCreated: TcxDateEdit;
    cxLabel14: TcxLabel;
    edRecipe_Number: TcxTextEdit;
    edMedicSP
    : TcxButtonEdit;
    GuidesMedicSP: TdsdGuides;
    Label3: TLabel;
    edSPKind: TcxButtonEdit;
    GuidesSPKind: TdsdGuides;
    spGet_SPKind: TdsdStoredProc;
    Panel1: TPanel;
    Panel2: TPanel;
    cxLabel22: TcxLabel;
    edMemberSP: TcxButtonEdit;
    GuidesMemberSP: TdsdGuides;
    spSelect_SearchData: TdsdStoredProc;
    spGet_Movement_InvNumberSP: TdsdStoredProc;
    edValid_From: TcxDateEdit;
    cxLabel1: TcxLabel;
    edValid_To: TcxDateEdit;
    cxLabel2: TcxLabel;
    edInstitution_Name: TcxTextEdit;
    rdDoctor_Name: TcxTextEdit;
    edPatient_Name: TcxTextEdit;
    Panel4: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    actFormClose: TdsdFormClose;
    edDiscount_Percent: TcxTextEdit;
    Label4: TLabel;
    spLink_MemberSP_LikiDnipro: TdsdStoredProc;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
  private
    { Private declarations }
    FMemberSPIdOld : Integer;
  public
  end;

function ShowLikiDniproReceiptDialog : boolean;


implementation

{$R *.dfm}

uses IniUtils, RegularExpressions, LikiDniproReceipt, MainCash2;

procedure TLikiDniproReceiptDialogForm.bbOkClick(Sender: TObject);
  var Key :Integer;
begin
  if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
  begin

//    try StrToDate(edCreated.Text)
//    except
//          ActiveControl:=edOperDateSP;
//          ShowMessage ('Ошибка.Значение <Дата рецепта> не определено');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//    if StrToDate(edOperDateSP.Text) < NOW - 30 then
//    begin ActiveControl:=edOperDateSP;
//          ShowMessage ('Ошибка.Значение <Дата рецепта> не может быть раньше чем <'+DateToStr(NOW - 30)+'>');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//    if StrToDate(edOperDateSP.Text) > NOW then
//    begin ActiveControl:=edOperDateSP;
//          ShowMessage ('Ошибка.Значение <Дата рецепта> не может быть позже чем <'+DateToStr(NOW)+'>');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//    if trim (edInvNumberSP.Text) = '' then
//    begin ActiveControl:=edInvNumberSP;
//          ShowMessage ('Ошибка.Значение <Номер рецепта> не определено');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;

    try Key:= GuidesSPKind.Params.ParamByName('Key').Value; except Key:= 0;end;
    if Key = 0 then
    begin
          ShowMessage ('Внимание.Значение <Вид соц.проекта> не установлено.');
          ModalResult:=mrNone; // не надо закрывать
          exit;
    end;

    try Key:= GuidesPartnerMedical.Params.ParamByName('Key').Value; except Key:= 0;end;
    if Key = 0 then
    begin
          ActiveControl:=cePartnerMedical;
          ShowMessage ('Внимание.Значение <Медицинское учреждение> не установлено.');
          ModalResult:=mrNone; // ??? может не надо закрывать
          exit;
    end;

//
//      if trim (edMedicSP.Text) = '' then
//      begin ActiveControl:=edMedicSP;
//            ShowMessage ('Ошибка.Значение <ФИО врача> не определено');
//            ModalResult:=mrNone; // не надо закрывать
//            exit;
//      end;
//      //

      try Key:= GuidesMemberSP.Params.ParamByName('Key').Value; except Key:= 0;end;
      if Key = 0 then
      begin
            ActiveControl:=edMemberSP;
            ShowMessage ('Внимание.Значение <ФИО пациента> не установлено.');
            ModalResult:=mrNone; // не надо закрывать
            exit;
      end;

      if (FMemberSPIdOld <> GuidesMemberSP.Params.ParamByName('Key').Value) and
        (LikiDniproReceiptApi.Recipe.FPatient_Id <> 0) then
      try
        spLink_MemberSP_LikiDnipro.Params.ParamByName('inLikiDniproId').Value :=  LikiDniproReceiptApi.Recipe.FPatient_Id;
        spLink_MemberSP_LikiDnipro.Execute;
      except
      end;
//
//    // а здесь уже все ОК
//    else ModalResult:=mrOk;
  end;

  ModalResult:=mrOk;
end;

procedure TLikiDniproReceiptDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  ActiveControl:= cePartnerMedical;
  inherited;
end;

function ShowLikiDniproReceiptDialog : boolean;
  var LikiDniproReceiptDialog : TLikiDniproReceiptDialogForm;
begin

  if LikiDniproReceiptApi.PositionCDS.IsEmpty then
  begin
    ShowMessage('Медикаменты не найдены.');
    Exit;
  end;

  if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
  begin
    if LikiDniproReceiptApi.Recipe.FRecipe_Valid_From > Date then
    begin
      ShowMessage('Рецепт не вступил в действие.');
      Exit;
    end;

    if LikiDniproReceiptApi.Recipe.FRecipe_Valid_To < Date then
    begin
      ShowMessage('Рецепт просрочен.');
      Exit;
    end;
  end;

  LikiDniproReceiptDialog := TLikiDniproReceiptDialogForm.Create(Screen.ActiveControl);
  try
    LikiDniproReceiptDialog.edRecipe_Number.Text := LikiDniproReceiptApi.Recipe.FRecipe_Number;
    LikiDniproReceiptDialog.edCreated.Date := LikiDniproReceiptApi.Recipe.FRecipe_Created;
    if LikiDniproReceiptApi.Recipe.FRecipe_Valid_From = Null then
    begin
      LikiDniproReceiptDialog.cxLabel1.Visible := False;
      LikiDniproReceiptDialog.edValid_From.Visible := False;
    end else LikiDniproReceiptDialog.edValid_From.Date := LikiDniproReceiptApi.Recipe.FRecipe_Valid_From;
    if LikiDniproReceiptApi.Recipe.FRecipe_Valid_From = Null then
    begin
      LikiDniproReceiptDialog.cxLabel2.Visible := False;
      LikiDniproReceiptDialog.edValid_To.Visible := False;
    end else LikiDniproReceiptDialog.edValid_To.Date := LikiDniproReceiptApi.Recipe.FRecipe_Valid_To;

    LikiDniproReceiptDialog.edInstitution_Name.Text := LikiDniproReceiptApi.Recipe.FInstitution_Name;
    LikiDniproReceiptDialog.rdDoctor_Name.Text := LikiDniproReceiptApi.Recipe.FDoctor_Name;
    LikiDniproReceiptDialog.edPatient_Name.Text := LikiDniproReceiptApi.Recipe.FPatient_Name;

    if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
    begin
      LikiDniproReceiptDialog.spGet_SPKind.Execute;
      LikiDniproReceiptDialog.spSelect_SearchData.ParamByName('inInstitution_Id').Value := LikiDniproReceiptApi.Recipe.FInstitution_Id;
      LikiDniproReceiptDialog.spSelect_SearchData.ParamByName('inDoctor_Id').Value := LikiDniproReceiptApi.Recipe.FDoctor_Id;
      LikiDniproReceiptDialog.spSelect_SearchData.ParamByName('inPatient_Id').Value := LikiDniproReceiptApi.Recipe.FPatient_Id;
      LikiDniproReceiptDialog.spSelect_SearchData.ParamByName('inInstitution_Edrpou').Value := LikiDniproReceiptApi.Recipe.FInstitution_Edrpou;
      LikiDniproReceiptDialog.spSelect_SearchData.Execute;
      LikiDniproReceiptDialog.edDiscount_Percent.Text := CurrToStr(LikiDniproReceiptApi.Recipe.FCategory_1303_Discount_Percent) + ' %';
      LikiDniproReceiptDialog.FMemberSPIdOld := LikiDniproReceiptDialog.spSelect_SearchData.Params.ParamByName('outMemberSPId').Value;
    end else
    begin
      LikiDniproReceiptDialog.edSPKind.Visible := False;
      LikiDniproReceiptDialog.Label4.Visible := False;
      LikiDniproReceiptDialog.edDiscount_Percent.Visible := False;
      LikiDniproReceiptDialog.Label3.Caption := 'Рецепт за полную стоимость.';
      LikiDniproReceiptDialog.Label3.Font.Size := Round(LikiDniproReceiptDialog.Label3.Font.Size * 1.5);
      LikiDniproReceiptDialog.Label3.Font.Color := clRed;
      LikiDniproReceiptDialog.cePartnerMedical.Visible := False;
      LikiDniproReceiptDialog.edValid_To.Visible := False;
//      LikiDniproReceiptDialog.edMedicSP.Visible := False;
      LikiDniproReceiptDialog.edMemberSP.Visible := False;
    end;

    Result := LikiDniproReceiptDialog.ShowModal = mrOk;

    if Result and (LikiDniproReceiptApi.Recipe.FRecipe_Type = 2) then
    begin
      MainCashForm.FormParams.ParamByName('InvNumberSP').Value := LikiDniproReceiptApi.Recipe.FRecipe_Number;
      MainCashForm.FormParams.ParamByName('OperDateSP').Value := LikiDniproReceiptApi.Recipe.FRecipe_Created;
      MainCashForm.FormParams.ParamByName('SPKindId').Value := LikiDniproReceiptDialog.GuidesSPKind.Params.ParamByName('Key').Value;
      MainCashForm.FormParams.ParamByName('SPKindName').Value := LikiDniproReceiptDialog.GuidesSPKind.Params.ParamByName('TextValue').Value;
      MainCashForm.FormParams.ParamByName('SPTax').Value := LikiDniproReceiptApi.Recipe.FCategory_1303_Discount_Percent;

      MainCashForm.FormParams.ParamByName('PartnerMedicalId').Value := LikiDniproReceiptDialog.GuidesPartnerMedical.Params.ParamByName('Key').Value;
      MainCashForm.FormParams.ParamByName('PartnerMedicalName').Value := LikiDniproReceiptDialog.GuidesPartnerMedical.Params.ParamByName('TextValue').Value;
      MainCashForm.FormParams.ParamByName('MedicSP').Value := LikiDniproReceiptDialog.rdDoctor_Name.Text;
                                                              // LikiDniproReceiptDialog.GuidesMedicSP.Params.ParamByName('TextValue').Value;
      MainCashForm.FormParams.ParamByName('MemberSPID').Value := LikiDniproReceiptDialog.GuidesMemberSP.Params.ParamByName('Key').Value;
      MainCashForm.FormParams.ParamByName('MemberSP').Value := LikiDniproReceiptDialog.GuidesMemberSP.Params.ParamByName('TextValue').Value;

      MainCashForm.lblSPKindName.Caption := '  ' + FloatToStr(MainCashForm.FormParams.ParamByName('SPTax')
        .Value) + '% : ' + MainCashForm.FormParams.ParamByName('SPKindName').Value;

      MainCashForm.Label30.Caption := '     Мед.уч.: ';
      MainCashForm.Label7.Caption := 'ФИО Врача:';

      MainCashForm.lblPartnerMedicalName.Caption := '  ' + MainCashForm.FormParams.ParamByName
        ('PartnerMedicalName').Value;
      // + '  /  № амб. ' + FormParams.ParamByName('Ambulance').Value;
      MainCashForm.lblMedicSP.Caption := '  ' + MainCashForm.FormParams.ParamByName('MedicSP').Value +
        '  /  № ' + MainCashForm.FormParams.ParamByName('InvNumberSP').Value + ' от ' +
        DateToStr(MainCashForm.FormParams.ParamByName('OperDateSP').Value);
      MainCashForm.lblMemberSP.Caption := '  ' + MainCashForm.FormParams.ParamByName('MemberSP').Value;
      MainCashForm.pnlSP.Visible := MainCashForm.FormParams.ParamByName('InvNumberSP').Value <> '';
      MainCashForm.pnlSP.Visible := True;
    end;

  finally
    LikiDniproReceiptDialog.Free;
  end;
end;

End.
