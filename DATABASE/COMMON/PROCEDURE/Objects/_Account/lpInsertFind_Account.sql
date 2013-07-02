-- Function: lpInsertFind_Account (Integer, Integer, Integer, Integer, Integer)

--DROP FUNCTION lpInsertFind_Account (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Account(
    IN inAccountGroupId         Integer  , -- Группа счетов
    IN inAccountDirectionId     Integer  , -- Аналитики счетов - направления
    IN inInfoMoneyDestinationId Integer  , -- Управленческие назначения
    IN inInfoMoneyId            Integer  , -- Статьи назначения
    IN inUserId                 Integer    -- Пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbAccountDirectionId Integer;
   DECLARE vbAccountDirectionCode Integer;
   DECLARE vbAccountDirectionName TVarChar;
   DECLARE vbAccountId Integer;
   DECLARE vbAccountCode Integer;
   DECLARE vbAccountName TVarChar;
BEGIN

   -- Проверки
   IF COALESCE (inAccountGroupId, 0) = 0
   THEN
       RAISE EXCEPTION 'Невозможно определить Счет т.к. не установлено Группа счетов';
   END IF;

   IF COALESCE (inAccountDirectionId, 0) = 0
   THEN
       RAISE EXCEPTION 'Невозможно определить Счет т.к. не установлено Аналитики счетов - направления';
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0 AND COALESCE (inInfoMoneyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Невозможно определить Счет т.к. не установлено Управленческие назначения';
   END IF;

   -- Находим Управленческий счет
   SELECT AccountId INTO vbAccountId FROM lfSelect_Object_Account WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = inAccountDirectionId AND InfoMoneyDestinationId = inInfoMoneyDestinationId;


   -- Создаем новый счет
   IF COALESCE (vbAccountId, 0) = 0 
   THEN
       -- Определяем Id 2-ий уровень по <Группа счетов> и <Аналитики счетов - направления>
       SELECT AccountDirectionId INTO vbAccountDirectionId FROM lfSelect_Object_AccountDirection WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = inAccountDirectionId;

       IF COALESCE (vbAccountDirectionId, 0) = 0
       THEN
            -- Определяем название 2-ий уровень по <Аналитики счетов - направления>
           SELECT AccountDirectionName INTO vbAccountDirectionName FROM lfSelect_Object_AccountDirection WHERE AccountDirectionId = inAccountDirectionId;

           -- Определяем Id 2-ий уровень по <Группа счетов> и vbAccountDirectionName
           SELECT AccountDirectionId INTO vbAccountDirectionId FROM lfSelect_Object_AccountDirection WHERE AccountGroupId = inAccountGroupId AND AccountDirectionName = vbAccountDirectionName;

           -- если Id не нашли, созаем 2-ий уровень
           IF COALESCE (vbAccountDirectionId, 0) = 0
           THEN
               -- Определяем будущий код
               SELECT COALESCE (MAX (AccountDirectionCode), 0) + 100 INTO vbAccountDirectionCode FROM lfSelect_Object_AccountDirection WHERE AccountGroupId = inAccountGroupId;
               -- создаем 2-ий уровень
               vbAccountDirectionId := lpInsertUpdate_Object (vbAccountDirectionId, zc_Object_AccountDirection(), vbAccountDirectionCode, vbAccountDirectionName);
               -- сохранили протокол
               PERFORM lpInsert_ObjectProtocol (vbAccountDirectionId, inUserId);
           END IF;

       END IF;


       -- Определяем название 3-ий уровень по <Управленческие назначения> или <Статьи назначения>
       IF inInfoMoneyId <> 0 THEN SELECT InfoMoneyName INTO vbAccountName FROM lfSelect_Object_InfoMoney WHERE InfoMoneyId = inInfoMoneyId;
                             ELSE SELECT InfoMoneyDestinationName INTO vbAccountName FROM lfSelect_Object_InfoMoneyDestination WHERE InfoMoneyDestinationId = inInfoMoneyDestinationId;
       END IF;

       -- Определяем будущий код
       SELECT COALESCE (MAX (AccountCode), 0) + 1 INTO vbAccountCode FROM lfSelect_Object_Account WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = vbAccountDirectionId;

       IF vbAccountCode = 1 THEN
         -- Определяем будущий код
         vbAccountCode:= vbAccountDirectionCode + 1;
       END IF;

       -- созаем 3-ий уровень
       vbAccountId := lpInsertUpdate_Object (vbAccountId, zc_Object_Account(), vbAccountCode, vbAccountName);
       -- все свойства для 3-ий уровень
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountDirection(), ioId, vbAccountDirectionId);
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoney(), ioId, inInfoMoneyId);
       
       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (vbAccountId, inUserId);
   END IF;


   -- Возвращаем значение
   RETURN (vbAccountId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lpInsertFind_Account (Integer, Integer, Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 02.07.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Account (inAccountGroupId:= zc_Enum_AccountGroup_100000(), inAccountDirectionId:= 23581, inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100(), inInfoMoneyId:= 0, inUserId:= 2)