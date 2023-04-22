unit DialogPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit,
  cxDropDownEdit, cxCalendar;

type
  TDialogPrintForm = class(TAncestorDialogScaleForm)
    PrintPanel: TPanel;
    PrintCountEdit: TcxCurrencyEdit;
    PrintCountLabel: TLabel;
    PrintIsValuePanel: TPanel;
    cbPrintMovement: TCheckBox;
    cbPrintAccount: TCheckBox;
    cbPrintTransport: TCheckBox;
    cbPrintQuality: TCheckBox;
    cbPrintPack: TCheckBox;
    cbPrintSpec: TCheckBox;
    cbPrintTax: TCheckBox;
    cbPrintPreview: TCheckBox;
    cbPrintPackGross: TCheckBox;
    cbPrintDiffOrder: TCheckBox;
    PanelDateValue: TPanel;
    LabelDateValue: TLabel;
    DateValueEdit: TcxDateEdit;
    procedure cbPrintTransportClick(Sender: TObject);
    procedure cbPrintQualityClick(Sender: TObject);
    procedure cbPrintTaxClick(Sender: TObject);
    procedure cbPrintAccountClick(Sender: TObject);
    procedure cbPrintPackClick(Sender: TObject);
    procedure cbPrintSpecClick(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute(MovementDescId:Integer;CountMovement:Integer; isMovement, isAccount, isTransport, isQuality, isPack, isPackGross, isSpec, isTax : Boolean): Boolean; virtual;
  end;

var
   DialogPrintForm: TDialogPrintForm;

implementation
{$R *.dfm}
uses UtilScale, DMMainScale;
{------------------------------------------------------------------------------}
function TDialogPrintForm.Execute(MovementDescId:Integer;CountMovement:Integer; isMovement, isAccount, isTransport, isQuality, isPack, isPackGross, isSpec, isTax : Boolean): Boolean; //Проверка корректного ввода в Edit
begin
     // для ScaleCeh только одна печать
     if (SettingMain.isCeh = TRUE)or((MovementDescId<>zc_Movement_Sale)and(MovementDescId<>zc_Movement_SendOnPrice))
     then cbPrintMovement.Checked:= TRUE
     else cbPrintMovement.Checked:= isMovement;
     //
     cbPrintPackGross.Checked:= FALSE;
     cbPrintDiffOrder.Checked:= FALSE;//(MovementDescId=zc_Movement_Sale)or(MovementDescId=zc_Movement_SendOnPrice);
     //
     cbPrintAccount.Enabled:=(SettingMain.isCeh = FALSE);//or(MovementDescId=zc_Movement_Sale)or(MovementDescId<>zc_Movement_SendOnPrice);
     cbPrintTransport.Enabled:=cbPrintAccount.Enabled;
     cbPrintQuality.Enabled:=cbPrintAccount.Enabled;
     cbPrintPack.Enabled:=cbPrintAccount.Enabled;
     cbPrintSpec.Enabled:=cbPrintAccount.Enabled;
     cbPrintTax.Enabled:=cbPrintAccount.Enabled;
     cbPrintDiffOrder.Enabled:=cbPrintAccount.Enabled;
     //
     cbPrintAccount.Checked:=(isAccount) and (cbPrintAccount.Enabled);
     cbPrintTransport.Checked:=(isTransport) and (cbPrintTransport.Enabled);
     cbPrintQuality.Checked:=(isQuality) and (cbPrintQuality.Enabled);
     cbPrintPack.Checked:=(isPack) and (cbPrintPack.Enabled);
     cbPrintSpec.Checked:=(isSpec) and (cbPrintSpec.Enabled);
     cbPrintTax.Checked:=(isTax) and (cbPrintTax.Enabled);
     //
     cbPrintPreview.Checked:=GetArrayList_Value_byName(Default_Array,'isPrintPreview') = AnsiUpperCase('TRUE');
     if SettingMain.isCeh = FALSE
     then PrintCountEdit.Text:=IntToStr(CountMovement)
     else PrintCountEdit.Text:=GetArrayList_Value_byName(Default_Array,'PrintCount');
     //
     ParamsMovement.ParamByName('isOperDatePartner').AsBoolean:= DMMainScaleForm.gpGet_Scale_Movement_OperDatePartner(ParamsMovement);
     DateValueEdit.Text:= DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime);
     //
     ActiveControl:=PrintCountEdit;
     //
     Result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
function TDialogPrintForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=false;
     //
     try ParamsMovement.ParamByName('OperDatePartner').AsDateTime:= StrToDate(DateValueEdit.Text)
     except if ParamsMovement.ParamByName('isOperDatePartner').AsBoolean = true
            then begin
                 ShowMessage('Ошибка.Дата у покупателя сформирована неверно.');
                 exit;
            end
            // еще раз
            else ParamsMovement.ParamByName('isOperDatePartner').AsBoolean:= DMMainScaleForm.gpGet_Scale_Movement_OperDatePartner(ParamsMovement);
     end;
     //
     if (ParamsMovement.ParamByName('OperDatePartner').AsDateTime < ParamsMovement.ParamByName('OperDate').AsDateTime)
        and (ParamsMovement.ParamByName('MovementId_find').AsInteger = 0)
     then begin
                 ShowMessage('Ошибка.Дата у покупателя = <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'> не может быть раньше даты документа = <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
                 exit;
     end;
     if ParamsMovement.ParamByName('OperDatePartner').AsDateTime > 14 + ParamsMovement.ParamByName('OperDate').AsDateTime
     then begin
                 ShowMessage('Ошибка.Дата у покупателя = <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'> не может быть позже даты документа = <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'> более чем на 14 дней.');
                 exit;
     end;
     //
     try Result:=(StrToInt(PrintCountEdit.Text)>0) and (StrToInt(PrintCountEdit.Text)<11);
     except Result:=false;
     end;
     //
     if not Result then ShowMessage('Ошибка.Значение <Кол-во копий> не попадает в диапазон от <1> до <10>.');
     //
     //
     if ParamsMovement.ParamByName('isOperDatePartner').AsBoolean = true
     then
         if MessageDlg('Документ будет сформирован'+#10+#13+'с Датой покупателя =  <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'>.'+#10+#13+'Продолжить?',mtConfirmation,mbYesNoCancel,0) <> 6
         then begin
            Result:=false;
            exit;
          end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintTransportClick(Sender: TObject);
begin
     if cbPrintTransport.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
         then cbPrintTransport.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintQualityClick(Sender: TObject);
begin
     if cbPrintQuality.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
          and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Loss)
         then cbPrintQuality.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintTaxClick(Sender: TObject);
begin
     if cbPrintTax.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          or (GetArrayList_Value_byName(Default_Array,'isTax') <> AnsiUpperCase('TRUE'))
         then cbPrintTax.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintAccountClick(Sender: TObject);
begin
     if cbPrintAccount.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
         then cbPrintAccount.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintPackClick(Sender: TObject);
begin
     if cbPrintPack.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
         then cbPrintPack.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintSpecClick(Sender: TObject);
begin
     if cbPrintSpec.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
         then cbPrintSpec.Checked:=false;
end;
{------------------------------------------------------------------------------}
end.
