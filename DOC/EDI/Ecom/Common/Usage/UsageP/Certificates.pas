unit Certificates;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls,
  Dialogs, StdCtrls, ExtCtrls, CommCtrl, ImgList, Grids, ValEdit, Certificate,
  EUSignCP, ImageLink;

{ ------------------------------------------------------------------------------ }

type
  CertificatesType = (CertTypeAll = 0, CertTypeCA = 1, CertTypeCAAll = 2,
    CertTypeCACMP = 3, CertTypeCAOCSP = 4, CertTypeCATSP = 5,
    CertTypeEndUser = 6, CertTypeAdmin = 7);

{ ------------------------------------------------------------------------------ }

type
  TCertificatesForm = class(TForm)
    CListView: TListView;
    TopLabel: TLabel;
    TopImage: TImage;
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    TopPanel: TPanel;
    UnderlineImage: TImage;
    Image1: TImage;
    TitleLabel: TLabel;
    CountLabel: TLabel;
    SearchLabel: TLabel;
    TypeComboBoxEx: TComboBoxEx;
    SearchEdit: TEdit;
    TypeImageList: TImageList;
    LVImageList: TImageList;
    CancelButton: TButton;
    OKButton: TButton;
    OKButtonOne: TButton;
    ImportCertLabel: TImageLinkFrame;
    ExportCertLabel: TImageLinkFrame;
    CertSaveDialog: TSaveDialog;
    CertOpenDialog: TOpenDialog;
    ImportCertsLabel: TImageLinkFrame;
    procedure CListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure CListViewDblClick(Sender: TObject);
    procedure CListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SearchEditChange(Sender: TObject);
    procedure UserTypeComboBoxExChange(Sender: TObject);
    procedure ImportCertLabelClick(Sender: TObject);
    procedure ImportCertsLabelClick(Sender: TObject);
    procedure ExportCertLabelClick(Sender: TObject);
    procedure CListViewClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    ChooseCertificate: Boolean;
    PublicKeyType: Cardinal;
    KeyUsage: Cardinal;
    procedure CListViewUpdate(SubjectType: Cardinal; SubjectSubType: Cardinal;
      ListView: TListView);
    procedure SortListView(ListView: TListView; Column: TListColumn);

  public
    function ShowForm(CPInterface: PEUSignCP; CertType: CertificatesType;
      Caption: AnsiString; Info: PPEUCertInfoEx;
      PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
      KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;

    function SelectCertificates(CPInterface: PEUSignCP;
      CertType: CertificatesType; Caption: AnsiString;
      CertificatesInfo: PEUCertificatesUniqueInfo;
      PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
      KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;

  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses
  EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TCertificatesForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Return: Integer;

begin
  CanClose := True;

  if (ChooseCertificate and
      (CListView.Selected = nil) and
      (ModalResult = mrOk)) then
  begin
    Return := MessageBox(Handle, 'Сертифікат не обрано. Обрати сертифікат?',
      'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);
    case Return of
      IDYES:
        CanClose := False;
      IDNO:
        begin
          CanClose := True;
          ModalResult := mrCancel;
        end;
      IDCANCEL:
        CanClose := False;
    else
      CanClose := False;
    end;
  end;
end;

{ ------------------------------------------------------------------------------ }

function TCertificatesForm.ShowForm(CPInterface: PEUSignCP;
  CertType: CertificatesType; Caption: AnsiString; Info: PPEUCertInfoEx;
  PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
  KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;
var
  Return: Integer;
  ListSubItem: TStrings;
  Error: Cardinal;

begin
  self.CPInterface := CPInterface;
  self.PublicKeyType := PublicKeyType;
  self.KeyUsage := KeyUsage;
  TypeComboBoxEx.ItemIndex := Integer(CertType);

  if (Info <> nil) then
  begin
    ChooseCertificate := True;
  end
  else
    ChooseCertificate := False;

  UserTypeComboBoxExChange(nil);
  TitleLabel.Caption := Caption;

  CancelButton.Visible := ChooseCertificate;
  OKButton.Visible := ChooseCertificate;
  OKButtonOne.Visible := (not ChooseCertificate);
  TypeComboBoxEx.Visible := (not ChooseCertificate);

  if (ChooseCertificate and (CListView.Items.Count = 1)) then
  begin
    CListView.Selected := CListView.Items[0];
    Return := mrOk;
  end
  else
  begin
    Return := self.ShowModal();
  end;

  if (Info = nil) then
  begin
    ShowForm := True;
    Exit;
  end;

  if (Return <> mrOk) then
  begin
    ShowForm := False;
    Exit;
  end;

  ListSubItem := CListView.Selected.SubItems;

  Error := CPInterface.GetCertificateInfoEx(
    PAnsiChar(AnsiString(ListSubItem.Strings[3])),
    PAnsiChar(AnsiString(ListSubItem.Strings[1])), Info);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    ShowForm := False;
    Exit;
  end;

  ShowForm := True;
end;

{ ------------------------------------------------------------------------------ }

function TCertificatesForm.SelectCertificates(CPInterface: PEUSignCP;
  CertType: CertificatesType; Caption: AnsiString;
  CertificatesInfo: PEUCertificatesUniqueInfo;
  PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
  KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;
var
  Return: Integer;
  ListItem : TListItem;
  ListSubItem: TStrings;
  CheckedItemsCount: Integer;
  Index: Integer;

begin
  self.CPInterface := CPInterface;
  self.PublicKeyType := PublicKeyType;
  self.KeyUsage := KeyUsage;
  TypeComboBoxEx.ItemIndex := Integer(CertType);

  UserTypeComboBoxExChange(nil);
  TitleLabel.Caption := Caption;

  CancelButton.Visible := True;
  OKButton.Visible := True;
  OKButtonOne.Visible := False;
  TypeComboBoxEx.Visible := False;
  CListView.Checkboxes := True;

  Return := self.ShowModal();

  if (Return <> mrOk) then
  begin
    SelectCertificates := False;
    Exit;
  end;

  CheckedItemsCount := 0;
  for ListItem in CListView.Items do
  begin
    if ListItem.Checked then
    begin
      CheckedItemsCount := CheckedItemsCount + 1;
    end;
  end;

  SetLength(CertificatesInfo.Issuers, CheckedItemsCount);
  SetLength(CertificatesInfo.Serials, CheckedItemsCount);
  if (CheckedItemsCount = 0) then
  begin
    SelectCertificates := True;
    Exit;
  end;

  Index := 0;
  for ListItem in CListView.Items do
  begin
    if ListItem.Checked then
    begin
      ListSubItem := ListItem.SubItems;
      CertificatesInfo.Issuers[Index] := AnsiString(ListSubItem.Strings[3]);
      CertificatesInfo.Serials[Index] := AnsiString(ListSubItem.Strings[1]);
      Index := Index + 1;
    end;
  end;

  SelectCertificates := True;
end;

{ ============================================================================== }

procedure TCertificatesForm.CListViewClick(Sender: TObject);
begin
  if (CListView.Selected = nil) then
  begin
    ExportCertLabel.Visible := False;
    Exit;
  end;

  ExportCertLabel.Visible := (not ChooseCertificate);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.CListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  SortListView(TListView(Sender), Column);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.CListViewDblClick(Sender: TObject);
var
  ListItem: TListItem;
  Info: PEUCertInfoEx;
  Error: Cardinal;

begin
  ListItem := TListView(Sender).Selected;

  if (ListItem = nil) then
    Exit;

  Error := CPInterface.GetCertificateInfoEx
    (PAnsiChar(AnsiString(ListItem.SubItems.Strings[3])),
    PAnsiChar(AnsiString(ListItem.SubItems.Strings[1])), @Info);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if (not ChooseCertificate) then
  begin
    EUShowCertificate(WindowHandle, '', CPInterface, Info, CertStatusDefault,
      False);
    CPInterface.FreeCertificateInfoEx(Info);
  end
  else
  begin
    CPInterface.FreeCertificateInfoEx(Info);
    ModalResult := mrOk;
    CloseModal();
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.CListViewUpdate(SubjectType: Cardinal;
  SubjectSubType: Cardinal; ListView: TListView);
var
  Error: Cardinal;
  Index: Cardinal;
  Info: TEUCertOwnerInfo;
  InfoEx: PEUCertInfoEx;
  ListItem: TListItem;
  PublicKeyTypeMatched: Boolean;
  KeyUsageMatched: Boolean;

begin
  ListView.Clear();

  Index := 0;
  Error := EU_ERROR_NONE;

  while (Error = EU_ERROR_NONE) do
  begin
    Error := CPInterface.EnumCertificates(SubjectType, SubjectSubType,
      Index, @Info);
    if (Error = EU_ERROR_NONE) then
    begin
      Error := CPInterface.GetCertificateInfoEx(Info.Issuer, Info.Serial, @InfoEx);
      CPInterface.FreeCertOwnerInfo(@Info);

      if (Error = EU_ERROR_NONE) then
      begin
        KeyUsageMatched := True;

        if (PublicKeyType = EU_CERT_KEY_TYPE_UNKNOWN) or
          (PublicKeyType = InfoEx.PublicKeyType) then
        begin
          PublicKeyTypeMatched := True;
        end
        else
          PublicKeyTypeMatched := False;

        if (KeyUsage = EU_KEY_USAGE_UNKNOWN) or
          ((KeyUsage and InfoEx.KeyUsageType) = KeyUsage) then
        begin
          KeyUsageMatched := True;
        end
        else
          KeyUsageMatched := False;

        if (PublicKeyTypeMatched and KeyUsageMatched) then
        begin
           ListItem := ListView.Items.Add();

          ListItem.ImageIndex := 0;

          ListItem.Caption := InfoEx.SubjCN;

          ListItem.SubItems.Add(InfoEx.IssuerCN);
          ListItem.SubItems.Add(InfoEx.Serial);
          ListItem.SubItems.Add(InfoEx.Subject);
          ListItem.SubItems.Add(InfoEx.Issuer);

          case InfoEx.PublicKeyType of
            EU_CERT_KEY_TYPE_DSTU4145:  ListItem.SubItems.Add('ДСТУ 4145-2002');
            EU_CERT_KEY_TYPE_RSA:       ListItem.SubItems.Add('RSA');
            else ListItem.SubItems.Add('');
          end;

          ListItem.SubItems.Add(InfoEx.KeyUsage);
        end;

        CPInterface.FreeCertificateInfoEx(InfoEx);
      end;
    end;

    Index := Index + 1;
  end;

  ListView.Tag := 0;
  ListView.Column[0].Tag := 1;

  SortListView(ListView, ListView.Column[0]);

  if ChooseCertificate then
  begin
    CountLabel.Caption := 'Кількість: ' + IntToStr(ListView.Items.Count);
  end
  else
    CountLabel.Caption := 'Кількість: ' + IntToStr(ListView.Items.Count) +
     ', тип власників:';
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.CListViewCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ListView: TListView;
  ListColumn: TListColumn;
  nItem: Integer;

begin
  ListView := TListView(Sender);
  if (ListView.Tag = -1) then
    Exit;

  ListColumn := ListView.Column[ListView.Tag];

  if (ListView.Tag = 0) then
  begin
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption);
  end
  else
  begin
    nItem := ListView.Tag - 1;
    Compare := AnsiCompareStr(Item1.SubItems.Strings[nItem],
      Item2.SubItems.Strings[nItem]);
  end;

  if (ListColumn.Tag <> 0) then
    Compare := -Compare;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.SortListView(ListView: TListView;
  Column: TListColumn);
var
  HandleHeader: HWND;
  HeaderItem: THDItem;

begin
  if (ListView.Tag = Column.Index) then
  begin
    Column.Tag := (Column.Tag + 1) mod 2;
  end
  else
  begin
    HandleHeader := SendMessage(ListView.Handle, LVM_GETHEADER, 0, 0);

    ZeroMemory(@HeaderItem, sizeof(THDItem));

    HeaderItem.mask := HDI_FORMAT;
    Header_GetItem(HandleHeader, ListView.Tag, HeaderItem);
    HeaderItem.mask := HDI_FORMAT;
    HeaderItem.hbm := 0;
    HeaderItem.fmt := HeaderItem.fmt and (not HDF_BITMAP_ON_RIGHT) and
      (not HDF_IMAGE);

    Header_SetItem(HandleHeader, ListView.Tag, HeaderItem);
    ListView.Tag := Column.Index;
    Column.Tag := 0;
  end;

  ListView.AlphaSort();

  HandleHeader := SendMessage(ListView.Handle, LVM_GETHEADER, 0, 0);
  ZeroMemory(@HeaderItem, sizeof(THDItem));

  HeaderItem.mask := HDI_FORMAT;
  Header_GetItem(HandleHeader, Column.Index, HeaderItem);
  HeaderItem.mask := HeaderItem.mask or HDI_IMAGE;

  HeaderItem.fmt := HeaderItem.fmt or HDF_BITMAP_ON_RIGHT or HDF_IMAGE;
  HeaderItem.iImage := Column.Tag + 1;

  Header_SetItem(HandleHeader, Column.Index, HeaderItem);
end;

{ ============================================================================== }

procedure TCertificatesForm.ExportCertLabelClick(Sender: TObject);
var
  ListItem: TListItem;
  FileName: AnsiString;
  FileStream: TFileStream;
  Error: Cardinal;
  CertData: PByte;
  CertDataSize: Cardinal;
  Written: Cardinal;

begin
  ListItem := CListView.Selected;

  if (ListItem = nil) then
    Exit;

  CertSaveDialog.FileName := ListItem.SubItems.Strings[1] + '.cer';

	if (not CertSaveDialog.Execute()) then
    Exit;

  Error := CPInterface.GetCertificate
    (PAnsiChar(AnsiString(ListItem.SubItems.Strings[3])),
    PAnsiChar(AnsiString(ListItem.SubItems.Strings[1])),
    nil,
    @CertData, @CertDataSize);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  FileName := CertSaveDialog.FileName;
  FileStream := nil;
  try
    FileStream := TFileStream.Create(FileName, fmOpenWrite or fmCreate);
    Written := FileStream.Write(CertData^, CertDataSize);
    if (Written <> CertDataSize) then
      EUShowErrorMessage(Handle, 'Виникла помилка при збереженні' +
      'сертифіката до файлу');
  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
  end;

  CPInterface.FreeMemory(CertData);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.ImportCertLabelClick(Sender: TObject);
var
  FileName: AnsiString;
  FileStream: TFileStream;
  Error: Cardinal;
  CertData: PByte;
  CertDataSize: Int64;

begin
	if (not CertOpenDialog.Execute()) then
	  Exit;

  FileName := CertOpenDialog.FileName;
  if (FileName = '') then
    Exit;

  FileStream := nil;
  CertData := nil;

  try
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    FileStream.Seek(0, soBeginning);

    CertDataSize := FileStream.Size;
    CertData := GetMemory(CertDataSize);
    FileStream.Read(CertData^, CertDataSize);

    Error := CPInterface.SaveCertificate(CertData,
      Cardinal(CertDataSize));

    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
    end
    else
      UserTypeComboBoxExChange(nil);

  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
    if (CertData <> nil) then
      FreeMemory(CertData);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertificatesForm.ImportCertsLabelClick(Sender: TObject);
var
  FileName: AnsiString;
  FileStream: TFileStream;
  Error: Cardinal;
  CertData: PByte;
  CertDataSize: Int64;

begin
	if (not CertOpenDialog.Execute()) then
	  Exit;

  FileName := CertOpenDialog.FileName;
  if (FileName = '') then
    Exit;

  FileStream := nil;
  CertData := nil;

  try
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    FileStream.Seek(0, soBeginning);

    CertDataSize := FileStream.Size;
    CertData := GetMemory(CertDataSize);
    FileStream.Read(CertData^, CertDataSize);

    Error := CPInterface.SaveCertificates(CertData,
      Cardinal(CertDataSize));

    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
    end
    else
      UserTypeComboBoxExChange(nil);

  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
    if (CertData <> nil) then
      FreeMemory(CertData);
  end;
end;

{ ============================================================================== }

procedure TCertificatesForm.SearchEditChange(Sender: TObject);
var
  ListItem: TListItem;

begin
  if (SearchEdit.Text = '') then
    Exit;

  ListItem := CListView.FindCaption(0, SearchEdit.Text, True, True, False);
  if (ListItem <> nil) then
  begin
    CListView.ClearSelection;
    CListView.Selected := ListItem;
    ListItem.MakeVisible(False);
  end;
end;

{ ============================================================================== }

procedure TCertificatesForm.UserTypeComboBoxExChange(Sender: TObject);
begin
  case CertificatesType(TypeComboBoxEx.ItemIndex) of
    CertTypeAll:
      CListViewUpdate(EU_SUBJECT_TYPE_UNDIFFERENCED, 0, CListView);

    CertTypeCA:
      CListViewUpdate(EU_SUBJECT_TYPE_CA, 0, CListView);

    CertTypeCAAll:
      CListViewUpdate(EU_SUBJECT_TYPE_CA_SERVER,
        EU_SUBJECT_CA_SERVER_SUB_TYPE_UNDIFFERENCED, CListView);

    CertTypeCACMP:
      CListViewUpdate(EU_SUBJECT_TYPE_CA_SERVER,
        EU_SUBJECT_CA_SERVER_SUB_TYPE_CMP, CListView);

    CertTypeCAOCSP:
      CListViewUpdate(EU_SUBJECT_TYPE_CA_SERVER,
        EU_SUBJECT_CA_SERVER_SUB_TYPE_OCSP, CListView);

    CertTypeCATSP:
      CListViewUpdate(EU_SUBJECT_TYPE_CA_SERVER,
        EU_SUBJECT_CA_SERVER_SUB_TYPE_TSP, CListView);

    CertTypeEndUser:
      CListViewUpdate(EU_SUBJECT_TYPE_END_USER, 0, CListView);

    CertTypeAdmin:
      CListViewUpdate(EU_SUBJECT_TYPE_RA_ADMINISTRATOR, 0, CListView);
  end;

  CListViewClick(nil);
end;

{ ============================================================================== }

end.
