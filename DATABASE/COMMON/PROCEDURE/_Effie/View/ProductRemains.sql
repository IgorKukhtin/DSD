-- View: ProductRemains

DROP VIEW IF EXISTS ProductRemains;

CREATE OR REPLACE VIEW ProductRemains
AS 
  WITH _tmpresult AS (SELECT warehouseExtId
                           , productExtId
                           , amount
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_ProductRemains_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (warehouseExtId      TVarChar   -- Идентификатор склада
                                               , productExtId        TVarChar   -- Идентификатор товара
                                               , amount              TFloat     -- Кол-во товара
                                               , isDeleted           Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.                        
                                                )
                     )
 --
 SELECT warehouseExtId
      , productExtId
      , amount
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE ProductRemains  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.ProductRemains TO admin;
GRANT ALL ON TABLE PUBLIC.ProductRemains TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM ProductRemains ORDER BY 1
