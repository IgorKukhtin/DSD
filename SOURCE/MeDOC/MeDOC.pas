unit MeDOC;

interface

uses dsdAction, DB, Classes;

type

  TMedoc = class
  private
    procedure CreateJ1201005XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201006XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201007XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  end;

  TMedocCorrective = class
  private
    procedure CreateJ1201205XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201206XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201207XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  end;

  TMedocAction = class(TdsdCustomAction)
  private
    FHeaderDataSet: TDataSet;
    FItemsDataSet: TDataSet;
    FDirectory: string;
    FAskFilePath: boolean;
    procedure SetDirectory(const Value: string);
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    property ItemsDataSet: TDataSet read FItemsDataSet write FItemsDataSet;
    property Directory: string read FDirectory write SetDirectory;
    property AskFilePath: boolean read FAskFilePath write FAskFilePath default true;
  end;

  TMedocCorrectiveAction = class(TMedocAction)
  protected
    function LocalExecute: boolean; override;
  end;

  procedure Register;

implementation

uses VCL.ActnList, StrUtils, SysUtils, Dialogs, DateUtils, MeDocXML;

procedure Register;
begin
  RegisterActions('TaxLib', [TMedocAction], TMedocAction);
  RegisterActions('TaxLib', [TMedocCorrectiveAction], TMedocCorrectiveAction);
end;


function CreateNodeROW_XML(DOCUMENT: IXMLDOCUMENTType; Tab, Line, Name, Value: String): IXMLROWType;
begin
  result := DOCUMENT.Add;
  result.Tab   := Tab;
  result.Line  := Line;
  result.Name  := Name;
  result.Value := trim(Value);
end;

{ TMedoc }

procedure TMedoc.CreateJ1201005XMLFile(HeaderDataSet, ItemsDataSet: TDataSet;
  FileName: string);
var
  ZVIT: MeDocXML.IXMLZVITType;
  i: integer;
