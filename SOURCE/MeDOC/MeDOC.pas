unit MeDOC;

interface

uses MeDocXML, dsdAction, DB;

type

  TMedoc = class
  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  end;

  TMedocCorrective = class
  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  end;

  TMedocAction = class(TdsdCustomAction)
  private
    FHeaderDataSet: TDataSet;
    FItemsDataSet: TDataSet;
  protected
    function LocalExecute: boolean; override;
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
  end;

  TMedocCorrectiveAction = class(TMedocAction)
  protected
    function LocalExecute: boolean; override;
  end;

  procedure Register;

implementation

uses VCL.ActnList, StrUtils, SysUtils, Dialogs, DateUtils;

procedure Register;
begin
  RegisterActions('TaxLib', [TMedocAction], TMedocAction);
end;

{ TMedoc }

procedure TMedoc.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet; FileName: string);
  function CreateNodeROW_XML(DOCUMENT: IXMLDOCUMENTType; Tab, Line, Name, Value: String): IXMLROWType;
  begin
    result := DOCUMENT.Add;
    result.Tab   := Tab;
    result.Line  := Line;
    result.Name  := Name;
    result.Value := trim(Value);
  end;
var
  ZVIT: IXMLZVITType;
  i: integer;
begin
  ZVIT := NewZVIT;
  ZVIT.TRANSPORT.CREATEDATE := FormatDateTime('dd.mm.yyyy', Now);
  ZVIT.TRANSPORT.VERSION := '3.0';
  ZVIT.ORG.FIELDS.EDRPOU := HeaderDataSet.FieldByName('OKPO_From').AsString;

  with ZVIT.ORG.CARD.FIELDS do begin
    PERTYPE := '0';
    //перший день періоду
    PERDATE := FormatDateTime('dd.mm.yyyy', StartOfTheMonth(HeaderDataSet.FieldByName('OperDate').AsDateTime));
    //код документу
    CHARCODE := HeaderDataSet.FieldByName('CHARCODE').AsString;
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
  //Числовий номер філії
  CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '0', '0', 'N2_13', '');
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
           //Одиниця виміру товару
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A14', FieldByName('MeasureName').AsString);
           //Кількість
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A15', ReplaceStr(FormatFloat('0.00', FieldByName('Amount').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Ціна постачання одиниці товару\послуги
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A16', ReplaceStr(FormatFloat('0.00', FieldByName('PriceNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ ("основна ставка")
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A17', ReplaceStr(FormatFloat('0.00', FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator, '.'));
           //Обсяги постачання без урахування ПДВ (нульова ставка експорт)
           CreateNodeROW_XML(ZVIT.ORG.CARD.DOCUMENT, '1', IntToStr(i), 'TAB1_A19', '0.00');
           inc(i);
         end;
         Next;
     end;
     Close;
  end;

  ZVIT.OwnerDocument.SaveToFile(FileName);
end;

{ TMedocAction }

function TMedocAction.LocalExecute: boolean;
begin
  with TSaveDialog.Create(nil) do
  try
    DefaultExt := '*.xml';
    FileName := FormatDateTime('dd_mm_yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime) + '_' +
                trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml';
    Filter := 'Файлы МеДок (.xml)|*.xml|';
    if Execute then begin
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

{ TMedocCorrectiveAction }

function TMedocCorrectiveAction.LocalExecute: boolean;
begin
  with TSaveDialog.Create(nil) do
  try
    DefaultExt := '*.xml';
    FileName := FormatDateTime('dd_mm_yyyy', HeaderDataSet.FieldByName('OperDate').AsDateTime) + '_' +
                trim(HeaderDataSet.FieldByName('InvNumberPartner').AsString) + '-' + 'NALOG.xml';
    Filter := 'Файлы МеДок (.xml)|*.xml|';
    if Execute then begin
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

procedure TMedocCorrective.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet;
  FileName: string);
begin

end;

end.
