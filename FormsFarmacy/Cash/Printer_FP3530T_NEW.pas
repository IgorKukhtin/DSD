unit Printer_FP3530T_NEW;

interface

uses Windows, PrinterInterface, FP3141_TLB;

type
  TPrinterFP3530T_NEW = class(TInterfacedObject, IPrinter)
  private
    FPrinter: IFiscPRN;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
  protected

    function OpenReceipt: boolean;
    function CloseReceipt: boolean;
    function PrintNotFiscalText(const PrintText: WideString): boolean;
    function PrintLine(const PrintText: WideString): boolean;
    function PrintSplitLine(const PrintText: WideString): boolean;
    function PrintText(const AText : WideString): boolean;
    function SerialNumber:String;
    procedure Anulirovt;

  public
    constructor Create;
    function LengNoFiscalText : integer;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, RegularExpressions, Log, UnitGetCash;

function СообщениеКА(k: string): boolean;
begin
  result := (k = '$0000') or (k = '');
  if result then
     exit;

  if (k='$0101') then begin Add_Log_RRO('$0101 Ошибка принтера');  exit;  end; //257
  if (k='$0201') then begin Add_Log_RRO('$0201 Ошибка RAM'); exit; end;//
  if (k='$0301') then begin Add_Log_RRO('$0301 Ошибка Контрольная сумма памяти программ'); exit; end; ///
  if (k='$0401') then begin Add_Log_RRO('$0401 Ошибка flash памяти. Нет физического доступа к Flash памяти.');  exit; end; //
  if (k='$0501') then begin Add_Log_RRO('$0501 Ошибка Дисплея(дисплей не подключён к регистратору)');  exit; end; //
  if (k='$0601') then begin Add_Log_RRO('$0601 Ошибка часов, необходимо скорректировать время');  exit; end; //
  if (k='$0701') then begin Add_Log_RRO('$0701 Ошибка возникла вследствие понижения питания (просадка питающей сети).');  exit; end; //
  if (k='$0801') then begin Add_Log_RRO('$0801 SIM: отказ оборудования. Требуется замена или восстановление microSD носителя.');  exit; end; //
  if (k='$0901') then begin Add_Log_RRO('$0901 MMC: отказ оборудования. Требуется замена или восстановление microSD носителя.');  exit; end; //
  if (k='$0A01') then begin Add_Log_RRO('$0A01 Ошибка превышения времени ожидания ответа от принтера.');  exit; end; //
  if (k='$0002') then begin Add_Log_RRO('$0002 Нет такой команды с таким кодом (возможно неверно выбран протокол обмена регистратора с ПК)');  exit; end; 	  //
  if (k='$0102') then begin Add_Log_RRO('$0102 Данная функция не поддерживается в данной модели регистратора.');  exit; end; 	  //
  if (k='$0202') then begin Add_Log_RRO('$0202 В сообщении нет данных)');  exit; end; 	  //
  if (k='$0302') then begin Add_Log_RRO('$0302 Переполнение буфера приемника/передатчика');  exit; end; 	  //
  if (k='$0402') then begin Add_Log_RRO('$0402 Ширина бумаги меньше горизонтального размера логотипа.');  exit; end; 	  //

   //0xNN03	Формат поля неверен, где NN -Порядковый номер неверного поля
  if Copy(k, 3, 2) = '03'	then begin Add_Log_RRO('Формат поля неверен, где NN -Порядковый номер неверного поля (' + Copy(k, 1, 2) + ')');  exit; end;
   //0xNN04	Значение поля выходит за диапазон, где NN -Порядковый номер неверного поля
  if Copy(k, 3, 2) = '04'	then begin Add_Log_RRO('Значение поля выходит за диапазон, где NN -Порядковый номер неверного поля (' + Copy(k, 1, 2) + ')');  exit; end;

   //0xXX05 Ошибка ФП
  if (k='$0005')	then begin Add_Log_RRO('$0005 Нет свободного места для записи в ФП');   exit; end;  //
  if (k='$0105')	then begin Add_Log_RRO('$0105 Ошибка записи в ФП');  exit; end;  //
  if (k='$0205')	then begin Add_Log_RRO('$0205 Заводской номер неустановлен');    exit; end;//
  if (k='$0305')	then begin Add_Log_RRO('$0305 Дата последней записи в ФП более поздняя, чем та, что пытаемся установить');  exit; end; //
  if (k='$0405')	then begin Add_Log_RRO('$0405 Нельзя выходить за пределы суток');  exit; end; //
  if (k='$0505')	then begin Add_Log_RRO('$0505 Сбой данных в ФП');  exit; end; //
  if (k='$0605')	then begin Add_Log_RRO('$0605 фискальная память исчерпана(Запись запрещена) Может быть ошибка в распределении программируемых налоговых групп (необходимо проверить построение программируемых налоговых групп).');  exit; end; //
  if (k='$0705')	then begin Add_Log_RRO('$0705 ЭККР не в фискальном режиме');  exit; end; //
  if (k='$0805')	then begin Add_Log_RRO('$0805 дата и время не были установлены с момента последнего аварийного обнуления ОЗУ');  exit; end; //
  if (k='$0905')	then begin Add_Log_RRO('$0905 С начала смены прошло более 24х часов. Необходимо выполнить Z-отчёт.');  exit; end; //
  if (k='$0A05')	then begin Add_Log_RRO('$0A05 Необходимо скорректировать время. Установите текущее время.');  exit; end; //
  if (k='$0B05')	then begin Add_Log_RRO('$0B05 Ошибка в таблице налоговых ставок');  exit; end; //
  if (k='$0C05')	then begin Add_Log_RRO('$0C05 Ошибка в формате даты');  exit; end; //
  if (k='$0D05')	then begin Add_Log_RRO('$0D05 Ошибка в формате времени');  exit; end; //
  if (k='$0E05')	then begin Add_Log_RRO('$0E05 Время что пытаемся установить меньше текущего');  exit; end; //
  if (k='$0F05')	then begin Add_Log_RRO('$0F05 Есть не отправленные эквайру документы в течение 72 часов или более');  exit; end; //

  if (k='$0006')	then begin Add_Log_RRO('$0006 Неверный пароль');  exit; end; //

   //0xXX07 ошибка режима
  if (k='$0007')	then begin Add_Log_RRO('$0007 Неверный режим аппарата (перемычка). Команда может быть выполнена только в сервисном режиме.');  exit; end; 	//
  if (k='$0107')	then begin Add_Log_RRO('$0107 В данном состоянии смены не выполнима. (Возможно, требуется выполнить принудительное обнуление контрольной ленты).');   exit; end; 	//
  if (k='$0207')	then begin Add_Log_RRO('$0207 Необходимо выгрузить контрольную ленту (бумажную/подписанную).');   exit; end; 	//
  if (k='$0307')	then begin Add_Log_RRO('$0307 Аппарат находится в автономном режиме.');   exit; end; 	//
  if (k='$0407')	then begin Add_Log_RRO('$0407 Смена закрыта но не обнулена. (Возможно, требуется выполнить принудительное обнуление контрольной ленты).');   exit; end; 	//
  if (k='$0507')	then begin Add_Log_RRO('$0507 Персонализация не выполнена.');   exit; end; 	//
  if (k='$0607')	then begin Add_Log_RRO('$0607 Не все данные переданы эквайеру перед сменой налоговых номеров.');   exit; end; 	//
  if (k='$0707')	then begin Add_Log_RRO('$0707 Версия внутреннего ПО не активирована. Требуется ключ активации ПО.');   exit; end; 	//
  if (k='$0907')	then begin Add_Log_RRO('$0907 Неверный ключ активации версии.');   exit; end; 	//
  if (k='$0A07')	then begin Add_Log_RRO('$0A07 Удаленный сервис не активирован.');   exit; end; 	//
  if (k='$0D07')	then begin Add_Log_RRO('$0D07 Операция отвергнута. Выполняется автоматический перевод на зимнее время.');   exit; end; 	//

  if (k='$0008')	then begin Add_Log_RRO('$0008 ПОбнаружено арифметическое переполнение.'); 	 exit; end; //

  if (k='$0009')	then begin Add_Log_RRO('$0009 Не очищено. Параметр, который пытаются перепрограммировать заблокирован и не может быть изменён до окончания смены (снятия Z-отчёта).'); 	 exit; end;   //
  if (k='$0109')	then begin Add_Log_RRO('$0109 Чтение/запись по неинициализированному указателю'); 	 exit; end;   //
  if (k='$0209')	then begin Add_Log_RRO('$0209 Адрес/параметр за пределами зоны.'); 	 exit; end;   //
  if (k='$0309')	then begin Add_Log_RRO('$0309 Выделен недостаточный буфер'); 	 exit; end;   //
  if (k='$0409')	then begin Add_Log_RRO('$0409 Ошибка данных'); 	 exit; end;   //

   //0xXX0A Ошибки при работе с базой товаров
  if (k='$000A')	then begin Add_Log_RRO('$000A Недостаточно свободного места для выполнения команды');  exit; end; //
  if (k='$010A')	then begin Add_Log_RRO('$010A Длина записи больше максимума (>255)'); 	 exit; end;//
  if (k='$020A')	then begin Add_Log_RRO('$020A Артикул с данным кодом не найден');  exit; end; 	  //
  if (k='$030A')	then begin Add_Log_RRO('$030A Индекс за пределами базы');  exit; end; 	 //
  if (k='$040A')	then begin Add_Log_RRO('$040A Артикул/отдел с данным кодом существует');  exit; end; 	  //
  if (k='$050A')	then begin Add_Log_RRO('$050A Налог запрещен. Требуется проверка правильности программирования таблицы налоговых ставок.');  exit; end; 	//
  if (k='$060A')	then begin Add_Log_RRO('$060A Продаж по налоговой группе не было.');  exit; end; 	//
  if (k='$070A')	then begin Add_Log_RRO('$070A Использование такого типа налога запрещено.');  exit; end; 	//

   //0хХX0B Ошибка при работе с цепочкой продаж //
  if (k='$000B')	then begin Add_Log_RRO('$000B Неверное состояние документа выполняется попытка повторно открыть документ, или выполняется попытка выполнить продажу без предварительного открытия чека.');  exit; end; 	//
  if (k='$010B')	then begin Add_Log_RRO('$010B Недостаточно свободного места для выполнения команды');  exit; end; //
  if (k='$020B')	then begin Add_Log_RRO('$020B Неизвестный тип записи продажи');  exit; end; 	  //
  if (k='$030B')	then begin Add_Log_RRO('$030B Аннуляция: не может начинаться с данной операции');  exit; end;  //
  if (k='$040B')	then begin Add_Log_RRO('$040B Аннуляция: данная операция в чеке не найдена');  exit; end; 	  //
  if (k='$050B')	then begin Add_Log_RRO('$050B Аннуляция: последовательность неполная');  exit; end; //
  if (k='$060B')	then begin Add_Log_RRO('$060B Аннулировать нечего'); 	 exit; end;//
  if (k='$070B')	then begin Add_Log_RRO('$070B Копия заданных чеков недоступна'); 	 exit; end;//
  if (k='$080B')	then begin Add_Log_RRO('$080B Недостаточно наличности для выполнения операции'); 	 exit; end;   //
  if (k='$090B')	then begin Add_Log_RRO('$090B Данная форма оплаты в этом чеке запрещена'); 	 exit; end;  //
  if (k='$0A0B')	then begin Add_Log_RRO('$0A0B Данная сдача с данной формы оплаты (в данном типе чека) запрещена');  exit; end; 	//
  if (k='$0B0B')	then begin Add_Log_RRO('$0B0B Значение скидки вышло за пределы');  exit; end; 	  //
  if (k='$0C0B')	then begin Add_Log_RRO('$0C0B Переполнение итога по чеку');  exit; end; 	  //
  if (k='$0D0B')	then begin Add_Log_RRO('$0D0B Переполнение по оплатам');  exit; end; 	  //
  if (k='$0E0B')	then begin Add_Log_RRO('$0E0B Вышли за пределы буфера'); 	 exit; end;  //
  if (k='$0F0B')	then begin Add_Log_RRO('$0F0B Продажа: ошибка в количестве'); 	 exit; end;  //
  if (k='$100B')	then begin Add_Log_RRO('$100B Продажа: ошибка в цене'); 	 exit; end;  //
  if (k='$110B')	then begin Add_Log_RRO('$110B Аннуляция: удаляемая последовательность заблокирована'); 	 exit; end;  //
  if (k='$120B')	then begin Add_Log_RRO('$120B Продажа: достигнуто максимальное количество позиций в чеке(комментарии считаются как позиции)'); 	 exit; end;  //
  if (k='$130B')	then begin Add_Log_RRO('$130B Включено использование прямого подключения к регистратору банковского терминала, а сам терминал не подключён к фискальному регистратору (FP-320). См. параметры форм оплаты.'); 	 exit; end;  //

   //0хХX0C
  if (k='$00C0')	then begin Add_Log_RRO('$00C0 ОTMPBuff: Не соответствует заголовок');   exit; end; 	  //
  if (k='$01C0')	then begin Add_Log_RRO('$01C0 TMPBuff: данные не совпали с ранее сохраненными');   exit; end;
  if (k='$02C0')	then begin Add_Log_RRO('$02C0 TMPBuff: за пределами буфера');   exit; end;

  //0хХXD0
  if (k='$00D0')	then begin Add_Log_RRO('$00D0 SIM: неправильный порядок вычисления хэша');   exit; end; 	  //
  if (k='$01D0')	then begin Add_Log_RRO('$01D0 SIM: подпись не совпадает');   exit; end; 	  //
  if (k='$02D0')	then begin Add_Log_RRO('$02D0 SIM: текущий открытый ключ не соответствует сохраненному в ФП');   exit; end; 	  //
  if (k='$03D0')	then begin Add_Log_RRO('$03D0 SIM: Ошибка закрытого ключа');   exit; end; 	  //
  if (k='$04D0')	then begin Add_Log_RRO('$04D0 SIM: ID_DEV не установлен');   exit; end; 	  //
  if (k='$05D0')	then begin Add_Log_RRO('$05D0 SIM: Неверное состояние карты');   exit; end; 	  //
  if (k='$06D0')	then begin Add_Log_RRO('$06D0 SIM: Ошибка подписывания');   exit; end; 	  //
  if (k='$07D0')	then begin Add_Log_RRO('$07D0 SIM: Ошибка формата XML');   exit; end; 	  //
  if (k='$08D0')	then begin Add_Log_RRO('$08D0 SIM: Ошибка версии ключа');   exit; end; 	  //
  if (k='$09D0')	then begin Add_Log_RRO('$09D0 SIM: Документ уничтожен');   exit; end; 	  //
  if (k='$0AD0')	then begin Add_Log_RRO('$0AD0 SIM: Документ изменен');   exit; end; 	  //
  if (k='$0BD0')	then begin Add_Log_RRO('$0BD0 SIM: Неверный размер документа');   exit; end; 	  //
  if (k='$0CD0')	then begin Add_Log_RRO('$0CD0 SIM: Копия документа временно не доступна. Идет передача данных.');   exit; end; 	  //

  //0хХXD1
  if (k='$00D1')	then begin Add_Log_RRO('$00D1 MMC: карточку необходимо форматировать');   exit; end; 	  //
  if (k='$01D1')	then begin Add_Log_RRO('$01D1 MMC: Недостаточно свободного места для выполнения команды');   exit; end; 	  //
  if (k='$02D1')	then begin Add_Log_RRO('$02D1 MMC: Ошибка создания файла, файл с таким именем уже существует');   exit; end; 	  //
  if (k='$03D1')	then begin Add_Log_RRO('$03D1 MMC: Ошибка чтения файла, запрошенный размер на чтение больше фактического размера файла');   exit; end; 	  //
  if (k='$04D1')	then begin Add_Log_RRO('$04D1 MMC: Попытка произвести операции с открытым файлом');   exit; end; 	  //
  if (k='$05D1')	then begin Add_Log_RRO('$05D1 MMC: ошибка открытия файла - не найден файл или директория');   exit; end; 	  //
  if (k='$06D1')	then begin Add_Log_RRO('$06D1 MMC: AccessMode');   exit; end; 	  //
  if (k='$07D1')	then begin Add_Log_RRO('$07D1 MMC: rErrSD_PathLength');   exit; end; 	  //
  if (k='$08D1')	then begin Add_Log_RRO('$08D1 MMC: Ошибка открытия/создания файла');   exit; end; 	  //
  if (k='$09D1')	then begin Add_Log_RRO('$09D1 MMC: Ошибка записи файла');   exit; end; 	  //
  if (k='$0AD1')	then begin Add_Log_RRO('$0AD1 MMC: Необходимо обратиться в службу сервиса (Ошибка инициализации носителя КЛЭФ).');   exit; end; 	  //
  if (k='$0BD1')	then begin Add_Log_RRO('$0BD1 MMC: Ошибка в записях КСЕФ. Необходимо обратиться в службу сервиса');   exit; end; 	  //

  //0хХXF0
  if (k='$00F0')	then begin Add_Log_RRO('$00F0 ФСтрока: Параметры');   exit; end; 	  //
  if (k='$01F0')	then begin Add_Log_RRO('$01F0 ФСтрока: Тип данных');   exit; end; 	  //
  if (k='$02F0')	then begin Add_Log_RRO('$02F0 ФСтрока: Выбор шрифта');   exit; end; 	  //
  if (k='$03F0')	then begin Add_Log_RRO('$03F0 ФСтрока: Выравнивание');   exit; end; 	  //
  if (k='$04F0')	then begin Add_Log_RRO('$04F0 ФСтрока: Позиции в строке');   exit; end; 	  //
  if (k='$05F0')	then begin Add_Log_RRO('$05F0 DBF: Формат файла неверен');   exit; end; 	  //
  if (k='$06F0')	then begin Add_Log_RRO('$06F0 DBF: Количество полей больше максимального');   exit; end; 	  //
  if (k='$07F0')	then begin Add_Log_RRO('$07F0 DBF: Обращение к несуществующей записи');   exit; end; 	  //
  if (k='$08F0')	then begin Add_Log_RRO('$08F0 DBF: Недопустимый тип поля');   exit; end; 	  //
  if (k='$09F0')	then begin Add_Log_RRO('$09F0 DBF: Неверное значение в поле');   exit; end; 	  //
  if (k='$0AF0')	then begin Add_Log_RRO('$0AF0 DBF: Значение для поиска не задано');   exit; end; 	  //
  if (k='$0BF0')	then begin Add_Log_RRO('$0BF0 DBF: База не открыта');   exit; end; 	  //

  //0хХXF1
  if (k='$00F1')	then begin Add_Log_RRO('$00F1 Строка ввода: Величина за пределами');   exit; end; 	  //
  if (k='$01F1')	then begin Add_Log_RRO('$01F1 Строка ввода: Нельзя изменять');   exit; end; 	  //
  if (k='$02F1')	then begin Add_Log_RRO('$02F1 Отменено пользователем');   exit; end; 	  //

  Add_Log_RRO(k + ' Недокументированная ошибка!!! Свяжитесь с разработчиком')
