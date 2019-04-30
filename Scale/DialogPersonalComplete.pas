unit DialogPersonalComplete;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Buttons, ExtCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit,
  cxCurrencyEdit, cxMaskEdit, cxButtonEdit, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, cxButtons,DB;

type
  TDialogPersonalCompleteForm = class(TAncestorDialogScaleForm)
    infoPanelPersona1: TPanel;
    infoPanelPersona2: TPanel;
    infoPanelPersona3: TPanel;
    infoPanelPersona4: TPanel;
    PanelPersonal1: TPanel;
    PanelPersonal2: TPanel;
    PanelPersonal3: TPanel;
    PanelPersonal4: TPanel;
    PanelPosition1: TPanel;
    PanelPosition2: TPanel;
    PanelPosition3: TPanel;
    PanelPosition4: TPanel;
    PanelPositionName1: TPanel;
    PanelPositionName2: TPanel;
    PanelPositionName3: TPanel;
    PanelPositionName4: TPanel;
    LabelPersonalName1: TLabel;
    LabelPersonalName2: TLabel;
    LabelPersonalName3: TLabel;
    LabePersonalName4: TLabel;
    LabelPositionName1: TLabel;
    LabelPositionName2: TLabel;
    LabelPositionName3: TLabel;
    LabelPositionName4: TLabel;
    gbPersonalCode2: TGroupBox;
    gbPersonalCode1: TGroupBox;
    gbPersonalCode3: TGroupBox;
    gbPersonalCode4: TGroupBox;
    gbPersonalName1: TGroupBox;
    gbPersonalName2: TGroupBox;
    gbPersonalName3: TGroupBox;
    gbPersonalName4: TGroupBox;
    gbPositionName1: TGroupBox;
    gbPositionName2: TGroupBox;
    gbPositionName3: TGroupBox;
    gbPositionName4: TGroupBox;
    EditPersonalCode1: TcxCurrencyEdit;
    EditPersonalName1: TcxButtonEdit;
    EditPersonalCode2: TcxCurrencyEdit;
    EditPersonalCode3: TcxCurrencyEdit;
    EditPersonalCode4: TcxCurrencyEdit;
    EditPersonalName2: TcxButtonEdit;
    EditPersonalName3: TcxButtonEdit;
    EditPersonalName4: TcxButtonEdit;
    infoPanelPersona5: TPanel;
    PanelPosition5: TPanel;
    LabelPositionName5: TLabel;
    gbPositionName5: TGroupBox;
    PanelPositionName5: TPanel;
    PanelPersonal5: TPanel;
    LabePersonalName5: TLabel;
    gbPersonalCode5: TGroupBox;
    EditPersonalCode5: TcxCurrencyEdit;
    gbPersonalName5: TGroupBox;
    EditPersonalName5: TcxButtonEdit;
    infoPanelPersonaStick1: TPanel;
    PanelPositionStick1: TPanel;
    LabelPositionStickName1: TLabel;
    gbPositionStickName1: TGroupBox;
    PanelPositionStickName1: TPanel;
    PanelPersonalStick1: TPanel;
    LabelPersonalStickName1: TLabel;
    gbPersonalStickCode1: TGroupBox;
    EditPersonalStickCode1: TcxCurrencyEdit;
    gbPersonalStickName1: TGroupBox;
    EditPersonalStickName1: TcxButtonEdit;

    procedure FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure EditPersonalCode1Exit(Sender: TObject);

    procedure EditPersonalCode1Enter(Sender: TObject);
    procedure EditPersonalCode1PropertiesChange(Sender: TObject);
    procedure EditPersonalName1PropertiesButtonClick(Sender: TObject;AButtonIndex: Integer);

    procedure FormCreate(Sender: TObject);
    procedure EditPersonalCode1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalName1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fStartWrite:Boolean;
    fChangePersonalCode:Boolean;

    ParamsPersonalComplete_local: TParams;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute(var execParamsPersonalComplete:TParams): boolean;virtual;
  end;

var
  DialogPersonalCompleteForm: TDialogPersonalCompleteForm;

