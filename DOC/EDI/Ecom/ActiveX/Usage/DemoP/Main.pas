unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ComObj;

type
  TTestForm = class(TForm)
    SplitterImage1: TImage;
    RoleLabel: TLabel;
    SplitterImage2: TImage;
    SignLabel: TLabel;
    InitializeButton: TButton;
    DataEdit: TEdit;
    SignButton: TButton;
    VerifyButton: TButton;
    ResetButton: TButton;
    ResultLabel: TLabel;
    ResultRichEdit: TRichEdit;
    SplitterImage3: TImage;
    SplitterImage4: TImage;
    SignEdit: TEdit;
    SplitterImage5: TImage;
    SignInfoLabel: TLabel;
    SignInfoRichEdit: TRichEdit;
    AppendSignButton: TButton;
    VerifyAllButton: TButton;
    GetSignersInfoButton: TButton;
    CertRichEdit: TRichEdit;
    CertLabel: TLabel;
    ShowFullInfoCheckBox: TCheckBox;
    procedure InitializeButtonClick(Sender: TObject);
    procedure SignButtonClick(Sender: TObject);
    procedure VerifyButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure AppendSignButtonClick(Sender: TObject);
    procedure VerifyAllButtonClick(Sender: TObject);
    procedure GetSignersInfoButtonClick(Sender: TObject);

    procedure MakeCertificateInfoEx(RichBox: TRichEdit; CertInfoEx: Variant);
    procedure MakeSignInfoEx(RichBox: TRichEdit; SignInfoEx: Variant);

  private
    EUSignFlexCube: Variant;

  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  TestForm: TTestForm;

implementation

{$R *.dfm}

constructor TTestForm.Create(AOwner: TComponent);
begin
  inherited;

  ResetButtonClick(nil);
end;

procedure TTestForm.MakeCertificateInfoEx(RichBox: TRichEdit; CertInfoEx: Variant);
begin
  RichBox.Lines.Add('ЦСК: ' + certInfoEx.GetIssuerCN);
  RichBox.Lines.Add('S/N: ' + certInfoEx.GetSerial);
  RichBox.Lines.Add('Власник: ' + certInfoEx.GetSubjCN);
  RichBox.Lines.Add('Час дії сертифіката: ' +
    DateTimeToStr(certInfoEx.GetCertBeginTime) + ' - ' +
    DateTimeToStr(certInfoEx.GetCertEndTime));
  RichBox.Lines.Add('Відкритий ключ: ' + certInfoEx.GetPublicKey);
  RichBox.Lines.Add('Призначення ключа: ' + certInfoEx.GetKeyUsage);

  if(certInfoEx.IsPowerCert) then
  begin
    RichBox.Lines.Add('Сертифікат посилений');
  end
  else
    RichBox.Lines.Add('Сертифікат не посилений');
end;

procedure TTestForm.MakeSignInfoEx(RichBox: TRichEdit; SignInfoEx: Variant);
begin
  if SignInfoEx.GetIsTimeAvail then
  begin
    if (SignInfoEx.GetIsTimeStamp) then
    begin
      RichBox.Lines.Add('Мітка часу: ' + DateTimeToStr(SignInfoEx.GetTime));
    end
    else
      RichBox.Lines.Add('Час підпису: ' + DateTimeToStr(SignInfoEx.GetTime));
  end
  else
    RichBox.Lines.Add('Час підпису відсутній');
  RichBox.Lines.Add('');
  MakeCertificateInfoEx(RichBox, SignInfoEx.GetSignerCertInfoEx);
end;

procedure TTestForm.InitializeButtonClick(Sender: TObject);
var
  Result: Variant;
