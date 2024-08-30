unit MeDOC;

{$I ..\dsdVer.inc}

interface

uses dsdAction, DB, Classes {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

type

  TMedoc = class
  private
    procedure CreateJ1201005XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201006XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201007XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201008XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);

    procedure CreateJ1201009XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201009XMLFile_IFIN(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);

    procedure CreateJ1201010XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201011XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201012XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);

  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string; FIsMedoc : Boolean);
  end;

  TMedocCorrective = class
  private
    procedure CreateJ1201205XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201206XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201207XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201208XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);

    procedure CreateJ1201209XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201209XMLFile_IFIN(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);

    procedure CreateJ1201210XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201211XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
    procedure CreateJ1201212XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string; FIsMedoc : Boolean);
  end;

  TMedocAction = class(TdsdCustomAction)
  private
    FHeaderDataSet: TDataSet;
    FItemsDataSet: TDataSet;
    FDirectory: string;
    FIsMedoc: boolean;
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
    property IsMedoc: boolean read FIsMedoc write FIsMedoc default true;
  end;

  TMedocCorrectiveAction = class(TMedocAction)
  protected
    function LocalExecute: boolean; override;
  end;

  procedure Register;

implementation

uses VCL.ActnList, StrUtils, SysUtils, Dialogs, DateUtils, MeDocXML
   , IFIN_J1201009, IFIN_J1201209
   , Medoc_J1201010, Medoc_J1201210
   , Medoc_J1201011, Medoc_J1201211
   , Medoc_J1201012, Medoc_J1201212
   , CommonData
   ;

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
{
function CreateNodeROW_XML_IFIN(DOCUMENT: IXMLDECLARBODYType; Tab, Line, Name, Value: String): IXMLROWType;
begin
  result := DOCUMENT.AddChild(;
  result.Tab   := Tab;
  result.Line  := Line;
  result.Name  := Name;
  result.Value := trim(Value);
end;
}
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
  //�������� ����� ��볿 +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
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
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.###', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� ("������� ������")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
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
  //�������� ����� ��볿 +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
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
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.###', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� ("������� ������")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
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

procedure TMedoc.CreateJ1201008XMLFile(HeaderDataSet, ItemsDataSet: TDataSet;
  FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.1';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_From').AsString;

  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201008';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //������ ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);

  //���������� ����� �� (�������� ����)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //���������� ����� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));

  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     // ������� ��������� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N25', '1');

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // �� �������� �������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N13', '1');
     // �� �������� ������� (��� �������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N14',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;

  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  // � Գ볿 �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_To').AsString);
  // ��� ������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //̳�������������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ���������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ �� ������ I (������� 12 "�������� ���� �����, �� ������ �����")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� � ������ ������ ���������� �� �������� ������� (��� ������ 20)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� � ������ ������ ���������� ��� ������� ������ �� ������� 0% (��� ������ 901)
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));

   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 901 then begin
     //����� � ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;
   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 902 then begin
     //����� � ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_8', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;

  //�������� ���� ������� �� ������ ������� �� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� ������� �� ������ �������, � ���� ����:
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� ����,�� ��������� ����� � ����������� ������� �� ������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� (������������) �����/������� ����� (�������� �����������)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ ����� ������� ������ �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_From').AsString);

  //�������� ���� � ��� ("������� ������")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� ����� � ��� (0% ��������� (�������))
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 10 "������� ������ �������")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //���� ������������
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //��� ������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A141', FieldByName('MeasureCode').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //��� ������
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A10', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //������ ���������� ��� ���������� ��� ("������� ������")
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� (������� ������ �������)
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedoc.CreateJ1201009XMLFile_IFIN(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IFIN_J1201009.IXMLDECLARType;
  i: integer;
begin
  ZVIT := IFIN_J1201009.NewDECLAR;

  //J1201009.xsd
  ZVIT.NoNamespaceSchemaLocation := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd';
  ZVIT.xsi := 'http://www.w3.org/2001/XMLSchema-instance';

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').AsString;
  //J1201009
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // J12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //010
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 8, 1); // 9

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := '00';
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsString;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := '04';
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := '65';

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2)));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := '1';
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4)));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := '0465';
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := '1';
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.Nil_ := true;
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'iFin';



  //
  ZVIT.DECLARBODY.H03.Nil_ := true;
  ZVIT.DECLARBODY.R03G10S.Nil_ := true;
  ZVIT.DECLARBODY.HORIG1.Nil_ := true;
  ZVIT.DECLARBODY.HTYPR.Nil_ := true;

  //ZVIT.DECLARBODY.HFILL :=FormatDateTime('ddmmyyyy', now);
  ZVIT.DECLARBODY.HFILL :=FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //ZVIT.DECLARBODY.HNUM := '1';
  ZVIT.DECLARBODY.HNUM := HeaderDataSet.FieldByName('InvNumberPartner').AsString;
  ZVIT.DECLARBODY.HNUM1.Nil_ := true;

  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  if HeaderDataSet.FieldByName('JuridicalName_To_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString + HeaderDataSet.FieldByName('JuridicalName_To_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString;

  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').AsString;
  ZVIT.DECLARBODY.HNUM2.Nil_ := true;

  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').AsString;
  ZVIT.DECLARBODY.HFBUY.Nil_ := true;


  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R03G109.Nil_ := true;

  ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R01G109.Nil_ := true;
  ZVIT.DECLARBODY.R01G9.Nil_ := true;
  ZVIT.DECLARBODY.R01G8.Nil_ := true;
  ZVIT.DECLARBODY.R01G10.Nil_ := true;
  ZVIT.DECLARBODY.R02G11.Nil_ := true;

  with ItemsDataSet do begin
     First;
     i := 1;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)
         then begin

          //������������ �������� ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := FieldByName('GoodsName').AsString;
          end;

          //��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := true;
            NodeValue := FieldByName('GoodsCodeUKTZED').AsString;
          end;
          //ChkColumn
          with ZVIT.DECLARBODY.RXXXXG32.Add do
          begin
            ROWNUM := IntToStr(i);
            Nil_ := true;
          end;
          //DKPPColumn
          with ZVIT.DECLARBODY.RXXXXG33.Add do
          begin
            ROWNUM := IntToStr(i);
            Nil_ := true;
          end;

          //������� ����� ������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := FieldByName('MeasureName').AsString;
          end;

          //???
          {with ZVIT.DECLARBODY.RXXXXG105_2S.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := '2009';
          end;}

          //ʳ������
          with ZVIT.DECLARBODY.RXXXXG5.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //ֳ�� ���������� ������� ������\�������
          with ZVIT.DECLARBODY.RXXXXG6.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;

          //20
          with ZVIT.DECLARBODY.RXXXXG008.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := '20';
          end;
          with ZVIT.DECLARBODY.RXXXXG009.Add do
          begin
            ROWNUM := IntToStr(i);
            Nil_ := true;
          end;
          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          with ZVIT.DECLARBODY.RXXXXG011.Add do
          begin
            ROWNUM := IntToStr(i);
            Nil_ := true;
          end;

          inc(i);

         end;
         Next;
     end;
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10_ifin').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').AsString;
  ZVIT.DECLARBODY.R003G10S.Nil_ := true;

  HeaderDataSet.Close;
  ItemsDataSet.Close;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedoc.CreateJ1201009XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.1';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_From').AsString;

  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString; // 'J1201009';
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //������ ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);

  //���������� ����� �� (�������� ����)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //���������� ����� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));

  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     // ������� ��������� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N25', '1');

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // �� �������� �������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N13', '1');
     // �� �������� ������� (��� �������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N14',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;

  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  // � Գ볿 �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_To').AsString);
  // ��� ������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //̳�������������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ���������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ �� ������ I (������� 12 "�������� ���� �����, �� ������ �����")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� � ������ ������ ���������� �� �������� ������� (��� ������ 20)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� � ������ ������ ���������� ��� ������� ������ �� ������� 0% (��� ������ 901)
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));

   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 901 then begin
     //����� � ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;
   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 902 then begin
     //����� � ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_8', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;

  //�������� ���� ������� �� ������ ������� �� �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� ������� �� ������ �������, � ���� ����:
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� ����,�� ��������� ����� � ����������� ������� �� ������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� (������������) �����/������� ����� (�������� �����������)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ ����� ������� ������ �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_From').AsString);

  //�������� ���� � ��� ("������� ������")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� ����� � ��� (0% ��������� (�������))
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //������ �� ������ I (������� 10 "������� ������ �������")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //���� ������������
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //��� ������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A141', FieldByName('MeasureCode').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //��� ������
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A10', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //������ ������������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A132', FieldByName('GoodsCodeTaxImport').AsString);
           //������� ����� � ����
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A133', FieldByName('GoodsCodeDKPP').AsString);
           //��� ���� �������� �� ���������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A11', FieldByName('GoodsCodeTaxAction').AsString);

           //������ ���������� ��� ���������� ��� ("������� ������")
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� (������� ������ �������)
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedoc.CreateJ1201010XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: Medoc_J1201010.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := Medoc_J1201010.NewDECLAR;


  ZVIT.DeclareNamespace(NS, NS_URI);
  //J1201010.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').AsString;
  //J1201010
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // J12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //010
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 7, 2); // 10

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';

  // ������� ��������� ��������
  if HeaderDataSet.FieldByName('TaxKind').asString = '4'
  then
      ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // else
  begin
      // ZVIT.DECLARBODY.ChildNodes['R01G1'].SetAttributeNS('nil', NS_URI, true);
      // �������� �� ��������, ������� �� �������������
      //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
      // �� ������ ������� ���������� (�������) � �������
      //ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
      //����������� ��������� ��� �������
      //ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);

      if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
      begin
         // �� �������� �������
         ZVIT.DECLARBODY.HORIG1 := 1;
         // �� �������� ������� (��� �������)
         ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
      end;
  end;

  ZVIT.DECLARBODY.HFILL :=FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  ZVIT.DECLARBODY.HNUM := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  if HeaderDataSet.FieldByName('JuridicalName_To_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString + HeaderDataSet.FieldByName('JuridicalName_To_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString;

  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.HTINSEL:= HeaderDataSet.FieldByName('OKPO_From').AsString;

  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').AsString;
  // � Գ볿 �������
  if HeaderDataSet.FieldByName('InvNumberBranch_To').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_To').AsString;

  // �������� ���� �����, �� ��������� ����� � ����������� ������� �� ������ �������
  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  // �������� ���� ������� �� ������ �������, � ���� ����:
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G11'].SetAttributeNS('nil', NS_URI, true);
  // �������� ���� ������� �� ������ ������� �� �������� �������
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G7'].SetAttributeNS('nil', NS_URI, true);
  // �������� ���� ������� �� ������ ������� �� ������� 7%
  ZVIT.DECLARBODY.ChildNodes['R03G109'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ���������� �� �������� ������� (��� ������ 20)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R01G7'].SetAttributeNS('nil', NS_URI, true);;

  // �������� ���� ������� �� ������ ������� �� ������� 7%
  ZVIT.DECLARBODY.ChildNodes['R01G109'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ���������� ��� ������� ������ �� ������� 0% (��� ������ 901)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.ChildNodes['R01G9'].SetAttributeNS('nil', NS_URI, true)
  else ZVIT.DECLARBODY.R01G9 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  // ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
  ZVIT.DECLARBODY.ChildNodes['R01G8'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ��������, ��������� �� ������������� (��� ������ 903)
  ZVIT.DECLARBODY.ChildNodes['R01G10'].SetAttributeNS('nil', NS_URI, true);
  // ��� ���� �������� (��������) ����
  ZVIT.DECLARBODY.ChildNodes['R02G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do
  begin
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������������ �������� ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('GoodsName').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do
          begin
            ROWNUM := i;
            //Nil_ := true;
            NodeValue := FieldByName('GoodsCodeUKTZED').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ChkColumn
          with ZVIT.DECLARBODY.RXXXXG32.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //DKPPColumn
          with ZVIT.DECLARBODY.RXXXXG33.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������� ����� ������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('MeasureName').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������� ����� ������/������� (���)
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('MeasureCode').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ʳ������
          with ZVIT.DECLARBODY.RXXXXG5.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ֳ�� ���������� ������� ������\�������
          with ZVIT.DECLARBODY.RXXXXG6.Add do
          begin
            ROWNUM := i;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //20
          with ZVIT.DECLARBODY.RXXXXG008.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            //NodeValue := '20';
            NodeValue := ReplaceStr(FormatFloat('0.##', HeaderDataSet.FieldByName('VATPercent').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //
          with ZVIT.DECLARBODY.RXXXXG009.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)
          then
          begin
          //���� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
            then NodeValue := ReplaceStr(FormatFloat('0.00####', FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
            else SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //
          with ZVIT.DECLARBODY.RXXXXG011.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);


  HeaderDataSet.Close;
  ItemsDataSet.Close;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedoc.CreateJ1201011XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: Medoc_J1201011.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := Medoc_J1201011.NewDECLAR;


  ZVIT.DeclareNamespace(NS, NS_URI);
  //J1201011.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').AsString;
  //J1201011
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // J12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //010
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 7, 2); // 10

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';

  // ������� ��������� ��������
  if HeaderDataSet.FieldByName('TaxKind').asString = '4'
  then
      ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // else
  begin
      // ZVIT.DECLARBODY.ChildNodes['R01G1'].SetAttributeNS('nil', NS_URI, true);
      // �������� �� ��������, ������� �� �������������
      //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
      // �� ������ ������� ���������� (�������) � �������
      //ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
      //����������� ��������� ��� �������
      //ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);

      if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
      begin
         // �� �������� �������
         ZVIT.DECLARBODY.HORIG1 := 1;
         // �� �������� ������� (��� �������)
         ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
      end;
  end;

  ZVIT.DECLARBODY.HFILL :=FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  ZVIT.DECLARBODY.HNUM := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  if HeaderDataSet.FieldByName('JuridicalName_To_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString + HeaderDataSet.FieldByName('JuridicalName_To_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString;

  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.HTINSEL:= HeaderDataSet.FieldByName('OKPO_From').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_From').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').AsString;
  // � Գ볿 �������
  if HeaderDataSet.FieldByName('InvNumberBranch_To').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKB := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKB'].SetAttributeNS('nil', NS_URI, true);

  // �������� ���� �����, �� ��������� ����� � ����������� ������� �� ������ �������
  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  // �������� ���� ������� �� ������ �������, � ���� ����:
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G11'].SetAttributeNS('nil', NS_URI, true);
  // �������� ���� ������� �� ������ ������� �� �������� �������
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G7'].SetAttributeNS('nil', NS_URI, true);
  // �������� ���� ������� �� ������ ������� �� ������� 7%
  ZVIT.DECLARBODY.ChildNodes['R03G109'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ���������� �� �������� ������� (��� ������ 20)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R01G7'].SetAttributeNS('nil', NS_URI, true);;

  // �������� ���� ������� �� ������ ������� �� ������� 7%
  ZVIT.DECLARBODY.ChildNodes['R01G109'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ���������� ��� ������� ������ �� ������� 0% (��� ������ 901)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.ChildNodes['R01G9'].SetAttributeNS('nil', NS_URI, true)
  else ZVIT.DECLARBODY.R01G9 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  // ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
  ZVIT.DECLARBODY.ChildNodes['R01G8'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ��������, ��������� �� ������������� (��� ������ 903)
  ZVIT.DECLARBODY.ChildNodes['R01G10'].SetAttributeNS('nil', NS_URI, true);
  // ��� ���� �������� (��������) ����
  ZVIT.DECLARBODY.ChildNodes['R02G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do
  begin
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������������ �������� ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('GoodsName').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do
          begin
            ROWNUM := i;
            //Nil_ := true;
            NodeValue := FieldByName('GoodsCodeUKTZED').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ChkColumn
          with ZVIT.DECLARBODY.RXXXXG32.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //DKPPColumn
          with ZVIT.DECLARBODY.RXXXXG33.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������� ����� ������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('MeasureName').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������� ����� ������/������� (���)
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('MeasureCode').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ʳ������
          with ZVIT.DECLARBODY.RXXXXG5.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ֳ�� ���������� ������� ������\�������
          with ZVIT.DECLARBODY.RXXXXG6.Add do
          begin
            ROWNUM := i;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //20
          with ZVIT.DECLARBODY.RXXXXG008.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            //NodeValue := '20';
            NodeValue := ReplaceStr(FormatFloat('0.##', HeaderDataSet.FieldByName('VATPercent').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //
          with ZVIT.DECLARBODY.RXXXXG009.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)
          then
          begin
          //���� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
            then NodeValue := ReplaceStr(FormatFloat('0.00####', FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
            else SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //
          with ZVIT.DECLARBODY.RXXXXG011.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);


  HeaderDataSet.Close;
  ItemsDataSet.Close;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedoc.CreateJ1201012XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: Medoc_J1201012.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := Medoc_J1201012.NewDECLAR;


  ZVIT.DeclareNamespace(NS, NS_URI);
  //J1201012.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').AsString;
  //J1201012
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // J12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //010
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 7, 2); // 10

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';

  // ������� ��������� ��������
  if HeaderDataSet.FieldByName('TaxKind').asString = '4'
  then
      ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // else
  begin
      // ZVIT.DECLARBODY.ChildNodes['R01G1'].SetAttributeNS('nil', NS_URI, true);
      // �������� �� ��������, ������� �� �������������
      //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
      // �� ������ ������� ���������� (�������) � �������
      //ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
      //����������� ��������� ��� �������
      //ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);

      if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
      begin
         // �� �������� �������
         ZVIT.DECLARBODY.HORIG1 := 1;
         // �� �������� ������� (��� �������)
         ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
      end;
  end;

  ZVIT.DECLARBODY.HFILL :=FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  ZVIT.DECLARBODY.HNUM := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  if HeaderDataSet.FieldByName('JuridicalName_To_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString + HeaderDataSet.FieldByName('JuridicalName_To_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').AsString;

  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.HTINSEL:= HeaderDataSet.FieldByName('OKPO_From').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_From').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').AsString;
  // � Գ볿 �������
  if HeaderDataSet.FieldByName('InvNumberBranch_To').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKB := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKB'].SetAttributeNS('nil', NS_URI, true);

  // �������� ���� �����, �� ��������� ����� � ����������� ������� �� ������ �������
  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  // �������� ���� ������� �� ������ �������, � ���� ����:
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G11'].SetAttributeNS('nil', NS_URI, true);
  // �������� ���� ������� �� ������ ������� �� �������� �������
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G7'].SetAttributeNS('nil', NS_URI, true);
  // �������� ���� ������� �� ������ ������� �� ������� 7%
  ZVIT.DECLARBODY.ChildNodes['R03G109'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ���������� �� �������� ������� (��� ������ 20)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R01G7'].SetAttributeNS('nil', NS_URI, true);;

  // �������� ���� ������� �� ������ ������� �� ������� 7%
  ZVIT.DECLARBODY.ChildNodes['R01G109'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ���������� ��� ������� ������ �� ������� 0% (��� ������ 901)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.ChildNodes['R01G9'].SetAttributeNS('nil', NS_URI, true)
  else ZVIT.DECLARBODY.R01G9 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  // ������ ������ ���������� �� ����� ������� ������ �� ������� 0% (��� ������ 902)
  ZVIT.DECLARBODY.ChildNodes['R01G8'].SetAttributeNS('nil', NS_URI, true);
  // ������ ������ ��������, ��������� �� ������������� (��� ������ 903)
  ZVIT.DECLARBODY.ChildNodes['R01G10'].SetAttributeNS('nil', NS_URI, true);
  // ��� ���� �������� (��������) ����
  ZVIT.DECLARBODY.ChildNodes['R02G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do
  begin
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������������ �������� ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('GoodsName').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do
          begin
            ROWNUM := i;
            //Nil_ := true;
            NodeValue := FieldByName('GoodsCodeUKTZED').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ChkColumn
          with ZVIT.DECLARBODY.RXXXXG32.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //DKPPColumn
          with ZVIT.DECLARBODY.RXXXXG33.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������� ����� ������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('MeasureName').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������� ����� ������/������� (���)
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := FieldByName('MeasureCode').AsString;
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ʳ������
          with ZVIT.DECLARBODY.RXXXXG5.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //ֳ�� ���������� ������� ������\�������
          with ZVIT.DECLARBODY.RXXXXG6.Add do
          begin
            ROWNUM := i;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //20
          with ZVIT.DECLARBODY.RXXXXG008.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            //NodeValue := '20';
            NodeValue := ReplaceStr(FormatFloat('0.##', HeaderDataSet.FieldByName('VATPercent').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;

     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //
          with ZVIT.DECLARBODY.RXXXXG009.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)
          then
          begin
          //���� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do
          begin
            ROWNUM := i;
            //Nil_ := false;
            if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
            then NodeValue := ReplaceStr(FormatFloat('0.00####', FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
            else SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //
          with ZVIT.DECLARBODY.RXXXXG011.Add do
          begin
            ROWNUM := i;
            SetAttributeNS('nil', NS_URI, true);
          end;
          //
          inc(i);
          //
          end;
          //
          Next;
     end;
     //
     //
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);


  HeaderDataSet.Close;
  ItemsDataSet.Close;

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

  //���������� ����� �� (�������� ����)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //���������� ����� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // �� �������� �������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N13', '1');
     // �� �������� ������� (��� �������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N14',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;

  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //̳�������������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
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
  //III ��� (������� 9 �0% �������)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //��� ��� (������� 12 "�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ��� (������� 8 "������� ������" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("�������� ���� �����, �� ������ �����")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //�������� ���� � ��� ("������� ������")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //����� ����� � ��� (0% ��������� (�������))
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
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
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //��� ������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A141', FieldByName('MeasureCode').AsString);
           //ʳ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ֳ�� ���������� ������� ������\�������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� ("������� ������")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //������ ���������� ��� ���������� ��� (������� ������ �������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedoc.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string; FIsMedoc : Boolean);
var
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';


   if FIsMedoc = FALSE
   then
       // ��� ��� IFin
       CreateJ1201009XMLFile_IFIN(HeaderDataSet, ItemsDataSet, FileName)
   else

   // ��� ��� ����� - 2021 - � 16.03
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '16.03.2021', F) then
       CreateJ1201012XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   // ��� ��� ����� - 2021 - �� 16.03
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.03.2021', F)
   then
       CreateJ1201011XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   // 2018
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.12.2018', F)
   then
       CreateJ1201010XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.03.2017', F)
   then
       CreateJ1201009XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else

   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.04.2016', F) then
      CreateJ1201008XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else

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
  isMedoc := true;
end;

function TMedocAction.LocalExecute: boolean;
begin
  result := false;
  with TSaveDialog.Create(nil) do
  try
    DefaultExt := '*.xml';

    if isMedoc = True then
      // ��� ��� �����
      FileName := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime) + '_' +
                  trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml'
    else
      // ��� ��� IFin
      FileName := '0000'

                  //����� ������, ����������� ����� ������ �� 10 ������.
                + HeaderDataSet.FieldByName('OKPO_From_ifin').AsString

                + HeaderDataSet.FieldByName('CHARCODE').AsString

                + '1'  // ��������� ���������.

                + '00' //����� ������ ��������� (�����������) ���-�� � �������� �������. ����������� ����� ������ �� 2 ������

                  //����� ��������� � �������. ����������� ����� ������ �� 7 ������.
                + HeaderDataSet.FieldByName('InvNumberPartner_ifin').AsString

                + '1'  //��� ��������� ������� (1-�����, 2-�������, 3-���������, 4-������ ���., 5-���).

                + FormatDateTime('mmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime)
                +'.xml';

    if Directory <> '' then begin
       if not DirectoryExists(Directory) then
          ForceDirectories(Directory);
       FileName := Directory + FileName;
    end;
    Filter := '����� ����� (.xml)|*.xml|';
    if (not AskFilePath) or Execute then begin
       with TMedoc.Create do
       try
         CreateXMLFile(Self.HeaderDataSet, Self.ItemsDataSet, FileName, isMedoc);
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
    HeaderDataSet.First;

    while not HeaderDataSet.EOF do begin
      if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then
         break;
      HeaderDataSet.Next;
    end;

    if isMedoc = True then
      // ��� ��� �����
      FileName := FormatDateTime('dd_mm_yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime)
          + '_' + trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml'
    else
      // ��� ��� IFin
      FileName := '0000'

                  //����� ������, ����������� ����� ������ �� 10 ������.
                + HeaderDataSet.FieldByName('OKPO_To_ifin').AsString

                + HeaderDataSet.FieldByName('CHARCODE').AsString

                + '1'  // ��������� ���������.

                + '00' //����� ������ ��������� (�����������) ���-�� � �������� �������. ����������� ����� ������ �� 2 ������

                  //����� ��������� � �������. ����������� ����� ������ �� 7 ������.
                + HeaderDataSet.FieldByName('InvNumberPartner_ifin').AsString

                + '1'  //��� ��������� ������� (1-�����, 2-�������, 3-���������, 4-������ ���., 5-���).

                + FormatDateTime('mmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime)
                +'.xml';


    if Directory <> '' then begin
       if not DirectoryExists(Directory) then
          ForceDirectories(Directory);
       FileName := Directory + FileName;
    end;
    Filter := '����� ����� (.xml)|*.xml|';
    if (not AskFilePath) or Execute then begin
       with TMedocCorrective.Create do
       try
         CreateXMLFile(Self.HeaderDataSet, Self.ItemsDataSet, FileName, isMedoc);
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

  while not HeaderDataSet.EOF do begin
    if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then
       break;
    HeaderDataSet.Next;
  end;

  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201205';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
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
  //����� ��������� ��������, �� ���������� (����� ��볿) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);

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
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
         //���� ������������
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
         //������� �����������:
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', '����������');
         //������������ �������� ������
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
         //������� ����� ������
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
         //����������� ������� (���� �������, ��'���, ������)
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.###', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
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

  while not HeaderDataSet.EOF do begin
    if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then
       break;
    HeaderDataSet.Next;
  end;

  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //��� ���������
    CHARCODE := 'J1201206';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id ���������
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
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
  //����� ��������� ��������, �� ���������� (����� ��볿) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);

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
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
         //���� ������������
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
         //������� �����������:
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', '����������');
         //������������ �������� ������
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
         //������� ����� ������
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
         //����������� ������� (���� �������, ��'���, ������)
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.###', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
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

procedure TMedocCorrective.CreateJ1201208XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
  DocumentSumm: double;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.1';

  HeaderDataSet.First;

  while not HeaderDataSet.EOF do begin
    if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then
       break;
    HeaderDataSet.Next;
  end;

  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    // ������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    // ��� ���������
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString;
    // Id ���������
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  // ��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  // ��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  // ������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  // ������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  // ����� �������� ��� ��������� ��������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  // ������ ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  // ��� ���������� �����'�����
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', HeaderDataSet.FieldByName('PZOB').AsString);

  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', '1');
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N26', '1');
  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     //�� ������� ��������� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N27', '1');


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // �� �������� �������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N17', '1');
     // �� �������� ������� (��� �������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N18',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;
  //���� ��������� ���������� �����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //���� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //����� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);

  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ���������� (����� ��볿) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);
  //���� ��������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ��������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);
  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //̳�������������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  // � Գ볿 �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_From').AsString);
  // ��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //����� �������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ ����� ������� ������ �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_To').AsString);
  //����� ���������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ "��������������� �� �������� �������" (������� 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_92', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));


  //����� ���������� ����������� (��� ���������� ����������� � ����� ��������� ���������)
  if HeaderDataSet.FieldByName('InvNumberBranch').AsString <> ''
  then
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', HeaderDataSet.FieldByName('InvNumberPartner').AsString+ '//'+HeaderDataSet.FieldByName('InvNumberBranch').AsString)
  else
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);

  with HeaderDataSet do begin
     First;
     i := 0;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
           //���� ������������
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //����� ����� ��, �� ����������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A01', FieldByName('LineNum').AsString);
           //������� �����������:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', FieldByName('KindName').AsString);
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A31', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //��� ������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A41', FieldByName('MeasureCode').AsString);
           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.####', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A7', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //��� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A011', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A013', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
//           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;
           inc(i);
        end;
        Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedocCorrective.CreateJ1201209XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IXMLZVITType;
  i: integer;
  DocumentSumm: double;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '4.1';

  HeaderDataSet.First;

  while not HeaderDataSet.EOF do begin
    if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then
       break;
    HeaderDataSet.Next;
  end;

  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    // ������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    // ��� ���������
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString;
    // Id ���������
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  // ��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  // ��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  // ������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  // ������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  // ����� �������� ��� ��������� ��������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  // ������ ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  // ��� ���������� �����'�����
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', HeaderDataSet.FieldByName('PZOB').AsString);

  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', '1');
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N26', '1');
  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     //�� ������� ��������� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N27', '1');


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // �� �������� �������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N17', '1');
     // �� �������� ������� (��� �������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N18',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;
  //���� ��������� ���������� �����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //���� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //����� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);

  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ���������� (����� ��볿) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);
  //���� ��������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //����� ��������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);
  //������������ �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //��� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //̳�������������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  // � Գ볿 �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_From').AsString);
  // ��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //����� �������� �������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //��� �������-��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //����� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //���� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //������� �����, ��� ������ ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //������������ ����� ������� ������ �������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_To').AsString);
  //����� ���������� ����������
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //������ "��������������� �� �������� �������" (������� 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //���� ����������� ����������� �����'������ �� ����������� �������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_92', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));


  //����� ���������� ����������� (��� ���������� ����������� � ����� ��������� ���������)
  if HeaderDataSet.FieldByName('InvNumberBranch').AsString <> ''
  then
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', HeaderDataSet.FieldByName('InvNumberPartner').AsString+ '//'+HeaderDataSet.FieldByName('InvNumberBranch').AsString)
  else
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);

  with HeaderDataSet do begin
     First;
     i := 0;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
           //���� ������������
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //����� ����� ��, �� ����������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A01', FieldByName('LineNum').AsString);
           //������� �����������:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', FieldByName('KindName').AsString);
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A31', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //��� ������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A41', FieldByName('MeasureCode').AsString);

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
           begin
               //����������� ������� (���� �������, ��'���, ������)
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A7', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
               //����������� �������  (���� ���������� ������� ������\�������):
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
           end
           else
           begin
               //����������� ������� (���� �������, ��'���, ������)
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
               //����������� �������  (���� ���������� ������� ������\�������):
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));
           end;

           //��� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A011', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A013', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
//           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;


           //������ ������������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A32', FieldByName('GoodsCodeTaxImport').AsString);
           //������� ����� � ����
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A33', FieldByName('GoodsCodeDKPP').AsString);
           //��� ���� �������� �� ���������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A014', FieldByName('GoodsCodeTaxAction').AsString);

           inc(i);
        end;
        Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedocCorrective.CreateJ1201210XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: Medoc_J1201210.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := Medoc_J1201210.NewDECLAR;

  ZVIT.DeclareNamespace(NS, NS_URI);
  //F1201210.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').AsString;
  //F1201209
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // F12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //012
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 7, 2); // 10

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';


  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     ZVIT.DECLARBODY.HERPN := 1;
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     ZVIT.DECLARBODY.HERPN0  := 1;

  if HeaderDataSet.FieldByName('TaxKind').asString = '4' then
     // ������� ��������� ��������
     ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // �������� �� ��������, ������� �� �������������
  //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������
     ZVIT.DECLARBODY.HORIG1 := 1;
     // �� �������� ������� (��� �������)
     ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  // ��� ���������� - ��������
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  // ������������ ���������� - ��������
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // ���������� ����� �������� ������� ��� ���� ��/��� ����� �������� (������������)
  ZVIT.DECLARBODY.HTINSEL := HeaderDataSet.FieldByName('OKPO_To').AsString;

  // ���� ��������� ��
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  // ���������� ����� ��
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  // ���������� ����� �� (��� ��������)
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  // �������� ����� ��볿 ��������
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);

  // ���� ��������� ��, ��� ����������
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  // ����� ��������� ��������, �� ����������
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);

  // ������������ ���������� - ����������
  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  // ��� ���������� - ����������
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  // ��� ��볿 �������
  if HeaderDataSet.FieldByName('InvNumberBranch_From').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);
  // ���������� ����� �������� ������� ��� ���� ��/��� ����� �������� (��������)
  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_From').AsString;

     // !!!!
     if (gc_User.Session = '5') or (gc_User.Session = '81241') then begin
  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00####', -1 * 0), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00####', -1 * 0), FormatSettings.DecimalSeparator, '.');
     end
     else begin
  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00####', -1 * HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00####', -1 * HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
     end;

  ZVIT.DECLARBODY.ChildNodes['R02G111'].SetAttributeNS('nil', NS_URI, true);
     // !!!!
     if (gc_User.Session = '5') or (gc_User.Session = '81241') then
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', -1 * 0), FormatSettings.DecimalSeparator, '.')
     else
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', -1 * HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  ZVIT.DECLARBODY.ChildNodes['R01G111'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R006G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R007G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R01G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do begin
     First;
     i := 1;
     // !!!!
     if (gc_User.Session <> '5') and (gc_User.Session <> '81241') then

     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString
        then begin

          //
          // with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := IntToStr(I); end;
          //����� ����� ��, �� ����������
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum').AsString; end;
          // ������� ����������� (��� �������)
          with ZVIT.DECLARBODY.RXXXXG21.Add do begin ROWNUM := I; NodeValue := FieldByName('KindCode').AsString; end;
          // ������� ����������� (� �/� ����� �����������)
          with ZVIT.DECLARBODY.RXXXXG22.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum_order').AsString; end;
          // ������������ ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          // ������ ������������� ������
          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // ������� ����� � ����
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // ��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;
          // ������� �����/������ ����������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          // ������� �����/������ ����������
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //�����������
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //�����������
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end
          else
          begin
              //ʳ������
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //ֳ�� ���������� ������� ������\�������
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          // ��� ������
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          // ��� �����
          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //���� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00####', -1 * FieldByName('SummVat').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //��� ���� �������� ��������������������� ���������������
          with ZVIT.DECLARBODY.RXXXXG011.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          inc(i);

         end;
         Next;
     end;
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_To').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);

  HeaderDataSet.Close;
  ItemsDataSet.Close;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedocCorrective.CreateJ1201211XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: Medoc_J1201211.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := Medoc_J1201211.NewDECLAR;

  ZVIT.DeclareNamespace(NS, NS_URI);
  //F1201210.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').AsString;
  //F1201209
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // F12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //012
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 7, 2); // 10

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';


  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     ZVIT.DECLARBODY.HERPN := 1;
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     ZVIT.DECLARBODY.HERPN0  := 1;

  if HeaderDataSet.FieldByName('TaxKind').asString = '4' then
     // ������� ��������� ��������
     ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // �������� �� ��������, ������� �� �������������
  //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������
     ZVIT.DECLARBODY.HORIG1 := 1;
     // �� �������� ������� (��� �������)
     ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  // ��� ���������� - ��������
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  // ������������ ���������� - ��������
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // ���������� ����� �������� ������� ��� ���� ��/��� ����� �������� (������������)
  ZVIT.DECLARBODY.HTINSEL := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  // ���� ��������� ��
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  // ���������� ����� ��
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  // ���������� ����� �� (��� ��������)
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  // �������� ����� ��볿 ��������
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);

  // ���� ��������� ��, ��� ����������
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  // ����� ��������� ��������, �� ����������
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);

  // ������������ ���������� - ����������
  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  // ��� ���������� - ����������
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  // ��� ��볿 �������
  if HeaderDataSet.FieldByName('InvNumberBranch_From').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);
  // ���������� ����� �������� ������� ��� ���� ��/��� ����� �������� (��������)
  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_From').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_From').AsString <> ''
  then ZVIT.DECLARBODY.HKB := StrToInt(HeaderDataSet.FieldByName('Code_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKB'].SetAttributeNS('nil', NS_URI, true);

     // !!!!
     if (gc_User.Session = '5') or (gc_User.Session = '81241') then begin
  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00####', -1 * 0), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00####', -1 * 0), FormatSettings.DecimalSeparator, '.');
     end
     else begin
  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00####', -1 * HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00####', -1 * HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
     end;

  ZVIT.DECLARBODY.ChildNodes['R02G111'].SetAttributeNS('nil', NS_URI, true);
     // !!!!
     if (gc_User.Session = '5') or (gc_User.Session = '81241') then
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', -1 * 0), FormatSettings.DecimalSeparator, '.')
     else
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', -1 * HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  ZVIT.DECLARBODY.ChildNodes['R01G111'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R006G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R007G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R01G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do begin
     First;
     i := 1;
     // !!!!
     if (gc_User.Session <> '5') and (gc_User.Session <> '81241') then

     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString
        then begin

          //
          // with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := IntToStr(I); end;
          //����� ����� ��, �� ����������
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum').AsString; end;
          // ������� ����������� (��� �������)
          with ZVIT.DECLARBODY.RXXXXG21.Add do begin ROWNUM := I; NodeValue := FieldByName('KindCode').AsString; end;
          // ������� ����������� (� �/� ����� �����������)
          with ZVIT.DECLARBODY.RXXXXG22.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum_order').AsString; end;
          // ������������ ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          // ������ ������������� ������
          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // ������� ����� � ����
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // ��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;
          // ������� �����/������ ����������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          // ������� �����/������ ����������
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //�����������
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //�����������
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end
          else
          begin
              //ʳ������
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //ֳ�� ���������� ������� ������\�������
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          // ��� ������
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          // ��� �����
          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //���� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00####', -1 * FieldByName('SummVat').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //��� ���� �������� ��������������������� ���������������
          with ZVIT.DECLARBODY.RXXXXG011.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          inc(i);

         end;
         Next;
     end;
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_To').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);

  HeaderDataSet.Close;
  ItemsDataSet.Close;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedocCorrective.CreateJ1201212XMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: Medoc_J1201212.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := Medoc_J1201212.NewDECLAR;

  ZVIT.DeclareNamespace(NS, NS_URI);
  //F1201212.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').AsString;
  //F1201212
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // F12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //012
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 7, 2); // 10

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';


  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     ZVIT.DECLARBODY.HERPN := 1;
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     ZVIT.DECLARBODY.HERPN0  := 1;

  if HeaderDataSet.FieldByName('TaxKind').asString = '4' then
     // ������� ��������� ��������
     ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // �������� �� ��������, ������� �� �������������
  //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������
     ZVIT.DECLARBODY.HORIG1 := 1;
     // �� �������� ������� (��� �������)
     ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  // ��� ���������� - ��������
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  // ������������ ���������� - ��������
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // ���������� ����� �������� ������� ��� ���� ��/��� ����� �������� (������������)
  ZVIT.DECLARBODY.HTINSEL := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  // ���� ��������� ��
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  // ���������� ����� ��
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  // ���������� ����� �� (��� ��������)
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  // �������� ����� ��볿 ��������
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);

  // ���� ��������� ��, ��� ����������
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  // ����� ��������� ��������, �� ����������
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);

  // ������������ ���������� - ����������

  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;


  // ��� ���������� - ����������
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  // ��� ��볿 �������
  if HeaderDataSet.FieldByName('InvNumberBranch_From').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);
  // ���������� ����� �������� ������� ��� ���� ��/��� ����� �������� (��������)
  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_From').AsString;
  // ���
  if HeaderDataSet.FieldByName('Code_From').AsString <> ''
  then ZVIT.DECLARBODY.HKB := StrToInt(HeaderDataSet.FieldByName('Code_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKB'].SetAttributeNS('nil', NS_URI, true);

     // !!!!
     if (gc_User.Session = '5') or (gc_User.Session = '81241') then begin
  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00####', -1 * 0), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00####', -1 * 0), FormatSettings.DecimalSeparator, '.');
     end
     else begin
  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00####', -1 * HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00####', -1 * HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
     end;

  ZVIT.DECLARBODY.ChildNodes['R02G111'].SetAttributeNS('nil', NS_URI, true);
     // !!!!
     if (gc_User.Session = '5') or (gc_User.Session = '81241') then
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', -1 * 0), FormatSettings.DecimalSeparator, '.')
     else
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', -1 * HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  ZVIT.DECLARBODY.ChildNodes['R01G111'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R006G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R007G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R01G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do begin
     First;
     i := 1;
     // !!!!
     if (gc_User.Session <> '5') and (gc_User.Session <> '81241') then

     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString
        then begin

          //
          // with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := IntToStr(I); end;
          //����� ����� ��, �� ����������
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum').AsString; end;
          // ������� ����������� (��� �������)
          with ZVIT.DECLARBODY.RXXXXG21.Add do begin ROWNUM := I; NodeValue := FieldByName('KindCode').AsString; end;
          // ������� ����������� (� �/� ����� �����������)
          with ZVIT.DECLARBODY.RXXXXG22.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum_order').AsString; end;
          // ������������ ������
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          // ������ ������������� ������
          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // ������� ����� � ����
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // ��� ������ ����� � ��� ���
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;
          // ������� �����/������ ����������
          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          // ������� �����/������ ����������
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //�����������
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.#####', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //�����������
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end
          else
          begin
              //ʳ������
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //ֳ�� ���������� ������� ������\�������
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          // ��� ������
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          // ��� �����
          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //���� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00####', -1 * FieldByName('SummVat').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //��� ���� �������� ��������������������� ���������������
          with ZVIT.DECLARBODY.RXXXXG011.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          inc(i);

         end;
         Next;
     end;
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_To').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);

  HeaderDataSet.Close;
  ItemsDataSet.Close;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);

