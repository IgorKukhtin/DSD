/*
  Создание 
    - таблица _tmpDiscountPrograms_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE _tmpDiscountPrograms_effie         (extId                      TVarChar   --Уникальный идентификатор промо акции
                                               , Name                       TVarChar   --Описание программы скидок
                                               , description                TVarChar   --Описание программы скидок
                                               , typeId                     Integer    --Тип расчета
                                               , linkTypeId                 Integer    --Тип связи
                                               , priority                   Integer    --Приоритет программы скидок при применении в заказе. От высшего = 1 до низшего = 255 
                                               , сontractHeaderExtId        TVarChar   -- Внешний идентификатор контракта, к которому привязана программа скидок
                                               , beginDate                  TVarChar   --Дата начала действия программы скидок
                                               , endDate                    TVarChar   --Дата окончания действия программы скидок
                                               , shortName                  TVarChar   --короткое название 
                                               , isAutoUse                  Boolean    --Авто применение программы скидок (признак false = не активен / true = активен) 
                                               , beforeDiscountQuestHeaderId TVarChar  --Id Анкеты Контроль цены до скидки
                                               , afterDiscountQuestHeaderId TVarChar   --Id Анкеты Контроль цены после скидки  
                                               , isDeleted                  Boolean    --Признак активности 
                                               , customTypeExtId            TVarChar   --Внешний идентификатор типа скидки.
                                               
                                               , clientExtId                TVarChar   --Внешний идентификатор контрагента
                                               , isPreDiscountCheckSkipped  Boolean    --Признак пропуска контроля цены до скидки
                                               
                                               , linkDiscounts_extId        TVarChar   --Идентификатор единицы связи. К примеру, типа связи по продуктам это будет значение внешнего идентификатора продукта.
                                               , linkDiscounts_discount     TFloat     --"Объём скидки, используется только для типа программы скидок 1 - фиксированная.Допустимо отрицательное значение.    
                                                );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.26                                        *
*/

/*
-- 1
INSERT INTO _tmpDiscountPrograms_effie         (extId
                           , Name
                           , description
                           , typeId
                           , linkTypeId
                           , priority
                           , сontractHeaderExtId
                           , beginDate
                           , endDate
                           , shortName
                           , isAutoUse
                           , beforeDiscountQuestHeaderId
                           , afterDiscountQuestHeaderId
                           , isDeleted
                           , customTypeExtId
                           , clientExtId
                           , isPreDiscountCheckSkipped
                           , linkDiscounts_extId
                           , linkDiscounts_discount)
                      SELECT extId
                           , Name
                           , description
                           , typeId
                           , linkTypeId
                           , priority
                           , сontractHeaderExtId
                           , beginDate
                           , endDate
                           , shortName
                           , isAutoUse
                           , beforeDiscountQuestHeaderId
                           , afterDiscountQuestHeaderId
                           , isDeleted
                           , customTypeExtId
                           , clientExtId
                           , isPreDiscountCheckSkipped
                           , linkDiscounts_extId
                           , linkDiscounts_discount
                    FROM gpSelect_Movement_DiscountPrograms_effie (zfCalc_UserAdmin()::TVarChar)

-- 2
INSERT INTO _tmpDiscountPrograms_effie         (extId
                           , Name
                           , description
                           , typeId
                           , linkTypeId
                           , priority
                           , сontractHeaderExtId
                           , beginDate
                           , endDate
                           , shortName
                           , isAutoUse
                           , beforeDiscountQuestHeaderId
                           , afterDiscountQuestHeaderId
                           , isDeleted
                           , customTypeExtId
                           , clientExtId
                           , isPreDiscountCheckSkipped
                           , linkDiscounts_extId
                           , linkDiscounts_discount)
                      SELECT extId
                           , Name
                           , description
                           , typeId
                           , linkTypeId
                           , priority
                           , сontractHeaderExtId
                           , beginDate
                           , endDate
                           , shortName
                           , isAutoUse
                           , beforeDiscountQuestHeaderId
                           , afterDiscountQuestHeaderId
                           , isDeleted
                           , customTypeExtId
                           , clientExtId
                           , isPreDiscountCheckSkipped
                           , linkDiscounts_extId
                           , linkDiscounts_discount
                    FROM gpSelect_Movement_DiscountProgramsTax_effie (zfCalc_UserAdmin()::TVarChar)
*/