unit EnterLoyaltySaveMoney;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, System.RegularExpressions, Data.DB, Datasnap.DBClient,
  dsdDB;

type
  TEnterLoyaltySaveMoneyForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    edMaskNumber: TcxMaskEdit;
    Label1: TLabel;
    pn1: TPanel;
    pn2: TPanel;
    BuyerCDS: TClientDataSet;
    spSelectObjectBuyer: TdsdStoredProc;
    edMaskName: TcxMaskEdit;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edMaskNumberPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure BuyerCDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure bbCancelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FID : integer;
    FPhone : String;
    FName : String;
    FLoyaltySMID : integer;
    FisFormClose : Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

function InputEnterLoyaltySaveMoney(var AID : integer; var APhone, AName : string; var ALoyaltySMID : integer) : boolean;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, BuyerList;

procedure TEnterLoyaltySaveMoneyForm.bbCancelKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

   if Key in [$30..$39, $60..$69] then
   begin
     edMaskNumber.SetFocus;
     edMaskNumber.SelectAll;
     PostMessage(edMaskNumber.Handle, WM_KEYDOWN, Key, 0);
   end;
   if Key in [$41..$5A, $DB, $DD, $BA, $DE, $DC, $BC, $BE, $BF, $C0] then
   begin
     edMaskName.SetFocus;
     edMaskName.SelectAll;
     PostMessage(edMaskName.Handle, WM_KEYDOWN, Key, 0);
   end;

end;

procedure TEnterLoyaltySaveMoneyForm.BuyerCDSFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
  Var S,S1:String; k:integer; F:Boolean;
begin
  S1 := Trim(edMaskName.Text);
  if S1 = '' then exit;
  Accept:=true;

  repeat
    k:=pos(' ',S1);
    if K = 0 then k:=length(S1)+1;
    s := Trim(copy(S1,1,k-1));
    S1 := Trim(copy(S1,k,Length(S1)));

    F := Pos(AnsiUpperCase(s), AnsiUpperCase(DataSet.FieldByName('Name').AsString)) > 0;

    Accept:=Accept AND F;
  until (S1='') or (Accept = False);
end;

procedure TEnterLoyaltySaveMoneyForm.edMaskNumberPropertiesValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin
  Error := Error and FisFormClose;
end;

procedure TEnterLoyaltySaveMoneyForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  try
    FisFormClose := True;
    if edMaskName.Text = '' then
    try
      edMaskNumber.ValidateEdit(True);
    except
      ShowMessage('Ошибка ввода номера телефона.');
      Action := caNone;
      Exit;
    end;

    if gc_User.Local then
    begin
      BuyerCDS.Close;
      BuyerCDS.Filtered := False;
      WaitForSingleObject(MutexBuyer, INFINITE);
      try
        if FileExists(Buyer_lcl) then
        begin
          LoadLocalData(BuyerCDS, Buyer_lcl);
          if not BuyerCDS.Active then BuyerCDS.Open;
        end;
      finally
        ReleaseMutex(MutexBuyer);
      end;

      if BuyerCDS.Active then
      begin
        if edMaskName.Text <> '' then BuyerCDS.OnFilterRecord := BuyerCDSFilterRecord
        else BuyerCDS.Filter := 'Phone = ''' + edMaskNumber.Text + '''';
        BuyerCDS.Filtered := True;
        BuyerCDS.First;
      end else
      begin
        ShowMessage('Ошибка загрузки справочника покупатедлей.');
        Action := caNone;
        Exit;
      end;
    end else
    begin
      try
        if FPhone = '' then
        begin
          spSelectObjectBuyer.ParamByName('inPhone').Value := edMaskNumber.Text;
          spSelectObjectBuyer.ParamByName('inName').Value  := edMaskName.Text;
          spSelectObjectBuyer.Execute;
        end;
      except on E: Exception do
        begin
          ShowMessage('Ошибка получения информации о покупателе: ' + #13#10 + E.Message);
          Action := caNone;
          Exit;
        end;
      end;
    end;

    if BuyerCDS.RecordCount = 1 then
    begin
      if not BuyerCDS.FieldByName('isErased').AsBoolean then
      begin
        FID := BuyerCDS.FieldByName('Id').AsInteger;
        FPhone :=  BuyerCDS.FieldByName('Phone').AsString;
        FName := BuyerCDS.FieldByName('Name').AsString;
        if Assigned(BuyerCDS.FindField('LoyaltySMID')) then FLoyaltySMID := BuyerCDS.FieldByName('LoyaltySMID').AsInteger;
      end else ShowMessage('Учетная запись покупателя ' + BuyerCDS.FieldByName('Name').AsString + ' удалена.');
    end else if BuyerCDS.RecordCount > 1 then
    begin
      if ShowBuyerList then
      begin
        if not BuyerCDS.FieldByName('isErased').AsBoolean then
        begin
          FID := BuyerCDS.FieldByName('Id').AsInteger;
          FPhone :=  BuyerCDS.FieldByName('Phone').AsString;
          FName := BuyerCDS.FieldByName('Name').AsString;
          if Assigned(BuyerCDS.FindField('LoyaltySMID')) then FLoyaltySMID := BuyerCDS.FieldByName('LoyaltySMID').AsInteger;
        end else ShowMessage('Учетная запись покупателя ' + BuyerCDS.FieldByName('Name').AsString + ' удалена.');
      end else
      begin
        Action := caNone;
        Exit;
      end;
    end else
    begin
      ShowMessage('По номеру телефона ' + edMaskNumber.Text + ' покупатель не найден.');
      Action := caNone;
      Exit;
    end;

  finally
    BuyerCDS.Filtered := False;
    BuyerCDS.Filter := '';
    BuyerCDS.OnFilterRecord := Nil;
    FisFormClose := False;
  end;
end;


function InputEnterLoyaltySaveMoney(var AID : integer; var APhone, AName : string; var ALoyaltySMID : integer) : boolean;
  var EnterLoyaltySaveMoneyForm : TEnterLoyaltySaveMoneyForm;
begin
  EnterLoyaltySaveMoneyForm := TEnterLoyaltySaveMoneyForm.Create(Screen.ActiveControl);
  try
    EnterLoyaltySaveMoneyForm.FId := 0;
    EnterLoyaltySaveMoneyForm.FPhone := '';
    EnterLoyaltySaveMoneyForm.FName := '';
    EnterLoyaltySaveMoneyForm.FLoyaltySMID := 0;
    EnterLoyaltySaveMoneyForm.FisFormClose := False;
    Result := EnterLoyaltySaveMoneyForm.ShowModal = mrOk;
    AId := EnterLoyaltySaveMoneyForm.FId;
    APhone := EnterLoyaltySaveMoneyForm.FPhone;
    AName := EnterLoyaltySaveMoneyForm.FName;
    ALoyaltySMID := EnterLoyaltySaveMoneyForm.FLoyaltySMID;
  finally
    EnterLoyaltySaveMoneyForm.Free;
  end;
end;

end.
