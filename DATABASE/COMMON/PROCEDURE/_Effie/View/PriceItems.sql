-- View: PriceItems

DROP VIEW IF EXISTS PriceItems;

CREATE OR REPLACE VIEW PriceItems
AS 
  WITH _tmpresult AS (SELECT extId                  
                           , priceHeaderExtId
                           , productExtId
                           , price
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_PriceItems_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId            TVarChar   -- Идентификатор строки прайса (необходим для того, чтобы можно было поменять цену по товару по этому идентификатору при новой загрузке данных)
                                               , priceHeaderExtId TVarChar   -- Идентификатор прайса
                                               , productExtId     TVarChar   -- Идентификатор товара
                                               , price            TVarChar   -- Цена
                                               , isDeleted        Boolean    -- Признак активности                
                                                )
                     )
 --
 SELECT extId                  
      , priceHeaderExtId
      , productExtId
      , price
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE PriceItems  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.PriceItems TO admin;
GRANT ALL ON TABLE PUBLIC.PriceItems TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM PriceItems ORDER BY 1
