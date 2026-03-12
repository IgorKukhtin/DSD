-- View: ChannelSales

DROP VIEW IF EXISTS ChannelSales;

CREATE OR REPLACE VIEW ChannelSales
AS 
  WITH _tmpresult AS (SELECT Id                  
                           , Name            
                           , isDeleted        
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_ChannelSales_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (Id              TVarChar   -- Идентификатор канала продаж
                                               , Name            TVarChar   -- Название канала продаж
                                               , isDeleted       Integer    -- Признак активности записи: 0 = активна / 1 = не активна                              
                                                )
                     )
 --
 SELECT Id                  
      , Name            
      , isDeleted              
   FROM _tmpresult
  ;

ALTER TABLE ChannelSales  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.ChannelSales TO admin;
GRANT ALL ON TABLE PUBLIC.ChannelSales TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM ChannelSales ORDER BY 1
