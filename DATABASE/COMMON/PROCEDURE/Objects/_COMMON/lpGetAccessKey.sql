-- Function: lpGetAccessKey()

-- DROP FUNCTION IF EXISTS lpGetAccessKey (Integer, Integer);
DROP FUNCTION IF EXISTS lpGetAccessKey (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetAccessKey(
    IN inUserId      Integer      , -- 
    IN inProcessId   Integer      , -- 
    IN inPersonalServiceListId Integer DEFAULT 0
 )
RETURNS Integer
AS
$BODY$
  DECLARE vbValueId Integer;
  DECLARE vbUserId_save Integer;
BEGIN

  vbUserId_save:= inUserId;

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
           -- <> Посохова Н.В. <> Омельяненко Ю.Б.
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE UserId NOT IN (2556726, 9984496) AND RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 24)); -- Транспорт Днепр
      ELSE
      -- Document
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Income()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                       , zc_Enum_Process_InsertUpdate_Movement_Sale()
                       , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                       , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                       , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                       , zc_Enum_Process_InsertUpdate_Movement_Send()
                       , zc_Enum_Process_InsertUpdate_Movement_Loss()
                       , zc_Enum_Process_InsertUpdate_Movement_Inventory()
                       , zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()

                       , zc_Enum_Process_InsertUpdate_Movement_Tax()
                       , zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()
                       , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                       , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                       , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()

                       , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                       , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()
                        )
      THEN
           inUserId := (SELECT MAX (Object_Process_User_View.UserId)
                        FROM Object_Process_User_View
                             JOIN Object_RoleAccessKey_View ON Object_RoleAccessKey_View.UserId = Object_Process_User_View.UserId
                        WHERE Object_Process_User_View.ProcessId = inProcessId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr()
                          -- <> Посохова Н.В. <> Омельяненко Ю.Б.
                          AND Object_Process_User_View.UserId <> 2556726
                          AND Object_Process_User_View.UserId <> 9984496
                       );
           IF inUserId IS NULL THEN inUserId:= (SELECT MAX (Object_Process_User_View.UserId)
                                                FROM Object_Process_User_View
                                                     JOIN Object_RoleAccessKey_View ON Object_RoleAccessKey_View.UserId = Object_Process_User_View.UserId
                                                WHERE Object_Process_User_View.ProcessId = inProcessId
                                               );
           END IF;
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
      -- PersonalService - 
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin());
      ELSE
          RAISE EXCEPTION 'Ошибка.У Роли <%> нельзя определить значение для доступа к документу.(%)', lfGet_Object_ValueData (zc_Enum_Role_Admin()), lfGet_Object_ValueData (inPersonalServiceListId);

      END IF;
      END IF;
      END IF;
      END IF;
      END IF;
  END IF;

  -- проверка - должен быть только "один" процесс (доступ просмотра)
  IF EXISTS (SELECT 1 FROM (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId NOT IN (zc_Enum_Process_AccessKey_TrasportAll()
                                                                                                                            , zc_Enum_Process_AccessKey_GuideAll()
                                                                                                                             )
                                                                             AND RoleCode NOT IN (22 -- Транспорт-просмотр ВСЕХ документов
                                                                                                , 32 -- Начисления транспорт-просмотр ВСЕХ документов
                                                                                                , 42 -- Начисления-просмотр ВСЕХ документов
                                                                                                , 48 -- Начисления(п.б.)-просмотр ВСЕХ документов
                                                                                                , 52 -- Касса-просмотр ВСЕХ документов
                                                                                                , 102 -- Приход/Возврат поставщик-просмотр ВСЕХ документов
                                                                                                , 122 -- Продажа/Возврат покупатель-просмотр ВСЕХ документов
--                                                                                                , 1101 -- Бухг
                                                                                                 )
                                                                             AND (((RoleCode BETWEEN 40 and 49
                                                                                 OR RoleCode BETWEEN 71 and 78
                                                                                 OR RoleCode IN (10274) -- Начисления Павильоны
                                                                                   )
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                               OR (NOT RoleCode BETWEEN 40 and 49
                                                                               AND NOT RoleCode BETWEEN 71 and 78
                                                                               AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                     , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                 , zc_Enum_Process_Get_Movement_Cash()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Income()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Send()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Inventory()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Tax()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Transport()
                                                                                                 , zc_Enum_Process_Get_Movement_Transport()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                 , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                                                                                                  )
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                         , zc_Enum_Process_Get_Movement_Cash()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Income()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Send()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Inventory()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Tax()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Transport()
                                                                                                         , zc_Enum_Process_Get_Movement_Transport()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                         , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                                                                                                          )
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                                 )
             GROUP BY AccessKeyId) AS tmp
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
--                                                                                                , 1101 -- Бухг
                                                                                                 )
                                                                             AND (((RoleCode BETWEEN 40 and 49
                                                                                 OR RoleCode BETWEEN 71 and 78
                                                                                 OR RoleCode IN (10274) -- Начисления Павильоны
                                                                                   )
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                               OR (NOT RoleCode BETWEEN 40 and 49
                                                                               AND NOT RoleCode BETWEEN 71 and 78
                                                                               AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                     , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                 , zc_Enum_Process_Get_Movement_Cash()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Income()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Send()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Inventory()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Tax()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()

                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Transport()
                                                                                                 , zc_Enum_Process_Get_Movement_Transport()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                 , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                                                                                                   )
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                         , zc_Enum_Process_Get_Movement_Cash()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Income()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Send()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Inventory()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Tax()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()

                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Transport()
                                                                                                         , zc_Enum_Process_Get_Movement_Transport()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                         , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                                                                                                          )
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                                 )
             GROUP BY AccessKeyId
            );
  ELSE
      RAISE EXCEPTION 'Ошибка.У пользователя <%> нельзя определить значение для доступа просмотра.(<%>)(%)', lfGet_Object_ValueData_sh (vbUserId_save), lfGet_Object_ValueData_sh (inUserId), lfGet_Object_ValueData (inPersonalServiceListId);
  END IF;  
  

  IF COALESCE (vbValueId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.У пользователя <%> нельзя определить значение для доступа просмотра.(<%>)(%)', lfGet_Object_ValueData_sh (vbUserId_save), lfGet_Object_ValueData_sh (inUserId), lfGet_Object_ValueData (inPersonalServiceListId);
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
 20.10.14                                        * add Object_RoleAccessKeyDocument_View
 25.08.14                                        * add zc_Enum_Process_InsertUpdate_Movement_OrderExternal() and zc_Enum_Process_InsertUpdate_Movement_OrderInternal()
 08.05.14                                        * add 1101 -- Бухг
 06.03.14                                        * add RoleCode
 10.02.14                                        * add Document...
 13.01.14                                        * возвращаем права админу :-)
 15.12.13                                        * add zc_Enum_Process_AccessKey_TrasportAll
 07.12.13                                        *
*/

-- тест
-- SELECT * FROM lpGetAccessKey (10895 :: Integer, zc_Enum_Process_AccessKey_TrasportDnepr())
