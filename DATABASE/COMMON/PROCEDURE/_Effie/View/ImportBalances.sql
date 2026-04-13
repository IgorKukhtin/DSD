-- View: ImportBalances

DROP VIEW IF EXISTS ImportBalances;

CREATE OR REPLACE VIEW ImportBalances
AS 
  WITH _tmpresult AS (SELECT ExtId
                           , employeeExtId
                           , ttExtId
                           , clientExtId
                           , contractHeaderExtId
                           , balanceValue
                           , balanceOverdue
                           , balanceDate
                           , limitOverdue
                      FROM dblink ('host=192.168.0.219 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT ExtId
                                          , employeeExtId
                                          , ttExtId
                                          , clientExtId
                                          , contractHeaderExtId
                                          , balanceValue
                                          , balanceOverdue
                                          , balanceDate
                                          , limitOverdue
                                    FROM gpSelect_Object_ClientBalance_effie (zfCalc_UserAdmin()::TVarChar)'
                                    ) :: Text
                                  ) AS gpSelect (ExtId                TVarChar   -- Идентификатор записи по долгам
                                               , employeeExtId        TVarChar   -- Идентификатор сотрудников
                                               , ttExtId              TVarChar   -- Идентификатор торговой точки
                                               , clientExtId          TVarChar   -- Идентификатор контрагента
                                               , contractHeaderExtId  TVarChar   -- Уникальный идентификатор контракта
                                               , balanceValue         TFloat     -- Текущая задолженность, Должно быть больше или равно чем balanceOverdue
                                               , balanceOverdue       TFloat     -- Просроченная задолженность
                                               , balanceDate          TVarChar   -- Дата формирования сальдо = current date (текущий РАБОЧИЙ день)
                                               , limitOverdue         Boolean    -- Превышение лимита по баллансу (false - отгрузка разрешена, true - блокировка отгрузок)
                                                )
                     )
 --
 SELECT ExtId
      , employeeExtId
      , ttExtId
      , clientExtId
      , contractHeaderExtId
      , balanceValue
      , balanceOverdue
      , balanceDate
      , limitOverdue
   FROM _tmpresult
  ;

ALTER TABLE Clients  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.Clients TO admin;
GRANT ALL ON TABLE PUBLIC.Clients TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.26         *
*/

-- тест
-- SELECT * FROM ImportBalances ORDER BY 1
