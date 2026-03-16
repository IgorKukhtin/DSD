-- View: ContractHeaderClients

DROP VIEW IF EXISTS ContractHeaderClients;

CREATE OR REPLACE VIEW ContractHeaderClients
AS 
  WITH _tmpresult AS (SELECT contractHeaderExtId
                           , clientExtId
                           , isDefault
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_ContractHeaderClients_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (contractHeaderExtId  TVarChar   -- Уникальный идентификатор контракта
                                               , clientExtId          TVarChar   -- Идентификатор контрагента
                                               , isDefault            Boolean    -- true - контракт по умолчанию, false - обычный контракт
                                               , isDeleted            Boolean    -- Признак активности               
                                                )
                     )
 --
 SELECT contractHeaderExtId
      , clientExtId
      , isDefault
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE ContractHeaderClients  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.ContractHeaderClients TO admin;
GRANT ALL ON TABLE PUBLIC.ContractHeaderClients TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM ContractHeaderClients ORDER BY 1
