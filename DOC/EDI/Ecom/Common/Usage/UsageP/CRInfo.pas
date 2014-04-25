unit CRInfo;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, ComCtrls, EUSignCP;

{ ------------------------------------------------------------------------------ }

type
  TCRForm = class(TForm)
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
    TopPanel: TPanel;
    UnderlineImage: TImage;
    TopLabel: TLabel;
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    OKButton: TButton;
    DataImageList: TImageList;
    TopImage: TImage;
    procedure DataListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);

  private
    procedure AddDataListViewItem(Caption, Text: AnsiString; IsHeader: boolean);
    procedure SetDetailInfo(Info: PEUCRInfo);

  public
    function ShowForm(Info: PEUCRInfo): Cardinal;

  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses
  EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TCRForm.AddDataListViewItem(Caption, Text: AnsiString;
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

procedure TCRForm.DataListViewSelectItem(Sender: TObject;
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

procedure TCRForm.SetDetailInfo(Info: PEUCRInfo);
var
  SubjTypeStr: AnsiString;

begin
  DataListView.Clear();

  if (Info.Subject <> '') then
  begin
    AddDataListViewItem('�������� ��������', Info.Subject, True);
  end
  else
    AddDataListViewItem('�������� �������� ������', '', True);


  if (AnsiString(Info.SubjAddress) = '') and
    (AnsiString(Info.SubjPhone) = '') and
    (AnsiString(Info.SubjDNS) = '') and (AnsiString(Info.SubjEMail) = '') and
    (AnsiString(Info.SubjEDRPOUCode) = '') and
    (AnsiString(Info.SubjDRFOCode) = '') and (AnsiString(Info.SubjNBUCode) = '')
    and (AnsiString(Info.SubjSPFMCode) = '') and (AnsiString(Info.SubjOCode) = '')
    and (AnsiString(Info.SubjOUCode) = '') and (AnsiString(Info.SubjUserCode) = '')
    and (AnsiString(Info.CRLDistribPoint1) = '')
    and (AnsiString(Info.CRLDistribPoint2) = '')
  then
  begin
    AddDataListViewItem('�������� ��� ������', '', True);
  end
  else
  begin
    AddDataListViewItem('�������� ��������', '', True);
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
    AddDataListViewItem('����� ������� �� ������ ��� ���',
        Info.CRLDistribPoint1, False);
    AddDataListViewItem('����� ������� �� ��������� ��� ���',
        Info.CRLDistribPoint2, False);
  end;

  SubjTypeStr := '�� ��������';
  if Info.SubjTypeExists then
  begin
    case Info.SubjType of
    EU_SUBJECT_TYPE_CA: SubjTypeStr := '������ ���';
    EU_SUBJECT_TYPE_CA_SERVER:
    begin
      case Info.SubjSubType of
        EU_SUBJECT_CA_SERVER_SUB_TYPE_CMP: SubjTypeStr := '������ CMP ���';
        EU_SUBJECT_CA_SERVER_SUB_TYPE_TSP: SubjTypeStr := '������ TSP ���';
        EU_SUBJECT_CA_SERVER_SUB_TYPE_OCSP: SubjTypeStr := '������ OCSP ���';
      end;
    end;
    EU_SUBJECT_TYPE_RA_ADMINISTRATOR: SubjTypeStr := '����������� ���������';
    EU_SUBJECT_TYPE_END_USER: SubjTypeStr := '����������';
    end;
  end;

  AddDataListViewItem('��� ��������', SubjTypeStr, True);

  if Info.CertTimesExists then
  begin
    AddDataListViewItem('����� ������� �����������', '', True);
    AddDataListViewItem('���������� ������ �',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.CertBeginTime))), False);
    AddDataListViewItem('���������� ������ ��',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.CertEndTime))), False);
  end
  else
    AddDataListViewItem('����� ������� �����������', '³������', True);

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
    AddDataListViewItem('����� 䳿 ���������� �����', '³������', True);

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

  if (AnsiString(Info.ExtKeyUsages) = '') then
  begin
    AddDataListViewItem('�������� ����������� ������', '³�����', True);
  end
  else
    AddDataListViewItem('�������� ����������� ������', Info.ExtKeyUsages, True);

  if (AnsiString(Info.SignIssuer) <> '') then
  begin
    AddDataListViewItem('��� ��� ����� ������', '', True);
    AddDataListViewItem('�������� ��� ��������', Info.SignIssuer, False);
    AddDataListViewItem('�� ����������� ��������', Info.SignSerial, False);
  end
  else
   AddDataListViewItem('����� �������������', '', true);
end;

{ ------------------------------------------------------------------------------ }

function TCRForm.ShowForm(Info: PEUCRInfo): Cardinal;
begin
  SetDetailInfo(Info);
  ShowModal();

  ShowForm := EU_ERROR_NONE;
end;

{ ============================================================================== }

end.
