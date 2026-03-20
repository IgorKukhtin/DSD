-- View: DiscountPrograms

DROP VIEW IF EXISTS DiscountPrograms;

CREATE OR REPLACE VIEW DiscountPrograms
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name
                           , startDate
                           , endDate
                           , description
                           , priority
                           , promoActionTypeId 
                           , totalQnt
                           , needBuy
                           , giftChoiseAbility
                           , shortName
                           , form
                           , changeNeedOrderToMinValue
                           , quantityLimitInTt
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_DiscountPrograms_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId                      TVarChar   --Уникальный идентификатор промо акции
                                               , Name                       TVarChar   --Название промо акции
                                               , startDate                  TVarChar   --Дата старта промо акции
                                               , endDate                    TVarChar   --Дата окончания промо акции
                                               , description                TVarChar   --Описание акции
                                               , priority                   Integer    --Приоритет промоакции (используется для определения порядка применения скидок по промоакциям и программам скидок)
                                               , promoActionTypeId          Integer    --"Механика промоакции:
                                               , totalQnt                   TFloat     --"Количество для срабатывания акции (логика работы с полями описана для БА здесь Настройка промо-акций )"
                                               , needBuy                    TFloat     --"Количество уникальных товаров для срабатывания акции (для акций типа 1-4 и 6)
                                               , giftChoiseAbility          Boolean    --Возможность выбора подарка: false = нет / true = да
                                               , shortName                  TVarChar   --Короткое название (аббревиатура)
                                               , form                       TVarChar   --Форма заказа для срабатывания (Корректные значения 1, 2 или null)
                                               , changeNeedOrderToMinValue  Boolean    --Не применять цикличность расчета количества товаров
                                               , quantityLimitInTt          Boolean    --Лимит на количество срабатываний акции в каждой торговой точке, где доступна эта акция. (По умолчанию null, т.е. лимит отсутствует)
                                               , isDeleted                  Boolean    -- Признак активности         
                                                )
                     )
 --
 SELECT extId
      , Name
      , startDate
      , endDate
      , description
      , priority
      , promoActionTypeId
      , totalQnt
      , needBuy
      , giftChoiseAbility
      , shortName
      , form
      , changeNeedOrderToMinValue
      , quantityLimitInTt
      , isDeleted
   FROM _tmpresult
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
