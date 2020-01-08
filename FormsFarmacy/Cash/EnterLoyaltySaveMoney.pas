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
    MutexBuyerCDS: TClientDataSet;
    spSelectObjectBuyerId: TdsdStoredProc;
    spInsertObjectBuyer: TdsdStoredProc;
    edMaskName: TcxMaskEdit;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FID : integer;
    FPhone : String;
    FName : String;
    FLoyaltySMID : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

function InputEnterLoyaltySaveMoney(var AID : integer; var APhone, AName : string; var ALoyaltySMID : integer) : boolean;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit;

procedure TEnterLoyaltySaveMoneyForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    try
      if edMaskNumber.ValidateEdit(True) then
      begin
        if gc_User.Local then
        begin
          MutexBuyerCDS.Close;
          MutexBuyerCDS.Filtered := False;
          WaitForSingleObject(MutexBuyer, INFINITE);
          try
            if FileExists(Buyer_lcl) then
            begin
              LoadLocalData(MutexBuyerCDS, Buyer_lcl);
              if not MutexBuyerCDS.Active then MutexBuyerCDS.Open;
            end;
          finally
            ReleaseMutex(MutexBuyer);
          end;

          if MutexBuyerCDS.Active then
          begin
            MutexBuyerCDS.Filter := 'Phone = ''' + edMaskNumber.Text + '''';
            MutexBuyerCDS.Filtered := True;
            MutexBuyerCDS.First;
            if not MutexBuyerCDS.Eof then
            begin
              if not MutexBuyerCDS.FieldByName('isErased').AsBoolean then
              begin
                FID := MutexBuyerCDS.FieldByName('Id').AsInteger;
                FPhone :=  MutexBuyerCDS.FieldByName('Phone').AsString;
                FName := MutexBuyerCDS.FieldByName('Name').AsString;
                FLoyaltySMID := MutexBuyerCDS.FieldByName('LoyaltySMID').AsInteger;
              end else ShowMessage('Учетная запись покупателя ' + MutexBuyerCDS.FieldByName('Name').AsString + ' удалена.');
            end else
            begin
              ShowMessage('По номеру телефона ' + edMaskNumber.Text + ' покупатель не найден.');
              Action := caNone;
            end;
          end else
          begin
            ShowMessage('Ошибка загрузки справочника покупатедлей.');
            Action := caNone;
          end;
        end else
        begin
          try
            if FPhone = '' then
            begin
              spSelectObjectBuyerId.ParamByName('inPhone').Value := edMaskNumber.Text;
              spSelectObjectBuyerId.ParamByName('Id').Value := 0;
              spSelectObjectBuyerId.Execute;
              if spSelectObjectBuyerId.ParamByName('Id').Value = 0 then
              begin
                if FPhone = '' then
                begin
                  if MessageDlg('По номеру телефона ' + edMaskNumber.Text + ' покупатель не найден.'#13#10#13#10 +
                     'Создать карточку нового покупателя?', mtConfirmation, mbYesNo, 0) = mrYes then
                  begin
                    Label1.Caption := 'Подтвердите номер телефона покупателя';
                    FPhone := edMaskNumber.Text;
                    edMaskNumber.Text := '';
                    Label2.Visible := True;
                    edMaskName.Visible := True;
                    edMaskName.Text := '';
                    Action := caNone;
                  end;
                end;
              end else
              begin
                if not spSelectObjectBuyerId.ParamByName('isErased').Value then
                begin
                  FID := spSelectObjectBuyerId.ParamByName('Id').Value;
                  FPhone :=  spSelectObjectBuyerId.ParamByName('Phone').Value;
                  FName := spSelectObjectBuyerId.ParamByName('Name').Value;
                end else ShowMessage('Учетная запись покупателя ' + spSelectObjectBuyerId.ParamByName('Name').Value + ' удалена.');
              end;
            end else
            begin
              if FPhone <> edMaskNumber.Text then
              begin
                ShowMessage('Ошибка подтверждения номера телефона.');
                Action := caNone;
                Exit;
              end;
              if Trim(edMaskName.Text) = '' then
              begin
                ShowMessage('Ошибка не заполнено Фамилия Имя Отчество покупателя.');
                Action := caNone;
                Exit;
              end;

              spInsertObjectBuyer.ParamByName('ioId').Value := 0;
              spInsertObjectBuyer.ParamByName('inPhone').Value := edMaskNumber.Text;
              spInsertObjectBuyer.ParamByName('inName').Value := edMaskName.Text;
              spInsertObjectBuyer.Execute;

              spSelectObjectBuyerId.ParamByName('inPhone').Value := edMaskNumber.Text;
              spSelectObjectBuyerId.ParamByName('Id').Value := 0;
              spSelectObjectBuyerId.Execute;
              if spSelectObjectBuyerId.ParamByName('Id').Value <> 0 then
              begin
                FID := spSelectObjectBuyerId.ParamByName('Id').Value;
                FPhone :=  spSelectObjectBuyerId.ParamByName('Phone').Value;
                FName := spSelectObjectBuyerId.ParamByName('Name').Value;
              end else ShowMessage('Учетная запись покупателя ' + edMaskNumber.Text + ' не создана.');
            end;
          except on E: Exception do
            ShowMessage('Ошибка получения информации о покупателе: ' + #13#10 + E.Message);
          end;
        end;
      end;
    except
      ShowMessage('Ошибка ввода номера телефона.');
      Action := caNone;
    end;
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
