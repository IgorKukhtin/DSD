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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := 'J1201005';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id документа
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //Адреса підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //Телефон підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);
  //Номер свідоцтва про реєстрацію платника
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_From').AsString);
  //Видається покупцю - Оригінал or //Видається покупцю - Копія
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', 'X');
  //Включено до ЄРПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', 'X');
  //Порядковий номер ПН (системне поле)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Порядковий номер ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //Місцезнаходження покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //Телефон покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Номер свідоцтва покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Форма проведення розрахунків
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);
  //Усього по розділу I (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 8 "основна ставка")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //ІІІ ПДВ (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ПДВ (колонка 8 "основна ставка" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума з ПДВ ("Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума з ПДВ ("основна ставка")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 10 "нульова ставка експорт")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //Дата відвантаження
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //Кількість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.###', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Ціна постачання одиниці товару\послуги
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ ("основна ставка")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ (нульова ставка експорт)
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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := 'J1201006';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id документа
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //Адреса підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //Телефон підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);
  //Видається покупцю - Оригінал or //Видається покупцю - Копія
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1', 'X');
  //Включено до ЄРПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', 'X');
  //Порядковий номер ПН (системне поле)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Порядковий номер ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //Місцезнаходження покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //Телефон покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Номер свідоцтва покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Форма проведення розрахунків
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);
  //Усього по розділу I (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 8 "основна ставка")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //ІІІ ПДВ (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ПДВ (колонка 8 "основна ставка" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума з ПДВ ("Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума з ПДВ ("основна ставка")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 10 "нульова ставка експорт")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //Дата відвантаження
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //Кількість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.###', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Ціна постачання одиниці товару\послуги
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ ("основна ставка")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ (нульова ставка експорт)
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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := 'J1201008';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id документа
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //Адреса підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //Телефон підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);

  //Порядковий номер ПН (системне поле)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Порядковий номер ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));

  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     // Зведена податкова накладна
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N25', '1');

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // Не видається покупцю
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N13', '1');
     // Не видається покупцю (тип причини)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N14',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;

  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  // № Філії покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_To').AsString);
  // Код ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //Місцезнаходження покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //Телефон покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Форма проведення розрахунків
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього по розділу I (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Розділ А Усього обсяги постачання за основною ставкою (код ставки 20)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Розділ А Усього обсяги постачання при експорті товарів за ставкою 0% (код ставки 901)
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));

   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 901 then begin
     //Розділ А Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;
   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 902 then begin
     //Розділ А Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_8', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;

  //Загальна сума податку на додану вартість за основною ставкою
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума податку на додану вартість, у тому числі:
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума кошті,що підлягають сплаті з урахуванням податку на додану вартість
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Посадова (уповноважена) особа/фізична особа (законний представник)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Реєстраційний номер облікової картки платника податку
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_From').AsString);

  //Загальна сума з ПДВ ("основна ставка")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Общая сумма с НДС (0% процентов (экспорт))
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 10 "нульова ставка експорт")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //Дата відвантаження
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //Код одиниці виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A141', FieldByName('MeasureCode').AsString);
           //Кількість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Ціна постачання одиниці товару\послуги
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Код ставки
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A10', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //Обсяги постачання без урахування ПДВ ("основна ставка")
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ (нульова ставка експорт)
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := '00';
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsString;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := '04';
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := '65';

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2)));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := '1';
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4)));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := '0465';
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := '1';
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.Nil_ := true;
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
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

          //Номенклатура поставки товарів
          with ZVIT.DECLARBODY.RXXXXG3S.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := FieldByName('GoodsName').AsString;
          end;

          //Код товару згідно з УКТ ЗЕД
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

          //Одиниця виміру товару
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

          //Кількість
          with ZVIT.DECLARBODY.RXXXXG5.Add do
          begin
            ROWNUM := IntToStr(i);
            //Nil_ := false;
            NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.');
          end;
          //Ціна постачання одиниці товару\послуги
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
          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString; // 'J1201009';
    //Id документа
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //Адреса підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //Телефон підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);

  //Порядковий номер ПН (системне поле)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Порядковий номер ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));

  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     // Зведена податкова накладна
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N25', '1');

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // Не видається покупцю
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N13', '1');
     // Не видається покупцю (тип причини)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N14',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;

  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  // № Філії покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_To').AsString);
  // Код ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //Місцезнаходження покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //Телефон покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Форма проведення розрахунків
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього по розділу I (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Розділ А Усього обсяги постачання за основною ставкою (код ставки 20)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Розділ А Усього обсяги постачання при експорті товарів за ставкою 0% (код ставки 901)
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));

   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 901 then begin
     //Розділ А Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;
   if HeaderDataSet.FieldByName('VatPercent').AsFloat = 902 then begin
     //Розділ А Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_8', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
   end;

  //Загальна сума податку на додану вартість за основною ставкою
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума податку на додану вартість, у тому числі:
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума кошті,що підлягають сплаті з урахуванням податку на додану вартість
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Посадова (уповноважена) особа/фізична особа (законний представник)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Реєстраційний номер облікової картки платника податку
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_From').AsString);

  //Загальна сума з ПДВ ("основна ставка")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Общая сумма с НДС (0% процентов (экспорт))
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 10 "нульова ставка експорт")
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //Дата відвантаження
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //Код одиниці виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A141', FieldByName('MeasureCode').AsString);
           //Кількість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Ціна постачання одиниці товару\послуги
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Код ставки
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A10', ReplaceStr(FormatFloat('0.00##', FieldByName('AmountSummNoVAT_12').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //Ознака імпортованого товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A132', FieldByName('GoodsCodeTaxImport').AsString);
           //Послуги згідно з ДКПП
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A133', FieldByName('GoodsCodeDKPP').AsString);
           //Код виду діяльності сг товаровир
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A11', FieldByName('GoodsCodeTaxAction').AsString);

           //Обсяги постачання без урахування ПДВ ("основна ставка")
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ (нульова ставка експорт)
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';

  // Зведена податкова накладна
  if HeaderDataSet.FieldByName('TaxKind').asString = '4'
  then
      ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // else
  begin
      // ZVIT.DECLARBODY.ChildNodes['R01G1'].SetAttributeNS('nil', NS_URI, true);
      // Складена на операції, звільнені від оподаткування
      //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
      // Не підлягає виданню отримувачу (покупцю) з причини
      //ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
      //Зазначається відповідний тип причини
      //ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);

      if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
      begin
         // Не видається покупцю
         ZVIT.DECLARBODY.HORIG1 := 1;
         // Не видається покупцю (тип причини)
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
  // № Філії покупця
  if HeaderDataSet.FieldByName('InvNumberBranch_To').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_To').AsString;

  // Загальна сума коштів, що підлягають сплаті з урахуванням податку на додану вартість
  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  // Загальна сума податку на додану вартість, у тому числі:
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G11'].SetAttributeNS('nil', NS_URI, true);
  // Загальна сума податку на додану вартість за основною ставкою
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G7'].SetAttributeNS('nil', NS_URI, true);
  // Загальна сума податку на додану вартість за ставкою 7%
  ZVIT.DECLARBODY.ChildNodes['R03G109'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги постачання за основною ставкою (код ставки 20)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R01G7'].SetAttributeNS('nil', NS_URI, true);;

  // Загальна сума податку на додану вартість за ставкою 7%
  ZVIT.DECLARBODY.ChildNodes['R01G109'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги постачання при експорті товарів за ставкою 0% (код ставки 901)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.ChildNodes['R01G9'].SetAttributeNS('nil', NS_URI, true)
  else ZVIT.DECLARBODY.R01G9 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  // Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
  ZVIT.DECLARBODY.ChildNodes['R01G8'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги операцій, звільнених від оподаткування (код ставки 903)
  ZVIT.DECLARBODY.ChildNodes['R01G10'].SetAttributeNS('nil', NS_URI, true);
  // Дані щодо зворотної (заставної) тари
  ZVIT.DECLARBODY.ChildNodes['R02G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do
  begin
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //Номенклатура поставки товарів
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
          //Код товару згідно з УКТ ЗЕД
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
          //Одиниця виміру товару
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
          //Одиниця виміру товару/послуги (код)
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
          //Кількість
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
          //Ціна постачання одиниці товару\послуги
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
          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
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
          //Сума податку на додану вартість
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';

  // Зведена податкова накладна
  if HeaderDataSet.FieldByName('TaxKind').asString = '4'
  then
      ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // else
  begin
      // ZVIT.DECLARBODY.ChildNodes['R01G1'].SetAttributeNS('nil', NS_URI, true);
      // Складена на операції, звільнені від оподаткування
      //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
      // Не підлягає виданню отримувачу (покупцю) з причини
      //ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
      //Зазначається відповідний тип причини
      //ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);

      if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
      begin
         // Не видається покупцю
         ZVIT.DECLARBODY.HORIG1 := 1;
         // Не видається покупцю (тип причини)
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
  // код
  if HeaderDataSet.FieldByName('Code_From').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').AsString;
  // № Філії покупця
  if HeaderDataSet.FieldByName('InvNumberBranch_To').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // код
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKB := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKB'].SetAttributeNS('nil', NS_URI, true);

  // Загальна сума коштів, що підлягають сплаті з урахуванням податку на додану вартість
  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  // Загальна сума податку на додану вартість, у тому числі:
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G11'].SetAttributeNS('nil', NS_URI, true);
  // Загальна сума податку на додану вартість за основною ставкою
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G7'].SetAttributeNS('nil', NS_URI, true);
  // Загальна сума податку на додану вартість за ставкою 7%
  ZVIT.DECLARBODY.ChildNodes['R03G109'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги постачання за основною ставкою (код ставки 20)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R01G7'].SetAttributeNS('nil', NS_URI, true);;

  // Загальна сума податку на додану вартість за ставкою 7%
  ZVIT.DECLARBODY.ChildNodes['R01G109'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги постачання при експорті товарів за ставкою 0% (код ставки 901)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.ChildNodes['R01G9'].SetAttributeNS('nil', NS_URI, true)
  else ZVIT.DECLARBODY.R01G9 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  // Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
  ZVIT.DECLARBODY.ChildNodes['R01G8'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги операцій, звільнених від оподаткування (код ставки 903)
  ZVIT.DECLARBODY.ChildNodes['R01G10'].SetAttributeNS('nil', NS_URI, true);
  // Дані щодо зворотної (заставної) тари
  ZVIT.DECLARBODY.ChildNodes['R02G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do
  begin
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //Номенклатура поставки товарів
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
          //Код товару згідно з УКТ ЗЕД
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
          //Одиниця виміру товару
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
          //Одиниця виміру товару/послуги (код)
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
          //Кількість
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
          //Ціна постачання одиниці товару\послуги
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
          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
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
          //Сума податку на додану вартість
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';

  // Зведена податкова накладна
  if HeaderDataSet.FieldByName('TaxKind').asString = '4'
  then
      ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // else
  begin
      // ZVIT.DECLARBODY.ChildNodes['R01G1'].SetAttributeNS('nil', NS_URI, true);
      // Складена на операції, звільнені від оподаткування
      //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);
      // Не підлягає виданню отримувачу (покупцю) з причини
      //ZVIT.DECLARBODY.ChildNodes['HORIG1'].SetAttributeNS('nil', NS_URI, true);
      //Зазначається відповідний тип причини
      //ZVIT.DECLARBODY.ChildNodes['HTYPR'].SetAttributeNS('nil', NS_URI, true);

      if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
      begin
         // Не видається покупцю
         ZVIT.DECLARBODY.HORIG1 := 1;
         // Не видається покупцю (тип причини)
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
  // код
  if HeaderDataSet.FieldByName('Code_From').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').AsString;
  // № Філії покупця
  if HeaderDataSet.FieldByName('InvNumberBranch_To').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);

  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // код
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKB := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKB'].SetAttributeNS('nil', NS_URI, true);

  // Загальна сума коштів, що підлягають сплаті з урахуванням податку на додану вартість
  ZVIT.DECLARBODY.R04G11  := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');

  // Загальна сума податку на додану вартість, у тому числі:
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G11  := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G11'].SetAttributeNS('nil', NS_URI, true);
  // Загальна сума податку на додану вартість за основною ставкою
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R03G7   := ReplaceStr(FormatFloat('0.00####', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R03G7'].SetAttributeNS('nil', NS_URI, true);
  // Загальна сума податку на додану вартість за ставкою 7%
  ZVIT.DECLARBODY.ChildNodes['R03G109'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги постачання за основною ставкою (код ставки 20)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.R01G7 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.')
  else ZVIT.DECLARBODY.ChildNodes['R01G7'].SetAttributeNS('nil', NS_URI, true);;

  // Загальна сума податку на додану вартість за ставкою 7%
  ZVIT.DECLARBODY.ChildNodes['R01G109'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги постачання при експорті товарів за ставкою 0% (код ставки 901)
  if (HeaderDataSet.FieldByName('VATPercent').AsFloat < 100)
  then ZVIT.DECLARBODY.ChildNodes['R01G9'].SetAttributeNS('nil', NS_URI, true)
  else ZVIT.DECLARBODY.R01G9 := ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.');
  // Усього обсяги постачання на митній території України за ставкою 0% (код ставки 902)
  ZVIT.DECLARBODY.ChildNodes['R01G8'].SetAttributeNS('nil', NS_URI, true);
  // Усього обсяги операцій, звільнених від оподаткування (код ставки 903)
  ZVIT.DECLARBODY.ChildNodes['R01G10'].SetAttributeNS('nil', NS_URI, true);
  // Дані щодо зворотної (заставної) тари
  ZVIT.DECLARBODY.ChildNodes['R02G11'].SetAttributeNS('nil', NS_URI, true);

  with ItemsDataSet do
  begin
     First;
     i := 1;
     while not EOF do
     begin
          if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0)then
          begin
          //Номенклатура поставки товарів
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
          //Код товару згідно з УКТ ЗЕД
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
          //Одиниця виміру товару
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
          //Одиниця виміру товару/послуги (код)
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
          //Кількість
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
          //Ціна постачання одиниці товару\послуги
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
          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
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
          //Сума податку на додану вартість
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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := 'J1201007';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id документа
    DOCID := HeaderDataSet.FieldByName('Id').AsString;
  end;


  //ЄДРПОУ покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', '');
  //Адреса підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_From').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //Телефон підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_From').AsString);

  //Порядковий номер ПН (системне поле)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Порядковий номер ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);
  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N11', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // Не видається покупцю
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N13', '1');
     // Не видається покупцю (тип причини)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N14',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;

  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_To').AsString);
  //Місцезнаходження покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  //Телефон покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Форма проведення розрахунків
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього по розділу I (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 8 "основна ставка")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III НДС (колонка 9 «0% экспорт»)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //ІІІ ПДВ (колонка 12 "Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //III ПДВ (колонка 8 "основна ставка" )
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A6_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума з ПДВ ("Загальна сума коштів, що підлягає сплаті")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_11', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Загальна сума з ПДВ ("основна ставка")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_7', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Общая сумма с НДС (0% процентов (экспорт))
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A7_9', ReplaceStr(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Усього по розділу I (колонка 10 "нульова ставка експорт")
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A5_9', '0.00');

  with ItemsDataSet do begin
     First;
     i := 0;
     while not EOF do begin
         if (FieldByName('Amount').AsFloat <> 0) and (FieldByName('PriceNoVAT').AsFloat <> 0) then begin
           //Дата відвантаження
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A13', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A131', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //Код одиниці виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A141', FieldByName('MeasureCode').AsString);
           //Кількість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.####', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Ціна постачання одиниці товару\послуги
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00##', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ ("основна ставка")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ (нульова ставка експорт)
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
       // так для IFin
       CreateJ1201009XMLFile_IFIN(HeaderDataSet, ItemsDataSet, FileName)
   else

   // так для Медка - 2021 - с 16.03
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '16.03.2021', F) then
       CreateJ1201012XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   // так для Медка - 2021 - до 16.03
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
      // так для Медка
      FileName := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime) + '_' +
                  trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml'
    else
      // так для IFin
      FileName := '0000'

                  //Номер ЄДРПОУ, Дополняется слева нулями до 10 знаков.
                + HeaderDataSet.FieldByName('OKPO_From_ifin').AsString

                + HeaderDataSet.FieldByName('CHARCODE').AsString

                + '1'  // Состояние документа.

                + '00' //Номер нового отчёнтого (уточняющего) док-та в отчётном периоде. Дополняется слева нулями до 2 знаков

                  //Номер документа в периоде. Дополняется слева нулями до 7 знаков.
                + HeaderDataSet.FieldByName('InvNumberPartner_ifin').AsString

                + '1'  //Код отчётного периода (1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год).

                + FormatDateTime('mmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime)
                +'.xml';

    if Directory <> '' then begin
       if not DirectoryExists(Directory) then
          ForceDirectories(Directory);
       FileName := Directory + FileName;
    end;
    Filter := 'Файлы МеДок (.xml)|*.xml|';
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
      // так для Медка
      FileName := FormatDateTime('dd_mm_yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime)
          + '_' + trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml'
    else
      // так для IFin
      FileName := '0000'

                  //Номер ЄДРПОУ, Дополняется слева нулями до 10 знаков.
                + HeaderDataSet.FieldByName('OKPO_To_ifin').AsString

                + HeaderDataSet.FieldByName('CHARCODE').AsString

                + '1'  // Состояние документа.

                + '00' //Номер нового отчёнтого (уточняющего) док-та в отчётном периоде. Дополняется слева нулями до 2 знаков

                  //Номер документа в периоде. Дополняется слева нулями до 7 знаков.
                + HeaderDataSet.FieldByName('InvNumberPartner_ifin').AsString

                + '1'  //Код отчётного периода (1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год).

                + FormatDateTime('mmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime)
                +'.xml';


    if Directory <> '' then begin
       if not DirectoryExists(Directory) then
          ForceDirectories(Directory);
       FileName := Directory + FileName;
    end;
    Filter := 'Файлы МеДок (.xml)|*.xml|';
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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := 'J1201205';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id документа
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //Телефон підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Номер свідоцтва про реєстрацію платника
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //Адреса підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);

  //Код податкових зобов'язань
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', '5');
  //Видається покупцю - Оригінал or //Видається покупцю - Копія
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'K1', 'X');
   //Включено до ЄРПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', 'X');
  //Дата складання розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Дата розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Номер розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', '');

  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується (номер філії) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);

  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);

  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //Місцезнаходження покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Телефон покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  //Номер свідоцтва покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Форма проведення розрахунків
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього "Оподатковуються за основною ставкою" (колонка 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));

  with ItemsDataSet do begin
     First;
     i := 0;
     DocumentSumm := 0;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
         //Дата відвантаження
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
         //Причина коригування:
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', 'повернення');
         //Номенклатура поставки товарів
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
         //Одиниця виміру товару
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
         //Коригування кількості (зміна кількості, об'єму, обсягу)
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.###', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
         //Коригування кількості  (ціна постачання одиниці товару\послуги):
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

         //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
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
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := 'J1201206';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    //Id документа
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  //Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  //ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  //Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  //Телефон підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  //Номер свідоцтва про реєстрацію платника
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  //Адреса підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);

  //Код податкових зобов'язань
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', '5');
  //Видається покупцю - Оригінал or //Видається покупцю - Копія
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'K1', 'X');
   //Включено до ЄРПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', 'X');
  //Дата складання розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Дата розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Номер розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', '');

  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується (номер філії) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);

  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);

  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //Місцезнаходження покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Телефон покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  //Номер свідоцтва покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Форма проведення розрахунків
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього "Оподатковуються за основною ставкою" (колонка 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));

  with ItemsDataSet do begin
     First;
     i := 0;
     DocumentSumm := 0;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
         //Дата відвантаження
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
         //Причина коригування:
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', 'повернення');
         //Номенклатура поставки товарів
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
         //Одиниця виміру товару
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
         //Коригування кількості (зміна кількості, об'єму, обсягу)
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.###', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
         //Коригування кількості  (ціна постачання одиниці товару\послуги):
         CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

         //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
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
    // перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    // код документу
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString;
    // Id документа
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  // Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  // ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  // Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  // Телефон підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  // Номер свідоцтва про реєстрацію платника
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  // Адреса підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  // Код податкових зобов'язань
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', HeaderDataSet.FieldByName('PZOB').AsString);

  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', '1');
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N26', '1');
  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     //До зведеної податкової накладної
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N27', '1');


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // Не видається покупцю
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N17', '1');
     // Не видається покупцю (тип причини)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N18',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;
  //Дата складання розрахунку коригування
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Дата розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Номер розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);

  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується (номер філії) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);
  //Дата договору
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Номер договору
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);
  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //Місцезнаходження покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Телефон покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  // № Філії покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_From').AsString);
  // Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //Номер свідоцтва покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Реєстраційний номер облікової картки платника податку
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_To').AsString);
  //Форма проведення розрахунків
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього "Оподатковуються за основною ставкою" (колонка 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_92', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));


  //Номер розрахунку коригування (для коректного відображення в Реєстрі первинних документів)
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
           //Дата відвантаження
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номер рядка ПН, що коригується
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A01', FieldByName('LineNum').AsString);
           //Причина коригування:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', FieldByName('KindName').AsString);
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A31', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //Код одиниці виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A41', FieldByName('MeasureCode').AsString);
           //Коригування кількості (зміна кількості, об'єму, обсягу)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.####', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Коригування кількості  (ціна постачання одиниці товару\послуги):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //Коригування кількості (зміна кількості, об'єму, обсягу)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A7', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Коригування кількості  (ціна постачання одиниці товару\послуги):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //Код ставки
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A011', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A013', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
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
    // перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    // код документу
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString;
    // Id документа
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  // Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  // ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  // Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  // Телефон підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  // Номер свідоцтва про реєстрацію платника
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  // Адреса підприємства
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  // Код податкових зобов'язань
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', HeaderDataSet.FieldByName('PZOB').AsString);

  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', '1');
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N26', '1');
  if HeaderDataSet.FieldByName('TaxKind').asString = 'X' then
     //До зведеної податкової накладної
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N27', '1');


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // Не видається покупцю
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N17', '1');
     // Не видається покупцю (тип причини)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N18',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;
  //Дата складання розрахунку коригування
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Дата розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Номер розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);

  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується (номер філії) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);
  //Дата договору
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Номер договору
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);
  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //Місцезнаходження покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Телефон покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  // № Філії покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'DEPT_POK', HeaderDataSet.FieldByName('InvNumberBranch_From').AsString);
  // Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'EDR_POK', HeaderDataSet.FieldByName('OKPO_From').AsString);
  //Номер свідоцтва покупця
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Реєстраційний номер облікової картки платника податку
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'INN', HeaderDataSet.FieldByName('AccounterINN_To').AsString);
  //Форма проведення розрахунків
  //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього "Оподатковуються за основною ставкою" (колонка 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_92', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));


  //Номер розрахунку коригування (для коректного відображення в Реєстрі первинних документів)
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
           //Дата відвантаження
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Номер рядка ПН, що коригується
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A01', FieldByName('LineNum').AsString);
           //Причина коригування:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', FieldByName('KindName').AsString);
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A31', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //Код одиниці виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A41', FieldByName('MeasureCode').AsString);

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
           begin
               //Коригування кількості (зміна кількості, об'єму, обсягу)
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A7', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
               //Коригування кількості  (ціна постачання одиниці товару\послуги):
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
           end
           else
           begin
               //Коригування кількості (зміна кількості, об'єму, обсягу)
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
               //Коригування кількості  (ціна постачання одиниці товару\послуги):
               CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));
           end;

           //Код ставки
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A011', ReplaceStr(FormatFloat('0.###', HeaderDataSet.FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A013', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
           //CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A9', ReplaceStr(FormatFloat('0.00', - FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'));
