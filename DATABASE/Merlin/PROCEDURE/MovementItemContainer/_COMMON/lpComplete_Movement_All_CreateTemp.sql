-- Function: lpComplete_Movement_All_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_All_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_All_CreateTemp ()
RETURNS VOID
AS
$BODY$
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         DELETE FROM _tmpMIContainer_insert;
     ELSE
         -- таблица - Проводки
         CREATE TEMP TABLE _tmpMIContainer_insert (Id             BigInt
                                                 , DescId         Integer
                                                 , MovementDescId Integer -- Вид документа
                                                 , MovementId     Integer
                                                 , MovementItemId Integer
                                                 , ContainerId    Integer
                                                 , ParentId       BigInt

                                                 , AccountId               Integer -- Счет
                                                 , AnalyzerId              Integer -- Типы аналитик (проводки)
                                                 , ObjectId_Analyzer       Integer -- MovementItem.ObjectId
                                                 , PartionId               Integer -- MovementItem.PartionId
                                                 , WhereObjectId_Analyzer  Integer -- Место учета

                                                 , AccountId_Analyzer      Integer -- Счет - корреспондент

                                                 , ContainerId_Analyzer    Integer -- Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
                                                 , ContainerIntId_Analyzer Integer -- Контейнер - Корреспондент
                                                 , ContainerExtId_Analyzer Integer -- Контейнер - Корреспондент

                                                 , ObjectIntId_Analyzer    Integer -- Аналитический справочник (Размер, УП статья или что-то особенное - т.е. все то что не вписалось в аналитики выше)
                                                 , ObjectExtId_Analyzer    Integer -- Аналитический справочник (Подразделение - корреспондент, Подразделение ЗП, ФИО, Контрагент и т.д. - т.е. все то что не вписалось в аналитики выше)

                                                 , Amount         TFloat
                                                 , OperDate       TDateTime
                                                 , IsActive       Boolean
                                                  ) ON COMMIT DROP;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