begin
  if InitializeButton.Caption = 'Ініціалізувати...' then
  begin
    CertRichEdit.Clear();
    try
      EUSignFlexCube := CreateOleObject('EUSignFlexCubeAX.EUSignFlexCube');
    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
           'Виникла помилка при завантаженні криптографічної бібліотеки',
           'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;

    try
      Result := EUSignFlexCube.Initialize('');

      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при ініціалізації криптографічної бібліотеки',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      Result := EUSignFlexCube.GetCertOwnerInfo;
      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при ініціалізації криптографічної бібліотеки',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
      MakeCertificateInfoEx(CertRichEdit, Result.GetResultEx);

    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
          'Виникла помилка при ініціалізації криптографічної бібліотеки',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;

    SignButton.Enabled := True;
    VerifyButton.Enabled := True;
    AppendSignButton.Enabled := True;
    VerifyAllButton.Enabled := True;
    GetSignersInfoButton.Enabled := True;

    InitializeButton.Caption := 'Завершити роботу...';
  end else
  begin
    CertRichEdit.Clear();
    EUSignFlexCube.Finalize;

    SignButton.Enabled := False;
    VerifyButton.Enabled := False;
    AppendSignButton.Enabled := False;
    VerifyAllButton.Enabled := False;
    GetSignersInfoButton.Enabled := False;

    InitializeButton.Caption := 'Ініціалізувати...';
  end;
end;

procedure TTestForm.ResetButtonClick(Sender: TObject);
begin
  DataEdit.Text := 'Дані для підпису 1234567890 Data to sign';
  SignEdit.Text := '';
  SignInfoRichEdit.Clear();
  ResultRichEdit.Clear();
  CertRichEdit.Clear();

  if InitializeButton.Caption = 'Завершити роботу...' then
  begin
    InitializeButtonClick(nil);
  end;
end;

procedure TTestForm.SignButtonClick(Sender: TObject);
var
  Result: Variant;
begin
    if DataEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено дані для підпису',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    try
      Result := EUSignFlexCube.Sign(DataEdit.Text);

      SignEdit.Text := '';

      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при підписі даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      SignEdit.Text := Result.GetResult;
    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
          'Виникла помилка при підписі даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;
end;

procedure TTestForm.VerifyButtonClick(Sender: TObject);
var
  Result: Variant;
begin
    if DataEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено дані для перевірки підпису',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    if SignEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено підпис даних',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    try
      if not ShowFullInfoCheckBox.Checked then
      begin
        Result := EUSignFlexCube.Verify(DataEdit.Text,
          SignEdit.Text, '');
      end
      else
      begin
        Result := EUSignFlexCube.VerifyEx(DataEdit.Text,
          SignEdit.Text, '');
      end;

      SignInfoRichEdit.Clear();

      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при перевірці підпису даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      if not ShowFullInfoCheckBox.Checked then
      begin
        SignInfoRichEdit.Lines.Add(
          Result.GetResult);
      end
      else
      begin
        MakeSignInfoEx(SignInfoRichEdit, Result.GetResultEx);
      end;

    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
          'Виникла помилка при перевірці підпису даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;
end;

procedure TTestForm.AppendSignButtonClick(Sender: TObject);
var
  Result: Variant;
begin
    if DataEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено дані для підпису',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    if SignEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено підпис даних',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    try
      Result := EUSignFlexCube.IsAlreadySigned(
        SignEdit.Text);

      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при підписі даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      if Result.GetResult = true then
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(
          'Дані вже було підписано за допомогою ' +
          'цього особистого ключа');
        Exit;
      end;

      Result := EUSignFlexCube.AppendSign(
        DataEdit.Text, SignEdit.Text);

      SignEdit.Text := '';

      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при підписі даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      SignEdit.Text := Result.GetResult;
    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
          'Виникла помилка при підписі даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;
end;

procedure TTestForm.VerifyAllButtonClick(Sender: TObject);
var
  Result: Variant;
  Signers: Cardinal;
  Index: Cardinal;
