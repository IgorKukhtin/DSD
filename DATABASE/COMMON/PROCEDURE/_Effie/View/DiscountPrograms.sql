-- View: DiscountPrograms

DROP VIEW IF EXISTS DiscountPrograms;

CREATE OR REPLACE VIEW DiscountPrograms
AS 
  WITH /*_tmpTT AS AS (SELECT ttExtId
                           , clientExtId
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT ttExtId
                                          , clientExtId
                                    FROM gpSelect_Object_Twins_effie(zfCalc_UserAdmin())
                                    WHERE ttExtId :: Integer > 0'
                                    ) :: Text
                                  ) AS gpSelect (ttExtId          TVarChar   -- Идентификатор торговой точки
                                               , clientExtId      TVarChar   -- Идентификатор контрагента.
                                                )
                     )*/
     , _tmpresult AS (SELECT extId
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
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT extId
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
                                    FROM _tmpDiscountPrograms_effie'
                                    ) :: Text
                                  ) AS gpSelect (extId                      TVarChar   --Уникальный идентификатор промо акции
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
                                                )
                     )
 --
 SELECT _tmpresult.extId
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
      , _tmpresult.clientExtId -- _tmpTT.ttExtId  AS clientExtId-- _tmpresult.clientExtId
      , isPreDiscountCheckSkipped
      , linkDiscounts_extId
      , linkDiscounts_discount
   FROM _tmpresult
        -- join _tmpTT ON _tmpTT.clientExtId = _tmpresult.clientExtId

  ;

ALTER TABLE DiscountPrograms  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.DiscountPrograms TO admin;
GRANT ALL ON TABLE PUBLIC.DiscountPrograms TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.03.26         *
*/

-- тест
-- SELECT * FROM DiscountPrograms ORDER BY 1
