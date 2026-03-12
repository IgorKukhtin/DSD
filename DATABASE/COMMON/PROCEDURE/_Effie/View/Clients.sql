-- View: Clients

DROP VIEW IF EXISTS Clients;

CREATE OR REPLACE VIEW Clients
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name
                           , legalAddress
                           , streetAddress
                           , regNumb
                           , regDate
                           , subjCode
                           , bankInfo
                           , corporationCode
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_Clients_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId           TVarChar   -- Идентификатор канала продаж
                                               , Name            TVarChar   -- Название канала продаж
                                               , legalAddress    TVarChar   -- Юр. адрес клиента
                                               , streetAddress   TVarChar   -- Физ. адрес клиента
                                               , regNumb         TVarChar   -- Регистрационный номер
                                               , regDate         TVarChar   -- Дата регистрации
                                               , subjCode        TVarChar   -- Код клиента
                                               , bankInfo        TVarChar   -- Банковские реквизиты клиента
                                               , corporationCode TVarChar   -- Код корпорации
                                               , isDeleted       Boolean    -- Признак активности записи: 0 = активна / 1 = не активна                            
                                                )
                     )
 --
 SELECT extId
      , Name
      , legalAddress
      , streetAddress
      , regNumb
      , regDate
      , subjCode
      , bankInfo
      , corporationCode
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE Clients  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.Clients TO admin;
GRANT ALL ON TABLE PUBLIC.Clients TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM Clients ORDER BY 1
