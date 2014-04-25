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

  VLabel.Caption := AnsiString('� ') +
    FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(Info.CertBeginTime)) +
    ' �� ' + FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(Info.CertEndTime));

  SNLabel.Caption := Info.Serial;

  case Info.PublicKeyType of
    EU_CERT_KEY_TYPE_DSTU4145:
      begin
        KeyUsageLabel.Caption := Info.KeyUsage + ' � ��������� ���������� ' +
			    '� ����������';
      end;
    EU_CERT_KEY_TYPE_RSA:
      begin
        KeyUsageLabel.Caption := Info.KeyUsage + ' � ���������� ���������� ' +
			    '� ����������';
      end;
  end;

  SetDetailInfo(Info);
  SetData := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificateForm.SetDetailInfo(Info: PEUCertInfoEx);
begin
  DataListView.Clear();

  AddDataListViewItem('�������� ��������', Info.Subject, True);
  AddDataListViewItem('�������� ���', Info.Issuer, True);
  AddDataListViewItem('������������ �����', Info.Serial, True);

  if (AnsiString(Info.SubjAddress) = '') and
    (AnsiString(Info.SubjPhone) = '') and
    (AnsiString(Info.SubjDNS) = '') and (AnsiString(Info.SubjEMail) = '') and
    (AnsiString(Info.SubjEDRPOUCode) = '') and
    (AnsiString(Info.SubjDRFOCode) = '') and (AnsiString(Info.SubjNBUCode) = '')
    and (AnsiString(Info.SubjSPFMCode) = '') and (AnsiString(Info.SubjOCode) = '')
    and (AnsiString(Info.SubjOUCode) = '') and (AnsiString(Info.SubjUserCode) = '')
  then
  begin
    AddDataListViewItem('�������� ��� �������� ������', '', True);
  end
  else
  begin
    AddDataListViewItem('�������� ��� ��������', '', True);
    AddDataListViewItem('������', Info.SubjAddress, False);
    AddDataListViewItem('�������', Info.SubjPhone, False);
    AddDataListViewItem('DNS-��`� �� ���� ��������� ������',
      Info.SubjDNS, False);
    AddDataListViewItem('������ ���������� �����', Info.SubjEMail, False);
    AddDataListViewItem('��� ������', Info.SubjEDRPOUCode, False);
    AddDataListViewItem('��� ����', Info.SubjDRFOCode, False);
    AddDataListViewItem('������������� ���', Info.SubjNBUCode, False);
    AddDataListViewItem('��� ����', Info.SubjSPFMCode, False);
    AddDataListViewItem('��� ����������', Info.SubjOCode, False);
    AddDataListViewItem('��� ��������', Info.SubjOUCode, False);
    AddDataListViewItem('��� �����������', Info.SubjUserCode, False);
    AddDataListViewItem('UPN-��`�', Info.UPN, False);
  end;

  AddDataListViewItem('����� ������� �����������', '', True);
  AddDataListViewItem('���������� ������ �',
    AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(Info.CertBeginTime))), False);
  AddDataListViewItem('���������� ������ ��',
    AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(Info.CertEndTime))), False);


  if Info.PrivKeyTimesExists then
  begin
    AddDataListViewItem('����� 䳿 ���������� �����', '', True);
    AddDataListViewItem('��� �������� � �� ��. �����',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.PrivKeyBeginTime))), False);
    AddDataListViewItem('��� ��������� � 䳿 ��. �����',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.PrivKeyEndTime))), False);
  end
  else
    AddDataListViewItem('����� 䳿 ���������� ����� �������', '', True);

  AddDataListViewItem('��������� ��������� �����', '', True);

  case Info.PublicKeyType of
    EU_CERT_KEY_TYPE_DSTU4145:
    begin
      AddDataListViewItem('��� �����', '���� 4145-2002', False);
		  AddDataListViewItem('������� �����', IntToStr(Info.PublicKeyBits) +
        ' ��(�)', False);
      AddDataListViewItem('³������� ����', Info.PublicKey, False);
    end;

    EU_CERT_KEY_TYPE_RSA:
    begin
      AddDataListViewItem('��� �����', 'RSA', False);
		  AddDataListViewItem('������� �����', IntToStr(Info.PublicKeyBits) +
        ' ��(�)', False);
		  AddDataListViewItem('������', Info.RSAModul, False);
      AddDataListViewItem('����������', Info.RSAExponent, False);
    end;
  end;

  AddDataListViewItem('������������� ��������� ����� ���',
    Info.PublicKeyID, False);

  AddDataListViewItem('������������ ������', Info.KeyUsage, True);

  if (AnsiString(Info.ExtKeyUsages) = '') then
  begin
    AddDataListViewItem('�������� ����������� ������ ������', '', True);
  end
  else
  begin
    AddDataListViewItem('�������� ����������� ������', Info.ExtKeyUsages, True);
  end;

  if (AnsiString(Info.Policies) = '') then
  begin
    AddDataListViewItem('������� ������������ �� ��������', '', True);
  end
  else
  begin
    AddDataListViewItem('������� ������������', Info.Policies, True);
  end;

  if (not Info.SubjType) then
  begin
		AddDataListViewItem('��� �������� �� ����������', '', True);
  end
	else
  begin
    if Info.SubjCA then
    begin
      AddDataListViewItem('��� ��������', '���', True);
      AddDataListViewItem('��������� �� ������� ��������',
        IntToStr(Info.ChainLength), False);
    end
    else
       AddDataListViewItem('��� ��������', '�� ���', True);
  end;

  if (AnsiString(Info.CRLDistribPoint1) = '') and
    (AnsiString(Info.CRLDistribPoint2) = '') then
  begin
    AddDataListViewItem('���. ��� ����� ������� �� ��� ��� �������', '', True);
  end
  else
  begin
    AddDataListViewItem('���. ��� ����� ������� �� ��� ���',
      Info.Policies, True);

    if (AnsiString(Info.CRLDistribPoint1) <> '') then
      AddDataListViewItem('����� ������� �� ������ ��� ���',
        Info.CRLDistribPoint1, False);

    if (AnsiString(Info.CRLDistribPoint2) <> '') then
      AddDataListViewItem('����� ������� �� ��������� ��� ���',
        Info.CRLDistribPoint2, False);
  end;

  if ((Info.OCSPAccessInfo <> '') or
		  (Info.IssuerAccessInfo <> '') or
		  (Info.TSPAccessInfo <> '')) then
  begin
    AddDataListViewItem('���. ��� ����� ������� �� ������� ���',
      '', true);

    if (Info.OCSPAccessInfo <> '') then
        AddDataListViewItem('����� ������� �� OCSP-�������',
          Info.OCSPAccessInfo, False);

    if (Info.IssuerAccessInfo <> '') then
        AddDataListViewItem('����� ������� �� �����������',
          Info.IssuerAccessInfo, False);

    if (Info.TSPAccessInfo <> '') then
        AddDataListViewItem('����� ������� �� TSP-�������',
          Info.TSPAccessInfo, False);
  end
  else
    AddDataListViewItem('���. ��� ����� ������� �� ������� ��� �������',
			  '', true);

  AddDataListViewItem('��. ����. ����� ��� ���', Info.IssuerPublicKeyID, True);

  if Info.PowerCert then
    AddDataListViewItem('����������', '���������', True);

  if Info.LimitValueAvailable then
    AddDataListViewItem('����������� ��������� �� ����������',
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
      EUShowErrorMessage(Handle, '������� ������� ��� �������� ����������' +
        ' �����������');
      Exit;
    end;
    if (Error = EU_ERROR_NONE) then
      Break;
  end;

  if (SetData(Info, CertStatusDefault) <> EU_ERROR_NONE) then
  begin
      EUShowErrorMessage(Handle, '������� ������� ��� ������ �����������');
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
