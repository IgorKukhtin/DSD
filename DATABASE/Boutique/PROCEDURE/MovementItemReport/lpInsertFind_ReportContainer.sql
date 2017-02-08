-- Function: lpInsertFind_ReportContainer (Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_ReportContainer (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_ReportContainer(
    IN inActiveContainerId   Integer              , -- 
    IN inPassiveContainerId  Integer              , -- 
    IN inActiveAccountId     Integer              , -- 
    IN inPassiveAccountId    Integer                -- 
)
  RETURNS Integer AS
$BODY$
  DECLARE vbReportContainerId Integer;

   DECLARE vbKeyValue TVarChar;
   DECLARE vbMasterKeyValue BigInt;
   DECLARE vbChildKeyValue BigInt;
BEGIN
     -- !!!Выход, т.к. больше не нужны!!!
     RETURN 0;


     -- Проверка
     IF  COALESCE (inActiveContainerId, 0) = 0 OR COALESCE (inPassiveContainerId, 0) = 0
      OR COALESCE (inActiveAccountId, 0) = 0 OR COALESCE (inPassiveAccountId, 0) = 0
     THEN
         RAISE EXCEPTION 'Невозможно cформировать аналитику у проводки для отчета с пустым счетом : "%", "%", "%", "%"', inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId;
     END IF;


     -- !!!определяется КЛЮЧ!!!
     vbKeyValue = (SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                         FROM     (SELECT zc_Enum_AccountKind_Passive()      AS Value, 0 AS myOrder1, -1 AS myOrder2
                         UNION ALL SELECT COALESCE (inPassiveContainerId, 0) AS Value, 1 AS myOrder1, -1 AS myOrder2
                         UNION ALL SELECT zc_Enum_AccountKind_Active()       AS Value, 0 AS myOrder1, -2 AS myOrder2
                         UNION ALL SELECT COALESCE (inActiveContainerId, 0)  AS Value, 1 AS myOrder1, -2 AS myOrder2
                                  ) AS tmp
                         ORDER BY tmp.myOrder2, tmp.myOrder1
                        ) AS tmp
                  );

     -- !!!определяется еще первый КЛЮЧ!!!
     vbMasterKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 1 FOR 8));
     -- !!!определяется еще второй КЛЮЧ!!!
     vbChildKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 9 FOR 8));


     -- !!!находим СРАЗУ по ДВУМ ключам!!!
     vbReportContainerId := (SELECT MAX (ReportContainerId) FROM ReportContainerLink WHERE MasterKeyValue = vbMasterKeyValue AND ChildKeyValue = vbChildKeyValue);

