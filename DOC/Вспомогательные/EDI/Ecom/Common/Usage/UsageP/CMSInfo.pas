unit CMSInfo;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImageLink, StdCtrls, ExtCtrls, ComCtrls, EUSignCP, ImgList;

{ ------------------------------------------------------------------------------ }

type
  TCMSInfoForm = class(TForm)
    DetailedContentPanel: TPanel;
    FieldsLabel: TLabel;
    DetailedPanel: TPanel;
    DataListView: TListView;
    DetailedBottomPanel: TPanel;
    DataMemo: TMemo;
    SplitPanel: TPanel;
    DataLabel: TLabel;
    PrintRichEdit: TRichEdit;
    CommonPanel: TPanel;
    SerialTitleLabel: TLabel;
    SerialLabel: TLabel;
    TimeTitleLabel: TLabel;
    TimeLabel: TLabel;
    IssuerTitleLabel: TLabel;
    IssuerLabel: TLabel;
    UserI1TitleLabel: TLabel;
    UserI1Label: TLabel;
    CertificateImage: TImage;
    TimeImage: TImage;
    UserImage: TImage;
    UserI2TitleLabel: TLabel;
    UserI2Label: TLabel;
    UserI3TitleLabel: TLabel;
    UserI3Label: TLabel;
    CertificateTitleLabel: TLabel;
    ServerImage: TImage;
    TopPanel: TPanel;
    UnderlineImage: TImage;
    TypeListView: TListView;
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    OKButton: TButton;
    ShortInfoLabel: TImageLinkFrame;
    DetailLabel: TImageLinkFrame;
    DataImageList: TImageList;
    TypeImageList: TImageList;
    procedure DataListViewSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
    procedure DetailInfoLabelClick(Sender: TObject);
    procedure ShortlInfoLabelClick(Sender: TObject);
    procedure TypeListViewSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);

  private
    procedure AddDataListViewItem(Caption, Text: AnsiString;
      IsHeader: Boolean = False; nType: Integer = 0);
    procedure SetCertificate(Issuer, Serial: AnsiString);
    procedure SetTime(Caption, Text: AnsiString);
    procedure SetTypeListView(const Name: AnsiString; nType: Integer);
    procedure SetUserInformation(Caption, Text: AnsiString; nIndex: Integer);

  public
    function SetData(Info: PEUSignInfo; IsSigned,
      IsEnveloped, IsUser: Boolean): Cardinal;
  end;

  { ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TCMSInfoForm.AddDataListViewItem(Caption, Text: AnsiString;
  IsHeader: Boolean; nType: Integer);
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
    Item.ImageIndex := nType;
  end
  else
  begin
    Item.ImageIndex := -1;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.SetCertificate(Issuer, Serial: AnsiString);
begin
  IssuerLabel.Caption := Issuer;
  SerialLabel.Caption := Serial;
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.SetTime(Caption, Text: AnsiString);
begin
  TimeTitleLabel.Caption := Caption;
  TimeLabel.Caption := Text;
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.SetTypeListView(const Name: AnsiString; nType: Integer);
var
  Item: TListItem;

begin
  TypeListView.Items.Clear();

  Item := TypeListView.Items.Add();

  Item.Caption := AnsiString('  ') + Name;
  Item.ImageIndex := nType;

  TypeListView.Repaint();
  Repaint();
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.SetUserInformation(Caption, Text: AnsiString;
  nIndex: Integer);
begin

  case nIndex of
    1:
      begin
        UserI1TitleLabel.Caption := Caption;
        UserI1Label.Caption := Text;
      end;

    2:
      begin
        UserI2TitleLabel.Caption := Caption;
        UserI2Label.Caption := Text;
      end;

    3:
      begin
        UserI3TitleLabel.Caption := Caption;
        UserI3Label.Caption := Text;
      end;
  end;
end;

{ ------------------------------------------------------------------------------ }

function TCMSInfoForm.SetData(Info: PEUSignInfo;
  IsSigned, IsEnveloped, IsUser: Boolean): Cardinal;
var
  TimeZone: TTimeZoneInformation;
  Time: TSystemTime;
  IsTime: Boolean;
  DataType: Integer;
  SignTime: AnsiString;

begin
  if (Info.Filled <> True) then
  begin
    SetData := EU_ERROR_BAD_PARAMETER;
    Exit;
  end;

  CommonPanel.Visible := True;
  CommonPanel.BringToFront();
  DetailedContentPanel.Visible := False;

  ShortInfoLabel.Visible := False;

  DataListView.Clear();
  DataMemo.Lines.Clear();
  DetailedBottomPanel.Visible := False;

  if IsEnveloped then
  begin
    if IsSigned then
    begin
      Caption := 'ϳ������ �� ���������� ���';
      SetTypeListView(AnsiString(Caption), 0);
    end
    else
    begin
      Caption := '���������� ���';
      SetTypeListView(AnsiString(Caption), 1);
    end;
  end
  else
  begin
    if IsSigned then
    begin
      Caption := 'ϳ������ ���';
      SetTypeListView(AnsiString(Caption), 0);
    end
    else
    begin
      Caption := '������� ���';
      SetTypeListView(AnsiString(Caption), 0);
    end;
  end;

  UserImage.Visible := IsUser;
  ServerImage.Visible := not UserImage.Visible;

  if IsEnveloped then
  begin
    DataType := 1;
  end
  else
    DataType := 0;

  if (IsSigned and (not IsEnveloped)) then
  begin
    AddDataListViewItem('ϳ��������', Info.SubjectCN, True, DataType);
    SetUserInformation('ϳ��������:', Info.SubjectCN, 1);
  end
  else
  begin
    AddDataListViewItem('³��������', Info.SubjectCN, True, DataType);
    SetUserInformation('³��������:', Info.SubjectCN, 1);
  end;

  if (IsSigned and (not IsEnveloped)) then
  begin
    AddDataListViewItem('���������� ��� ����������', '', True, DataType);
  end
  else
    AddDataListViewItem('���������� ��� ����������', '', True, DataType);

  if IsUser then
    AddDataListViewItem('�.�.�.', Info.SubjectFullName);

  AddDataListViewItem('����������', Info.SubjectOrg);
  AddDataListViewItem('ϳ������', Info.SubjectOrgUnit);

  SetUserInformation('���������� �� �������:',
    AnsiString(Info.SubjectOrg + #13#10 + Info.SubjectOrgUnit), 2);

  if IsUser then
  begin
    AddDataListViewItem('������', Info.SubjectTitle);
    SetUserInformation('������:', Info.SubjectTitle, 3);
  end
  else
  begin
    AddDataListViewItem('������������� �����������', Info.SubjectTitle);
    SetUserInformation('������������� �����������:', Info.SubjectTitle, 3);
  end;

  AddDataListViewItem('�������', Info.SubjectState);
  AddDataListViewItem('��������� �����', Info.SubjectLocality);

  if ((AnsiString(Info.SubjectAddress) = '') and
    (AnsiString(Info.SubjectPhone) = '') and (AnsiString(Info.SubjectDNS) = '')
    and (AnsiString(Info.SubjectEMail) = '') and
    (AnsiString(Info.SubjectEDRPOUCode) = '') and
    (AnsiString(Info.SubjectDRFOCode) = '')) then
  begin
    AddDataListViewItem('�������� ��� ������', '', True, DataType);
  end
  else
  begin
    AddDataListViewItem('�������� ���', '', True, DataType);

    AddDataListViewItem('������', Info.SubjectAddress);
    AddDataListViewItem('�������', Info.SubjectPhone);
    AddDataListViewItem('DNS-��''� �� ���� ��������� ������', Info.SubjectDNS);
    AddDataListViewItem('������ ���������� �����', Info.SubjectEMail);

    AddDataListViewItem('��� ������', Info.SubjectEDRPOUCode);
    AddDataListViewItem('��� ����', Info.SubjectDRFOCode);
  end;

  if (IsSigned and (not IsEnveloped)) then
  begin
    AddDataListViewItem('���������� ��� ���������� ����������', '', True,
      DataType);
  end
  else
    AddDataListViewItem('���������� ��� ���������� ����������', '', True,
      DataType);

  if (AnsiString(Info.IssuerCN) = '') then
  begin
    AddDataListViewItem('�������� ���', Info.Issuer);
    SetCertificate(Info.Issuer, Info.Serial);
  end
  else
    AddDataListViewItem('���', Info.IssuerCN);
  SetCertificate(Info.IssuerCN, Info.Serial);

  AddDataListViewItem('������������ �����', Info.Serial);

  GetTimeZoneInformation(TimeZone);
  IsTime := SystemTimeToTzSpecificLocalTime(@TimeZone, Info.Time, Time);

  if (Info.bTime and IsTime) then
  begin
    SignTime := FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.Time));
    if (not Info.bTimeStamp) then
    begin
      AddDataListViewItem('�������� ���� �������', '', True, DataType);
      AddDataListViewItem('��� ������', SignTime, True, DataType);
      SetTime('��� ������:', SignTime);
    end
    else
    begin
      AddDataListViewItem('�������� ����', SignTime, True, DataType);
      SetTime('�������� ����:', SignTime);
    end;
  end
  else
  begin
    AddDataListViewItem('���������� ��� ��� ������ �������', '',
      True, DataType);
    if IsSigned then
    begin
      SetTime('��� ������:', '���������� �������');
    end
    else
      SetTime('��� ������:', 'ϳ���� �������');
  end;

  SetData := EU_ERROR_NONE;
end;

{ ============================================================================== }

procedure TCMSInfoForm.DataListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
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
  begin
    DetailedBottomPanel.Visible := False;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.DetailInfoLabelClick(Sender: TObject);
begin
  CommonPanel.Visible := False;
  ShortInfoLabel.Visible := True;
  DetailedContentPanel.Visible := True;
  DetailedContentPanel.BringToFront();
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.ShortlInfoLabelClick(Sender: TObject);
begin
  CommonPanel.Visible := True;
  CommonPanel.BringToFront();
  DetailedContentPanel.Visible := False;
  ShortInfoLabel.Visible := False;
end;

{ ------------------------------------------------------------------------------ }

procedure TCMSInfoForm.TypeListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  TypeListView.Selected := nil;
end;

{ ============================================================================== }

end.
