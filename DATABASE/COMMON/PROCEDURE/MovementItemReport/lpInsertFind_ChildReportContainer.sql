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
BEGIN

     -- удаляем предыдущие
     DELETE FROM _tmpChildReportContainer;

     -- заполняем
     INSERT INTO _tmpChildReportContainer (AccountKindId, ContainerId, AccountId)
        SELECT zc_Enum_AccountKind_Active(), COALESCE (inActiveContainerId, 0), COALESCE (inActiveAccountId, 0)
       UNION ALL
        SELECT zc_Enum_AccountKind_Passive(), COALESCE (inPassiveContainerId, 0), COALESCE (inPassiveAccountId, 0)
       UNION ALL
        SELECT inAccountKindId_1, COALESCE (inContainerId_1, 0), COALESCE (inAccountId_1, 0) WHERE inAccountKindId_1 IS NOT NULL
       UNION ALL
        SELECT inAccountKindId_2, COALESCE (inContainerId_2, 0), COALESCE (inAccountId_2, 0) WHERE inAccountKindId_2 IS NOT NULL
       UNION ALL
        SELECT inAccountKindId_3, COALESCE (inContainerId_3, 0), COALESCE (inAccountId_3, 0) WHERE inAccountKindId_3 IS NOT NULL
       UNION ALL
        SELECT inAccountKindId_4, COALESCE (inContainerId_4, 0), COALESCE (inAccountId_4, 0) WHERE inAccountKindId_4 IS NOT NULL
       UNION ALL
        SELECT inAccountKindId_5, COALESCE (inContainerId_5, 0), COALESCE (inAccountId_5, 0) WHERE inAccountKindId_5 IS NOT NULL
        ;

     -- Проверка
     IF EXISTS (SELECT ContainerId FROM _tmpChildReportContainer WHERE ContainerId = 0 OR AccountId = 0)
     THEN
         RAISE EXCEPTION 'Невозможно cформировать аналитику у проводки для отчета с пустым счетом : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inAccountKindId_1, inContainerId_1, inAccountId_1, inAccountKindId_2, inContainerId_2, inAccountId_2;
     END IF;

     -- определяем количество Аналитик
     SELECT COUNT(*) INTO vbRecordCount FROM _tmpChildReportContainer;

     -- находим
     vbChildReportContainerId:=(SELECT ChildReportContainerLink.ChildReportContainerId
                                FROM _tmpChildReportContainer
                                     JOIN ChildReportContainerLink ON ChildReportContainerLink.ContainerId = _tmpChildReportContainer.ContainerId
                                                                  AND ChildReportContainerLink.AccountKindId = _tmpChildReportContainer.AccountKindId
                                GROUP BY ChildReportContainerLink.ChildReportContainerId
                                HAVING COUNT(*) = vbRecordCount);

     -- Если не нашли, добавляем
     IF COALESCE (vbChildReportContainerId, 0) = 0
     THEN
         -- определяем новый ReportContainerId
         SELECT NEXTVAL ('childreportcontainer_id_seq') INTO vbChildReportContainerId;

         -- добавили Аналитики
         INSERT INTO ChildReportContainerLink (ChildReportContainerId, ContainerId, AccountId, AccountKindId)
            SELECT vbChildReportContainerId, ContainerId, AccountId, AccountKindId FROM _tmpChildReportContainer;

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
