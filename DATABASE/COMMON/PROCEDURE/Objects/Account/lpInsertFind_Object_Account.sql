-- Function: lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Boolean, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_Account(
    IN inAccountGroupId         Integer               , -- Группа счетов
    IN inAccountDirectionId     Integer               , -- Аналитики счетов - направления
    IN inInfoMoneyDestinationId Integer               , -- Управленческие назначения
    IN inInfoMoneyId            Integer               , -- Статьи назначения
    IN inInsert                 Boolean  DEFAULT FALSE , -- 
    IN inUserId                 Integer  DEFAULT NULL   -- Пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbAccountDirectionId Integer;
   DECLARE vbAccountDirectionCode Integer;
   DECLARE vbAccountDirectionName TVarChar;
   DECLARE vbAccountId Integer;
   DECLARE vbAccountCode Integer;
   DECLARE vbAccountName TVarChar;
   DECLARE vbAccountKindId Integer;
BEGIN

   -- Проверки
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Пользователя : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inAccountGroupId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Счет УП т.к. не установлено <Группа счета УП> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inAccountDirectionId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Счет УП т.к. не установлено <Аналитика счета - направление> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0 AND COALESCE (inInfoMoneyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Счет УП т.к. не установлено <Управленческое назначение> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Счет УП т.к. не установлено <Управленческое назначение> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;


   -- Находим Управленческий счет по <Управленческие назначения> или <Статьи назначения>
   IF inInfoMoneyDestinationId <> 0 THEN vbAccountId := lfGet_Object_Account_byInfoMoneyDestination (inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId);
                                    ELSE vbAccountId := lfGet_Object_Account_byInfoMoney(inAccountGroupId, inAccountDirectionId, inInfoMoneyId);
   END IF;


   -- проверка - статья не должна быть удалена
   IF EXISTS (SELECT Id FROM Object WHERE Id = vbAccountId AND isErased = TRUE)
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно использовать удаленный Счет УП: <%>, <%>, <%>, <%>', lfGet_Object_ValueData (inAccountGroupId), lfGet_Object_ValueData (inAccountDirectionId), lfGet_Object_ValueData (inInfoMoneyDestinationId), lfGet_Object_ValueData (inInfoMoneyId);
   END IF;


   -- Создаем новый счет
   IF COALESCE (vbAccountId, 0) = 0 
   THEN
       -- для некоторых случаев блокируем создание счета
       IF inInsert = FALSE
       THEN
           RAISE EXCEPTION 'Ошибка.В данном документе невозможно создать новый Счет УП с параметрами: <%>, <%>, <%>, <%>, (%)', lfGet_Object_ValueData (inAccountGroupId), lfGet_Object_ValueData (inAccountDirectionId), lfGet_Object_ValueData (inInfoMoneyDestinationId), lfGet_Object_ValueData (inInfoMoneyId), inInfoMoneyDestinationId;
       END IF;

       -- Определяем Id 2-ий уровень по <Группа счетов> и <Аналитики счетов - направления>
       SELECT AccountDirectionId INTO vbAccountDirectionId FROM lfSelect_Object_AccountDirection() WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = inAccountDirectionId;

       IF COALESCE (vbAccountDirectionId, 0) = 0
       THEN
            -- Определяем название 2-ий уровень по <Аналитики счетов - направления>
           SELECT AccountDirectionName INTO vbAccountDirectionName FROM lfSelect_Object_AccountDirection() WHERE AccountDirectionId = inAccountDirectionId;

           -- Определяем Id 2-ий уровень по <Группа счетов> и vbAccountDirectionName
           SELECT AccountDirectionId INTO vbAccountDirectionId FROM lfSelect_Object_AccountDirection() WHERE AccountGroupId = inAccountGroupId AND AccountDirectionName = vbAccountDirectionName;

           -- если Id не нашли, созаем 2-ий уровень
           IF COALESCE (vbAccountDirectionId, 0) = 0
           THEN
               -- Определяем будущий код
               SELECT COALESCE (MAX (AccountDirectionCode), 0) + 100 INTO vbAccountDirectionCode FROM lfSelect_Object_AccountDirection() WHERE AccountGroupId = inAccountGroupId;
               -- создаем 2-ий уровень
               vbAccountDirectionId := lpInsertUpdate_Object (vbAccountDirectionId, zc_Object_AccountDirection(), vbAccountDirectionCode, vbAccountDirectionName);
               -- сохранили протокол
               PERFORM lpInsert_ObjectProtocol (vbAccountDirectionId, inUserId);
           END IF;

       END IF;


       -- Еще раз находим Управленческий счет по <Управленческие назначения> или <Статьи назначения> (но здесь другой vbAccountDirectionId)
       IF inInfoMoneyDestinationId <> 0 
          THEN vbAccountId := lfGet_Object_Account_byInfoMoneyDestination (inAccountGroupId, vbAccountDirectionId, inInfoMoneyDestinationId);
          ELSE vbAccountId := lfGet_Object_Account_byInfoMoney (inAccountGroupId, vbAccountDirectionId, inInfoMoneyId);
       END IF;

       -- Создаем новый счет
       IF COALESCE (vbAccountId, 0) = 0 
       THEN
           -- Определяем название 3-ий уровень по <Управленческие назначения> или <Статьи назначения>
           IF inInfoMoneyDestinationId <> 0 THEN SELECT InfoMoneyDestinationName INTO vbAccountName FROM lfSelect_Object_InfoMoneyDestination() WHERE InfoMoneyDestinationId = inInfoMoneyDestinationId;
                                            ELSE SELECT InfoMoneyName INTO vbAccountName FROM lfSelect_Object_InfoMoney() WHERE InfoMoneyId = inInfoMoneyId;
           END IF;

           -- определяем свойство <Виды счетов>
           IF EXISTS (SELECT Object_AccountGroup.Id
                      FROM Object AS Object_AccountGroup
                           LEFT JOIN Object AS Object_AccountGroup_70000 ON Object_AccountGroup_70000.Id = zc_Enum_AccountGroup_70000()
                      WHERE Object_AccountGroup.Id = inAccountGroupId
                        AND Object_AccountGroup.ObjectCode < Object_AccountGroup_70000.ObjectCode)
           THEN
               vbAccountKindId:= zc_Enum_AccountKind_Active();
           ELSE
               vbAccountKindId:= zc_Enum_AccountKind_Passive();
           END IF ;

           -- Определяем будущий код
           SELECT COALESCE (MAX (AccountCode), 0) + 1 INTO vbAccountCode FROM lfSelect_Object_Account() WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = vbAccountDirectionId;

           IF vbAccountCode = 1 THEN
             -- Определяем будущий код
             vbAccountCode:= vbAccountDirectionCode + 1;
           END IF;

           -- созаем 3-ий уровень
           vbAccountId := lpInsertUpdate_Object (vbAccountId, zc_Object_Account(), vbAccountCode, vbAccountName);
           -- все свойства для 3-ий уровень
           PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Account_onComplete(), vbAccountId, TRUE);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountGroup(), vbAccountId, inAccountGroupId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountDirection(), vbAccountId, vbAccountDirectionId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoneyDestination(), vbAccountId, inInfoMoneyDestinationId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoney(), vbAccountId, inInfoMoneyId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountKind(), vbAccountId, vbAccountKindId);
       
           -- сохранили протокол
           PERFORM lpInsert_ObjectProtocol (vbAccountId, inUserId);
       END IF;

   END IF;

   IF COALESCE (vbAccountId, 0) = 0 
   THEN
         RAISE EXCEPTION 'Ошибка.Счет не определен.Параметры: <%> <%> <%> <%> <%> <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId, inInsert, inUserId;
   END IF;

   -- Возвращаем значение
   RETURN (vbAccountId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Boolean, Integer)  OWNER TO postgres;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 31.01.14                                        * add проверка - статья не должна быть удалена
 25.01.14                                        * add !!!запрет вставки счета!!!, т.е. inInsert = FALSE
 22.12.13                                        * add inInsert
 26.08.13                                        * error - vbAccountDirectionId
 08.07.13                                        * add vbAccountKindId and zc_ObjectBoolean_Account_onComplete
 02.07.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_Account (inAccountGroupId:= zc_Enum_AccountGroup_100000(), inAccountDirectionId:= 23581, inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100(), inInfoMoneyId:= 0, inUserId:= 2)
--
-- SELECT * FROM lfSelect_Object_Account () order by 8