/*
     -- Если не нашли, находим по старому алгоритму
     IF COALESCE (vbReportContainerId, 0) = 0
     THEN

     -- находим
     vbReportContainerId:=(SELECT ReportContainerLink_Active.ReportContainerId
                           FROM ReportContainerLink  AS ReportContainerLink_Active
                                JOIN ReportContainerLink  AS ReportContainerLink_Passive
                                                          ON ReportContainerLink_Passive.ReportContainerId = ReportContainerLink_Active.ReportContainerId
                                                         AND ReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                         AND ReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                           WHERE ReportContainerLink_Active.ContainerId = inActiveContainerId
                             AND ReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                          );
     END IF; -- if Если не нашли, находим по старому алгоритму
*/

     -- Если не нашли, добавляем
     IF COALESCE (vbReportContainerId, 0) = 0
     THEN
         -- определяем новый ReportContainerId
         SELECT NEXTVAL ('reportcontainer_id_seq') INTO vbReportContainerId;

         -- добавили Аналитики
         INSERT INTO ReportContainerLink (ReportContainerId, ContainerId, AccountId, AccountKindId, ChildContainerId, ChildAccountId, KeyValue, MasterKeyValue, ChildKeyValue)
            SELECT vbReportContainerId, inActiveContainerId, inActiveAccountId, zc_Enum_AccountKind_Active(), inPassiveContainerId, inPassiveAccountId, vbKeyValue, vbMasterKeyValue, vbChildKeyValue
           UNION ALL
            SELECT vbReportContainerId, inPassiveContainerId, inPassiveAccountId, zc_Enum_AccountKind_Passive(), inActiveContainerId, inActiveAccountId, vbKeyValue, vbMasterKeyValue, vbChildKeyValue
            ;

     END IF;  

     -- Возвращаем значение
     RETURN (vbReportContainerId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_ReportContainer (Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.12.14                                        * add ChildContainerId and ChildAccountId 
 13.08.14                                        * ALL
 19.09.13                                        * optimize
 29.08.13                                        *
*/

-- тест
/*
SELECT * FROM lpInsertFind_ReportContainer (inActiveContainerId   := 1
                                          , inPassiveContainerId  := 2
                                          , inActiveAccountId     := 11
                                          , inPassiveAccountId    := 12
                                           )
*/

/*
-- !!!!!!!!!!!!!!!!!!!!!
-- !!!update KeyValue!!!
-- !!!!!!!!!!!!!!!!!!!!!

select  co, tmp.KeyValue, ReportContainerLink.KeyValue, ReportContainerLink.*

-- update ReportContainerLink set KeyValue = tmp.KeyValue
from (
SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
 || case count(*) when 2 then ';0,0'
                         else ''
    end 
    as KeyValue

, tmp.ReportContainerId, count(*) as co
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                              , tmp.ReportContainerId
                         FROM     (SELECT Value, myOrder1, myOrder2, ReportContainerId FROM (SELECT zc_Enum_AccountKind_Passive() AS Value, 0 AS myOrder1, -1 AS myOrder2, ReportContainerId FROM ReportContainerLink where AccountKindId = zc_Enum_AccountKind_Passive() group by ContainerId, ReportContainerId) as tmp
                         UNION ALL SELECT Value, myOrder1, myOrder2, ReportContainerId FROM (SELECT ContainerId                   AS Value, 1 AS myOrder1, -1 AS myOrder2, ReportContainerId FROM ReportContainerLink where AccountKindId = zc_Enum_AccountKind_Passive() group by ContainerId, ReportContainerId) as tmp
                         UNION ALL SELECT Value, myOrder1, myOrder2, ReportContainerId FROM (SELECT zc_Enum_AccountKind_Active()  AS Value, 0 AS myOrder1, -2 AS myOrder2, ReportContainerId FROM ReportContainerLink where AccountKindId = zc_Enum_AccountKind_Active()  group by ContainerId, ReportContainerId) as tmp
                         UNION ALL SELECT Value, myOrder1, myOrder2, ReportContainerId FROM (SELECT ContainerId                   AS Value, 1 AS myOrder1, -2 AS myOrder2, ReportContainerId FROM ReportContainerLink where AccountKindId = zc_Enum_AccountKind_Active()  group by ContainerId, ReportContainerId) as tmp
                                  ) AS tmp
                         ORDER BY ReportContainerId, tmp.myOrder2, tmp.myOrder1
                        ) as tmp
group by tmp.ReportContainerId
) as tmp

 where ReportContainerLink.ReportContainerId = tmp.ReportContainerId  -- !!!update
   and ReportContainerLink.AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive()) -- !!!update

 left join ReportContainerLink on ReportContainerLink.ReportContainerId = tmp.ReportContainerId
                                   and ReportContainerLink.AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
 where coalesce (ReportContainerLink.KeyValue, '') <> tmp.KeyValue


-- select * from ReportContainerLink where coalesce (KeyValue, '') = ''
-- select KeyValue from (select ReportContainerId, KeyValue from ReportContainerLink group by ReportContainerId, KeyValue) as tmp group by KeyValue having count (*) > 1


-- update ReportContainerLink set MasterKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 1 FOR 8)), ChildKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 9 FOR 8)) where AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
-- select * from ReportContainerLink where (coalesce (MasterKeyValue, 0) = 0 or coalesce (ChildKeyValue, 0) = 0) and AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
-- select MasterKeyValue, ChildKeyValue from (select ReportContainerId, MasterKeyValue, ChildKeyValue from ReportContainerLink where AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive()) group by ReportContainerId, MasterKeyValue, ChildKeyValue) as tmp group by MasterKeyValue, ChildKeyValue having count (*) > 1
*/
