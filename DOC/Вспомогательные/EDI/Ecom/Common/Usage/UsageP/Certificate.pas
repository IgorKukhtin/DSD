unit Certificate;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, ComCtrls, EUSignCP,
  ImageLink;

{ ------------------------------------------------------------------------------ }

type
  CertificateStatus = (CertStatusDefault = 0, CertStatusVerified = 1,
    CertStatusTimeExpired = 2, CertStatusError = 3);

{ ------------------------------------------------------------------------------ }

type
  TCertificateForm = class(TForm)
    BasePanel: TPanel;
    DetailedContentPanel: TPanel;
    FieldsLabel: TLabel;
    DetailedPanel: TPanel;
    ContentPanel: TPanel;
    DataListView: TListView;
    DetailedBottomPanel: TPanel;
    SplitPanel: TPanel;
    DataLabel: TLabel;
    PrintRichEdit: TRichEdit;
    TextMemo: TMemo;
    DataMemo: TMemo;
    CommonPanel: TPanel;
    IssuerTitleLabel: TLabel;
    SubjectTitleLabel: TLabel;
    VTitleLabel: TLabel;
    VLabel: TLabel;
    SubjectLabel: TLabel;
    IssuerLabel: TLabel;
    SNTitleLabel: TLabel;
    SNLabel: TLabel;
    TopPanel: TPanel;
    UnderlineImage: TImage;
    TopLabel: TLabel;
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    OKButton: TButton;
    DataImageList: TImageList;
    TopImage: TImage;
    CertificateImages: TImageList;
    ShortInfoLabel: TImageLinkFrame;
    DetailLabel: TImageLinkFrame;
    KeyUsageTitleLabel: TLabel;
    KeyUsageLabel: TLabel;
    CommonAttachedLabel: TImageLinkFrame;
    DetailedAttachedLabel: TImageLinkFrame;
    function ShowForm(CPInterface: PEUSignCP; Info: PEUCertInfoEx;
      CertStatus: CertificateStatus; IsUserCertificate: boolean): Cardinal;
    procedure DataListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure DetailInfoLabelClick(Sender: TObject);
    procedure ShortlInfoLabelClick(Sender: TObject);
    procedure AttachedLabelClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    CurentCertificate: Cardinal;
    function SetData(Info: PEUCertInfoEx; CertStatus: CertificateStatus): Cardinal;
    procedure SetDetailInfo(Info: PEUCertInfoEx);
    procedure AddDataListViewItem(Caption, Text: AnsiString; IsHeader: boolean);

  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses
  EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

function TCertificateForm.ShowForm(CPInterface: PEUSignCP; Info: PEUCertInfoEx;
      CertStatus: CertificateStatus; IsUserCertificate: boolean): Cardinal;
var
  Error: Cardinal;

begin
  self.CPInterface := CPInterface;

  Error := SetData(Info, CertStatus);

  if (Error <> EU_ERROR_NONE) then
  begin
    ShowForm := Error;
    Exit;
  end;
  CurentCertificate := 0;
  ShortlInfoLabelClick(nil);
  CommonAttachedLabel.Visible := IsUserCertificate;

  ShowModal();

  ShowForm := EU_ERROR_NONE;
end;

{ ============================================================================== }

procedure TCertificateForm.AddDataListViewItem(Caption, Text: AnsiString;
  IsHeader: boolean);
var
  Item: TListItem;

begin
  if ((AnsiString(Text) = '') and (not IsHeader)) then
    Exit;

  Item := DataListView.Items.Add();
  Item.Caption := Caption;
  Item.SubItems.Add(Text);

  if IsHeader then
  begin
    Item.ImageIndex := 0;
  end
  else
    Item.ImageIndex := -1;
end;

{ ------------------------------------------------------------------------------ }

function TCertificateForm.SetData(Info: PEUCertInfoEx;
  CertStatus: CertificateStatus): Cardinal;
begin
  if (Info.Filled <> True) then
  begin
    SetData := EU_ERROR_BAD_PARAMETER;
    Exit;
  end;

  self.CPInterface := CPInterface;

  IssuerLabel.Caption := Info.IssuerCN;;
  SubjectLabel.Caption := Info.SubjCN;

  VLabel.Caption := AnsiString('з ') +
    FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(Info.CertBeginTime)) +
    ' до ' + FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(Info.CertEndTime));

  SNLabel.Caption := Info.Serial;

  case Info.PublicKeyType of
    EU_CERT_KEY_TYPE_DSTU4145:
      begin
        KeyUsageLabel.Caption := Info.KeyUsage + ' у державних алгоритмах ' +
			    'і протоколах';
      end;
    EU_CERT_KEY_TYPE_RSA:
      begin
        KeyUsageLabel.Caption := Info.KeyUsage + ' у міжнародних алгоритмах ' +
			    'і протоколах';
      end;
  end;

  SetDetailInfo(Info);
  SetData := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificateForm.SetDetailInfo(Info: PEUCertInfoEx);
