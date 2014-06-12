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
    AddDataListViewItem('Реквізити заявника', Info.Subject, True);
  end
  else
    AddDataListViewItem('Реквізити заявника відсутні', '', True);


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
    AddDataListViewItem('Додаткові дані відсутні', '', True);
  end
  else
  begin
    AddDataListViewItem('Реквізити заявника', '', True);
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
    AddDataListViewItem('Точка доступу до повних СВС ЦСК',
        Info.CRLDistribPoint1, False);
    AddDataListViewItem('Точка доступу до часткових СВС ЦСК',
        Info.CRLDistribPoint2, False);
  end;

  SubjTypeStr := 'Не вказаний';
  if Info.SubjTypeExists then
  begin
    case Info.SubjType of
    EU_SUBJECT_TYPE_CA: SubjTypeStr := 'Сервер ЦСК';
    EU_SUBJECT_TYPE_CA_SERVER:
    begin
      case Info.SubjSubType of
        EU_SUBJECT_CA_SERVER_SUB_TYPE_CMP: SubjTypeStr := 'Сервер CMP ЦСК';
        EU_SUBJECT_CA_SERVER_SUB_TYPE_TSP: SubjTypeStr := 'Сервер TSP ЦСК';
        EU_SUBJECT_CA_SERVER_SUB_TYPE_OCSP: SubjTypeStr := 'Сервер OCSP ЦСК';
      end;
    end;
    EU_SUBJECT_TYPE_RA_ADMINISTRATOR: SubjTypeStr := 'Адміністратор реєстрації';
    EU_SUBJECT_TYPE_END_USER: SubjTypeStr := 'Користувач';
    end;
  end;

  AddDataListViewItem('Тип заявника', SubjTypeStr, True);

  if Info.CertTimesExists then
  begin
    AddDataListViewItem('Строк чинності сертифіката', '', True);
    AddDataListViewItem('Сертифікат чинний з',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.CertBeginTime))), False);
    AddDataListViewItem('Сертифікат чинний до',
      AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
      SystemTimeToDateTime(Info.CertEndTime))), False);
  end
  else
    AddDataListViewItem('Строк чинності сертифіката', 'Відсутній', True);

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
    AddDataListViewItem('Строк дії особистого ключа', 'Відсутній', True);

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

  if (AnsiString(Info.ExtKeyUsages) = '') then
  begin
    AddDataListViewItem('Уточнене призначення ключів', 'Відсутнє', True);
  end
  else
    AddDataListViewItem('Уточнене призначення ключів', Info.ExtKeyUsages, True);

  if (AnsiString(Info.SignIssuer) <> '') then
  begin
    AddDataListViewItem('Дані про підпис запита', '', True);
    AddDataListViewItem('Реквізити ЦСК заявника', Info.SignIssuer, False);
    AddDataListViewItem('РН сертифіката заявника', Info.SignSerial, False);
  end
  else
   AddDataListViewItem('Запит самопідписаний', '', true);
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
