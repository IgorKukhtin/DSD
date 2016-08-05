-- Function: gpExport_TXTBankVostokPayroll(integer, tvarchar, integer, tvarchar, tdatetime)

-- DROP FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, integer, TDateTime, tvarchar);

-- Экспорт в текстовый документ зарплатной ведомости для импорта в клиент-банк Восток

CREATE OR REPLACE FUNCTION gpExport_TXTBankVostokPayroll(
	IN inPayrollID Integer,
	IN inNumDoc TVarChar,
	IN inAmount TFloat,
	IN inDateDoc TDateTime,
	IN inSession TVarChar)
RETURNS TABLE(
	TXTRes TVarChar
) AS
$BODY$
	DECLARE r RECORD;
	DECLARE i integer; -- автонумерация
	DECLARE e text;
	DECLARE er text;
BEGIN
	-- *** Временная таблица для сбора результата
	CREATE TEMP TABLE _tmpPayrollResult(TXTRes TVarChar) ON COMMIT DROP;
	
	-- *** Шапка файла
	-- Тип документа (из ТЗ)
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('Content-Type=doc/pay_sheet');
	-- Пустая строка
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('');
	-- Дата документа
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('DATE_DOC='||to_char(NOW(), 'dd.mm.yyyy'));
	-- Дата валютирования
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('VALUE_DATE='||to_char(NOW(), 'dd.mm.yyyy'));
	-- Номер документа
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('NUM_DOC='||inNumDoc);
	-- МФО банка плтельщика
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('PAYER_BANK_MFO=307123');
	-- Счет списания
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('PAYER_ACCOUNT=26007010192834');
	-- Сумма зачисления	
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('AMOUNT='||ROUND(inAmount::numeric, 2));
	-- Счет банка плательщика
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('PAYER_BANK_ACCOUNT=29244006');
	-- Тип документа импорта
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('ONFLOW_TYPE=Виплата заробітної плати');
	-- Наименование клиента
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CLN_NAME=ТОВ "АЛАН"');
	-- Код ЕГРПОУ клиента
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CLN_OKPO=24447183');
	-- Период начисления
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('PERIOD='||to_char(NOW(), 'TMMonth yyyy'));

	-- *** Строчный вывод
	i := 0; -- обнуляем автонумерацию
	FOR r IN (select card, personalname, inn, summcardrecalc from gpSelect_MovementItem_PersonalService(inMovementId := inPayrollID, inShowAll := 'False', inIsErased := 'False',  inSession := inSession))
	LOOP
		IF (char_length(r.card)<>14) 
		   OR (NOT ISNUMERIC(r.card))
		   --OR (NOT ISNUMERIC(r.inn)) 
		   --OR (char_length(r.inn)<>10) 
		   OR (char_length(r.personalname)=0) THEN
		   BEGIN
			e := 'Неверные/неполные данные: Карта - ' || r.card || ', ФИО - ' || r.personalname || ', ИНН - ' || r.inn || ', Сумма - ' || r.summcardrecalc || CHR(13) || CHR(10);
			er := concat(er, e);
		   END;
		ELSE
		BEGIN
			-- Номер карточного счета
			INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_NUM='||r.card);
			-- ФИО держателя карты
			INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER='||LEFT(REPLACE(r.personalname, chr(39), ''), 80));
			-- ИНН держателя карты
			INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER_INN='||r.inn);
			-- Сумма зачисления
			INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.AMOUNT='||ROUND(r.summcardrecalc::numeric, 2));
			i := i + 1; -- увеличиваем значение автонумерации
		END;
		END IF;
	END LOOP;

	-- *** Возврат результата
	IF er <> '' THEN
		RAISE EXCEPTION '%', er;
	ELSE
	RETURN QUERY
		SELECT * FROM _tmpPayrollResult;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql;
  
ALTER FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, TFloat, TDateTime, tvarchar)
  OWNER TO admin;

GRANT EXECUTE ON FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, TFloat, TDateTime, tvarchar) TO public;
GRANT EXECUTE ON FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, TFloat, TDateTime, tvarchar) TO admin;

-- Проверка
select * from gpExport_TXTBankVostokPayroll(3861092, '1959', 50000.01, '15.06.2016'::TdateTime, '9464'::TVarChar);