begin
  DataListView.Clear();

  AddDataListViewItem('Реквізити власника', Info.Subject, True);
  AddDataListViewItem('Реквізити ЦСК', Info.Issuer, True);
  AddDataListViewItem('Реєстраційний номер', Info.Serial, True);

  if (AnsiString(Info.SubjAddress) = '') and
    (AnsiString(Info.SubjPhone) = '') and
    (AnsiString(Info.SubjDNS) = '') and (AnsiString(Info.SubjEMail) = '') and
    (AnsiString(Info.SubjEDRPOUCode) = '') and
    (AnsiString(Info.SubjDRFOCode) = '') and (AnsiString(Info.SubjNBUCode) = '')
    and (AnsiString(Info.SubjSPFMCode) = '') and (AnsiString(Info.SubjOCode) = '')
    and (AnsiString(Info.SubjOUCode) = '') and (AnsiString(Info.SubjUserCode) = '')
  then
  begin
    AddDataListViewItem('Додаткові дані власника відсутні', '', True);
  end
  else
  begin
    AddDataListViewItem('Додаткові дані власника', '', True);
    AddDataListViewItem('Адреса', Info.SubjAddress, False);
    AddDataListViewItem('Телефон', Info.SubjPhone, False);
    AddDataListViewItem('DNS-ім`я чи інше технічного засобу',
      Info.SubjDNS, False);
    AddDataListViewItem('Адреса електронної пошти', Info.SubjEMail, False);
    AddDataListViewItem('Код ЄДРПОУ', Info.SubjEDRPOUCode, False);
    AddDataListViewItem('Код ДРФО', Info.SubjDRFOCode, False);
    AddDataListViewItem('Ідентифікатор НБУ', Info.SubjNBUCode, False);
    AddDataListViewItem('Код СПФМ', Info.SubjSPFMCode, False);
    AddDataListViewItem('Код організації', Info.SubjOCode, False);
    AddDataListViewItem('Код підрозділу', Info.SubjOUCode, False);
    AddDataListViewItem('Код користувача', Info.SubjUserCode, False);
    AddDataListViewItem('UPN-ім`я', Info.UPN, False);
  end;

  AddDataListViewItem('Строк чинності сертифіката', '', True);
  AddDataListViewItem('Сертифікат чинний з',
    AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(Info.CertBeginTime))), False);
  AddDataListViewItem('Сертифікат чинний до',
    AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(Info.CertEndTime))), False);


  if Info.PrivKeyTimesExists then
  begin
    AddDataListViewItem('Строк дії особистого ключа', '', True);
    AddDataListViewItem('Час введення в дію ос. ключа',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.PrivKeyBeginTime))), False);
    AddDataListViewItem('Час виведення з дії ос. ключа',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.PrivKeyEndTime))), False);
  end
  else
    AddDataListViewItem('Строк дії особистого ключа відсутній', '', True);

  AddDataListViewItem('Параметри відкритого ключа', '', True);

  case Info.PublicKeyType of
    EU_CERT_KEY_TYPE_DSTU4145:
    begin
      AddDataListViewItem('Тип ключа', 'ДСТУ 4145-2002', False);
		  AddDataListViewItem('Довжина ключа', IntToStr(Info.PublicKeyBits) +
        ' біт(а)', False);
      AddDataListViewItem('Відкритий ключ', Info.PublicKey, False);
    end;

    EU_CERT_KEY_TYPE_RSA:
    begin
      AddDataListViewItem('Тип ключа', 'RSA', False);
		  AddDataListViewItem('Довжина ключа', IntToStr(Info.PublicKeyBits) +
        ' біт(а)', False);
		  AddDataListViewItem('Модуль', Info.RSAModul, False);
      AddDataListViewItem('Експонента', Info.RSAExponent, False);
    end;
  end;

  AddDataListViewItem('Ідентифікатор відкритого ключа ЕЦП',
    Info.PublicKeyID, False);

  AddDataListViewItem('Використання ключів', Info.KeyUsage, True);

  if (AnsiString(Info.ExtKeyUsages) = '') then
  begin
    AddDataListViewItem('Уточнене призначення ключів відсутнє', '', True);
  end
  else
  begin
    AddDataListViewItem('Уточнене призначення ключів', Info.ExtKeyUsages, True);
  end;

  if (AnsiString(Info.Policies) = '') then
  begin
    AddDataListViewItem('Правила сертифікації не визначені', '', True);
  end
  else
  begin
    AddDataListViewItem('Правила сертифікації', Info.Policies, True);
  end;

  if (not Info.SubjType) then
  begin
		AddDataListViewItem('Тип власника не визначений', '', True);
  end
	else
  begin
    if Info.SubjCA then
    begin
      AddDataListViewItem('Тип власника', 'ЦСК', True);
      AddDataListViewItem('Обмеження на довжину ланцюжка',
        IntToStr(Info.ChainLength), False);
    end
    else
       AddDataListViewItem('Тип власника', 'Не ЦСК', True);
  end;

  if (AnsiString(Info.CRLDistribPoint1) = '') and
    (AnsiString(Info.CRLDistribPoint2) = '') then
  begin
    AddDataListViewItem('Інф. про точки доступу до СВС ЦСК відсутня', '', True);
  end
  else
  begin
    AddDataListViewItem('Інф. про точки доступу до СВС ЦСК',
      Info.Policies, True);

    if (AnsiString(Info.CRLDistribPoint1) <> '') then
      AddDataListViewItem('Точка доступу до повних СВС ЦСК',
        Info.CRLDistribPoint1, False);

    if (AnsiString(Info.CRLDistribPoint2) <> '') then
      AddDataListViewItem('Точка доступу до часткових СВС ЦСК',
        Info.CRLDistribPoint2, False);
  end;

  if ((Info.OCSPAccessInfo <> '') or
		  (Info.IssuerAccessInfo <> '') or
		  (Info.TSPAccessInfo <> '')) then
  begin
    AddDataListViewItem('Інф. про точки доступу до серверів ЦСК',
      '', true);

    if (Info.OCSPAccessInfo <> '') then
        AddDataListViewItem('Точка доступу до OCSP-сервера',
          Info.OCSPAccessInfo, False);

    if (Info.IssuerAccessInfo <> '') then
        AddDataListViewItem('Точка доступу до сертифікатів',
          Info.IssuerAccessInfo, False);

    if (Info.TSPAccessInfo <> '') then
        AddDataListViewItem('Точка доступу до TSP-сервера',
          Info.TSPAccessInfo, False);
  end
  else
    AddDataListViewItem('Інф. про точки доступу до серверів ЦСК відсутня',
			  '', true);

  AddDataListViewItem('Ід. відкр. ключа ЕЦП ЦСК', Info.IssuerPublicKeyID, True);

  if Info.PowerCert then
    AddDataListViewItem('Сертифікат', 'Посилений', True);

  if Info.LimitValueAvailable then
    AddDataListViewItem('Максимальне обмеження на транзакцію',
      IntToStr(Info.LimitValue) + ' ' + Info.LimitValueCurrency, True);
