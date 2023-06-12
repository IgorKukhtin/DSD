-- Function: lpInsertFind_Object_ProfitLoss (Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ProfitLoss (Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ProfitLoss(
    IN inProfitLossGroupId      Integer  , -- Группа ОПиУ
    IN inProfitLossDirectionId  Integer  , -- Аналитика ОПиУ - направление
    IN inInfoMoneyDestinationId Integer  , -- Управленческие назначения
    IN inInfoMoneyId            Integer  , -- Статьи назначения
    IN inInsert                 Boolean  DEFAULT FALSE , --
    IN inUserId                 Integer  DEFAULT NULL   -- Пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbProfitLossDirectionId Integer;
   DECLARE vbProfitLossDirectionCode Integer;
   DECLARE vbProfitLossDirectionName TVarChar;
   DECLARE vbProfitLossId Integer;
   DECLARE vbProfitLossCode Integer;
   DECLARE vbProfitLossName TVarChar;
BEGIN

   -- Сразу - Возвращаем значение
   IF (COALESCE (inProfitLossGroupId, 0) = 0 OR COALESCE (inProfitLossDirectionId, 0) = 0)
      AND 1 = (SELECT  COUNT(*) FROM ObjectLink AS OL_InfoMoney WHERE OL_InfoMoney.ChildObjectId = inInfoMoneyId AND OL_InfoMoney.DescId = zc_ObjectLink_ProfitLoss_InfoMoney())
   THEN
       RETURN (SELECT OL_InfoMoney.ObjectId
               FROM ObjectLink AS OL_InfoMoney
               WHERE OL_InfoMoney.ChildObjectId = inInfoMoneyId
                 AND OL_InfoMoney.DescId        = zc_ObjectLink_ProfitLoss_InfoMoney()
              );
   END IF;

   -- Проверки
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Пользователя : <%>, <%>, <%>, <%>', inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId, lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId);
   END IF;

   IF COALESCE (inProfitLossGroupId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Статью ОПиУ т.к. не установлено <Группа ОПиУ> : <%>, <%>, <%>, <%>', inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inProfitLossDirectionId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Статью ОПиУ т.к. не установлено <Аналитика ОПиУ - направление> : <%>, <%>, <%>, <%>', lfGet_Object_ValueData_sh (inProfitLossGroupId), lfGet_Object_ValueData_sh (inProfitLossDirectionId), lfGet_Object_ValueData_sh (inInfoMoneyDestinationId), lfGet_Object_ValueData_sh (inInfoMoneyId);
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0 AND COALESCE (inInfoMoneyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно определить Статью ОПиУ т.к. не установлено <Управленческое назначение> : <%>, <%>, <%>, <%>', inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;


   -- Попытка.1 - Находим статью ОПиУ по <Управленческие назначения> или <Статьи назначения>
   IF inInfoMoneyDestinationId <> 0 THEN vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId);
                                    ELSE vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoney (inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyId);
   END IF;
   -- Попытка.2 (если не нашли) - меняем (10200)Прочее сырье -> (20600)Прочие материалы и Находим статью ОПиУ по <Управленческие назначения>
   IF COALESCE (vbProfitLossId, 0) = 0 AND inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()
   THEN vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, inProfitLossDirectionId, zc_Enum_InfoMoneyDestination_20600());
   END IF;


   -- проверка - статья не должна быть удалена
   IF EXISTS (SELECT Id FROM Object WHERE Id = vbProfitLossId AND isErased = TRUE)
   THEN
       RAISE EXCEPTION 'Ошибка.Невозможно использовать удаленную статью ОПиУ: <%>, <%>, <%>, <%>', lfGet_Object_ValueData (inProfitLossGroupId), lfGet_Object_ValueData (inProfitLossDirectionId), lfGet_Object_ValueData (inInfoMoneyDestinationId), lfGet_Object_ValueData (inInfoMoneyId);
   END IF;


   -- Создаем новую статью ОПиУ
   IF COALESCE (vbProfitLossId, 0) = 0
   THEN
       -- для некоторых случаев блокируем создание новой статьи ОПиУ
       IF inInsert = FALSE
       THEN
           RAISE EXCEPTION 'Ошибка.В данном документе невозможно создать новую статью ОПиУ с параметрами: %<%> %<%> %<%> %<%> %(%)(%)(%)'
                         , CHR (13)
                         , lfGet_Object_ValueData (inProfitLossGroupId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inProfitLossDirectionId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inInfoMoneyDestinationId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inInfoMoneyId)
                         , CHR (13)
                         , inProfitLossGroupId
                         , inProfitLossDirectionId
                         , inInfoMoneyDestinationId
                          ;
       END IF;

       -- Определяем Id 2-ий уровень по <Группа ОПиУ> и <Аналитика ОПиУ - направление>
       SELECT ProfitLossDirectionId INTO vbProfitLossDirectionId FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossGroupId = inProfitLossGroupId AND ProfitLossDirectionId = inProfitLossDirectionId;

       IF COALESCE (vbProfitLossDirectionId, 0) = 0
       THEN
            -- Определяем название 2-ий уровень по <Аналитика ОПиУ - направление>
           SELECT ProfitLossDirectionName INTO vbProfitLossDirectionName FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossDirectionId = inProfitLossDirectionId;

           -- Определяем Id 2-ий уровень по <Группа ОПиУ> и vbProfitLossDirectionName
           SELECT ProfitLossDirectionId INTO vbProfitLossDirectionId FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossGroupId = inProfitLossGroupId AND ProfitLossDirectionName = vbProfitLossDirectionName;

           -- если Id не нашли, созаем 2-ий уровень
           IF COALESCE (vbProfitLossDirectionId, 0) = 0
           THEN
               -- Определяем будущий код
               SELECT COALESCE (MAX (ProfitLossDirectionCode), 0) + 100 INTO vbProfitLossDirectionCode FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossGroupId = inProfitLossGroupId;
               -- создаем 2-ий уровень
               vbProfitLossDirectionId := lpInsertUpdate_Object (vbProfitLossDirectionId, zc_Object_ProfitLossDirection(), vbProfitLossDirectionCode, vbProfitLossDirectionName);
               -- сохранили протокол
               PERFORM lpInsert_ObjectProtocol (vbProfitLossDirectionId, inUserId);
           END IF;

       END IF;


       -- Еще раз находим статью ОПиУ по <Управленческие назначения> или <Статьи назначения> (но здесь другой vbProfitLossDirectionId)
       IF inInfoMoneyDestinationId <> 0
          THEN vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, vbProfitLossDirectionId, inInfoMoneyDestinationId);
          ELSE vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoney (inProfitLossGroupId, vbProfitLossDirectionId, inInfoMoneyId);
       END IF;

       -- Создаем новую статью ОПиУ
       IF COALESCE (vbProfitLossId, 0) = 0
       THEN
           -- Определяем название 3-ий уровень по <Управленческие назначения> или <Статьи назначения>
           IF inInfoMoneyDestinationId <> 0 THEN SELECT InfoMoneyDestinationName INTO vbProfitLossName FROM lfSelect_Object_InfoMoneyDestination() WHERE InfoMoneyDestinationId = inInfoMoneyDestinationId;
                                            ELSE SELECT InfoMoneyName INTO vbProfitLossName FROM lfSelect_Object_InfoMoney() WHERE InfoMoneyId = inInfoMoneyId;
           END IF;

           -- Определяем будущий код
           SELECT COALESCE (MAX (ProfitLossCode), 0) + 1 INTO vbProfitLossCode FROM lfSelect_Object_ProfitLoss() WHERE ProfitLossGroupId = inProfitLossGroupId AND ProfitLossDirectionId = vbProfitLossDirectionId;

           IF vbProfitLossCode = 1 THEN
             -- Определяем будущий код
             vbProfitLossCode:= vbProfitLossDirectionCode + 1;
           END IF;

           -- созаем 3-ий уровень
           vbProfitLossId := lpInsertUpdate_Object (vbProfitLossId, zc_Object_ProfitLoss(), vbProfitLossCode, vbProfitLossName);
           -- все свойства для 3-ий уровень
           PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ProfitLoss_onComplete(), vbProfitLossId, TRUE);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_ProfitLossGroup(), vbProfitLossId, inProfitLossGroupId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_ProfitLossDirection(), vbProfitLossId, vbProfitLossDirectionId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_InfoMoneyDestination(), vbProfitLossId, inInfoMoneyDestinationId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_InfoMoney(), vbProfitLossId, inInfoMoneyId);

           -- сохранили протокол
           PERFORM lpInsert_ObjectProtocol (vbProfitLossId, inUserId);
       END IF;

   END IF;


   -- Возвращаем значение
   RETURN (vbProfitLossId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_ProfitLoss (Integer, Integer, Integer, Integer, Boolean, Integer)  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.10.14                                        * add меняем (10200)Прочее сырье -> (20600)Прочие материалы и ...
 31.01.14                                        * add проверка - статья не должна быть удалена
 30.01.14                                        * add !!!запрет вставки статьи!!!, т.е. inInsert = FALSE
 23.12.13                                        * add inInsert
 26.08.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_ProfitLoss (inProfitLossGroupId:= zc_Enum_ProfitLossGroup_100000(), inProfitLossDirectionId:= 23581, inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100(), inInfoMoneyId:= 0, inUserId:= 2)
--
-- SELECT * FROM lfSelect_Object_ProfitLoss () order by 8
