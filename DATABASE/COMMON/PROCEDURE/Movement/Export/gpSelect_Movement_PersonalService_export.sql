-- Function: gpSelect_Movement_PersonalService_export

-- DROP FUNCTION IF EXISTS gpexport_txtbankvostokpayroll (Integer, TVarChar, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_export (Integer, TVarChar, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_export(
    IN inMovementId           Integer,
    IN inInvNumber            TVarChar,
    IN inAmount               TFloat,
    IN inOperDate             TDateTime,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TVarChar)
AS
$BODY$
   DECLARE vbBankId    Integer;
   DECLARE vbTotalSumm TFloat;

   DECLARE r RECORD;
   DECLARE i Integer; -- автонумерация
   DECLARE e Text;
   DECLARE er Text;
BEGIN
     -- *** Временная таблица для сбора результата
     CREATE TEMP TABLE _tmpResult (NPP Integer, RowData TVarChar, errStr TVarChar) ON COMMIT DROP;


     -- определили БАНК
     vbBankId:= (SELECT ObjectLink_PersonalServiceList_Bank.ChildObjectId
                 FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                       LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                            ON ObjectLink_PersonalServiceList_Bank.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                           AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
                 WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                   AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                );


     -- ВЫплата Карта БН (ввод) - 2ф.
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                  ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                 AND MIFloat_SummCardSecondRecalc.DescId         = zc_MIFloat_SummCardSecondRecalc()
                                                 AND MIFloat_SummCardSecondRecalc.ValueData      <> 0
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
     THEN
	-- Шапка файла
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-1, 'Счет;ИНН;Сумма в копейках;Фамилия;Имя;Отчество');

	-- Строчный вывод
	i           := 0; -- обнуляем автонумерацию
        vbTotalSumm := 0; -- обнуляем

	FOR r IN (SELECT COALESCE (gpSelect.CardSecond, '') AS CardSecond, UPPER (COALESCE (gpSelect.PersonalName, '')) AS PersonalName, COALESCE (gpSelect.INN, '') AS INN
	                 -- добавили % и округлили до 2-х знаков + ПЕРЕВОДИМ в копейки
	               , SUM (FLOOR (100 * CAST (COALESCE (gpSelect.SummCardSecondRecalc, 0) * 1.00705 AS NUMERIC (16, 2)))) AS SummCardSecondRecalc
	          FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
	          WHERE gpSelect.SummCardSecondRecalc <> 0
	          GROUP BY COALESCE (gpSelect.CardSecond, ''), UPPER (COALESCE (gpSelect.PersonalName, '')), COALESCE (gpSelect.INN, '')
	         )
	LOOP
            -- Итого сумма -
            vbTotalSumm:= vbTotalSumm + r.SummCardSecondRecalc;
            --
            IF   CHAR_LENGTH (r.personalname) = 0
              -- OR CHAR_LENGTH (r.CardSecond)   <> 14
              -- OR ISNUMERIC (r.CardSecond)     = FALSE
            THEN
                e := 'Неверные/неполные данные: Карта - ' || r.CardSecond || ', ФИО - ' || r.personalname || ', ИНН - ' || r.inn || ', Сумма - ' || r.SummCardSecondRecalc || CHR(13) || CHR(10);
                er := concat(er, e);
            ELSE
                -- Номер карточного счета ф2; ИНН; Сумма - ПЕРЕВОДИМ в копейки; Фамилия; Имя; Отчество
                INSERT INTO _tmpResult (NPP, RowData) VALUES (i, ''||r.CardSecond||';'||r.inn||';'|| r.SummCardSecondRecalc || ';' || LEFT(REPLACE(REPLACE(r.personalname, ' ', ';'), chr(39), ''), 80) );
                i := i + 1; -- увеличиваем значение автонумерации
            END IF;

        END LOOP;

	-- Пустая строка
	INSERT INTO _tmpResult (NPP, RowData) VALUES (i + 1, '');
        -- Сумма зачисления
	INSERT INTO _tmpResult (NPP, RowData) VALUES (i + 2, ';;' || vbTotalSumm);

     END IF;

     -- ПАТ "БАНК ВОСТОК"
     IF vbBankId = 76968
     THEN
	-- *** Шапка файла
	-- Тип документа (из ТЗ)
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-100, 'Content-Type=doc/pay_sheet');
	-- Пустая строка
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-95, '');
	-- Дата документа
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-90, 'DATE_DOC='||TO_CHAR(NOW(), 'dd.mm.yyyy'));
	-- Дата валютирования
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-85, 'VALUE_DATE='||TO_CHAR(NOW(), 'dd.mm.yyyy'));
	-- Номер документа
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-80, 'NUM_DOC='||inInvNumber);
	-- МФО банка плтельщика
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-75, 'PAYER_BANK_MFO=307123');
	-- Счет списания
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-70, 'PAYER_ACCOUNT=26007010192834');
	-- Сумма зачисления
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-65, 'AMOUNT='||ROUND(inAmount::numeric, 2));
	-- Счет банка плательщика
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-60, 'PAYER_BANK_ACCOUNT=29244006');
	-- Тип документа импорта
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-55, 'ONFLOW_TYPE=Виплата заробітної плати');
	-- Наименование клиента
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-50, 'CLN_NAME=ТОВ "АЛАН"');
	-- Код ЕГРПОУ клиента
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-45, 'CLN_OKPO=24447183');
	-- Период начисления
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-40, 'PERIOD='||TO_CHAR(NOW(), 'TMMonth yyyy'));

	-- *** Строчный вывод
	i := 0; -- обнуляем автонумерацию
	FOR r IN (select card, personalname, inn, SummCardRecalc from gpSelect_MovementItem_PersonalService(inMovementId := inMovementId, inShowAll := 'False', inIsErased := 'False',  inSession := inSession))
	LOOP
		IF (char_length(r.card)<>14)
		   OR (NOT ISNUMERIC(r.card))
		   -- OR (NOT ISNUMERIC(r.inn))
		   -- OR (char_length(r.inn)<>10)
		   OR (char_length(r.personalname)=0) THEN
		   BEGIN
			e := 'Неверные/неполные данные: Карта - ' || r.card || ', ФИО - ' || r.personalname || ', ИНН - ' || r.inn || ', Сумма - ' || r.SummCardRecalc || CHR(13) || CHR(10);
			er := concat(er, e);
		   END;
		ELSE
		BEGIN
			-- Номер карточного счета
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 1, 'CARD_HOLDERS.'||i::TVarChar||'.CARD_NUM='||r.card);
			-- ФИО держателя карты
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 2, 'CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER='||LEFT(REPLACE(r.personalname, chr(39), ''), 80));
			-- ИНН держателя карты
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 3, 'CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER_INN='||r.inn);
			-- Сумма зачисления
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 4, 'CARD_HOLDERS.'||i::TVarChar||'.AMOUNT='||ROUND(r.SummCardRecalc::numeric, 2));
                        -- следующий
			i := i + 1;
		END;
		END IF;

        END LOOP;

     END IF; -- if vbBankId = 76968 -- ПАТ "БАНК ВОСТОК"


     -- ПАТ "ОТП БАНК"
     IF vbBankId = 76970
     THEN

         -- первые строчки XML
         INSERT INTO _tmpResult (NPP, RowData) VALUES (-40, '<?xml version="1.0" encoding="windows-1251"?>');
         INSERT INTO _tmpResult (NPP, RowData) VALUES (-30, '<DATAPACKET Version="2.0">');

         -- Шапка
         INSERT INTO _tmpResult(NPP, RowData)
            SELECT -20
                 , '<SCHEDULEINFO SHEDULE_DATE="' || TO_CHAR (NOW(), 'dd/mm/yyyy') || '"'   -- Дата зарплатной ведомости в формате ДД/ММ/ГГГГ
                     ||       ' SHEDULE_NUMBER="' || inInvNumber || '"'                     -- Номер зарплатной ведомости
                     ||  ' PAYER_BANK_BRANCHID="' || '300528' || '"'                        -- МФО банка, в котором открыт счёт плательщика
                  -- || ' PAYER_BANK_ACCOUNTNO="' || '00002' || '"'                         -- Счёт плательщика в банке (транзитный). Примечание. Если администратор выполнил настройку системы таким образом, что транзитный счет будет определяться автоматически, то данное поле будет необязательным для заполнения
                     ||      ' PAYER_ACCOUNTNO="' || '26000301367079' || '"'                -- Счёт для списания средств
                     || ' TOTAL_SHEDULE_AMOUNT="' || REPLACE (CAST (inAmount AS NUMERIC (16, 2)) :: TVarChar, '.', ',') || '"' -- Общая сумма зарплатной ведомости в формате ГРН,КОП
                     ||   ' CONTRAGENT_CODEZKP="' || '1011442' || '"'                       -- Код зарплатного проекта. Обязательно указывается только для банков, использующих ЗКП
                     || '>'
                    ;


           -- Строчная часть
           INSERT INTO _tmpResult(NPP, RowData) VALUES (-10, '<EMPLOYEES>');
           --
           INSERT INTO _tmpResult (NPP, RowData)
                   SELECT ROW_NUMBER() OVER (ORDER BY gpSelect.card) AS NPP
                        , '<EMPLOYEE IDENTIFYCODE="' || gpSelect.inn || '"'                              -- Идентификационный код сотрудника
                               || ' CARDACCOUNTNO="' || gpSelect.card || '"'                             -- Номер карточного (или другого) счёта
                               ||        ' AMOUNT="' || REPLACE (CAST (gpSelect.SummCardRecalc AS NUMERIC (16, 2)) :: TVarChar, '.', ',') || '"' -- Сумма для зачисления на счёт сотрудника в формате ГРН,КОП
                               || '/>'
                   FROM gpSelect_MovementItem_PersonalService (inMovementId := inMovementId
                                                             , inShowAll    := FALSE
                                                             , inIsErased   := FALSE
                                                             , inSession    := inSession
                                                              ) AS gpSelect
                   WHERE gpSelect.SummCardRecalc <> 0
                  ;

           -- последние строчки XML
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</EMPLOYEES>');
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</SCHEDULEINFO>');
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</DATAPACKET>');

     END IF; -- if vbBankId = 76970 -- ПАТ "ОТП БАНК"


     -- проверка ошибки
     IF er <> ''
     THEN
         RAISE EXCEPTION '%', er;
     END IF;


     -- Результат
     RETURN QUERY
        SELECT _tmpResult.RowData FROM _tmpResult ORDER BY NPP;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.07.17         *
 20.12.16                                        *
 01.07.16
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService_export (4989071, '1959', 50000.01, '15.06.2016', zfCalc_UserAdmin());
