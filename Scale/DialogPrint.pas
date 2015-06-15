unit DialogPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons;

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
    procedure cbPrintTransportClick(Sender: TObject);
    procedure cbPrintQualityClick(Sender: TObject);
    procedure cbPrintTaxClick(Sender: TObject);
    procedure cbPrintAccountClick(Sender: TObject);
    procedure cbPrintPackClick(Sender: TObject);
    procedure cbPrintSpecClick(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute(isMovement, isAccount, isTransport, isQuality, isPack, isSpec, isTax : Boolean): Boolean; virtual;
  end;

var
   DialogPrintForm: TDialogPrintForm;

implementation
{$R *.dfm}
uses UtilScale;
{------------------------------------------------------------------------------}
function TDialogPrintForm.Execute(isMovement, isAccount, isTransport, isQuality, isPack, isSpec, isTax : Boolean): Boolean; //Проверка корректного ввода в Edit
begin
     // для ScaleCeh только одна печать
     if SettingMain.isCeh = TRUE
     then cbPrintMovement.Checked:= TRUE
     else cbPrintMovement.Checked:=isMovement;
     cbPrintAccount.Checked:=isAccount;
     cbPrintTransport.Checked:=isTransport;
     cbPrintQuality.Checked:=isQuality;
     cbPrintPack.Checked:=isPack;
     cbPrintSpec.Checked:=isSpec;
     cbPrintTax.Checked:=isTax;
     //
     cbPrintAccount.Enabled:=SettingMain.isCeh = TRUE;
     cbPrintTransport.Enabled:=SettingMain.isCeh = TRUE;
     cbPrintQuality.Enabled:=SettingMain.isCeh = TRUE;
     cbPrintPack.Enabled:=SettingMain.isCeh = TRUE;
     cbPrintSpec.Enabled:=SettingMain.isCeh = TRUE;
     cbPrintTax.Enabled:=SettingMain.isCeh = TRUE;
     //
     cbPrintPreview.Checked:=GetArrayList_Value_byName(Default_Array,'isPrintPreview') = AnsiUpperCase('TRUE');
     PrintCountEdit.Text:=GetArrayList_Value_byName(Default_Array,'PrintCount');
     //
     ActiveControl:=PrintCountEdit;
     //
     Result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
function TDialogPrintForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     try Result:=(StrToInt(PrintCountEdit.Text)>0) and (StrToInt(PrintCountEdit.Text)<11);
     except Result:=false;
     end;
     //
     if not Result then ShowMessage('Ошибка.Значение <Кол-во копий> не попадает в диапазон от <1> до <10>.')
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
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
         then cbPrintPack.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintSpecClick(Sender: TObject);
begin
     if cbPrintSpec.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
         then cbPrintSpec.Checked:=false;
end;
{------------------------------------------------------------------------------}
end.
