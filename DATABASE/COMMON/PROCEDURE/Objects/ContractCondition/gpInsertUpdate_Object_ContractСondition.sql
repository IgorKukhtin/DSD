 -- Function: gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractCondition(
 INOUT ioId                        Integer   , -- ключ объекта <Условия договора>
    IN inComment                   TVarChar  , -- примечание
    IN inValue                     TFloat    , -- значение
    IN inPercentRetBonus           TFloat    , -- % возврата план
    IN inContractId                Integer   , -- Договор
    IN inContractConditionKindId   Integer   , -- Типы условий договоров 
    IN inBonusKindId               Integer   , -- Виды бонусов
    IN inInfoMoneyId               Integer   , -- Статьи назначения
    IN inContractSendId            Integer   , -- Договор маркетинга
    IN inPaidKindId                Integer   , -- Форма оплаты
    IN inStartDate                 TDateTime , -- Дейстует с...
   OUT outEndDate                  TDateTime , -- Дейстует до...
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   IF ioId > 0
   THEN
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractCondition());
   ELSE
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   END IF;
  
    -- проверка
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Договор не установлен.';
   END IF;

    -- проверка
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_Contract_PaidKind
              WHERE ObjectLink_Contract_PaidKind.ObjectId      = inContractId
                AND ObjectLink_Contract_PaidKind.DescId        = zc_ObjectLink_Contract_PaidKind()
                AND ObjectLink_Contract_PaidKind.ChildObjectId = zc_Enum_PaidKind_SecondForm()
            )
      AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
      AND inValue > 14
      AND vbUserId <> 6604558 -- Голота К.О.
   THEN
       RAISE EXCEPTION 'Ошибка.%Значение <%> для <%> %не может быть больше 14 дней.'
                     , CHR (13)
                     , lfGet_Object_ValueData_sh (inContractConditionKindId)
                     , lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm())
                     , CHR (13)
                      ;
   END IF;


   -- проверка на уникальность, нельзя добавить с существующим StartDate
   IF COALESCE (inStartDate, zc_DateStart()) > zc_DateStart()
   THEN
        IF EXISTS (SELECT 1
                   FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                       INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                             ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                            AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                            AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                       INNER JOIN ObjectDate AS ObjectDate_StartDate
                                             ON ObjectDate_StartDate.ObjectId  = ObjectLink_ContractCondition_Contract.ObjectId
                                            AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractCondition_StartDate()
                                            AND ObjectDate_StartDate.ValueData = inStartDate
                       -- еще такая группировка
                       LEFT JOIN ObjectLink AS ObjectLink_BonusKind
                                            ON ObjectLink_BonusKind.ObjectId      = ObjectLink_ContractCondition_Contract.ObjectId
                                           AND ObjectLink_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()
                   WHERE ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                     AND ObjectLink_ContractCondition_Contract.ObjectId <> ioId
                     AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                     AND COALESCE (ObjectLink_BonusKind.ChildObjectId, 0) = inBonusKindId
                 )
        THEN
            RAISE EXCEPTION 'Ошибка.Дата начала действия условия договора не уникальна.';
        END IF;
   END IF;
   
   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractCondition(), 0, inComment);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_Value(), ioId, inValue);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_PercentRetBonus(), ioId, inPercentRetBonus);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_Contract(), ioId, inContractId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractConditionKind(), ioId, inContractConditionKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_BonusKind(), ioId, inBonusKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractSend(), ioId, inContractSendId);   

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_PaidKind(), ioId, inPaidKindId); 

   IF COALESCE (inStartDate, zc_DateStart()) > zc_DateStart() OR 1 < (SELECT COUNT(*)
                                                                      FROM ObjectLink AS ObjectLink_Contract
                                                                           INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                                                                 ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                                                                AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                                                                AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                                                                        AND Object_ContractCondition.isErased = FALSE
                                                                           -- еще такая группировка
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BonusKind
                                                                                                ON ObjectLink_BonusKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                                                               AND ObjectLink_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()
                                                                      WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                                                        AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                                                                        AND COALESCE (ObjectLink_BonusKind.ChildObjectId, 0) = inBonusKindId
                                                                     )
                                                              OR EXISTS (SELECT 1
                                                                         FROM ObjectDate AS ObjectDate_EndDate
                                                                         WHERE ObjectDate_EndDate.ObjectId  = ioId
                                                                           AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractCondition_EndDate()
                                                                           AND ObjectDate_EndDate.ValueData IS NOT NULL
                                                                        )
   THEN
       -- StartDate - обновляем
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_StartDate(), ioId, inStartDate);
       
       -- EndDate - обнуляем ВСЕМ
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), tmp.Id, NULL)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId AS Id
                              FROM ObjectLink AS ObjectLink_Contract
                                   -- только для одного условия
                                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                         ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                        AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                        AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                   INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                         ON ObjectDate_EndDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                        AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractCondition_EndDate()
                                                        AND ObjectDate_EndDate.ValueData IS NOT NULL
                                   -- еще такая группировка
                                   LEFT JOIN ObjectLink AS ObjectLink_BonusKind
                                                        ON ObjectLink_BonusKind.ObjectId = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                              --AND COALESCE (ObjectLink_BonusKind.ChildObjectId, 0) = inBonusKindId
                             )
             SELECT tmpData.Id
             FROM tmpData
             ) AS tmp
            ;

       -- EndDate - апдейтим ВСЕМ
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), tmp.ContractConditionId, tmp.EndDate)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                              AS ContractConditionId
                                   , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart()) AS StartDate
                                   , COALESCE (ObjectLink_BonusKind.ChildObjectId, 0)          AS BonusKindId
                                   , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectLink_BonusKind.ChildObjectId, 0)
                                                        ORDER BY COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart()) ASC
                                                       ) AS Ord
                              FROM ObjectLink AS ObjectLink_Contract
                                   -- только для одного условия
                                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                         ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                        AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                        AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                   -- условие не удалено
                                   INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                                AND Object_ContractCondition.isErased = FALSE
                                   LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                        ON ObjectDate_StartDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                       AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractCondition_StartDate()
                                                     --AND ObjectDate_StartDate.ValueData > zc_DateStart()
                                   -- еще такая группировка
                                   LEFT JOIN ObjectLink AS ObjectLink_BonusKind
                                                        ON ObjectLink_BonusKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()

                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                             )
             SELECT tmpData.ContractConditionId, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
             FROM tmpData
                  LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord         = tmpData.Ord + 1
                                                   AND tmpData_next.BonusKindId = tmpData.BonusKindId
                                                   AND tmpData_next.StartDate   > zc_DateStart()
             ) AS tmp
      ;


   END IF;
   

   -- Скидка в цене ГСМ +  % Наценки Павильоны (Приход покупателю) 
   IF inContractConditionKindId NOT IN (WITH tmpOS AS (SELECT * FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Enum())
                                        SELECT zc_Enum_ContractConditionKind_ChangePrice() UNION SELECT zc_Enum_ContractConditionKind_ChangePercentPartner()
                                  UNION SELECT zc_Enum_ContractConditionKind_ChangePercent()
                                  UNION SELECT zc_Enum_ContractConditionKind_DelayDayCalendar() UNION SELECT zc_Enum_ContractConditionKind_DelayDayBank()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                  UNION SELECT tmpOS.ObjectId FROM tmpOS WHERE tmpOS.ValueData ILIKE 'zc_Enum_ContractConditionKind_Transport%'
                                  --
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentAccount()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentSale()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentSalePart()
                                       )
 --AND vbUserId = 5
   AND 0 < (WITH tmpData AS (SELECT ObjectLink_ContractConditionKind.ChildObjectId                          AS ContractConditionKindId
                                  , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
                                --, COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate
                             FROM ObjectLink AS ObjectLink_Contract
                                  -- только для одного условия
                                  INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                        ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                       AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                  INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                               AND Object_ContractCondition.isErased = FALSE
                                  LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                       ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                                      AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractCondition_StartDate()
                                --LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                --                     ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                --                    AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractCondition_EndDate()
                             WHERE ObjectLink_Contract.ChildObjectId = inContractId
                               AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                            )
            SELECT COUNT(*)
            FROM tmpData
                 JOIN tmpData AS tmpData_next ON tmpData_next.ContractConditionKindId = tmpData.ContractConditionKindId
                                             AND tmpData_next.StartDate               > tmpData.StartDate
           )
   THEN
       RAISE EXCEPTION 'Ошибка.Для условия договора <%> история не предусмотрена.', lfGet_Object_ValueData_sh (inContractConditionKindId);
   END IF;

   -- если Выбран элемент УДАЛЕН нужно изменить дату окончания предыдущего условия договора,   у последнего №п/п всегда получится zc_DateEnd()
   -- текущие обнулим
   IF COALESCE (inContractConditionKindId, 0) = 0
   THEN
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_StartDate(), ioId, NULL);
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), ioId, NULL);   

       -- EndDate - апдейтим ВСЕМ
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), tmp.ContractConditionId, tmp.EndDate)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                          AS ContractConditionId
                                   , ObjectDate_StartDate.ValueData                        AS StartDate
                                   , COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, ObjectLink_Contract.ObjectId) AS ContractConditionKindId
                                   , COALESCE (ObjectLink_BonusKind.ChildObjectId, 0)      AS BonusKindId
                                   , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectLink_BonusKind.ChildObjectId, 0)
                                                                   , COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, ObjectLink_Contract.ObjectId)
                                                        ORDER BY ObjectDate_StartDate ASC
                                                       ) AS Ord
                              FROM ObjectLink AS ObjectLink_Contract
                                   -- только НЕ для одного условия
                                   LEFT JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                        ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     --AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId

                                   -- еще такая группировка
                                   LEFT JOIN ObjectLink AS ObjectLink_BonusKind
                                                        ON ObjectLink_BonusKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()

                                   INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                                AND Object_ContractCondition.isErased = FALSE
                                   INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                         ON ObjectDate_StartDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                        AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractCondition_StartDate()
                                                        AND ObjectDate_StartDate.ValueData > zc_DateStart()
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                             )
             SELECT tmpData.ContractConditionId, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
             FROM tmpData
                  LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord                     = tmpData.Ord + 1
                                                   AND tmpData_next.ContractConditionKindId = tmpData.ContractConditionKindId
                                                   AND tmpData_next.BonusKindId             = tmpData.BonusKindId
                                                   AND tmpData_next.StartDate               > zc_DateStart()
             ) AS tmp
      ;
   END IF;

   -- вернули новое значение
   outEndDate:= (SELECT ObjectDate_EndDate.ValueData
                 FROM ObjectDate AS ObjectDate_EndDate
                 WHERE ObjectDate_EndDate.ObjectId  = ioId
                   AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractCondition_EndDate()
                );
   
   --
   IF vbUserId = 5 AND 1=1
   THEN
       RAISE EXCEPTION 'Ошибка.%.', outEndDate;
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.05.20         * add inPercentRetBonus
 20.05.20         * add inPaidKindId
 24.03.20         * add inStartDate
 08.05.14                                        * add lpCheckRight
 14.03.14         * add InfoMoney
 25.02.14                                        * add inIsUpdate and inIsErased
 19.02.14         * add inBonusKindId, inComment
 16.11.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractCondition (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
