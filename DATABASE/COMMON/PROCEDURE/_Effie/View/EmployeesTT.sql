-- View: EmployeesTT

DROP VIEW IF EXISTS EmployeesTT;

CREATE OR REPLACE VIEW EmployeesTT
AS 
  WITH _tmpresult AS (SELECT employeeExtId
                           , ttExtId
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_EmployeesTT_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (employeeExtId    TVarChar   -- Идентификатор сотрудника
                                               , ttExtId          TVarChar   -- Идентификатор торговой точки
                                               , isDeleted        Integer    -- Признак активности              
                                                )
                     )
 --
 SELECT employeeExtId
      , ttExtId
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE EmployeesTT  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.EmployeesTT TO admin;
GRANT ALL ON TABLE PUBLIC.EmployeesTT TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM EmployeesTT ORDER BY 1