end;

const

  Password = '000000';

{ TPrinterFP3530T_NEW }
constructor TPrinterFP3530T_NEW.Create;
begin
  inherited Create;
  FLengNoFiscalText := 35;
  FPrinter := CoFiscPrn.Create;
  FPrinter.SETCOMPORT[StrToInt(iniPrinterPortNumber), StrToInt(iniPrinterPortSpeed)];
  СообщениеКА(FPrinter.GETERROR);
end;

function TPrinterFP3530T_NEW.OpenReceipt: boolean;
begin
  FPrinter.OPENCHECK[Password];
  result := СообщениеКА(FPrinter.GETERROR)
end;

function TPrinterFP3530T_NEW.CloseReceipt: boolean;
begin
  result := false;

  FPrinter.CLOSEFISKCHECK[1, Password];
  result := СообщениеКА(FPrinter.GETERROR)
end;

function TPrinterFP3530T_NEW.PrintNotFiscalText(const PrintText: WideString): boolean;
begin
  FPrinter.PRNCHECK[PrintText, Password];
  result := СообщениеКА(FPrinter.GETERROR)
end;

function TPrinterFP3530T_NEW.PrintSplitLine(const PrintText: WideString): boolean;
var I : Integer;
begin
  Result := False;
  I := 1;
  while COPY(PrintText, I, FLengNoFiscalText) <> '' do
  begin
    if not PrintNotFiscalText(COPY(PrintText, I, FLengNoFiscalText)) then Exit;
    I := I + FLengNoFiscalText;
  end;
  Result := True;
