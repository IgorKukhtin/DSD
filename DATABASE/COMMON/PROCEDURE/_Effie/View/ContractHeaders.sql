-- View: ContractHeaders

DROP VIEW IF EXISTS ContractHeaders;

CREATE OR REPLACE VIEW ContractHeaders
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name
                           , code 
                           , contractDate
                           , validFrom
                           , validTo
                           , form
                           , paymentDelay
                           , creditLimit
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_ContractHeaders_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId            TVarChar   -- Уникальный идентификатор договора
                                               , Name             TVarChar   -- Название Договора  
                                               , code             TVarChar   -- Код договора
                                               , contractDate     TVarChar   -- Дата оформления контракта
                                               , validFrom        TVarChar   -- Дата начала контракта (минимальное значение )
                                               , validTo          TVarChar   -- Дата окончания контракта
                                               , form             Integer    -- 1 или 2 форма
                                               , paymentDelay     Integer    -- Отсрочка оплаты в днях
                                               , creditLimit      TFloat     -- Кредитный лимит 
                                               , isDeleted        Boolean    -- Признак активности: false = активен / true = не активен                        
                                                )
                     )
 --
 SELECT extId
      , Name
      , code 
      , contractDate
      , validFrom
      , validTo
      , form
      , paymentDelay
      , creditLimit
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE ContractHeaders  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.ContractHeaders TO admin;
GRANT ALL ON TABLE PUBLIC.ContractHeaders TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM ContractHeaders ORDER BY 1
