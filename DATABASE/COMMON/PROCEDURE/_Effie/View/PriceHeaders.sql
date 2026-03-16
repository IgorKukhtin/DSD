-- View: PriceHeaders

DROP VIEW IF EXISTS PriceHeaders;

CREATE OR REPLACE VIEW PriceHeaders
AS 
  WITH _tmpresult AS (SELECT extId                  
                           , Name            
                           , isDeleted        
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_PriceHeaders_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId           TVarChar   -- Идентификатор прайса
                                               , Name            TVarChar   -- Название прайса
                                               , isDeleted       Boolean    -- Признак активности: false = активен / true = не активен                 
                                                )
                     )
 --
 SELECT extId                  
      , Name            
      , isDeleted              
   FROM _tmpresult
  ;

ALTER TABLE PriceHeaders  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.PriceHeaders TO admin;
GRANT ALL ON TABLE PUBLIC.PriceHeaders TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM PriceHeaders ORDER BY 1
