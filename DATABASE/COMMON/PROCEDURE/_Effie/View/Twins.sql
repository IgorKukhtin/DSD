-- View: Twins

DROP VIEW IF EXISTS Twins;

CREATE OR REPLACE VIEW Twins
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT extId, Name, isDeleted
                                    FROM gpSelect_Object_Clients_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId           TVarChar   -- Идентификатор канала продаж
                                               , Name            TVarChar   -- Название канала продаж
                                               , isDeleted       Boolean    -- Признак активности записи: 0 = активна / 1 = не активна                            
                                                )
                     )
 --
 SELECT extId AS ttExtId
      , extId AS clientExtId
      , TRUE  AS IsDefaultClient
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE Twins  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.Twins TO admin;
GRANT ALL ON TABLE PUBLIC.Twins TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26                                        *
*/

-- тест
-- SELECT * FROM Twins ORDER BY 1
