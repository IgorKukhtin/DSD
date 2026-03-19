-- View: PriceForTwin

DROP VIEW IF EXISTS PriceForTwin;

CREATE OR REPLACE VIEW PriceForTwin
AS 
  WITH _tmpresult AS (SELECT extId
                           , clientExtID
                           , priceHeaderExtId
                           , ttExtID
                           , employeeExtId
                           , defaultPrice
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_PriceForTwin_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId                 TVarChar   -- Идентификатор перевязки прайс-торговая точка-клиент
                                               , clientExtID           TVarChar   -- Идентификатор клиента
                                               , priceHeaderExtId      TVarChar   -- Идентификатор прайса
                                               , ttExtID               TVarChar   -- Идентификатор торговой точки
                                               , employeeExtId         TVarChar   -- Идентификатор сотрудника 
                                               , defaultPrice          Boolean    -- true - прайс по умолчанию / false - обычный
                                               , isDeleted             Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.                    
                                                )
                     )
 --
 SELECT extId
      , clientExtID
      , priceHeaderExtId
      , ttExtID
      , employeeExtId
      , defaultPrice
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE PriceForTwin  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.PriceForTwin TO admin;
GRANT ALL ON TABLE PUBLIC.PriceForTwin TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM PriceForTwin ORDER BY 1
