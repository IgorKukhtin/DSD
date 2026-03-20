-- View: Twins

DROP VIEW IF EXISTS Twins;

CREATE OR REPLACE VIEW Twins
AS 
  WITH _tmpresult AS (SELECT ttExtId
                           , clientExtId
                           , IsDefaultClient
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_Clients_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (ttExtId          TVarChar   -- Идентификатор торговой точки
                                               , clientExtId      TVarChar   -- Идентификатор контрагента.
                                               , IsDefaultClient  Boolean    -- Контрагент по умолчанию
                                               , isDeleted        Boolean    -- Признак активности                            
                                                )
                     )
 --
 SELECT ttExtId
      , clientExtId
      , IsDefaultClient
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
 19.03.26         *
 11.03.26                                        *
*/

-- тест
-- SELECT * FROM Twins ORDER BY 1
