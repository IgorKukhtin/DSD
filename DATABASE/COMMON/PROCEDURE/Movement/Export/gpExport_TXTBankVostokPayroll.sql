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
BEGIN
	-- *** Временная таблица для сбора результата
	CREATE TEMP TABLE _tmpPayrollResult(TXTRes TVarChar) ON COMMIT DROP;
	
	-- *** Шапка файла
	-- Тип документа (из ТЗ)
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('Content-Type=doc/pay_sheet');
	-- Дата документа
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('DOC_DATE='||to_char(inDateDoc, 'dd.mm.yyyy'));
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
	-- Процент РКО
	INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('COMISSION_PERCENT=0.5');

	-- *** Строчный вывод
	i := 0; -- обнуляем автонумерацию
	FOR r IN (select card, personalname, inn, summcardrecalc from gpSelect_MovementItem_PersonalService(inMovementId := inPayrollID, inShowAll := 'False', inIsErased := 'False',  inSession := inSession))
	LOOP
		-- Номер карточного счета
		INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_NUM='||r.card);
		-- ФИО держателя карты
		INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER='||r.personalname);
		-- ИНН держателя карты
		INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER_INN='||r.inn);
		-- Сумма зачисления
		INSERT INTO _tmpPayrollResult (TXTRes) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.AMOUNT='||ROUND(r.summcardrecalc::numeric, 2));
		i := i + 1; -- увеличиваем значение автонумерации
	END LOOP;

	-- *** Возврат результата
	RETURN QUERY
		SELECT * FROM _tmpPayrollResult;
END;
$BODY$
  LANGUAGE plpgsql;
  
ALTER FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, TFloat, TDateTime, tvarchar)
  OWNER TO admin;

GRANT EXECUTE ON FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, TFloat, TDateTime, tvarchar) TO public;
GRANT EXECUTE ON FUNCTION gpExport_TXTBankVostokPayroll(integer, tvarchar, TFloat, TDateTime, tvarchar) TO admin;

-- Проверка
select * from gpExport_TXTBankVostokPayroll(3861092, '1959', 50000.01, '15.06.2016'::TdateTime, '9464'::TVarChar);