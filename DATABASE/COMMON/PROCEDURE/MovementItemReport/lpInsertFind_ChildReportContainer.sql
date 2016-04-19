-- Function: lpInsertFind_ChildReportContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

-- DROP FUNCTION lpInsertFind_ChildReportContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_ChildReportContainer(
    IN inActiveContainerId   Integer              , -- 
    IN inPassiveContainerId  Integer              , -- 
    IN inActiveAccountId     Integer              ,
    IN inPassiveAccountId    Integer              ,
    IN inAccountKindId_1     Integer DEFAULT NULL , -- 
    IN inContainerId_1       Integer DEFAULT NULL , -- 
    IN inAccountId_1         Integer DEFAULT NULL , -- 
    IN inAccountKindId_2     Integer DEFAULT NULL , -- 
    IN inContainerId_2       Integer DEFAULT NULL , -- 
    IN inAccountId_2         Integer DEFAULT NULL , -- 
    IN inAccountKindId_3     Integer DEFAULT NULL , -- 
    IN inContainerId_3       Integer DEFAULT NULL , -- 
    IN inAccountId_3         Integer DEFAULT NULL , -- 
    IN inAccountKindId_4     Integer DEFAULT NULL , -- 
    IN inContainerId_4       Integer DEFAULT NULL , -- 
    IN inAccountId_4         Integer DEFAULT NULL , -- 
    IN inAccountKindId_5     Integer DEFAULT NULL , -- 
    IN inContainerId_5       Integer DEFAULT NULL , -- 
    IN inAccountId_5         Integer DEFAULT NULL   -- 
)
  RETURNS Integer AS
$BODY$
  DECLARE vbChildReportContainerId Integer;
  DECLARE vbRecordCount Integer;

   DECLARE vbKeyValue TVarChar;
   DECLARE vbMasterKeyValue BigInt;
   DECLARE vbChildKeyValue BigInt;