end;

{ ============================================================================== }

procedure TCertificateForm.AttachedLabelClick(Sender: TObject);
var
  Info: PEUCertInfoEx;
  Error: Cardinal;

begin
	CurentCertificate := CurentCertificate + 1;

  while True do
  begin
    Error := CPInterface.EnumOwnCertificates(CurentCertificate, @Info);
    if (Error = EU_WARNING_END_OF_ENUM) then
    begin
      CurentCertificate := 0;
      Continue;
    end;
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowErrorMessage(Handle, 'Виникла помилка при отриманні наступного' +
        ' сертифіката');
      Exit;
    end;
    if (Error = EU_ERROR_NONE) then
      Break;
  end;

  if (SetData(Info, CertStatusDefault) <> EU_ERROR_NONE) then
  begin
      EUShowErrorMessage(Handle, 'Виникла помилка при розборі сертифіката');
  end;

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificateForm.DataListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: boolean);
begin
  if Selected then
  begin
    DataMemo.Lines.Clear;
    DataMemo.Lines.Add(Item.SubItems.Strings[0]);
  end;

  if (Selected and (AnsiString(Item.SubItems.Strings[0]) <> '')) then
  begin
    DataMemo.Height := ((abs(DataMemo.Font.Height) + 2) *
      DataMemo.Lines.Count) + 10;
    DataMemo.SelStart := 0;
    DataMemo.SelLength := 0;
    DataLabel.Caption := Item.Caption + ':';

    DetailedBottomPanel.Height := SplitPanel.Height + DataMemo.Height;
    DetailedBottomPanel.Visible := True;
  end
  else
    DetailedBottomPanel.Visible := False;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificateForm.DetailInfoLabelClick(Sender: TObject);
begin
  CommonPanel.Visible := False;
  ShortInfoLabel.Visible := True;
  DetailedContentPanel.Visible := True;
  DetailedAttachedLabel.Visible := CommonAttachedLabel.Visible;

end;

{ ------------------------------------------------------------------------------ }

procedure TCertificateForm.ShortlInfoLabelClick(Sender: TObject);
begin
  CommonPanel.Visible := True;
  DetailedContentPanel.Visible := False;
  ShortInfoLabel.Visible := False;
  CommonAttachedLabel.Visible := DetailedAttachedLabel.Visible;
  DetailedAttachedLabel.Visible := False;
end;

{ ============================================================================== }

end.
