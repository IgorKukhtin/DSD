-- Function: public.gpInsertUpdate_LogBillsKS2 (TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_LogBillsKS2 (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_LogBillsKS2(
    inXmlfile       TBlob   ,  -- файл xml
    inSession       TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer; 

  DECLARE vbXMLFile    Text;
  DECLARE vbOperDate   TDateTime;
  DECLARE vbMovementId Integer;
  DECLARE vbContractId Integer; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Замена - Убираем экранизацию
     -- vbXMLFile:= REPLACE (REPLACE (REPLACE (REPLACE (inXMLFile, 'Windows-1251', 'UTF-8'), '%', '<'), '$', '>'), '^', '"');
     vbXMLFile:= convert_from(decode(inXMLFile, 'base64'), 'UTF8');
  
--        delete from tmpProtocol;
--        insert into tmpProtocol (Text,   ProtocolData)
--        values (vbUserId :: TVarChar, CURRENT_TIMESTAMP :: Text);
--        return;

     IF vbUserId <> 5 AND 1=0
     THEN
        -- Дата документа
        vbOperDate:= (SELECT unnest(xpath('//Array-Bill/bill[1]/od/text()', vbXMLFile :: XML)));
     ELSE
        -- Дата счета
        vbOperDate:= (SELECT unnest(xpath('//Array-Bill/InvoiceDocument/Invoice/Header/InvoiceDate/text()', vbXMLFile :: XML)));

--        insert into tmpProtocol (Text,   ProtocolData)
--        values (vbOperDate :: TVarChar, CURRENT_TIMESTAMP :: Text);
         
        -- return;
        -- RAISE EXCEPTION 'Ошибка. xmlBillDate = <%>', vbOperDate;
     END IF;


     -- IF vbUserId = 5 THEN RAISE EXCEPTION 'Ошибка. % ', vbOperDate; END IF;

     IF vbUserId = 5 THEN vbOperDate:= DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '2 MONTH'); END IF;

     -- Парсим XML - получили строчную часть
     CREATE TEMP TABLE _tmpItem (PhoneNum TVarChar, TotalSumm TFloat) ON COMMIT DROP;
     IF vbUserId <> 5 AND 1=0
     THEN
         INSERT INTO _tmpItem (PhoneNum, TotalSumm)
            WITH tmpData AS (SELECT vbXMLFile :: XML AS ValueData)
            SELECT -- Номер мобильного
                   regexp_split_to_table (replace (replace (CAST (xpath ('//Array-Bill/bill/subs[stnd_id=1]/msisdn/text()', ValueData) AS Text), '}', ''), '{', ''), ',') :: TVarChar AS PhoneNum
                   -- Сумма Итого
                 , regexp_split_to_table (replace (replace (CAST (xpath ('//Array-Bill/bill/subs[stnd_id=1]/s_det/tot/text()', ValueData) AS Text), '}', ''), '{', ''),',') :: TFloat AS TotalSumm
       
            FROM tmpData;
     ELSE
         INSERT INTO _tmpItem (PhoneNum, TotalSumm)
            WITH tmpData AS (SELECT vbXMLFile :: XML AS ValueData)
            SELECT -- Номер мобильного
                   regexp_split_to_table (replace (replace (CAST (xpath ('//Array-Bill/InvoiceDocument/Invoice/Contract/ContractDetail/ContractID/text()', ValueData) AS Text), '}', ''), '{', ''), ',') :: TVarChar AS PhoneNum
                   -- Сумма Итого
                 , zfConvert_StringToFloat (regexp_split_to_table (replace (replace (CAST (xpath ('//Array-Bill/InvoiceDocument/Invoice/Contract/ContractDetail/SubInvoiceAmount/AmountDetail/AmountExclTax/text()', ValueData) AS Text), '}', ''), '{', ''),',')) :: TFloat AS TotalSumm
       
            FROM tmpData;

     END IF;

--         insert into tmpProtocol (Text,   ProtocolData)
--         values ((select count(*) from _tmpItem), CURRENT_TIMESTAMP :: Text);

     -- RAISE EXCEPTION '<%>  <%>', (select PhoneNum from  _tmpItem), (select TotalSumm from  _tmpItem );

     -- даные - моб.номера
     CREATE TEMP TABLE _tmpMobileEmployee (Id Integer, PhoneNum TVarChar, PersonalId Integer, MobileTariffId Integer, MobileLimit TFloat, DutyLimit TFloat, Navigator TFloat, Monthly TFloat, ContractId Integer) ON COMMIT DROP;
     INSERT INTO _tmpMobileEmployee (Id, PhoneNum, PersonalId, MobileTariffId, MobileLimit, DutyLimit, Navigator, Monthly, ContractId)
	    SELECT Object_MobileEmployee.Id          AS Id
                 , COALESCE (Object_MobileEmployee.ValueData, '') ::TVarChar    AS PhoneNum
                 , COALESCE (ObjectLink_MobileEmployee_Personal.ChildObjectId, 0) ::Integer      AS PersonalId
                 , COALESCE (ObjectLink_MobileEmployee_MobileTariff.ChildObjectId, 0) ::Integer  AS MobileTariffId
                 , COALESCE (ObjecTFloat_Limit.ValueData, 0)      ::TFloat      AS MobileLimit
                 , COALESCE (ObjecTFloat_DutyLimit.ValueData, 0)  ::TFloat      AS DutyLimit
                 , COALESCE (ObjecTFloat_Navigator.ValueData, 0)  ::TFloat      AS Navigator
                 , COALESCE (ObjecTFloat_Monthly.ValueData, 0)    ::TFloat      AS Monthly
                 , COALESCE (ObjectLink_MobileTariff_Contract.ChildObjectId, 0) AS ContractId
            FROM Object AS Object_MobileEmployee
               LEFT JOIN ObjecTFloat AS ObjecTFloat_Limit
                                     ON ObjecTFloat_Limit.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjecTFloat_Limit.DescId = zc_ObjecTFloat_MobileEmployee_Limit()
               LEFT JOIN ObjecTFloat AS ObjecTFloat_DutyLimit
                                     ON ObjecTFloat_DutyLimit.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjecTFloat_DutyLimit.DescId = zc_ObjecTFloat_MobileEmployee_DutyLimit()
               LEFT JOIN ObjecTFloat AS ObjecTFloat_Navigator
                                     ON ObjecTFloat_Navigator.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjecTFloat_Navigator.DescId = zc_ObjecTFloat_MobileEmployee_Navigator()
               LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Personal
                                    ON ObjectLink_MobileEmployee_Personal.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectLink_MobileEmployee_Personal.DescId = zc_ObjectLink_MobileEmployee_Personal()
               LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobileTariff
                                    ON ObjectLink_MobileEmployee_MobileTariff.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectLink_MobileEmployee_MobileTariff.DescId = zc_ObjectLink_MobileEmployee_MobileTariff()
               LEFT JOIN ObjecTFloat AS ObjecTFloat_Monthly
                                     ON ObjecTFloat_Monthly.ObjectId = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId
                                    AND ObjecTFloat_Monthly.DescId = zc_ObjecTFloat_MobileTariff_Monthly()

               LEFT JOIN ObjectLink AS ObjectLink_MobileTariff_Contract
                                    ON ObjectLink_MobileTariff_Contract.ObjectId = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId
                                   AND ObjectLink_MobileTariff_Contract.DescId = zc_ObjectLink_MobileTariff_Contract()
       
            WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
            --AND Object_MobileEmployee.isErased = FALSE -- пусть пока ???НЕ??? будут и удаленные тоже
           ;

     IF vbUserId = 5 AND 1=1
     THEN 
         RAISE EXCEPTION 'Ошибка. %    % '
                        , vbOperDate
                        , (SELECT COUNT(*) FROM _tmpMobileEmployee WHERE PhoneNum ilike '0979965665')
                         ;
     END IF;
             

     -- сохранили - Новые моб.номера
     PERFORM lpInsertUpdate_Object_MobileEmployee2 (ioId             := 0
                                                  , inCode           := 0
                                                  , inName           := tmp.PhoneNum
                                                  , inLimit          := 0
                                                  , inDutyLimit      := 0
                                                  , inNavigator      := 0
                                                  , inComment        := ''
                                                  , inPersonalId     := 0
                                                  , inMobileTariffId := 0
                                                  , inRegionId       := 0
                                                  , inUserId         := vbUserId
                                                   )
     FROM (SELECT DISTINCT PhoneNum FROM _tmpItem WHERE PhoneNum <> '') AS tmp
          LEFT JOIN _tmpMobileEmployee ON RIGHT (_tmpMobileEmployee.PhoneNum, 10) = tmp.PhoneNum -- ???только по правым 10 цифрам???
     WHERE _tmpMobileEmployee.PhoneNum IS NULL
    ;


     -- определили договор 
     vbContractId := (SELECT DISTINCT tmp.ContractId FROM _tmpMobileEmployee AS tmp WHERE tmp.ContractId <> 0);

     -- нашли документ
     vbMovementId:= (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                       AND MovementLinkObject_Contract.ObjectId   = vbContractId
                     WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', vbOperDate) AND DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                       AND Movement.DescId = zc_Movement_MobileBills()
                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                    );

     -- проверка
     IF vbMovementId <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Данные уже загружены. Для повторной загрузки необходимо сначала удалить документ № <%> от <%>.'
                       , (SELECT InvNumber FROM Movement WHERE Id = vbMovementId)
                       , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = vbMovementId))
                         ;
     END IF;
              
    -- Создали документ - !!!всегда!!!
    vbMovementId := gpInsertUpdate_Movement_MobileBills (0, CAST (NEXTVAL ('Movement_MobileBills_seq') AS TVarChar), vbOperDate, vbContractId, inSession);


    -- сохранили Элементы - !!!всегда!!!
    PERFORM lpInsertUpdate_MovementItem_MobileBills (ioId                 := 0
                                                   , inMovementId         := vbMovementId
                                                   , inMobileEmployeeId   := tmp.MobileEmployeeId
                                                   , inAmount             := tmp.TotalSumm
                                                   , inCurrMonthly        := tmp.Monthly             -- Ежемесячная абонплата
                                                   , inCurrNavigator      := tmp.Navigator           -- Услуга Навигатор
                                                   , inPrevNavigator      := tmp.Navigator_prev      -- ***Предыдущее состояние услуги Навигатор
                                                   , inLimit              := tmp.MobileLimit         -- Текущий лимит
                                                   , inPrevLimit          := tmp.MobileLimit_prev    -- ***Предыдущий лимит
                                                   , inDutyLimit          := tmp.DutyLimit           -- Служебный лимит
                                                   , inOverlimit          := CASE WHEN tmp.TotalSumm - (tmp.MobileLimit + tmp.DutyLimit + tmp.Navigator) > 0 THEN tmp.TotalSumm - (tmp.MobileLimit + tmp.DutyLimit + tmp.Navigator) ELSE 0 END
                                                   , inPrevMonthly        := tmp.Monthly_prev        -- *** Ежемесячная абонплата за предыдущий период
                                                   -- , inRegionId           := 0                       -- Текущий регион обслуживания
                                                   , inEmployeeID         := tmp.PersonalId          -- Сотрудник
                                                   , inPrevEmployeeId     := tmp.PersonalId_prev     -- *** Предыдущий сотрудник
                                                   , inMobileTariffId     := tmp.MobileTariffId      -- Текущий тарифный план
                                                   , inPrevMobileTariffId := tmp.MobileTariffId_prev -- *** Предыдущий тарифный план
                                                   , inUserId             := vbUserId
                                                    )
    FROM (WITH tmpMobileBills_prev AS (SELECT MovementItem.ObjectId              AS MobileEmployeeId
                                            , MIFloat_CurrMonthly.ValueData      AS Monthly
                                            , MIFloat_CurrNavigator.ValueData    AS Navigator
                                            , MIFloat_Limit.ValueData            AS MobileLimit
                                            , MILinkObject_Employee.ObjectId     AS PersonalId
                                            , MILinkObject_MobileTariff.ObjectId AS MobileTariffId
                                            , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                         AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                         AND MovementLinkObject_Contract.ObjectId   = vbContractId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased   = FALSE
                                            LEFT JOIN MovementItemFloat AS MIFloat_CurrMonthly
                                                                        ON MIFloat_CurrMonthly.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_CurrMonthly.DescId = zc_MIFloat_CurrMonthly()
                                            LEFT JOIN MovementItemFloat AS MIFloat_CurrNavigator
                                                                        ON MIFloat_CurrNavigator.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_CurrNavigator.DescId = zc_MIFloat_CurrNavigator()
                                            LEFT JOIN MovementItemFloat AS MIFloat_Limit
                                                                        ON MIFloat_Limit.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_Limit.DescId = zc_MIFloat_Limit()
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee
                                                                             ON MILinkObject_Employee.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_Employee.DescId = zc_MILinkObject_Employee()
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_MobileTariff
                                                                             ON MILinkObject_MobileTariff.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_MobileTariff.DescId = zc_MILinkObject_MobileTariff()
                                       WHERE -- !!!за Предыдущий месяц!!!
                                             Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '1 MONTH' AND DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '1 DAY'
                                         AND Movement.DescId   = zc_Movement_MobileBills()
                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                      )
          -- результат
          SELECT Object_MobileEmployee.Id                           AS MobileEmployeeId
               , _tmpItem.TotalSumm                                 AS TotalSumm
               , COALESCE (_tmpMobileEmployee.Monthly, 0)           AS Monthly
               , COALESCE (tmpMobileBills_prev.Monthly, 0)          AS Monthly_prev
               , COALESCE (_tmpMobileEmployee.Navigator, 0)         AS Navigator
               , COALESCE (tmpMobileBills_prev.Navigator, 0)        AS Navigator_prev
               , COALESCE (_tmpMobileEmployee.MobileLimit, 0)       AS MobileLimit
               , COALESCE (tmpMobileBills_prev.MobileLimit, 0)      AS MobileLimit_prev
               , COALESCE (_tmpMobileEmployee.DutyLimit, 0)         AS DutyLimit
               , _tmpMobileEmployee.PersonalId                      AS PersonalId
               , tmpMobileBills_prev.PersonalId                     AS PersonalId_prev
               , _tmpMobileEmployee.MobileTariffId                  AS MobileTariffId
               , tmpMobileBills_prev.MobileTariffId                 AS MobileTariffId_prev
          FROM _tmpItem
               INNER JOIN Object AS Object_MobileEmployee
                                 ON Object_MobileEmployee.DescId                = zc_Object_MobileEmployee()
                                AND Object_MobileEmployee.isErased              = FALSE
                                AND RIGHT (Object_MobileEmployee.ValueData, 10) = _tmpItem.PhoneNum -- ???только по правым 10 цифрам???
               LEFT JOIN _tmpMobileEmployee ON _tmpMobileEmployee.Id = Object_MobileEmployee.Id
               LEFT JOIN tmpMobileBills_prev ON tmpMobileBills_prev.MobileEmployeeId = Object_MobileEmployee.Id
                                            AND tmpMobileBills_prev.Ord = 1
         ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.10.16         * parce
 30.09.16         *
*/

-- тест
--  select * from tmpProtocol
-- SELECT * FROM gpInsertUpdate_LogBillsKS2