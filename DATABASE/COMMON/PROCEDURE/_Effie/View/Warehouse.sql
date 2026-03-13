-- View: Warehouse

DROP VIEW IF EXISTS Warehouse;

CREATE OR REPLACE VIEW Warehouse
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name
                           , warehouseTypeId
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_Warehouse_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId            TVarChar   -- Уникальный идентификатор склада
                                               , Name             TVarChar   -- Название склада
                                               , warehouseTypeId  TVarChar  -- "Тип склада:1 - Stationary 2 - Mobile , по умолчанию 1"
                                               , isDeleted        Boolean    -- Признак активности: false = активен / true = не активен                             
                                                )
                     )
 --
 SELECT extId
      , Name
      , warehouseTypeId
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE Warehouse  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.Warehouse TO admin;
GRANT ALL ON TABLE PUBLIC.Warehouse TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.26         *
*/

-- тест
-- SELECT * FROM Warehouse ORDER BY 1