end;

procedure TMedocCorrective.CreateJ1201209XMLFile_IFIN(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
var
  ZVIT: IFIN_J1201209.IXMLDeclarContent;
  i: integer;
const
  NS = 'xsi';
  NS_URI = 'http://www.w3.org/2001/XMLSchema-instance';
  TaxDateFormat = 'YYYYMMDD';
begin
  ZVIT := IFIN_J1201209.NewDECLAR;

  ZVIT.DeclareNamespace(NS, NS_URI);
  //F1201209.xsd
  ZVIT.SetAttributeNS('noNamespaceSchemaLocation', NS_URI, Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 8) + '.xsd');

  ZVIT.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').AsString;
  //F1201209
  ZVIT.DECLARHEAD.C_DOC := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 1, 3); // F12
  ZVIT.DECLARHEAD.C_DOC_SUB := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 4, 3); //012
  ZVIT.DECLARHEAD.C_DOC_VER := Copy(HeaderDataSet.FieldByName('CHARCODE').AsString, 8, 1); // 9

  //����� ������ ��������� (�����������) ��������� - ��� ������� ��������� (���������) ��������� �������� ������� �������� ��������� 0. ��� ������� ������������ ������ ��������� (�����������) ��������� ����� �� ���� ��� ������� ��������� ������� �������� ������������� �� �������
  ZVIT.DECLARHEAD.C_DOC_TYPE := '00';
  //����� ��������� � �������	- �������� ������� �������� �������� ���������� ����� ������� ����������� ��������� � ������ �������.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsString;

  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := '04';
  //��� �������	- ��� �������, �� ���������� ������� ����������� ��������� ���������, � ������� ������� �������� ���� ����� ���������. ����������� �������� ����������� SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := '65';

  //�������� �����	�������� ������� ��������� ��������� ����� � �������� ������� (��� ������� - ���������� ����� ������, ��� �������� - 3,6,9,12 �����, ��������� - 6 � 12, ��� ���� - 12)� 9 ������ � 9, ��� ���� � 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2)));
  //��� ��������� �������	1-�����, 2-�������, 3-���������, 4-������ ���., 5-���
  ZVIT.DECLARHEAD.PERIOD_TYPE := '1';
  //�������� ���	������ YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4)));

  //��� ���������, � ������� ������� �������� ���������	��� ���������� �� ����������� ���������. ����������� �� �������: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := '0465';
  //��������� ���������	1-�������� ��������, 2-����� �������� �������� ,3-���������� ��������
  ZVIT.DECLARHEAD.C_DOC_STAN := '1';
  //�������� ��������� ����������. ������� �������� �������, � ���� �������� �������� DOC	��� ��������� ��������� �������� ������ �� ����������, ��� ���������� - ������ �� ��������.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //���� ���������� ���������	������ ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //��������� ������������ �����������	������������� ��, � ������� �������� ����������� �����
  ZVIT.DECLARHEAD.SOFTWARE := 'iFin';


  ZVIT.DECLARBODY.HERPN0 := 1;
  ZVIT.DECLARBODY.ChildNodes['H03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);
  // ������������ ���������� - ��������
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // ������������ ���������� - ����������
  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  // ��� ���������� - ��������
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);
  // ��� ���������� - ����������
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.R001G03 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.R02G9   := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.ChildNodes['R02G111'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.R01G9   := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  ZVIT.DECLARBODY.ChildNodes['R01G111'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R006G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R007G03'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['R01G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do begin
     First;
     i := 1;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString
        then begin

          //
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := IntToStr(I); end;
          with ZVIT.DECLARBODY.RXXXXG2S.Add do begin ROWNUM := I; NodeValue := FieldByName('KindName').AsString; end;
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;

          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //����������� ������� (���� �������, ��'���, ������) - ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.')
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
              //����������� �������  (���� ���������� ������� ������\�������) - ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.')
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          end
          else
          begin
              //ʳ������
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //ֳ�� ���������� ������� ������\�������
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          //��� ������
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //������ ���������� (���� �������������) ��� ���������� ������� �� ������ �������
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', 1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;


          with ZVIT.DECLARBODY.RXXXXG011.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          inc(i);

         end;
         Next;
     end;
     // Close;
  end;

  ZVIT.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10_ifin').AsString;
  ZVIT.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_To').AsString;
  ZVIT.DECLARBODY.ChildNodes['R003G10S'].SetAttributeNS('nil', NS_URI, true);

  HeaderDataSet.Close;
  ItemsDataSet.Close;

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

  HeaderDataSet.First;

  while not HeaderDataSet.EOF do begin
    if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then
       break;
    HeaderDataSet.Next;
  end;

  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_To').AsString;


  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    // ������ ���� ������
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    // ��� ���������
    CHARCODE := 'J1201207';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    // Id ���������
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  // ��� ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  // ��� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  // ������������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  // ������� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  // ����� �������� ��� ��������� ��������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  // ������ ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  // ��� ���������� �����'�����
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', HeaderDataSet.FieldByName('PZOB').AsString);

  if HeaderDataSet.FieldByName('isERPN').asBoolean then
     // ϳ����� ��������� � ���� ��������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', '1');
  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // �� �������� �������
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N17', '1');
     // �� �������� ������� (��� �������)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N18',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;
  //���� ��������� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //���� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //����� ���������� �����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //�������� ����� ��볿
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);

  //���� ������� ��
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ����������
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //����� ��������� ��������, �� ���������� (����� ��볿) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);

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

  with HeaderDataSet do begin
     First;
     i := 0;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
           //���� ������������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //������� �����������:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', FieldByName('KindName').AsString);
           //������������ �������� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //��� ������ ����� � ��� ���
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A31', FieldByName('GoodsCodeUKTZED').AsString);
           //������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //��� ������� ����� ������
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A41', FieldByName('MeasureCode').AsString);
           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.####', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //����������� ������� (���� �������, ��'���, ������)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A7', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //����������� �������  (���� ���������� ������� ������\�������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //ϳ�������� �����. ������ ���������� ��� ���������� ��� (�� �������� �������):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
//           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;
           inc(i);
        end;
        Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.Encoding :='WINDOWS-1251';
  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

procedure TMedocCorrective.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet;  FileName: string; FIsMedoc : Boolean);
var
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';


   if FIsMedoc = FALSE
   then
       // ��� ��� IFin
       CreateJ1201209XMLFile_IFIN(HeaderDataSet, ItemsDataSet, FileName)
   else

   // ��� ��� ����� - 2021 - � 16.03
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '16.03.2021', F) then
      CreateJ1201212XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   // ��� ��� ����� - 2021 - �� 16.03
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.03.2021', F) then
      CreateJ1201211XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   // 2018
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.12.2018', F) then
      CreateJ1201210XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else

   if HeaderDataSet.FieldByName('OperDate').asDateTime >= StrToDateTime( '01.03.2017', F) then
      CreateJ1201209XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else

   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.04.2016', F) then
      CreateJ1201208XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else

   if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.12.2014', F) then
      CreateJ1201205XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else begin
     if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.01.2015', F) then
        CreateJ1201206XMLFile(HeaderDataSet, ItemsDataSet, FileName)
     else
        CreateJ1201207XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   end;
end;

initialization
  RegisterClass(TMedocAction);
  RegisterClass(TMedocCorrectiveAction);

end.




