/*
  Создание 
    - таблица _tmpImportBalances_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE _tmpImportBalances_effie         (ExtId                TVarChar   -- Идентификатор записи по долгам
                                             , employeeExtId        TVarChar   -- Идентификатор сотрудников
                                             , ttExtId              TVarChar   -- Идентификатор торговой точки
                                             , clientExtId          TVarChar   -- Идентификатор контрагента
                                             , contractHeaderExtId  TVarChar   -- Уникальный идентификатор контракта
                                             , balanceValue         TFloat     -- Текущая задолженность, Должно быть больше или равно чем balanceOverdue
                                             , balanceOverdue       TFloat     -- Просроченная задолженность
                                             , balanceDate          TVarChar   -- Дата формирования сальдо = current date (текущий РАБОЧИЙ день)
                                             , limitOverdue         Boolean    -- Превышение лимита по баллансу (false - отгрузка разрешена, true - блокировка отгрузок)
                                              );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.26                                        *
*/

/*
INSERT INTO _tmpImportBalances_effie (ExtId
                                    , employeeExtId
                                    , ttExtId
                                    , clientExtId
                                    , contractHeaderExtId
                                    , balanceValue
                                    , balanceOverdue
                                    , balanceDate
                                    , limitOverdue
                                     )
                      SELECT ExtId
                           , employeeExtId
                           , ttExtId
                           , clientExtId
                           , contractHeaderExtId
                           , balanceValue
                           , balanceOverdue
                           , balanceDate
                           , limitOverdue
                    FROM gpSelect_Object_ClientBalance_effie (zfCalc_UserAdmin()::TVarChar)
*/