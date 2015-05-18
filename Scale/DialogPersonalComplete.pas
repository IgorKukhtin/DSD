unit DialogPersonalComplete;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialog, StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit,
  CurrEdit,Db, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit,
  cxCurrencyEdit, cxMaskEdit, cxButtonEdit;

type
  TDialogPersonalCompleteForm = class(TAncestorDialogForm)

    infoPanelMember1: TPanel;
    infoPanelMember2: TPanel;
    infoPanelMember3: TPanel;
    infoPanelMember4: TPanel;
    PanelMember1: TPanel;
    PanelMember2: TPanel;
    PanelMember3: TPanel;
    PanelMember4: TPanel;
    PanelPosition1: TPanel;
    PanelPosition2: TPanel;
    PanelPosition3: TPanel;
    PanelPosition4: TPanel;
    PanelPositionName1: TPanel;
    PanelPositionName2: TPanel;
    PanelPositionName3: TPanel;
    PanelPositionName4: TPanel;

    LabelMemberName1: TLabel;
    LabelMemberName2: TLabel;
    LabelMemberName3: TLabel;
    LabelMemberName4: TLabel;
    LabelPositionName1: TLabel;
    LabelPositionName2: TLabel;
    LabelPositionName3: TLabel;
    LabelPositionName4: TLabel;

    gbMemberCode2: TGroupBox;
    gbMemberCode1: TGroupBox;
    gbMemberCode3: TGroupBox;
    gbMemberCode4: TGroupBox;
    gbMemberName1: TGroupBox;
    gbMemberName2: TGroupBox;
    gbMemberName3: TGroupBox;
    gbMemberName4: TGroupBox;
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

    procedure FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure EditPositionCode1Exit(Sender: TObject);
    procedure EditMemberCode1Exit(Sender: TObject);
    procedure EditPositionCode1Enter(Sender: TObject);
    procedure EditPositionCode2Enter(Sender: TObject);
    procedure EditPositionCode3Enter(Sender: TObject);
    procedure EditPositionCode4Enter(Sender: TObject);
    procedure EditMemberCode2Exit(Sender: TObject);
    procedure EditPositionCode2Exit(Sender: TObject);
    procedure EditMemberCode3Exit(Sender: TObject);
    procedure EditMemberCode4Exit(Sender: TObject);
    procedure EditMemberCode1Enter(Sender: TObject);
    procedure EditPositionCode3Exit(Sender: TObject);
    procedure EditPositionCode4Exit(Sender: TObject);
    procedure EditMemberName1ButtonClick(Sender: TObject);
    procedure EditMemberName2ButtonClick(Sender: TObject);
    procedure EditMemberName3ButtonClick(Sender: TObject);
    procedure EditMemberName4ButtonClick(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    isCheckZakaz:Smallint;
    BillDate:TDateTime;
    FromId,ToId:Integer;
  end;

implementation
uses ConstFromServer,UtilDB,MessageShow,GuideMemberProduction;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogPersonalCompleteForm.Checked: boolean; //Проверка корректного ввода в Edit
var MemberCode1,PositionCode1:Integer;
    MemberCode2,PositionCode2:Integer;
    MemberCode3,PositionCode3:Integer;
    MemberCode4,PositionCode4:Integer;
begin
     Result:=false;
     //
     try MemberCode1:=StrToInt(EditMemberCode1.Text) except MemberCode1:=0 end;
     try PositionCode1:=StrToInt(EditPositionCode1.Text) except PositionCode1:=0 end;
     try MemberCode2:=StrToInt(EditMemberCode2.Text) except MemberCode2:=0 end;
     try PositionCode2:=StrToInt(EditPositionCode2.Text) except PositionCode2:=0 end;
     try MemberCode3:=StrToInt(EditMemberCode3.Text) except MemberCode3:=0 end;
     try PositionCode3:=StrToInt(EditPositionCode3.Text) except PositionCode3:=0 end;
     try MemberCode4:=StrToInt(EditMemberCode4.Text) except MemberCode4:=0 end;
     try PositionCode4:=StrToInt(EditPositionCode4.Text) except PositionCode4:=0 end;
     //
     EditPositionCode1Exit(EditPositionCode1);
     Result:=(trim(EditMemberName1.Text)<>'')and(trim(EditMemberName1.Text)<>_strNotFindValue)and(PanelPositionName1.Caption<>_strNotFindValue);
     if not Result then
     begin if (MemberCode1=0)and(trim(EditMemberName1.Text)='') then begin ActiveControl:=EditMemberCode1;ShowMessage('Введите Код для Комплектовщик 1.');end
           else if (trim(EditMemberName1.Text)='')or(trim(EditMemberName1.Text)=_strNotFindValue)then begin ActiveControl:=EditMemberCode1;ShowMessage('Введите Код для Комплектовщик 1.');end
                else begin ActiveControl:=EditPositionCode1;ShowMessage('Введите Код должности для Комплектовщик 1.');end;
           exit;
     end;
     //
     if (trim(EditMemberName2.Text)<>'')or(MemberCode2<>0)or(trim(EditMemberName3.Text)<>'')or(MemberCode3<>0)or(trim(EditMemberName4.Text)<>'')or(MemberCode4<>0)then
     begin
          EditPositionCode2Exit(EditPositionCode2);
          Result:=(trim(EditMemberName2.Text)<>'')and(trim(EditMemberName2.Text)<>_strNotFindValue)and(PanelPositionName2.Caption<>_strNotFindValue);
          if not Result then
          begin if (MemberCode2=0)and(trim(EditMemberName2.Text)='') then begin ActiveControl:=EditMemberCode2;ShowMessage('Введите Код для Комплектовщик 2.');end
                else if (trim(EditMemberName2.Text)='')or(trim(EditMemberName2.Text)=_strNotFindValue)then begin ActiveControl:=EditMemberCode2;ShowMessage('Введите Код для Комплектовщик 2.');end
                     else begin ActiveControl:=EditPositionCode2;ShowMessage('Введите Код должности для Комплектовщик 2.');end;
                exit;
          end;
     end;
     //
     if (trim(EditMemberName3.Text)<>'')or(MemberCode3<>0)or(trim(EditMemberName4.Text)<>'')or(MemberCode4<>0)then
     begin
          EditPositionCode3Exit(EditPositionCode3);
          Result:=(trim(EditMemberName3.Text)<>'')and(trim(EditMemberName3.Text)<>_strNotFindValue)and(PanelPositionName3.Caption<>_strNotFindValue);
          if not Result then
          begin if (MemberCode3=0)and(trim(EditMemberName3.Text)='') then begin ActiveControl:=EditMemberCode3;ShowMessage('Введите Код для Комплектовщик 3.');end
                else if (trim(EditMemberName3.Text)='')or(trim(EditMemberName3.Text)=_strNotFindValue)then begin ActiveControl:=EditMemberCode3;ShowMessage('Введите Код для Комплектовщик 3.');end
                     else begin ActiveControl:=EditPositionCode3;ShowMessage('Введите Код должности для Комплектовщик 3.');end;
                exit;
          end;
     end;
     //
     if (trim(EditMemberName4.Text)<>'')or(MemberCode4<>0) then
     begin
          EditPositionCode4Exit(EditPositionCode4);
          Result:=(trim(EditMemberName4.Text)<>'')and(trim(EditMemberName4.Text)<>_strNotFindValue)and(PanelPositionName4.Caption<>_strNotFindValue);
          if not Result then
          begin if (MemberCode4=0)and(trim(EditMemberName4.Text)='') then begin ActiveControl:=EditMemberCode4;ShowMessage('Введите Код для Комплектовщик 4.');end
                else if (trim(EditMemberName4.Text)='')or(trim(EditMemberName4.Text)=_strNotFindValue)then begin ActiveControl:=EditMemberCode4;ShowMessage('Введите Код для Комплектовщик 4.');end
                     else begin ActiveControl:=EditPositionCode4;ShowMessage('Введите Код должности для Комплектовщик 4.');end;
                exit;
          end;
     end;
     //
     if isCheckZakaz=zc_rvYes then
     begin
          Result:=0<>StrToInt(GetStringValue('select fGet_BillId_byZakaz_find('+FormatToDateServer(BillDate)+','+IntToStr(FromID)+','+IntToStr(ToID)+','+FormatToVarCharServer(trim(EditInvNumberZakaz.Text))+')as RetV'));
          if not Result
          then
              if TypeShowMessage ('Ошибка.№ заявки введен неправильно.Продолжить?', mtConfirmation, mbYesNoCancel, 0) <> 6
              then Result:=false
              else if TypeShowMessage ('Ошибка.№ заявки введен неправильно.Продолжить?', mtConfirmation, mbYesNoCancel, 0) <> 6
                   then Result:=false
                   else if TypeShowMessage ('Ошибка.№ заявки введен неправильно.Продолжить?', mtConfirmation, mbYesNoCancel, 0) <> 6
                        then Result:=false
                        else Result:=true;
          if not Result then begin ActiveControl:=EditInvNumberZakaz;exit;end;
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key=13 then
      if (ActiveControl=EditMemberCode1)then ActiveControl:=EditMemberName1
      else if (ActiveControl=EditMemberName1)then ActiveControl:=EditPositionCode1
           else if (ActiveControl=EditPositionCode1)then ActiveControl:=EditMemberCode2
                else if (ActiveControl=EditMemberCode2)then ActiveControl:=EditMemberName2
                     else if ActiveControl=EditMemberName2 then ActiveControl:=EditPositionCode2
                          else if ActiveControl=EditPositionCode2 then ActiveControl:=EditMemberCode3
                               else if ActiveControl=EditMemberCode3 then ActiveControl:=EditMemberName3
                                    else if ActiveControl=EditMemberName3 then ActiveControl:=EditPositionCode3
                                         else if ActiveControl=EditPositionCode3 then ActiveControl:=EditMemberCode4
                                              else if ActiveControl=EditMemberCode4 then ActiveControl:=EditMemberName4
                                                   else if ActiveControl=EditMemberName4 then ActiveControl:=EditPositionCode4
                                                         else if ActiveControl=EditPositionCode4 then bbOkClick(self);
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberCode1Enter(Sender: TObject);
begin TEdit(Sender).SelectAll;end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode1Enter(Sender: TObject);
begin
  try
     //if StrToInt(EditMemberCode1.Text)>0 then ActiveControl:=EditMemberCode2
     //else
     TEdit(Sender).SelectAll;
  except TEdit(Sender).SelectAll;
  end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode2Enter(Sender: TObject);
begin
  try
     //if StrToInt(EditMemberCode2.Text)>0 then ActiveControl:=EditMemberCode3
     //else
     TEdit(Sender).SelectAll;
  except TEdit(Sender).SelectAll;
  end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode3Enter(Sender: TObject);
begin
  try
     //if StrToInt(EditMemberCode3.Text)>0 then ActiveControl:=EditMemberCode4
     //else
     TEdit(Sender).SelectAll;
  except TEdit(Sender).SelectAll;
  end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode4Enter(Sender: TObject);
begin
  try
     //if StrToInt(EditMemberCode4.Text)>0 then ActiveControl:=bbOk
     //else
     TEdit(Sender).SelectAll;
  except TEdit(Sender).SelectAll;
  end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberCode1Exit(Sender: TObject);
var ParamsMember:TParams;
    MemberCode,PositionCode:Integer;
begin
     try MemberCode:=StrToInt(trim(EditMemberCode1.Text));except MemberCode:=0;end;
     try PositionCode:=StrToInt(trim(EditPositionCode1.Text));except PositionCode:=0;end;
     //
     if MemberCode <> 0 then
     begin
          ParamsMember:=GetAllFieldsQueryValue(' select MemberProductionName as MemberName, isnull(PositionMemberCode,0) as PositionCode, isnull(PositionMemberName,'+FormatToVarCharServer('')+')as PositionName'
                                              +' from dba.MemberProduction'
                                              +'      left outer join dba.PositionMember on PositionMember.Id = MemberProduction.PositionMemberId'
                                              +' where MemberProductionCode = '+IntToStr(MemberCode));
          if not Assigned(ParamsMember) then
          begin
               ActiveControl:=EditMemberCode1;
               EditMemberName1.Text:=_strNotFindValue;
               exit;
          end;
          EditMemberName1.Text:=ParamsMember.ParamByName('MemberName').AsString;
          EditPositionCode1.Text:=ParamsMember.ParamByName('PositionCode').AsString;
          if ParamsMember.ParamByName('PositionCode').AsInteger>0
          then PanelPositionName1.Caption:=ParamsMember.ParamByName('PositionName').AsString
          else PanelPositionName1.Caption:=_strNotFindValue;
          ParamsMember.Free;
     end;
     //else begin EditMemberName1.Text:='';EditPositionCode1.Text:='0';PanelPositionName1.Caption:=_strNotFindValue;end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberCode2Exit(Sender: TObject);
var ParamsMember:TParams;
    MemberCode,PositionCode:Integer;
begin
     try MemberCode:=StrToInt(trim(EditMemberCode2.Text));except MemberCode:=0;end;
     try PositionCode:=StrToInt(trim(EditPositionCode2.Text));except PositionCode:=0;end;
     //
     if MemberCode <> 0 then
     begin
          ParamsMember:=GetAllFieldsQueryValue(' select MemberProductionName as MemberName, isnull(PositionMemberCode,0) as PositionCode, isnull(PositionMemberName,'+FormatToVarCharServer('')+')as PositionName'
                                              +' from dba.MemberProduction'
                                              +'      left outer join dba.PositionMember on PositionMember.Id = MemberProduction.PositionMemberId'
                                              +' where MemberProductionCode = '+IntToStr(MemberCode));
          if not Assigned(ParamsMember) then
          begin
               ActiveControl:=EditMemberCode2;
               EditMemberName2.Text:=_strNotFindValue;
               exit;
          end;
          EditMemberName2.Text:=ParamsMember.ParamByName('MemberName').AsString;
          EditPositionCode2.Text:=ParamsMember.ParamByName('PositionCode').AsString;
          if ParamsMember.ParamByName('PositionCode').AsInteger>0
          then PanelPositionName2.Caption:=ParamsMember.ParamByName('PositionName').AsString
          else PanelPositionName2.Caption:=_strNotFindValue;
          ParamsMember.Free;
     end;
     //else begin EditMemberName2.Text:='';EditPositionCode2.Text:='0';PanelPositionName2.Caption:=_strNotFindValue;end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberCode3Exit(Sender: TObject);
var ParamsMember:TParams;
    MemberCode,PositionCode:Integer;
begin
     try MemberCode:=StrToInt(trim(EditMemberCode3.Text));except MemberCode:=0;end;
     try PositionCode:=StrToInt(trim(EditPositionCode3.Text));except PositionCode:=0;end;
     //
     if MemberCode <> 0 then
     begin
          ParamsMember:=GetAllFieldsQueryValue(' select MemberProductionName as MemberName, isnull(PositionMemberCode,0) as PositionCode, isnull(PositionMemberName,'+FormatToVarCharServer('')+')as PositionName'
                                              +' from dba.MemberProduction'
                                              +'      left outer join dba.PositionMember on PositionMember.Id = MemberProduction.PositionMemberId'
                                              +' where MemberProductionCode = '+IntToStr(MemberCode));
          if not Assigned(ParamsMember) then
          begin
               ActiveControl:=EditMemberCode3;
               EditMemberName3.Text:=_strNotFindValue;
               exit;
          end;
          EditMemberName3.Text:=ParamsMember.ParamByName('MemberName').AsString;
          EditPositionCode3.Text:=ParamsMember.ParamByName('PositionCode').AsString;
          if ParamsMember.ParamByName('PositionCode').AsInteger>0
          then PanelPositionName3.Caption:=ParamsMember.ParamByName('PositionName').AsString
          else PanelPositionName3.Caption:=_strNotFindValue;
          ParamsMember.Free;
     end;
     //else begin EditMemberName3.Text:='';EditPositionCode3.Text:='0';PanelPositionName3.Caption:=_strNotFindValue;end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberCode4Exit(Sender: TObject);
var ParamsMember:TParams;
    MemberCode,PositionCode:Integer;
begin
     try MemberCode:=StrToInt(trim(EditMemberCode4.Text));except MemberCode:=0;end;
     try PositionCode:=StrToInt(trim(EditPositionCode4.Text));except PositionCode:=0;end;
     //
     if MemberCode <> 0 then
     begin
          ParamsMember:=GetAllFieldsQueryValue(' select MemberProductionName as MemberName, isnull(PositionMemberCode,0) as PositionCode, isnull(PositionMemberName,'+FormatToVarCharServer('')+')as PositionName'
                                              +' from dba.MemberProduction'
                                              +'      left outer join dba.PositionMember on PositionMember.Id = MemberProduction.PositionMemberId'
                                              +' where MemberProductionCode = '+IntToStr(MemberCode));
          if not Assigned(ParamsMember) then
          begin
               ActiveControl:=EditMemberCode3;
               EditMemberName4.Text:=_strNotFindValue;
               exit;
          end;
          EditMemberName4.Text:=ParamsMember.ParamByName('MemberName').AsString;
          EditPositionCode4.Text:=ParamsMember.ParamByName('PositionCode').AsString;
          if ParamsMember.ParamByName('PositionCode').AsInteger>0
          then PanelPositionName4.Caption:=ParamsMember.ParamByName('PositionName').AsString
          else PanelPositionName4.Caption:=_strNotFindValue;
          ParamsMember.Free;
     end;
     //else begin EditMemberName4.Text:='';EditPositionCode4.Text:='0';PanelPositionName4.Caption:=_strNotFindValue;end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode1Exit(Sender: TObject);
var PositionCode:Integer;
begin
     try PositionCode:=StrToInt(trim(EditPositionCode1.Text));except PositionCode:=0;end;
     //
     if PositionCode <> 0 then PanelPositionName1.Caption:=GetStringValue('select PositionMemberName as RetV from dba.PositionMember where Id<100 and PositionMemberCode = '+IntToStr(PositionCode))
     else PanelPositionName1.Caption:=_strNotFindValue;
     if PanelPositionName1.Caption='' then PanelPositionName1.Caption:=_strNotFindValue;
     //
     if (PanelPositionName1.Caption=_strNotFindValue)and(PositionCode<>0)
     then ActiveControl:=EditPositionCode1;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode2Exit(Sender: TObject);
var PositionCode:Integer;
begin
     try PositionCode:=StrToInt(trim(EditPositionCode2.Text));except PositionCode:=0;end;
     //
     if PositionCode <> 0 then PanelPositionName2.Caption:=GetStringValue('select PositionMemberName as RetV from dba.PositionMember where Id<100 and PositionMemberCode = '+IntToStr(PositionCode))
     else PanelPositionName2.Caption:=_strNotFindValue;
     if PanelPositionName2.Caption='' then PanelPositionName2.Caption:=_strNotFindValue;
     //
     if (PanelPositionName2.Caption=_strNotFindValue)and(PositionCode<>0)
     then ActiveControl:=EditPositionCode2;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode3Exit(Sender: TObject);
var PositionCode:Integer;
begin
     try PositionCode:=StrToInt(trim(EditPositionCode3.Text));except PositionCode:=0;end;
     //
     if PositionCode <> 0 then PanelPositionName3.Caption:=GetStringValue('select PositionMemberName as RetV from dba.PositionMember where Id<100 and PositionMemberCode = '+IntToStr(PositionCode))
     else PanelPositionName3.Caption:=_strNotFindValue;
     if PanelPositionName3.Caption='' then PanelPositionName3.Caption:=_strNotFindValue;
     //
     if (PanelPositionName3.Caption=_strNotFindValue)and(PositionCode<>0)
     then ActiveControl:=EditPositionCode3;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditPositionCode4Exit(Sender: TObject);
var PositionCode:Integer;
begin
     try PositionCode:=StrToInt(trim(EditPositionCode4.Text));except PositionCode:=0;end;
     //
     if PositionCode <> 0 then PanelPositionName4.Caption:=GetStringValue('select PositionMemberName as RetV from dba.PositionMember where Id<100 and PositionMemberCode = '+IntToStr(PositionCode))
     else PanelPositionName4.Caption:=_strNotFindValue;
     if PanelPositionName4.Caption='' then PanelPositionName4.Caption:=_strNotFindValue;
     //
     if (PanelPositionName4.Caption=_strNotFindValue)and(PositionCode<>0)
     then ActiveControl:=EditPositionCode4;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberName1ButtonClick(Sender: TObject);
var execParams:TParams;
    MemberCode:Integer;
begin
    try MemberCode:=StrToInt(trim(EditMemberCode1.Text))except MemberCode:=0;end;
    execParams:=nil;
    ParamAddValue(execParams,'MemberId',ftInteger,0);
    ParamAddValue(execParams,'MemberCode',ftInteger,MemberCode);
    ParamAddValue(execParams,'MemberName',ftString,'');
    ParamAddValue(execParams,'PositionId',ftInteger,0);
    ParamAddValue(execParams,'PositionCode',ftInteger,0);
    ParamAddValue(execParams,'PositionName',ftString,'');
    //
     with TGuideMemberProductionForm.Create(nil) do begin
         Execute(execParams);
         Free;
     end;
     //
     if execParams.ParamByName('MemberCode').AsInteger<>0
     then begin
               EditMemberCode1.Text:=execParams.ParamByName('MemberCode').AsString;
               EditMemberName1.Text:=execParams.ParamByName('MemberName').AsString;
               EditPositionCode1.Text:=execParams.ParamByName('PositionCode').AsString;
               PanelPositionName1.Caption:=execParams.ParamByName('PositionName').AsString;
     end;
     //
     execParams.Free;
     ActiveControl:=EditMemberCode2;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberName2ButtonClick(Sender: TObject);
var execParams:TParams;
    MemberCode:Integer;
begin
    try MemberCode:=StrToInt(trim(EditMemberCode2.Text))except MemberCode:=0;end;
    execParams:=nil;
    ParamAddValue(execParams,'MemberId',ftInteger,0);
    ParamAddValue(execParams,'MemberCode',ftInteger,MemberCode);
    ParamAddValue(execParams,'MemberName',ftString,'');
    ParamAddValue(execParams,'PositionId',ftInteger,0);
    ParamAddValue(execParams,'PositionCode',ftInteger,0);
    ParamAddValue(execParams,'PositionName',ftString,'');
    //
     with TGuideMemberProductionForm.Create(nil) do begin
         Execute(execParams);
         Free;
     end;
     //
     if execParams.ParamByName('MemberCode').AsInteger<>0
     then begin
               EditMemberCode2.Text:=execParams.ParamByName('MemberCode').AsString;
               EditMemberName2.Text:=execParams.ParamByName('MemberName').AsString;
               EditPositionCode2.Text:=execParams.ParamByName('PositionCode').AsString;
               PanelPositionName2.Caption:=execParams.ParamByName('PositionName').AsString;
     end;
     //
     execParams.Free;
     ActiveControl:=EditMemberCode3;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberName3ButtonClick(Sender: TObject);
var execParams:TParams;
    MemberCode:Integer;
begin
    try MemberCode:=StrToInt(trim(EditMemberCode3.Text))except MemberCode:=0;end;
    execParams:=nil;
    ParamAddValue(execParams,'MemberId',ftInteger,0);
    ParamAddValue(execParams,'MemberCode',ftInteger,MemberCode);
    ParamAddValue(execParams,'MemberName',ftString,'');
    ParamAddValue(execParams,'PositionId',ftInteger,0);
    ParamAddValue(execParams,'PositionCode',ftInteger,0);
    ParamAddValue(execParams,'PositionName',ftString,'');
    //
     with TGuideMemberProductionForm.Create(nil) do begin
         Execute(execParams);
         Free;
     end;
     //
     if execParams.ParamByName('MemberCode').AsInteger<>0
     then begin
               EditMemberCode3.Text:=execParams.ParamByName('MemberCode').AsString;
               EditMemberName3.Text:=execParams.ParamByName('MemberName').AsString;
               EditPositionCode3.Text:=execParams.ParamByName('PositionCode').AsString;
               PanelPositionName3.Caption:=execParams.ParamByName('PositionName').AsString;
     end;
     //
     execParams.Free;
     ActiveControl:=EditMemberCode4;
end;
{------------------------------------------------------------------------------}
procedure TDialogPersonalCompleteForm.EditMemberName4ButtonClick(Sender: TObject);
var execParams:TParams;
    MemberCode:Integer;
begin
    try MemberCode:=StrToInt(trim(EditMemberCode4.Text))except MemberCode:=0;end;
    execParams:=nil;
    ParamAddValue(execParams,'MemberId',ftInteger,0);
    ParamAddValue(execParams,'MemberCode',ftInteger,MemberCode);
    ParamAddValue(execParams,'MemberName',ftString,'');
    ParamAddValue(execParams,'PositionId',ftInteger,0);
    ParamAddValue(execParams,'PositionCode',ftInteger,0);
    ParamAddValue(execParams,'PositionName',ftString,'');
    //
     with TGuideMemberProductionForm.Create(nil) do begin
         Execute(execParams);
         Free;
     end;
     //
     if execParams.ParamByName('MemberCode').AsInteger<>0
     then begin
               EditMemberCode4.Text:=execParams.ParamByName('MemberCode').AsString;
               EditMemberName4.Text:=execParams.ParamByName('MemberName').AsString;
               EditPositionCode4.Text:=execParams.ParamByName('PositionCode').AsString;
               PanelPositionName4.Caption:=execParams.ParamByName('PositionName').AsString;
     end;
     //
     execParams.Free;
     ActiveControl:=bbOk;
end;
{------------------------------------------------------------------------------}
end.