begin
    if DataEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено дані для перевірки підпису',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    if SignEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено підпис даних',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    try
      Result := EUSignFlexCube.GetSignersCount(
        SignEdit.Text);
      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при отриманні кількості підписувачів',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      Signers := Result.GetResult;

      SignInfoRichEdit.Clear();
      ResultRichEdit.Clear();

      for Index := 0 to Signers - 1 do
      begin
        if not ShowFullInfoCheckBox.Checked then
        begin
          Result := EUSignFlexCube.VerifySpecific(DataEdit.Text,
            Index, SignEdit.Text, '');
        end
        else
        begin
          Result := EUSignFlexCube.VerifySpecificEx(DataEdit.Text,
            Index, SignEdit.Text, '');
        end;

        ResultRichEdit.Lines.Add(IntToStr(
          Result.GetErrorCode));
        ResultRichEdit.Lines.Add(
          Result.GetErrorDescription);

        if Result.GetErrorCode <> 0 then
        begin
          MessageBoxA(Handle,
            'Виникла помилка при перевірці підпису даних',
            'Повідомлення оператору', MB_ICONERROR);
          Exit;
        end;

        if not ShowFullInfoCheckBox.Checked then
        begin
          SignInfoRichEdit.Lines.Add(
            IntToStr(Index + 1) + '. ' + Result.GetResult);
        end
        else
        begin
          SignInfoRichEdit.Lines.Add(IntToStr(Index + 1) + '. ');
          MakeSignInfoEx(SignInfoRichEdit, Result.GetResultEx)
        end;
      end;
    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
          'Виникла помилка при перевірці підпису даних',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;
end;

procedure TTestForm.GetSignersInfoButtonClick(Sender: TObject);
var
  Result: Variant;
  Signers: Cardinal;
  Index: Cardinal;
begin
    if DataEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено дані для перевірки підпису',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    if SignEdit.Text = '' then
    begin
      MessageBoxA(Handle,
        'Не введено підпис даних',
        'Повідомлення оператору', MB_ICONWARNING);
      Exit;
    end;

    try
      Result := EUSignFlexCube.GetSignersCount(
        SignEdit.Text);
      ResultRichEdit.Clear();
      ResultRichEdit.Lines.Add(IntToStr(
        Result.GetErrorCode));
      ResultRichEdit.Lines.Add(
        Result.GetErrorDescription);

      if Result.GetErrorCode <> 0 then
      begin
        MessageBoxA(Handle,
          'Виникла помилка при отриманні кількості підписувачів',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;

      Signers := Result.GetResult;

      SignInfoRichEdit.Clear();
      ResultRichEdit.Clear();

      for Index := 0 to Signers - 1 do
      begin
        if not ShowFullInfoCheckBox.Checked then
        begin
          Result := EUSignFlexCube.GetSignerInfo(
            Index, SignEdit.Text);
        end
        else
        begin
          Result := EUSignFlexCube.GetSignerInfoEx(
            Index, SignEdit.Text);
        end;

        ResultRichEdit.Lines.Add(IntToStr(
          Result.GetErrorCode));
        ResultRichEdit.Lines.Add(
          Result.GetErrorDescription);

        if Result.GetErrorCode <> 0 then
        begin
          MessageBoxA(Handle,
            'Виникла помилка при перевірці підпису даних',
            'Повідомлення оператору', MB_ICONERROR);
          Exit;
        end;

        if not ShowFullInfoCheckBox.Checked then
        begin
          SignInfoRichEdit.Lines.Add(
            IntToStr(Index + 1) + '. ' + Result.GetResult);
        end
        else
        begin
          SignInfoRichEdit.Lines.Add(IntToStr(Index + 1) + '. ');
          MakeSignInfoEx(SignInfoRichEdit, Result.GetResultEx)
        end;
      end;
    except on E:Exception
    do
      begin
        ResultRichEdit.Clear();
        ResultRichEdit.Lines.Add(E.Message);

        MessageBoxA(Handle,
          'Виникла помилка при отриманні інформації ' +
          'про підрисувача',
          'Повідомлення оператору', MB_ICONERROR);
        Exit;
      end;
    end;
end;

end.