//           DocumentSumm := DocumentSumm + FieldByName('AmountSumm').AsFloat;


           //Ознака імпортованого товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A32', FieldByName('GoodsCodeTaxImport').AsString);
           //Послуги згідно з ДКПП
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A33', FieldByName('GoodsCodeDKPP').AsString);
           //Код виду діяльності сг товаровир
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';


  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     ZVIT.DECLARBODY.HERPN := 1;
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     ZVIT.DECLARBODY.HERPN0  := 1;

  if HeaderDataSet.FieldByName('TaxKind').asString = '4' then
     // Зведена податкова накладна
     ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // Складена на операції, звільнені від оподаткування
  //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // Не видається покупцю
     ZVIT.DECLARBODY.HORIG1 := 1;
     // Не видається покупцю (тип причини)
     ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  // ІПН підприємства - Продавец
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  // Найменування підприємства - Продавец
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // Податковий номер платника податку або серія та/або номер паспорта (постачальник)
  ZVIT.DECLARBODY.HTINSEL := HeaderDataSet.FieldByName('OKPO_To').AsString;

  // Дата складання РК
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  // Порядковий номер РК
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  // Порядковий номер РК (код діяльності)
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  // Числовий номер філії продавця
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);

  // Дата складання ПН, яка коригується
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  // Номер податкової накладної, що коригується
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);

  // Найменування підприємства - Покупатель
  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  // ІПН підприємства - Покупатель
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  // Код філії покупця
  if HeaderDataSet.FieldByName('InvNumberBranch_From').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);
  // Податковий номер платника податку або серія та/або номер паспорта (покупець)
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
          //Номер рядка ПН, що коригується
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum').AsString; end;
          // Причина коригування (код причини)
          with ZVIT.DECLARBODY.RXXXXG21.Add do begin ROWNUM := I; NodeValue := FieldByName('KindCode').AsString; end;
          // Причина коригування (№ з/п групи коригування)
          with ZVIT.DECLARBODY.RXXXXG22.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum_order').AsString; end;
          // Номенклатура товарів
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          // Ознака імпортованого товару
          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // Послуги згідно з ДКПП
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // Код товару згідно з УКТ ЗЕД
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;
          // Одиниця виміру/Умовне позначення
          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          // Одиниця виміру/Умовне позначення
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //Коригування
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Коригування
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end
          else
          begin
              //Кількість
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Ціна постачання одиниці товару\послуги
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          // Код ставки
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          // Код пільги
          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //Сума податку на додану вартість
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00####', -1 * FieldByName('SummVat').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //Код виду діяльності сільськогосподарського товаровиробника
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';


  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     ZVIT.DECLARBODY.HERPN := 1;
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     ZVIT.DECLARBODY.HERPN0  := 1;

  if HeaderDataSet.FieldByName('TaxKind').asString = '4' then
     // Зведена податкова накладна
     ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // Складена на операції, звільнені від оподаткування
  //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // Не видається покупцю
     ZVIT.DECLARBODY.HORIG1 := 1;
     // Не видається покупцю (тип причини)
     ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  // ІПН підприємства - Продавец
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  // Найменування підприємства - Продавец
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // Податковий номер платника податку або серія та/або номер паспорта (постачальник)
  ZVIT.DECLARBODY.HTINSEL := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // код
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  // Дата складання РК
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  // Порядковий номер РК
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  // Порядковий номер РК (код діяльності)
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  // Числовий номер філії продавця
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);

  // Дата складання ПН, яка коригується
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  // Номер податкової накладної, що коригується
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);

  // Найменування підприємства - Покупатель
  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  // ІПН підприємства - Покупатель
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  // Код філії покупця
  if HeaderDataSet.FieldByName('InvNumberBranch_From').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);
  // Податковий номер платника податку або серія та/або номер паспорта (покупець)
  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_From').AsString;
  // код
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
          //Номер рядка ПН, що коригується
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum').AsString; end;
          // Причина коригування (код причини)
          with ZVIT.DECLARBODY.RXXXXG21.Add do begin ROWNUM := I; NodeValue := FieldByName('KindCode').AsString; end;
          // Причина коригування (№ з/п групи коригування)
          with ZVIT.DECLARBODY.RXXXXG22.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum_order').AsString; end;
          // Номенклатура товарів
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          // Ознака імпортованого товару
          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // Послуги згідно з ДКПП
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // Код товару згідно з УКТ ЗЕД
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;
          // Одиниця виміру/Умовне позначення
          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          // Одиниця виміру/Умовне позначення
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //Коригування
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Коригування
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end
          else
          begin
              //Кількість
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Ціна постачання одиниці товару\послуги
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          // Код ставки
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          // Код пільги
          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //Сума податку на додану вартість
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00####', -1 * FieldByName('SummVat').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //Код виду діяльності сільськогосподарського товаровиробника
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := 0;
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsInteger;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := 4;
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := 63;

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := 1;
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := 463;
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := 1;
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
  ZVIT.DECLARHEAD.SOFTWARE := 'MEDOC';


  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     ZVIT.DECLARBODY.HERPN := 1;
  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     ZVIT.DECLARBODY.HERPN0  := 1;

  if HeaderDataSet.FieldByName('TaxKind').asString = '4' then
     // Зведена податкова накладна
     ZVIT.DECLARBODY.R01G1 := StrToInt(HeaderDataSet.FieldByName('TaxKind').AsString);
  // Складена на операції, звільнені від оподаткування
  //****ZVIT.DECLARBODY.ChildNodes['R03G10S'].SetAttributeNS('nil', NS_URI, true);

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // Не видається покупцю
     ZVIT.DECLARBODY.HORIG1 := 1;
     // Не видається покупцю (тип причини)
     ZVIT.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  // ІПН підприємства - Продавец
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  // Найменування підприємства - Продавец
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // Податковий номер платника податку або серія та/або номер паспорта (постачальник)
  ZVIT.DECLARBODY.HTINSEL := HeaderDataSet.FieldByName('OKPO_To').AsString;
  // код
  if HeaderDataSet.FieldByName('Code_To').AsString <> ''
  then ZVIT.DECLARBODY.HKS := StrToInt(HeaderDataSet.FieldByName('Code_To').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HKS'].SetAttributeNS('nil', NS_URI, true);

  // Дата складання РК
  ZVIT.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  // Порядковий номер РК
  ZVIT.DECLARBODY.HNUM := StrToInt(HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  // Порядковий номер РК (код діяльності)
  ZVIT.DECLARBODY.ChildNodes['HNUM1'].SetAttributeNS('nil', NS_URI, true);
  // Числовий номер філії продавця
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);

  // Дата складання ПН, яка коригується
  ZVIT.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime);
  // Номер податкової накладної, що коригується
  ZVIT.DECLARBODY.HPODNUM := StrToInt(HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM1'].SetAttributeNS('nil', NS_URI, true);
  ZVIT.DECLARBODY.ChildNodes['HPODNUM2'].SetAttributeNS('nil', NS_URI, true);

  // Найменування підприємства - Покупатель

  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;


  // ІПН підприємства - Покупатель
  ZVIT.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').AsString;
  // Код філії покупця
  if HeaderDataSet.FieldByName('InvNumberBranch_From').AsString <> ''
  then ZVIT.DECLARBODY.HFBUY := StrToInt(HeaderDataSet.FieldByName('InvNumberBranch_From').AsString)
  else ZVIT.DECLARBODY.ChildNodes['HFBUY'].SetAttributeNS('nil', NS_URI, true);
  // Податковий номер платника податку або серія та/або номер паспорта (покупець)
  ZVIT.DECLARBODY.HTINBUY := HeaderDataSet.FieldByName('OKPO_From').AsString;
  // код
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
          //Номер рядка ПН, що коригується
          with ZVIT.DECLARBODY.RXXXXG001.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum').AsString; end;
          // Причина коригування (код причини)
          with ZVIT.DECLARBODY.RXXXXG21.Add do begin ROWNUM := I; NodeValue := FieldByName('KindCode').AsString; end;
          // Причина коригування (№ з/п групи коригування)
          with ZVIT.DECLARBODY.RXXXXG22.Add do begin ROWNUM := I; NodeValue := FieldByName('LineNum_order').AsString; end;
          // Номенклатура товарів
          with ZVIT.DECLARBODY.RXXXXG3S.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsName').AsString; end;
          // Ознака імпортованого товару
          with ZVIT.DECLARBODY.RXXXXG32.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // Послуги згідно з ДКПП
          with ZVIT.DECLARBODY.RXXXXG33.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          // Код товару згідно з УКТ ЗЕД
          with ZVIT.DECLARBODY.RXXXXG4.Add do begin ROWNUM := I; NodeValue := FieldByName('GoodsCodeUKTZED').AsString; end;
          // Одиниця виміру/Умовне позначення
          with ZVIT.DECLARBODY.RXXXXG4S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureName').AsString; end;
          // Одиниця виміру/Умовне позначення
          with ZVIT.DECLARBODY.RXXXXG105_2S.Add do begin ROWNUM := I; NodeValue := FieldByName('MeasureCode').AsString; end;

           if FieldByName('Price_for_PriceCor').AsFloat <> 0 then
          begin
              //Коригування
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.#####', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Коригування
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end
          else
          begin
              //Кількість
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', -1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Ціна постачання одиниці товару\послуги
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          // Код ставки
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          // Код пільги
          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
          with ZVIT.DECLARBODY.RXXXXG010.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', -1 * FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //Сума податку на додану вартість
          with ZVIT.DECLARBODY.RXXXXG11_10.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00####', -1 * FieldByName('SummVat').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          //Код виду діяльності сільськогосподарського товаровиробника
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

  //Номер нового отчётного (уточняющего) документа - Для первого поданного (отчётного) документа значение данного элемента равняется 0. Для каждого последующего нового отчётного (уточняющего) документа этого же типа для данного отчётного периода значение увеличивается на единицу
  ZVIT.DECLARHEAD.C_DOC_TYPE := '00';
  //Номер документа в периоде	- Значение данного элемента содержит порядковый номер каждого однотипного документа в данном периоде.
  ZVIT.DECLARHEAD.C_DOC_CNT := HeaderDataSet.FieldByName('InvNumberPartner').AsString;

  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_REG := '04';
  //Код области	- Код области, на территории которой расположена налоговая инспекция, в которую подаётся оригинал либо копия документа. Заполняется согласно справочнику SPR_STI.XML.
  ZVIT.DECLARHEAD.C_RAJ := '65';

  //Отчётный месяц	Отчётным месяцем считается последний месяц в отчётном периоде (для месяцев - порядковый номер месяца, для квартала - 3,6,9,12 месяц, полугодия - 6 и 12, для года - 12)я 9 місяців – 9, для року – 12)
  ZVIT.DECLARHEAD.PERIOD_MONTH := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 3, 2)));
  //Тип отчётного периода	1-месяц, 2-квартал, 3-полугодие, 4-девять мес., 5-год
  ZVIT.DECLARHEAD.PERIOD_TYPE := '1';
  //Отчётный год	Формат YYYY
  ZVIT.DECLARHEAD.PERIOD_YEAR := IntToStr(StrToInt(Copy(FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime), 5, 4)));

  //Код инспекции, в которую подаётся оригинал документа	Код выбирается из справочника инспекций. вычисляется по формуле: C_REG*100+C_RAJ.
  ZVIT.DECLARHEAD.C_STI_ORIG := '0465';
  //Состояние документа	1-отчётный документ, 2-новый отчётный документ ,3-уточняющий документ
  ZVIT.DECLARHEAD.C_DOC_STAN := '1';
  //Перечень связанных документов. Элемент является узловым, в себе содержит элементы DOC	Для основного документа содержит ссылку на дополнение, для дополнения - ссылку на основной.
  ZVIT.DECLARHEAD.LINKED_DOCS.SetAttributeNS('nil', NS_URI, true);
  //Дата заполнения документа	Формат ddmmyyyy
  ZVIT.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime);
  //Сигнатура программного обеспечения	Идентификатор ПО, с помощью которого сформирован отчёт
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
  // Найменування підприємства - Продавец
  ZVIT.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_To').AsString;
  // Найменування підприємства - Покупатель
  if HeaderDataSet.FieldByName('JuridicalName_From_add').AsString <> ''
  then ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString
                                 + HeaderDataSet.FieldByName('JuridicalName_From_add').AsString
  else ZVIT.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_From').AsString;
  // ІПН підприємства - Продавец
  ZVIT.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').AsString;
  ZVIT.DECLARBODY.ChildNodes['HNUM2'].SetAttributeNS('nil', NS_URI, true);
  // ІПН підприємства - Покупатель
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
              //Коригування кількості (зміна кількості, об'єму, обсягу) - ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.')
              with ZVIT.DECLARBODY.RXXXXG7.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
              //Коригування кількості  (ціна постачання одиниці товару\послуги) - ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.')
              with ZVIT.DECLARBODY.RXXXXG8.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;
          end
          else
          begin
              //Кількість
              with ZVIT.DECLARBODY.RXXXXG5.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
              //Ціна постачання одиниці товару\послуги
              with ZVIT.DECLARBODY.RXXXXG6.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00##', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'); end;
          end;

          //Код ставки
          with ZVIT.DECLARBODY.RXXXXG008.Add do begin ROWNUM := I; NodeValue := ReplaceStr(FormatFloat('0.00', FieldByName('VatPercent').AsFloat), FormatSettings.DecimalSeparator, '.'); end;

          with ZVIT.DECLARBODY.RXXXXG009.Add do begin ROWNUM := I; SetAttributeNS('nil', NS_URI, true); end;

          //Обсяги постачання (база оподаткування) без урахування податку на додану вартість
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
    // перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    // код документу
    CHARCODE := 'J1201207';//HeaderDataSet.FieldByName('CHARCODE').AsString;
    // Id документа
    DOCID := HeaderDataSet.FieldByName('MovementId').AsString;
  end;

  // Код ЄДРПОУ підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_EDRPOU', HeaderDataSet.FieldByName('OKPO_To').AsString);
  // ІПН підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_INN', HeaderDataSet.FieldByName('INN_To').AsString);
  // Найменування підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_NAME', HeaderDataSet.FieldByName('JuridicalName_To').AsString);
  // Телефон підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PHON', HeaderDataSet.FieldByName('Phone_To').AsString);
  // Номер свідоцтва про реєстрацію платника
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_SRPNDS', HeaderDataSet.FieldByName('NumberVAT_To').AsString);
  // Адреса підприємства
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'FIRM_ADR', HeaderDataSet.FieldByName('JuridicalAddress_To').AsString);
  // Код податкових зобов'язань
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'PZOB', HeaderDataSet.FieldByName('PZOB').AsString);

  if HeaderDataSet.FieldByName('isERPN').asBoolean then
     // Підлягає реєстрації в ЄРПН покупцем
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N16', '1');
  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
     // Не видається покупцю
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N17', '1');
     // Не видається покупцю (тип причини)
     CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N18',
             HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString);
  end;
  //Дата складання розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N12', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Дата розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N15', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
  //Номер розрахунку коригування
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_11', HeaderDataSet.FieldByName('InvNumberPartner').AsString);
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N1_13', HeaderDataSet.FieldByName('InvNumberBranch').AsString);

  //Дата виписки ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate_Child').AsDateTime));
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_1', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_11', HeaderDataSet.FieldByName('InvNumber_Child').AsString);
  //Номер податкової накладної, що корегується (номер філії) +++
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', HeaderDataSet.FieldByName('InvNumberBranch_Child').AsString);

  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_2', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_3', HeaderDataSet.FieldByName('ContractName').AsString);

  //Найменування покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N3', HeaderDataSet.FieldByName('JuridicalName_From').AsString);
  //ІПН покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N4', HeaderDataSet.FieldByName('INN_From').AsString);
  //Місцезнаходження покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N5', HeaderDataSet.FieldByName('JuridicalAddress_From').AsString);
  //Телефон покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N6', HeaderDataSet.FieldByName('Phone_From').AsString);
  //Номер свідоцтва покупця
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N7', HeaderDataSet.FieldByName('NumberVAT_From').AsString);

  //Вид цивільно-правового договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N8', HeaderDataSet.FieldByName('ContractKind').AsString);
  //Номер договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N81', HeaderDataSet.FieldByName('ContractName').AsString);
  //Дата договору
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N82', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('ContractSigningDate').AsDateTime));
  //Прізвище особи, яка склала ПН
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N10', HeaderDataSet.FieldByName('N10').AsString);
  //Форма проведення розрахунків
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N9', HeaderDataSet.FieldByName('N9').AsString);

  //Усього "Оподатковуються за основною ставкою" (колонка 10)
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A1_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
  //Сума коригування податкового зобов'язання та податкового кредиту
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'A2_9', ReplaceStr(FormatFloat('0.00', - HeaderDataSet.FieldByName('TotalSummVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));

  with HeaderDataSet do begin
     First;
     i := 0;
     while not EOF do begin
        if HeaderDataSet.FieldByName('MovementId').AsString = HeaderDataSet.FieldByName('inMovementId').AsString then begin
           //Дата відвантаження
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A1', FormatDateTime('dd.mm.yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime));
           //Причина коригування:
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A2', FieldByName('KindName').AsString);
           //Номенклатура поставки товарів
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A3', FieldByName('GoodsName').AsString);
           //Код товару згідно з УКТ ЗЕД
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A31', FieldByName('GoodsCodeUKTZED').AsString);
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A4', FieldByName('MeasureName').AsString);
           //Код одиниці виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A41', FieldByName('MeasureCode').AsString);
           //Коригування кількості (зміна кількості, об'єму, обсягу)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A5', ReplaceStr(FormatFloat('0.####', - FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Коригування кількості  (ціна постачання одиниці товару\послуги):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A6', ReplaceStr(FormatFloat('0.00', FieldByName('Price').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //Коригування кількості (зміна кількості, об'єму, обсягу)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A7', ReplaceStr(FormatFloat('0.00', -1 * FieldByName('Price_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Коригування кількості  (ціна постачання одиниці товару\послуги):
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A8', ReplaceStr(FormatFloat('0.####', 1 * FieldByName('Amount_for_PriceCor').AsFloat), FormatSettings.DecimalSeparator, '.'));

           //Підлягають кориг. обсяги постачання без урахування ПДВ (за основною ставкою):
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
       // так для IFin
       CreateJ1201209XMLFile_IFIN(HeaderDataSet, ItemsDataSet, FileName)
   else

   // так для Медка - 2021 - с 16.03
   if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '16.03.2021', F) then
      CreateJ1201212XMLFile(HeaderDataSet, ItemsDataSet, FileName)
   else
   // так для Медка - 2021 - до 16.03
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