BEGIN
     -- !!!Выход, т.к. больше не нужны!!!
     RETURN 0;


     inActiveContainerId  := COALESCE (inActiveContainerId, 0);
     inPassiveContainerId := COALESCE (inPassiveContainerId, 0);
     inActiveAccountId    := COALESCE (inActiveAccountId, 0);
     inPassiveAccountId   := COALESCE (inPassiveAccountId, 0);
     inContainerId_1      := COALESCE (inContainerId_1, 0);
     inAccountId_1        := COALESCE (inAccountId_1, 0);
     inContainerId_2      := COALESCE (inContainerId_2, 0);
     inAccountId_2        := COALESCE (inAccountId_2, 0);
     inContainerId_3      := COALESCE (inContainerId_3, 0);
     inAccountId_3        := COALESCE (inAccountId_3, 0);
     inContainerId_4      := COALESCE (inContainerId_4, 0);
     inAccountId_4        := COALESCE (inAccountId_4, 0);
     inContainerId_5      := COALESCE (inContainerId_5, 0);
     inAccountId_5        := COALESCE (inAccountId_5, 0);


     -- !!!определяется КЛЮЧ!!!
     vbKeyValue = (SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                         FROM     (SELECT zc_Enum_AccountKind_Passive()      AS Value, 0 AS myOrder1, -1 AS myOrder2
                         UNION ALL SELECT COALESCE (inPassiveContainerId, 0) AS Value, 1 AS myOrder1, -1 AS myOrder2
                         UNION ALL SELECT zc_Enum_AccountKind_Active()       AS Value, 0 AS myOrder1, -2 AS myOrder2
                         UNION ALL SELECT COALESCE (inActiveContainerId, 0)  AS Value, 1 AS myOrder1, -2 AS myOrder2

                         UNION ALL SELECT COALESCE (inAccountKindId_1, 0)    AS Value, 0 AS myOrder1, COALESCE (inAccountKindId_1, 1000000001)  AS myOrder2
                         UNION ALL SELECT COALESCE (inContainerId_1, 0)      AS Value, 1 AS myOrder1, COALESCE (inAccountKindId_1, 1000000001)  AS myOrder2
                         UNION ALL SELECT COALESCE (inAccountKindId_2, 0)    AS Value, 0 AS myOrder1, COALESCE (inAccountKindId_2, 1000000002)  AS myOrder2
                         UNION ALL SELECT COALESCE (inContainerId_2, 0)      AS Value, 1 AS myOrder1, COALESCE (inAccountKindId_2, 1000000002)  AS myOrder2
                         UNION ALL SELECT COALESCE (inAccountKindId_3, 0)    AS Value, 0 AS myOrder1, COALESCE (inAccountKindId_3, 1000000003)  AS myOrder2
                         UNION ALL SELECT COALESCE (inContainerId_3, 0)      AS Value, 1 AS myOrder1, COALESCE (inAccountKindId_3, 1000000003)  AS myOrder2
                         UNION ALL SELECT COALESCE (inAccountKindId_4, 0)    AS Value, 0 AS myOrder1, COALESCE (inAccountKindId_4, 1000000004)  AS myOrder2
                         UNION ALL SELECT COALESCE (inContainerId_4, 0)      AS Value, 1 AS myOrder1, COALESCE (inAccountKindId_4, 1000000004)  AS myOrder2
                         UNION ALL SELECT COALESCE (inAccountKindId_5, 0)    AS Value, 0 AS myOrder1, COALESCE (inAccountKindId_5, 1000000005)  AS myOrder2
                         UNION ALL SELECT COALESCE (inContainerId_5, 0)      AS Value, 1 AS myOrder1, COALESCE (inAccountKindId_5, 1000000005)  AS myOrder2
                                  ) AS tmp
                         ORDER BY tmp.myOrder2, tmp.myOrder1
                        ) AS tmp
                  );
     -- !!!определяется еще первый КЛЮЧ!!!
     vbMasterKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 1 FOR 8));
     -- !!!определяется еще второй КЛЮЧ!!!
     vbChildKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 9 FOR 8));


     BEGIN
     -- !!!находим СРАЗУ по ключу!!!
     -- vbChildReportContainerId := (SELECT MAX (ChildReportContainerId) FROM ChildReportContainerLink WHERE KeyValue = vbKeyValue);

     -- !!!находим СРАЗУ по ДВУМ ключам!!!
     vbChildReportContainerId := (SELECT MAX (ChildReportContainerId) FROM ChildReportContainerLink WHERE MasterKeyValue = vbMasterKeyValue AND ChildKeyValue = vbChildKeyValue);