end;

function TPrinterFP3530T_NEW.PrintLine(const PrintText: WideString): boolean;
var I : Integer;
    L : WideString;
    N : WideString;
    Res: TArray<string>;
begin
  Result := False;
  L := '';
  Res := TRegEx.Split(PrintText, ' ');
  for I := 0 to High(Res) do
  begin
    if (Res[i] = '') or (L <> '') then L := L + ' ';
    if Res[i] <> '' then L := L + Res[i];
    if I < High(Res) then N := ' ' + Res[i + 1] else N := '';
    if Length(L + N) > FLengNoFiscalText then
    begin
      if not PrintSplitLine(L) then Exit;
      L := '';
    end;
  end;
  if L <> '' then if not PrintSplitLine(L) then Exit;
  Result := True;
end;

function TPrinterFP3530T_NEW.PrintText(const AText : WideString): boolean;
var I : Integer;
    Res: TArray<string>;
begin
  Result := False;
  try
    OpenReceipt;
    Res := TRegEx.Split(AText, #$D#$A);
    for I := 0 to High(Res) do
    begin
      if POS('https', Res[I]) = 0 then
        if not PrintLine(TrimRight(Res[I])) then Exit;
    end;
    Result := True;
  finally
    if Result then CloseReceipt
    else Anulirovt;
  end;
end;

function TPrinterFP3530T_NEW.SerialNumber:String;
begin
  Result := FPrinter.ZNUM[Password];
end;

procedure TPrinterFP3530T_NEW.Anulirovt;
begin
  try
    FPrinter.ANULIROVT[0, Password];
  except
  end;
end;

function TPrinterFP3530T_NEW.LengNoFiscalText : integer;
begin
  Result := FLengNoFiscalText;
end;

end.