begin
  ZVIT := MeDocXML.NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '3.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_From').AsString;

  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201005';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);
  //����� �������� ��� ��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_From').AsString);
  //�������� ������� - ������� or //�������� ������� - ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', 'X');
  //�������� �� ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', 'X');
  //���������� ����� �� (�������� ����)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //���������� ����� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');
  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //����� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ���������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);
  //������ �� ������ I (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 8 "������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //��� ��� (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ��� (������� 8 "������� ������" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 10 "������� ������ �������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.00', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� ("������� ������")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� (������� ������ �������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', '0.00');
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedoc.CreateJ1201006XMLFile(HeaderDataSet, ItemsDataSet: TDataSet;
  FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_From').AsString;

  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201006';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);
  //�������� ������� - ������� or //�������� ������� - ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', 'X');
  //�������� �� ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', 'X');
  //���������� ����� �� (�������� ����)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //���������� ����� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');
  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //����� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ���������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);
  //������ �� ������ I (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 8 "������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //��� ��� (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ��� (������� 8 "������� ������" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 10 "������� ������ �������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.00', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� ("������� ������")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� (������� ������ �������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', '0.00');
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedoc.CreateJ1201007XMLFile(HeaderDataSet, ItemsDataSet: TDataSet;
  FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_From').AsString;

  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201007';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);
  //�������� ������� - ������� or //�������� ������� - ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', 'X');
  //�������� �� ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', 'X');
  //���������� ����� �� (�������� ����)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //���������� ����� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');
  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //����� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ���������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);
  //������ �� ������ I (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 8 "������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //��� ��� (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ��� (������� 8 "������� ������" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 10 "������� ������ �������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.00', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� ("������� ������")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� (������� ������ �������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', '0.00');
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedoc.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';
   if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.12.2014', F) then
      CreateJ1201005XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else begin
     if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.01.2015', F) then
        CreateJ1201006XMLFile(HeaderDataSet, ItemsDataSet, FileName)
     else
        CreateJ1201007XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   end;
end;

{ TMedocAction }

constructor TMedocAction.Create(AOwner: TComponent);
begin
  inherited;
  AskFilePath := true;
end;

function TMedocAction.LocalExecute: boolean;
begin
  result := false;
  with TSaveDialog.Create(nil) do
  try
    DefaultExt := '*.xml';
    FileName := FormatDateTime('dd_mm_yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime) + '_' +
                trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml';
    if Directory <> '' then begin
       if not DirectoryExists(Directory) then
          ForceDirectories(Directory);
       FileName := Directory + FileName;
    end;
    Filter := '����� ����� (.xml)|*.xml|';
    if (not AskFilePath) or Execute then begin
       with TMedoc.Create do
       try
         CreateXMLFile(Self.HeaderDataSet, Self.ItemsDataSet, FileName);
       finally
         Free;
       end;
      result := true;
    end;
  finally
    Free;
  end;
end;

procedure TMedocAction.SetDirectory(const Value: string);
begin
  FDirectory := Value;
end;

{ TMedocCorrectiveAction }

function TMedocCorrectiveAction.LocalExecute: boolean;
begin
  result := false;
  with TSaveDialog.Create(nil) do
  try
    DefaultExt := '*.xml';
    FileName := FormatDateTime('dd_mm_yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime) + '_' +
                trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml';
    if Directory <> '' then begin
       if not DirectoryExists(Directory) then
          ForceDirectories(Directory);
       FileName := Directory + FileName;
    end;
    Filter := '����� ����� (.xml)|*.xml|';
    if (not AskFilePath) or Execute then begin
       with TMedocCorrective.Create do
       try
         CreateXMLFile(Self.HeaderDataSet, Self.ItemsDataSet, FileName);
       finally
         Free;
       end;
      result := true;
    end;
  finally
    Free;
  end;
end;

{ TMedocCorrective }

procedure TMedocCorrective.CreateJ1201205XMLFile(HeaderDataSet,
  ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
  DocumentSumm: double;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '3.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201205';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;

  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  //����� �������� ��� ��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);

  //��� ���������� �����'�����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', '5');
  //�������� ������� - ������� or //�������� ������� - ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'K1', 'X');
   //�������� �� ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', 'X');
  //���� ��������� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //���� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //����� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', '');

  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ���������� (����� ��볿)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');

  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);

  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  //����� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //����� ���������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ "��������������� �� �������� �������" (������� 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));

  with ItemsDataSet do begin
     First;
     i := 0;
     DocumentSumm := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('Price').AsFloat <> 0) then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������� �����������:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', '����������');
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.00', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedocCorrective.CreateJ1201206XMLFile(HeaderDataSet,
  ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
  DocumentSumm: double;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201206';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;

  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  //����� �������� ��� ��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);

  //��� ���������� �����'�����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', '5');
  //�������� ������� - ������� or //�������� ������� - ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'K1', 'X');
   //�������� �� ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', 'X');
  //���� ��������� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //���� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //����� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', '');

  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ���������� (����� ��볿)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');

  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);

  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  //����� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //����� ���������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ "��������������� �� �������� �������" (������� 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));

  with ItemsDataSet do begin
     First;
     i := 0;
     DocumentSumm := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('Price').AsFloat <> 0) then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������� �����������:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', '����������');
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.00', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedocCorrective.CreateJ1201207XMLFile(HeaderDataSet,
  ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
  DocumentSumm: double;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201207';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;

  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  //����� �������� ��� ��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);

  //��� ���������� �����'�����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', '5');
  //�������� ������� - ������� or //�������� ������� - ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'K1', 'X');
   //�������� �� ����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', 'X');
  //���� ��������� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //���� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //����� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', '');

  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ���������� (����� ��볿)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');

  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);

  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  //����� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //����� ���������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ "��������������� �� �������� �������" (������� 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));

  with ItemsDataSet do begin
     First;
     i := 0;
     DocumentSumm := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('Price').AsFloat <> 0) then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������� �����������:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', '����������');
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.00', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedocCorrective.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet;
  FileName: string);
var
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';
   if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.12.2014', F) then
      CreateJ1201205XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else begin
     if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.01.2015', F) then
        CreateJ1201206XMLFile(HeaderDataSet, ItemsDataSet, FileName)
     else
        CreateJ1201207XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   end;
end;

end.




