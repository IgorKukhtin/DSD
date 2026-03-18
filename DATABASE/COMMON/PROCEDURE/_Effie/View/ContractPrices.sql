-- View: ContractPrices

DROP VIEW IF EXISTS ContractPrices;

CREATE OR REPLACE VIEW ContractPrices
AS 
  WITH _tmpresult AS (SELECT priceHeaderExtId
                           , contractHeaderExtId
                           , validFrom
                           , validTo
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_ContractPrices_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (priceHeaderExtId      TVarChar   -- Идентификатор прайса
                                               , contractHeaderExtId   TVarChar   -- Идентификатор контракта
                                               , validFrom             TVarChar   -- Дата начала (минимальная дата 1753-01-01)
                                               , validTo               TVarChar   -- Дата окончания (максимальная дата 9999-12-31)
                                               , isDeleted             Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.                        
                                                )
                     )
 --
 SELECT priceHeaderExtId
      , contractHeaderExtId
      , validFrom
      , validTo
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE ContractPrices  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.ContractPrices TO admin;
GRANT ALL ON TABLE PUBLIC.ContractPrices TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.26         *
*/

-- тест
-- SELECT * FROM ContractPrices ORDER BY 1
