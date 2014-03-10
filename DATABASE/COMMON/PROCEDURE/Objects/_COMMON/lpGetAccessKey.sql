-- Function: lpGetAccessKey()

DROP FUNCTION IF EXISTS lpGetAccess (Integer, Integer);
DROP FUNCTION IF EXISTS lpGetAccessKey (Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetAccessKey(
    IN inUserId      Integer      , -- 
    IN inProcessId   Integer        -- 
 )
RETURNS Integer
AS
$BODY$
  DECLARE vbValueId Integer;
BEGIN

  -- для Админа  - Все Права
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN
      -- Transport
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Transport()
                       , zc_Enum_Process_Get_Movement_Transport()
                       , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                       , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                       , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                       , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                       , zc_Enum_Process_Get_Movement_TransportService()
                       , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 24)); -- Транспорт Днепр
      ELSE
      -- Document
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Income()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                       , zc_Enum_Process_InsertUpdate_Movement_Sale()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 104)); -- Документы товарные Днепр (доступ просмотра)
      ELSE
      -- Service
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                       , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 44)); -- Начисления Днепр
      ELSE
      -- Cash
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                       , zc_Enum_Process_Get_Movement_Cash()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 54)); -- Касса Днепр
      ELSE
          RAISE EXCEPTION 'Ошибка.У Роли <%> нельзя определить значение для доступа просмотра.', lfGet_Object_ValueData (zc_Enum_Role_Admin());

      END IF;
      END IF;
      END IF;
      END IF;
  END IF;

  -- проверка - должен быть только "один" процесс (доступ просмотра)
  IF EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId NOT IN (zc_Enum_Process_AccessKey_TrasportAll()
                                                                                                   , zc_Enum_Process_AccessKey_GuideAll()
                                                                                                    )
                                                                             AND RoleCode NOT IN (22 -- Транспорт-просмотр ВСЕХ документов
                                                                                                , 32 -- Начисления транспорт-просмотр ВСЕХ документов
                                                                                                , 42 -- Начисления-просмотр ВСЕХ документов
                                                                                                , 48 -- Начисления(п.б.)-просмотр ВСЕХ документов
                                                                                                , 52 -- Касса-просмотр ВСЕХ документов
                                                                                                , 102 -- Приход/Возврат поставщик-просмотр ВСЕХ документов
                                                                                                , 122 -- Продажа/Возврат покупатель-просмотр ВСЕХ документов
                                                                                                 )
             HAVING Count(*) = 1)
  THEN
      vbValueId := (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId NOT IN (zc_Enum_Process_AccessKey_TrasportAll()
                                                                                                                    , zc_Enum_Process_AccessKey_GuideAll()
                                                                                                                     )
                                                                             AND RoleCode NOT IN (22 -- Транспорт-просмотр ВСЕХ документов
                                                                                                , 32 -- Начисления транспорт-просмотр ВСЕХ документов
                                                                                                , 42 -- Начисления-просмотр ВСЕХ документов
                                                                                                , 48 -- Начисления(п.б.)-просмотр ВСЕХ документов
                                                                                                , 52 -- Касса-просмотр ВСЕХ документов
                                                                                                , 102 -- Приход/Возврат поставщик-просмотр ВСЕХ документов
                                                                                                , 122 -- Продажа/Возврат покупатель-просмотр ВСЕХ документов
                                                                                                 )
                   );
  ELSE
      RAISE EXCEPTION 'Ошибка.У пользователя <%> нельзя определить значение для доступа просмотра.', lfGet_Object_ValueData (inUserId);
  END IF;  
  

  IF COALESCE (vbValueId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.У пользователя <%> нельзя определить значение для доступа просмотра.', lfGet_Object_ValueData (inUserId);
  ELSE RETURN vbValueId;
  END IF;  


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpGetAccessKey (Integer, Integer)  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.03.14                                        * add RoleCode
 10.02.14                                        * add Document...
 13.01.14                                        * возвращаем права админу :-)
 15.12.13                                        * add zc_Enum_Process_AccessKey_TrasportAll
 07.12.13                                        *
*/

-- тест
-- SELECT * FROM lpGetAccessKey (zfCalc_UserAdmin() :: Integer, null)
