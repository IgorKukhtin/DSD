-- View: EmployeeWarehouseLinks

DROP VIEW IF EXISTS EmployeeWarehouseLinks;

CREATE OR REPLACE VIEW EmployeeWarehouseLinks
AS 
  WITH _tmpresult AS (SELECT employeeExtId
                           , warehouseExtId
                           , linkItemTypeId
                           , linkItemExtId
                           , isDefaultWarehouse
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_EmployeeWarehouseLinks_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (employeeExtId       TVarChar   -- Идентификатор сотрудника
                                               , warehouseExtId      TVarChar   -- Идентификатор склада
                                               , linkItemTypeId      TFloat     -- "Тип связи : null - все товары, доступные на складе
                                               , linkItemExtId       TVarChar   -- "Идентификатор связи. В зависимости от типа связи соответствующий идентификатор."
                                               , isDefaultWarehouse  Boolean    -- Признак того, что текущий склад для сотрудника - склад по умолчанию. true - склад по умолчанию, false - обычный склад
                                               , isDeleted           Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.                           
                                                )
                     )
 --
 SELECT employeeExtId
      , warehouseExtId
      , linkItemTypeId
      , linkItemExtId
      , isDefaultWarehouse
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE EmployeeWarehouseLinks  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.EmployeeWarehouseLinks TO admin;
GRANT ALL ON TABLE PUBLIC.EmployeeWarehouseLinks TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM EmployeeWarehouseLinks ORDER BY 1