/*
     -- Если не нашли, находим по старому алгоритму
     IF COALESCE (vbObjectCostId, 0) = 0
     THEN

     -- находим
     IF inAccountKindId_5 IS NOT NULL
     THEN
         vbChildReportContainerId:=(SELECT ChildReportContainerLink_Active.ChildReportContainerId
                                    FROM ChildReportContainerLink AS ChildReportContainerLink_Active
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Passive
                                                                       ON ChildReportContainerLink_Passive.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                                      AND ChildReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_1
                                                                       ON ChildReportContainerLink_1.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_1.ContainerId = inContainerId_1
                                                                      AND ChildReportContainerLink_1.AccountKindId = inAccountKindId_1
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_2
                                                                       ON ChildReportContainerLink_2.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_2.ContainerId = inContainerId_2
                                                                      AND ChildReportContainerLink_2.AccountKindId = inAccountKindId_2
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_3
                                                                       ON ChildReportContainerLink_3.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_3.ContainerId = inContainerId_3
                                                                      AND ChildReportContainerLink_3.AccountKindId = inAccountKindId_3
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_4
                                                                       ON ChildReportContainerLink_4.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_4.ContainerId = inContainerId_4
                                                                      AND ChildReportContainerLink_4.AccountKindId = inAccountKindId_4
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_5
                                                                       ON ChildReportContainerLink_5.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_5.ContainerId = inContainerId_5
                                                                      AND ChildReportContainerLink_5.AccountKindId = inAccountKindId_5
                                    WHERE ChildReportContainerLink_Active.ContainerId = inActiveContainerId
                                      AND ChildReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                                   );
     ELSE
     IF inAccountKindId_4 IS NOT NULL
     THEN
         vbChildReportContainerId:=(SELECT ChildReportContainerLink_Active.ChildReportContainerId
                                    FROM ChildReportContainerLink AS ChildReportContainerLink_Active
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Passive
                                                                       ON ChildReportContainerLink_Passive.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                                      AND ChildReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_1
                                                                       ON ChildReportContainerLink_1.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_1.ContainerId = inContainerId_1
                                                                      AND ChildReportContainerLink_1.AccountKindId = inAccountKindId_1
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_2
                                                                       ON ChildReportContainerLink_2.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_2.ContainerId = inContainerId_2
                                                                      AND ChildReportContainerLink_2.AccountKindId = inAccountKindId_2
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_3
                                                                       ON ChildReportContainerLink_3.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_3.ContainerId = inContainerId_3
                                                                      AND ChildReportContainerLink_3.AccountKindId = inAccountKindId_3
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_4
                                                                       ON ChildReportContainerLink_4.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_4.ContainerId = inContainerId_4
                                                                      AND ChildReportContainerLink_4.AccountKindId = inAccountKindId_4
                                    WHERE ChildReportContainerLink_Active.ContainerId = inActiveContainerId
                                      AND ChildReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                                   );
     ELSE
     IF inAccountKindId_3 IS NOT NULL
     THEN
         vbChildReportContainerId:=(SELECT ChildReportContainerLink_Active.ChildReportContainerId
                                    FROM ChildReportContainerLink AS ChildReportContainerLink_Active
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Passive
                                                                       ON ChildReportContainerLink_Passive.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                                      AND ChildReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_1
                                                                       ON ChildReportContainerLink_1.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_1.ContainerId = inContainerId_1
                                                                      AND ChildReportContainerLink_1.AccountKindId = inAccountKindId_1
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_2
                                                                       ON ChildReportContainerLink_2.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_2.ContainerId = inContainerId_2
                                                                      AND ChildReportContainerLink_2.AccountKindId = inAccountKindId_2
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_3
                                                                       ON ChildReportContainerLink_3.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_3.ContainerId = inContainerId_3
                                                                      AND ChildReportContainerLink_3.AccountKindId = inAccountKindId_3
                                    WHERE ChildReportContainerLink_Active.ContainerId = inActiveContainerId
                                      AND ChildReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                                   );
     ELSE
     IF inAccountKindId_2 IS NOT NULL
     THEN
         vbChildReportContainerId:=(SELECT ChildReportContainerLink_Active.ChildReportContainerId
                                    FROM ChildReportContainerLink AS ChildReportContainerLink_Active
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Passive
                                                                       ON ChildReportContainerLink_Passive.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                                      AND ChildReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_1
                                                                       ON ChildReportContainerLink_1.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_1.ContainerId = inContainerId_1
                                                                      AND ChildReportContainerLink_1.AccountKindId = inAccountKindId_1
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_2
                                                                       ON ChildReportContainerLink_2.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_2.ContainerId = inContainerId_2
                                                                      AND ChildReportContainerLink_2.AccountKindId = inAccountKindId_2
                                    WHERE ChildReportContainerLink_Active.ContainerId = inActiveContainerId
                                      AND ChildReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                                   );
     ELSE
     IF inAccountKindId_1 IS NOT NULL
     THEN
         vbChildReportContainerId:=(SELECT ChildReportContainerLink_1.ChildReportContainerId
                                    FROM ChildReportContainerLink AS ChildReportContainerLink_1
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Active
                                                                       ON ChildReportContainerLink_Active.ChildReportContainerId = ChildReportContainerLink_1.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Active.ContainerId = inActiveContainerId
                                                                      AND ChildReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Passive
                                                                       ON ChildReportContainerLink_Passive.ChildReportContainerId = ChildReportContainerLink_1.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                                      AND ChildReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                                    WHERE ChildReportContainerLink_1.ContainerId = inContainerId_1
                                      AND ChildReportContainerLink_1.AccountKindId = inAccountKindId_1
                                   );
     ELSE
         vbChildReportContainerId:=(SELECT ChildReportContainerLink_Active.ChildReportContainerId
                                    FROM ChildReportContainerLink AS ChildReportContainerLink_Active
                                         JOIN ChildReportContainerLink AS ChildReportContainerLink_Passive
                                                                       ON ChildReportContainerLink_Passive.ChildReportContainerId = ChildReportContainerLink_Active.ChildReportContainerId
                                                                      AND ChildReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                                      AND ChildReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                                    WHERE ChildReportContainerLink_Active.ContainerId = inActiveContainerId
                                      AND ChildReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                                   );
     END IF; -- 1
     END IF; -- 2
     END IF; -- 3
     END IF; -- 4
     END IF; -- 5
     END IF; -- if Если не нашли, находим по старому алгоритму

*/

     EXCEPTION
              WHEN invalid_row_count_in_limit_clause
              THEN RAISE EXCEPTION 'Невозможно cформировать аналитику у проводки для отчета с пустым счетом : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inAccountKindId_1, inContainerId_1, inAccountId_1, inAccountKindId_2, inContainerId_2, inAccountId_2;
     END;


     -- Если не нашли, добавляем
     IF COALESCE (vbChildReportContainerId, 0) = 0
     THEN
         -- определяем новый ChildReportContainerId
         SELECT NEXTVAL ('childreportcontainer_id_seq') INTO vbChildReportContainerId;

         -- добавили Аналитики
         INSERT INTO ChildReportContainerLink (ChildReportContainerId, AccountKindId, ContainerId, AccountId, KeyValue, MasterKeyValue, ChildKeyValue)
            SELECT vbChildReportContainerId, zc_Enum_AccountKind_Active(), inActiveContainerId, inActiveAccountId, vbKeyValue, vbMasterKeyValue, vbChildKeyValue
           UNION ALL
            SELECT vbChildReportContainerId, zc_Enum_AccountKind_Passive(), inPassiveContainerId, inPassiveAccountId, vbKeyValue, vbMasterKeyValue, vbChildKeyValue
           UNION ALL
            SELECT vbChildReportContainerId, inAccountKindId_1, inContainerId_1, inAccountId_1, '', 0, 0 WHERE inAccountKindId_1 IS NOT NULL
           UNION ALL
            SELECT vbChildReportContainerId, inAccountKindId_2, inContainerId_2, inAccountId_2, '', 0, 0 WHERE inAccountKindId_2 IS NOT NULL
           UNION ALL
            SELECT vbChildReportContainerId, inAccountKindId_3, inContainerId_3, inAccountId_3, '', 0, 0 WHERE inAccountKindId_3 IS NOT NULL
           UNION ALL
            SELECT vbChildReportContainerId, inAccountKindId_4, inContainerId_4, inAccountId_4, '', 0, 0 WHERE inAccountKindId_4 IS NOT NULL
           UNION ALL
            SELECT vbChildReportContainerId, inAccountKindId_5, inContainerId_5, inAccountId_5, '', 0, 0 WHERE inAccountKindId_5 IS NOT NULL
          ;

     END IF;  

     -- Возвращаем значение
     RETURN (vbChildReportContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_ChildReportContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.14                                        * ALL
 12.01.14                                        * optimize2
 19.09.13                                        * optimize
 29.08.13                                        *
*/

-- тест
/*
CREATE TEMP TABLE _tmpChildReportContainer (isActive Boolean, ContainerId Integer) ON COMMIT DROP;
SELECT * FROM lpInsertFind_ChildReportContainer (inContainerId_Active  := 1
                                          , inContainerId_Passive := 2
                                          , inIsActive_1          := TRUE
                                          , inContainerId_1       := 3
                                           )
*/

/*
-- !!!!!!!!!!!!!!!!!!!!!
-- !!!update KeyValue!!!
-- !!!!!!!!!!!!!!!!!!!!!

select  co, tmp.KeyValue, ChildReportContainerLink.KeyValue, ChildReportContainerLink.*

-- update ChildReportContainerLink set KeyValue = tmp.KeyValue
from (
SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
 || case count(*) when 2 then ';0,0;0,0;0,0;0,0;0,0;0,0'
                  when 4 then ';0,0;0,0;0,0;0,0;0,0'
                  when 6 then ';0,0;0,0;0,0;0,0'
                  when 8 then ';0,0;0,0;0,0'
                  when 10 then ';0,0;0,0'
                  when 12 then ';0,0'
                          else ''
    end 
    as KeyValue

, tmp.ChildReportContainerId, count(*) as co
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                              , tmp.ChildReportContainerId
                         FROM     (SELECT Value, myOrder1, myOrder2, ChildReportContainerId FROM (SELECT zc_Enum_AccountKind_Passive() AS Value, 0 AS myOrder1, -1 AS myOrder2, ChildReportContainerId FROM ChildReportContainerLink where AccountKindId = zc_Enum_AccountKind_Passive() group by ContainerId, ChildReportContainerId) as tmp
                         UNION ALL SELECT Value, myOrder1, myOrder2, ChildReportContainerId FROM (SELECT ContainerId                   AS Value, 1 AS myOrder1, -1 AS myOrder2, ChildReportContainerId FROM ChildReportContainerLink where AccountKindId = zc_Enum_AccountKind_Passive() group by ContainerId, ChildReportContainerId) as tmp
                         UNION ALL SELECT Value, myOrder1, myOrder2, ChildReportContainerId FROM (SELECT zc_Enum_AccountKind_Active()  AS Value, 0 AS myOrder1, -2 AS myOrder2, ChildReportContainerId FROM ChildReportContainerLink where AccountKindId = zc_Enum_AccountKind_Active()  group by ContainerId, ChildReportContainerId) as tmp
                         UNION ALL SELECT Value, myOrder1, myOrder2, ChildReportContainerId FROM (SELECT ContainerId                   AS Value, 1 AS myOrder1, -2 AS myOrder2, ChildReportContainerId FROM ChildReportContainerLink where AccountKindId = zc_Enum_AccountKind_Active()  group by ContainerId, ChildReportContainerId) as tmp
                         UNION ALL SELECT COALESCE (AccountKindId, 0) AS Value, 0 AS myOrder1, AccountKindId AS myOrder2, ChildReportContainerId FROM ChildReportContainerLink where AccountKindId NOT IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
                         UNION ALL SELECT COALESCE (ContainerId, 0)   AS Value, 1 AS myOrder1, AccountKindId AS myOrder2, ChildReportContainerId FROM ChildReportContainerLink where AccountKindId NOT IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
                                  ) AS tmp
                         ORDER BY ChildReportContainerId, tmp.myOrder2, tmp.myOrder1
                        ) as tmp
group by tmp.ChildReportContainerId
) as tmp

 where ChildReportContainerLink.ChildReportContainerId = tmp.ChildReportContainerId  -- !!!update
   and ChildReportContainerLink.AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive()) -- !!!update

 left join ChildReportContainerLink on ChildReportContainerLink.ChildReportContainerId = tmp.ChildReportContainerId
                                   and ChildReportContainerLink.AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
 where coalesce (ChildReportContainerLink.KeyValue, '') <> tmp.KeyValue


-- select * from ChildReportContainerLink where coalesce (KeyValue, '') = ''
-- select KeyValue from (select ChildReportContainerId, KeyValue from ChildReportContainerLink group by ChildReportContainerId, KeyValue) as tmp group by KeyValue having count (*) > 1


-- update ChildReportContainerLink set MasterKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 1 FOR 8)), ChildKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 9 FOR 8)) where AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
-- select * from ChildReportContainerLink where (coalesce (MasterKeyValue, 0) = 0 or coalesce (ChildKeyValue, 0) = 0) and AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive())
-- select MasterKeyValue, ChildKeyValue from (select ChildReportContainerId, MasterKeyValue, ChildKeyValue from ChildReportContainerLink where AccountKindId IN (zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_Passive()) group by ChildReportContainerId, MasterKeyValue, ChildKeyValue) as tmp group by MasterKeyValue, ChildKeyValue having count (*) > 1
*/