implementation
uses UtilScale,DMMainScale,GuidePersonal;
{$R *.dfm}
{------------------------------------------------------------------------}
function TDialogPersonalCompleteForm.Execute(var execParamsPersonalComplete:TParams): Boolean; //Проверка корректного ввода в Edit
begin
     if (execParamsPersonalComplete.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
        and(execParamsPersonalComplete.ParamByName('MovementDescId').AsInteger<>zc_Movement_Loss)
        and(execParamsPersonalComplete.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
     then begin
               Result:=false;
               exit;
     end;
     //
     CopyValuesParamsFrom(execParamsPersonalComplete,ParamsPersonalComplete_local);
     //
     fStartWrite:=true;
     with ParamsPersonalComplete_local do
     begin
          if execParamsPersonalComplete.ParamByName('MovementDescId').AsInteger=zc_Movement_Sale
          then Caption:='Изменить для Накладной № <'+execParamsPersonalComplete.ParamByName('InvNumber').AsString+'> от<'+execParamsPersonalComplete.ParamByName('OperDate').AsString+'>'+'<'+execParamsPersonalComplete.ParamByName('ToName').AsString+'>'
          else Caption:='Изменить для Накладной № <'+execParamsPersonalComplete.ParamByName('InvNumber').AsString+'> от<'+execParamsPersonalComplete.ParamByName('OperDate').AsString+'>'+'<'+execParamsPersonalComplete.ParamByName('FromName').AsString+'>';
          //
          EditPersonalCode1.Text:=ParamByName('PersonalCode1').AsString;
          EditPersonalName1.Text:=ParamByName('PersonalName1').AsString;
          PanelPositionName1.Caption:=ParamByName('PositionName1').AsString;

          EditPersonalCode2.Text:=ParamByName('PersonalCode2').AsString;
          EditPersonalName2.Text:=ParamByName('PersonalName2').AsString;
          PanelPositionName2.Caption:=ParamByName('PositionName2').AsString;

          EditPersonalCode3.Text:=ParamByName('PersonalCode3').AsString;
          EditPersonalName3.Text:=ParamByName('PersonalName3').AsString;
          PanelPositionName3.Caption:=ParamByName('PositionName3').AsString;

          EditPersonalCode4.Text:=ParamByName('PersonalCode4').AsString;
          EditPersonalName4.Text:=ParamByName('PersonalName4').AsString;
          PanelPositionName4.Caption:=ParamByName('PositionName4').AsString;

          EditPersonalCode5.Text:=ParamByName('PersonalCode5').AsString;
          EditPersonalName5.Text:=ParamByName('PersonalName5').AsString;
          PanelPositionName5.Caption:=ParamByName('PositionName5').AsString;

          EditPersonalStickCode1.Text:=ParamByName('PersonalCode1_Stick').AsString;
          EditPersonalStickName1.Text:=ParamByName('PersonalName1_Stick').AsString;
          PanelPositionStickName1.Caption:=ParamByName('PositionName1_Stick').AsString;
     end;
     ActiveControl:=EditPersonalCode1;
     fStartWrite:=false;
     fChangePersonalCode:=false;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsPersonalComplete_local,execParamsPersonalComplete);

end;
{------------------------------------------------------------------------}
function TDialogPersonalCompleteForm.Checked: boolean; //Проверка корректного ввода в Edit
var PersonalCode1:Integer;
    PersonalStickCode1:Integer;
    PersonalCode2:Integer;
    PersonalCode3:Integer;
    PersonalCode4:Integer;
    PersonalCode5:Integer;
begin
     Result:=false;
     //
     try PersonalCode1:= StrToInt(EditPersonalCode1.Text); except PersonalCode1:= 0;end;
     try PersonalCode2:= StrToInt(EditPersonalCode2.Text); except PersonalCode2:= 0;end;
     try PersonalCode3:= StrToInt(EditPersonalCode3.Text); except PersonalCode3:= 0;end;
     try PersonalCode4:= StrToInt(EditPersonalCode4.Text); except PersonalCode4:= 0;end;
     try PersonalCode5:= StrToInt(EditPersonalCode5.Text); except PersonalCode5:= 0;end;
     try PersonalStickCode1:= StrToInt(EditPersonalStickCode1.Text); except PersonalStickCode1:= 0;end;
     //
     EditPersonalCode1Exit(EditPersonalCode1);
     EditPersonalCode1Exit(EditPersonalCode2);
     EditPersonalCode1Exit(EditPersonalCode3);
     EditPersonalCode1Exit(EditPersonalCode4);
     EditPersonalCode1Exit(EditPersonalCode5);
     EditPersonalCode1Exit(EditPersonalStickCode1);

     //
     //
     Result:=(PersonalCode1<>0)and(trim(EditPersonalName1.Text)<>'')and(ParamsPersonalComplete_local.ParamByName('PersonalId1').AsInteger<>0);
     if not Result then
     begin
           ActiveControl:=EditPersonalCode1;
           ShowMessage('Введите Комплектовщик 1.');
           exit;
     end;
     //
     //
     Result:=((PersonalCode2<>0)and(trim(EditPersonalName2.Text)<>'')and(ParamsPersonalComplete_local.ParamByName('PersonalId2').AsInteger<>0))
          or ((PersonalCode2=0)and(trim(EditPersonalName2.Text)='')and(ParamsPersonalComplete_local.ParamByName('PersonalId2').AsInteger=0)
              and(PersonalCode3=0)and(PersonalCode4=0)and(PersonalCode5=0)
             );
     if not Result then
     begin
           ActiveControl:=EditPersonalCode2;
           ShowMessage('Введите Комплектовщик 2.');
           exit;
     end;
     //
     //
     Result:=((PersonalCode3<>0)and(trim(EditPersonalName3.Text)<>'')and(ParamsPersonalComplete_local.ParamByName('PersonalId3').AsInteger<>0))
          or ((PersonalCode3=0)and(trim(EditPersonalName3.Text)='')and(ParamsPersonalComplete_local.ParamByName('PersonalId3').AsInteger=0)
              and(PersonalCode4=0)and(PersonalCode5=0)
             );
     if not Result then
     begin
           ActiveControl:=EditPersonalCode3;
           ShowMessage('Введите Код для Комплектовщик 3.');
           exit;
     end;
     //
     //
     Result:=((PersonalCode4<>0)and(trim(EditPersonalName4.Text)<>'')and(ParamsPersonalComplete_local.ParamByName('PersonalId4').AsInteger<>0))
          or ((PersonalCode4=0)and(trim(EditPersonalName4.Text)='')and(ParamsPersonalComplete_local.ParamByName('PersonalId4').AsInteger=0)
           and(PersonalCode5=0)
             );
     if not Result then
     begin
           ActiveControl:=EditPersonalCode4;
           ShowMessage('Введите Комплектовщик 4.');
           exit;
     end;
     //
     //
     Result:=((PersonalCode5<>0)and(trim(EditPersonalName5.Text)<>'')and(ParamsPersonalComplete_local.ParamByName('PersonalId5').AsInteger<>0))
          or ((PersonalCode5=0)and(trim(EditPersonalName5.Text)='')and(ParamsPersonalComplete_local.ParamByName('PersonalId5').AsInteger=0)
             );
     if not Result then
     begin
           ActiveControl:=EditPersonalCode5;
           ShowMessage('Введите Комплектовщик 5.');
           exit;
     end;
     //
     //
     Result:=((PersonalStickCode1<>0)and(trim(EditPersonalStickName1.Text)<>'')and(ParamsPersonalComplete_local.ParamByName('PersonalId1_Stick').AsInteger<>0))
          or ((PersonalStickCode1=0)and(trim(EditPersonalStickName1.Text)='')and(ParamsPersonalComplete_local.ParamByName('PersonalId1_Stick').AsInteger=0)
             );
     if not Result then
     begin
           ActiveControl:=EditPersonalStickCode1;
           ShowMessage('Введите Стикеровщик 1.');
           exit;
     end;
     //
     //
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.FormCreate(Sender: TObject);
begin
    Create_ParamsPersonalComplete(ParamsPersonalComplete_local);
    fStartWrite:=true;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key=13 then
      if (ActiveControl=EditPersonalCode1)or(ActiveControl=EditPersonalName1)then ActiveControl:=EditPersonalCode2
      else if (ActiveControl=EditPersonalCode2)or(ActiveControl=EditPersonalName2)then ActiveControl:=EditPersonalCode3
           else if (ActiveControl=EditPersonalCode3)or(ActiveControl=EditPersonalName3)then ActiveControl:=EditPersonalCode4
                else if (ActiveControl=EditPersonalCode4)or(ActiveControl=EditPersonalName4) then ActiveControl:=EditPersonalCode5
                     else if (ActiveControl=EditPersonalCode5)or(ActiveControl=EditPersonalName5) then ActiveControl:=EditPersonalStickCode1
                          else if (ActiveControl=EditPersonalStickCode1)or(ActiveControl=EditPersonalStickName1) then bbOkClick(self);
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPersonalCode1KeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
var Value:Integer;
begin
    if Key=13 then
    begin
         try Value:= StrToInt((TcxCurrencyEdit(Sender).Text)); except Value:= 0; end;
         //
         if (TcxCurrencyEdit(Sender).Tag = 1) then if Value = 0 then ActiveControl:=EditPersonalName1 else ActiveControl:=EditPersonalCode2
         else if (TcxCurrencyEdit(Sender).Tag = 2) then if Value = 0 then ActiveControl:=EditPersonalName2 else ActiveControl:=EditPersonalCode3
              else if (TcxCurrencyEdit(Sender).Tag = 3) then if Value = 0 then ActiveControl:=EditPersonalName3 else ActiveControl:=EditPersonalCode4
                   else if (TcxCurrencyEdit(Sender).Tag = 4) then if Value = 0 then ActiveControl:=EditPersonalName4 else ActiveControl:=EditPersonalCode5
                        else if (TcxCurrencyEdit(Sender).Tag = 5) then if Value = 0 then ActiveControl:=EditPersonalName5 else ActiveControl:=EditPersonalStickCode1
                             else if (TcxCurrencyEdit(Sender).Tag = 11) then if Value = 0 then ActiveControl:=EditPersonalStickName1 else bbOkClick(self);
    end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPersonalName1KeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
    if Key=13 then
    begin
         if (TcxCurrencyEdit(Sender).Tag = 1) then ActiveControl:=EditPersonalCode2
         else if (TcxCurrencyEdit(Sender).Tag = 2) then ActiveControl:=EditPersonalCode3
              else if (TcxCurrencyEdit(Sender).Tag = 3) then ActiveControl:=EditPersonalCode4
                   else if (TcxCurrencyEdit(Sender).Tag = 4) then ActiveControl:=EditPersonalCode5
                        else if (TcxCurrencyEdit(Sender).Tag = 5) then ActiveControl:=EditPersonalStickCode1
                             else if (TcxCurrencyEdit(Sender).Tag = 11) then bbOkClick(self);
    end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPersonalCode1Enter(Sender: TObject);
begin TEdit(Sender).SelectAll;end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPersonalCode1Exit(Sender: TObject);
var execParams:TParams;
    PersonalCode:Integer;
    idx:String;
begin
    idx:=IntToStr(TcxButtonEdit(Sender).Tag);
    //
    if idx = '1'  then try PersonalCode:= StrToInt(EditPersonalCode1.Text);      except PersonalCode:= 0;end;
    if idx = '2'  then try PersonalCode:= StrToInt(EditPersonalCode2.Text);      except PersonalCode:= 0;end;
    if idx = '3'  then try PersonalCode:= StrToInt(EditPersonalCode3.Text);      except PersonalCode:= 0;end;
    if idx = '4'  then try PersonalCode:= StrToInt(EditPersonalCode4.Text);      except PersonalCode:= 0;end;
    if idx = '5'  then try PersonalCode:= StrToInt(EditPersonalCode5.Text);      except PersonalCode:= 0;end;
    if idx = '11' then try PersonalCode:= StrToInt(EditPersonalStickCode1.Text); except PersonalCode:= 0;end;
    //
    if PersonalCode = 0 then
    begin
         if TcxButtonEdit(Sender).Tag < 10
         then begin
             ParamsPersonalComplete_local.ParamByName('PersonalId'+idx).AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx).AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PersonalName'+idx).AsString:='';
             ParamsPersonalComplete_local.ParamByName('PositionId'+idx).AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PositionCode'+idx).AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PositionName'+idx).AsString:='';
         end
         else begin
             ParamsPersonalComplete_local.ParamByName('PersonalId'+idx+'_Stick').AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx+'_Stick').AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PersonalName'+idx+'_Stick').AsString:='';
             ParamsPersonalComplete_local.ParamByName('PositionId'+idx+'_Stick').AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PositionCode'+idx+'_Stick').AsInteger:=0;
             ParamsPersonalComplete_local.ParamByName('PositionName'+idx+'_Stick').AsString:='';
         end;
         //
         fStartWrite:=true;
         if idx = '1'  then begin EditPersonalName1.Text:='';      PanelPositionName1.Caption:=''; end;
         if idx = '2'  then begin EditPersonalName2.Text:='';      PanelPositionName2.Caption:=''; end;
         if idx = '3'  then begin EditPersonalName3.Text:='';      PanelPositionName3.Caption:=''; end;
         if idx = '4'  then begin EditPersonalName4.Text:='';      PanelPositionName4.Caption:=''; end;
         if idx = '5'  then begin EditPersonalName5.Text:='';      PanelPositionName5.Caption:=''; end;
         if idx = '11' then begin EditPersonalStickName1.Text:=''; PanelPositionStickName1.Caption:=''; end;
         fStartWrite:=false;
         //
         fChangePersonalCode:=false;
    end
    else if fChangePersonalCode = true then
         begin
              Create_ParamsPersonal(execParams,'');
              //
              if DMMainScaleForm.gpGet_Scale_Personal(execParams,PersonalCode) = true
              then begin
                        if TcxButtonEdit(Sender).Tag < 10
                        then begin
                            ParamsPersonalComplete_local.ParamByName('PersonalId'+idx).AsInteger:=execParams.ParamByName('PersonalId').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx).AsInteger:=execParams.ParamByName('PersonalCode').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PersonalName'+idx).AsString:=execParams.ParamByName('PersonalName').AsString;
                            ParamsPersonalComplete_local.ParamByName('PositionId'+idx).AsInteger:=execParams.ParamByName('PositionId').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PositionCode'+idx).AsInteger:=execParams.ParamByName('PositionCode').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PositionName'+idx).AsString:=execParams.ParamByName('PositionName').AsString;
                        end
                        else begin
                            ParamsPersonalComplete_local.ParamByName('PersonalId'+idx+'_Stick').AsInteger:=execParams.ParamByName('PersonalId').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx+'_Stick').AsInteger:=execParams.ParamByName('PersonalCode').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PersonalName'+idx+'_Stick').AsString:=execParams.ParamByName('PersonalName').AsString;
                            ParamsPersonalComplete_local.ParamByName('PositionId'+idx+'_Stick').AsInteger:=execParams.ParamByName('PositionId').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PositionCode'+idx+'_Stick').AsInteger:=execParams.ParamByName('PositionCode').AsInteger;
                            ParamsPersonalComplete_local.ParamByName('PositionName'+idx+'_Stick').AsString:=execParams.ParamByName('PositionName').AsString;
                        end;
                        //
                        fStartWrite:=true;
                        //
                         if idx = '1' then
                         begin
                              EditPersonalCode1.Text:=execParams.ParamByName('PersonalCode').AsString;
                              EditPersonalName1.Text:=execParams.ParamByName('PersonalName').AsString;
                              PanelPositionName1.Caption:=execParams.ParamByName('PositionName').AsString;
                         end;
                         if idx = '2' then
                         begin
                              EditPersonalCode2.Text:=execParams.ParamByName('PersonalCode').AsString;
                              EditPersonalName2.Text:=execParams.ParamByName('PersonalName').AsString;
                              PanelPositionName2.Caption:=execParams.ParamByName('PositionName').AsString;
                         end;
                         if idx = '3' then
                         begin
                              EditPersonalCode3.Text:=execParams.ParamByName('PersonalCode').AsString;
                              EditPersonalName3.Text:=execParams.ParamByName('PersonalName').AsString;
                              PanelPositionName3.Caption:=execParams.ParamByName('PositionName').AsString;
                         end;
                         if idx = '4' then
                         begin
                              EditPersonalCode4.Text:=execParams.ParamByName('PersonalCode').AsString;
                              EditPersonalName4.Text:=execParams.ParamByName('PersonalName').AsString;
                              PanelPositionName4.Caption:=execParams.ParamByName('PositionName').AsString;
                         end;
                         if idx = '5' then
                         begin
                              EditPersonalCode5.Text:=execParams.ParamByName('PersonalCode').AsString;
                              EditPersonalName5.Text:=execParams.ParamByName('PersonalName').AsString;
                              PanelPositionName5.Caption:=execParams.ParamByName('PositionName').AsString;
                         end;
                         if idx = '11' then
                         begin
                              EditPersonalStickCode1.Text:=execParams.ParamByName('PersonalCode').AsString;
                              EditPersonalStickName1.Text:=execParams.ParamByName('PersonalName').AsString;
                              PanelPositionStickName1.Caption:=execParams.ParamByName('PositionName').AsString;
                         end;
                        //
                        fStartWrite:=false;
                        //
                        fChangePersonalCode:=false;
                   end
              else begin
                        if execParams.ParamByName('PersonalId').AsInteger>1
                        then ShowMessage('Ошибка.У сотрудника с кодом <'+IntToStr(PersonalCode)+'> нельзя определить <Должность>.'+#10+#13+'Попробуйте выбрать его из <Справочника>.')
                        else ShowMessage('Ошибка.Не найден сотрудник с кодом <'+IntToStr(PersonalCode)+'>.');
                        ParamsPersonalComplete_local.ParamByName('PersonalId'+idx).AsInteger:=0;
                        //
                        fStartWrite:=true;
                        if idx = '1'  then begin EditPersonalName1.Text:='';      PanelPositionName1.Caption:=''; ActiveControl:=EditPersonalCode1; end;
                        if idx = '2'  then begin EditPersonalName2.Text:='';      PanelPositionName2.Caption:=''; ActiveControl:=EditPersonalCode2; end;
                        if idx = '3'  then begin EditPersonalName3.Text:='';      PanelPositionName3.Caption:=''; ActiveControl:=EditPersonalCode3; end;
                        if idx = '4'  then begin EditPersonalName4.Text:='';      PanelPositionName4.Caption:=''; ActiveControl:=EditPersonalCode4; end;
                        if idx = '5'  then begin EditPersonalName5.Text:='';      PanelPositionName5.Caption:=''; ActiveControl:=EditPersonalCode5; end;
                        if idx = '11' then begin EditPersonalStickName1.Text:=''; PanelPositionStickName1.Caption:=''; ActiveControl:=EditPersonalStickCode1; end;
                        fStartWrite:=false;
                        //
                   end;
              //
              execParams.Free;
         end;
     //
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPersonalCode1PropertiesChange(Sender: TObject);
begin
   if fStartWrite=false
   then fChangePersonalCode:=true;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPersonalName1PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var execParams:TParams;
    idx:String;
begin
     Create_ParamsPersonal(execParams,'');
     //
     idx:=IntToStr(TcxButtonEdit(Sender).Tag);
     //
     with execParams do
     begin
          ParamByName('PersonalId').AsInteger:=ParamsPersonalComplete_local.ParamByName('PersonalId'+idx).AsInteger;
          ParamByName('PersonalCode').AsInteger:=ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx).AsInteger;
     end;
     //
     if GuidePersonalForm.Execute(execParams)
     then begin
               if TcxButtonEdit(Sender).Tag < 10
               then begin
                   ParamsPersonalComplete_local.ParamByName('PersonalId'+idx).AsInteger:=execParams.ParamByName('PersonalId').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx).AsInteger:=execParams.ParamByName('PersonalCode').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PersonalName'+idx).AsString:=execParams.ParamByName('PersonalName').AsString;
                   ParamsPersonalComplete_local.ParamByName('PositionId'+idx).AsInteger:=execParams.ParamByName('PositionId').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PositionCode'+idx).AsInteger:=execParams.ParamByName('PositionCode').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PositionName'+idx).AsString:=execParams.ParamByName('PositionName').AsString;
               end
               else begin
                   ParamsPersonalComplete_local.ParamByName('PersonalId'+idx+'_Stick').AsInteger:=execParams.ParamByName('PersonalId').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PersonalCode'+idx+'_Stick').AsInteger:=execParams.ParamByName('PersonalCode').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PersonalName'+idx+'_Stick').AsString:=execParams.ParamByName('PersonalName').AsString;
                   ParamsPersonalComplete_local.ParamByName('PositionId'+idx+'_Stick').AsInteger:=execParams.ParamByName('PositionId').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PositionCode'+idx+'_Stick').AsInteger:=execParams.ParamByName('PositionCode').AsInteger;
                   ParamsPersonalComplete_local.ParamByName('PositionName'+idx+'_Stick').AsString:=execParams.ParamByName('PositionName').AsString;
               end;
               //
               fStartWrite:=true;
               //
               if idx = '1' then
               begin
                    EditPersonalCode1.Text:=execParams.ParamByName('PersonalCode').AsString;
                    EditPersonalName1.Text:=execParams.ParamByName('PersonalName').AsString;
                    PanelPositionName1.Caption:=execParams.ParamByName('PositionName').AsString;
                    ActiveControl:=EditPersonalCode2;
               end;
               if idx = '2' then
               begin
                    EditPersonalCode2.Text:=execParams.ParamByName('PersonalCode').AsString;
                    EditPersonalName2.Text:=execParams.ParamByName('PersonalName').AsString;
                    PanelPositionName2.Caption:=execParams.ParamByName('PositionName').AsString;
                    ActiveControl:=EditPersonalCode3;
               end;
               if idx = '3' then
               begin
                    EditPersonalCode3.Text:=execParams.ParamByName('PersonalCode').AsString;
                    EditPersonalName3.Text:=execParams.ParamByName('PersonalName').AsString;
                    PanelPositionName3.Caption:=execParams.ParamByName('PositionName').AsString;
                    ActiveControl:=EditPersonalCode4;
               end;
               if idx = '4' then
               begin
                    EditPersonalCode4.Text:=execParams.ParamByName('PersonalCode').AsString;
                    EditPersonalName4.Text:=execParams.ParamByName('PersonalName').AsString;
                    PanelPositionName4.Caption:=execParams.ParamByName('PositionName').AsString;
                    ActiveControl:=EditPersonalCode5;
               end;
               if idx = '5' then
               begin
                    EditPersonalCode5.Text:=execParams.ParamByName('PersonalCode').AsString;
                    EditPersonalName5.Text:=execParams.ParamByName('PersonalName').AsString;
                    PanelPositionName5.Caption:=execParams.ParamByName('PositionName').AsString;
                    ActiveControl:=EditPersonalStickCode1;
               end;
               if idx = '11' then
               begin
                    EditPersonalStickCode1.Text:=execParams.ParamByName('PersonalCode').AsString;
                    EditPersonalStickName1.Text:=execParams.ParamByName('PersonalName').AsString;
                    PanelPositionStickName1.Caption:=execParams.ParamByName('PositionName').AsString;
                    ActiveControl:=bbOk;
               end;
               //
               fStartWrite:=false;
               //
     end;
     //
     execParams.Free;
end;
{------------------------------------------------------------------------------}
end.

