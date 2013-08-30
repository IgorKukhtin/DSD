-- Function: lpInsertFind_ReportContainer (Integer, Integer, Boolean, Integer, Boolean, Integer, Boolean, Integer, Boolean, Integer)

-- DROP FUNCTION lpInsertFind_ReportContainer (Integer, Integer, Boolean, Integer, Boolean, Integer, Boolean, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_ReportContainer(
    IN inContainerId_Active  Integer              , -- 
    IN inContainerId_Passive Integer              , -- 
    IN inIsActive_1          Boolean DEFAULT NULL , -- 
    IN incontainerid_1       Integer DEFAULT NULL , -- 
    IN inisactive_2          Boolean DEFAULT NULL , -- 
    IN incontainerid_2       Integer DEFAULT NULL , -- 
    IN inisactive_3          Boolean DEFAULT NULL , -- 
    IN incontainerid_3       Integer DEFAULT NULL , -- 
    IN inisactive_4          Boolean DEFAULT NULL , -- 
    IN incontainerid_4       Integer DEFAULT NULL   -- 
)
  RETURNS Integer AS
$BODY$
  DECLARE vbReportContainerId Integer;
  DECLARE vbRecordCount Integer;
BEGIN

     -- удаляем предыдущие
     DELETE FROM _tmpReportContainer;

     -- заполняем
     INSERT INTO _tmpReportContainer (isActive, ContainerId)
        SELECT TRUE, COALESCE (inContainerId_Active, 0)
       UNION ALL
        SELECT FALSE, COALESCE (inContainerId_Passive, 0)
       UNION ALL
        SELECT inIsActive_1, COALESCE (inContainerId_1, 0) WHERE inIsActive_1 IS NOT NULL
       UNION ALL
        SELECT inIsActive_2, COALESCE (inContainerId_2, 0) WHERE inIsActive_2 IS NOT NULL
       UNION ALL
        SELECT inIsActive_3, COALESCE (inContainerId_3, 0) WHERE inIsActive_3 IS NOT NULL
       UNION ALL
        SELECT inIsActive_4, COALESCE (inContainerId_4, 0) WHERE inIsActive_4 IS NOT NULL
        ;

     -- Проверка
     IF EXISTS (SELECT ContainerId FROM _tmpReportContainer WHERE ContainerId = 0)
     THEN
         RAISE EXCEPTION 'Невозможно cформировать аналитику у проводки для отчета с ContainerId=0 : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inContainerId_Active, inContainerId_Passive, inIsActive_1, inContainerId_1, inIsActive_2, inContainerId_2, inIsActive_3, inContainerId_3, inIsActive_4, inContainerId_4;
     END IF;

     -- определяем количество Аналитик
     SELECT COUNT(*) INTO vbRecordCount FROM _tmpReportContainer;

     -- находим
     vbReportContainerId:=(SELECT ReportContainerLink.ReportContainerId
                           FROM _tmpReportContainer
                                JOIN ReportContainerLink ON ReportContainerLink.isActive = _tmpReportContainer.isActive
                                                        AND ReportContainerLink.ContainerId = _tmpReportContainer.ContainerId
                           GROUP BY ReportContainerLink.ReportContainerId
                           HAVING COUNT(*) = vbRecordCount);

     -- Если не нашли, добавляем
     IF COALESCE (vbReportContainerId, 0) = 0
     THEN
         -- определяем новый ReportContainerId
         SELECT NEXTVAL ('reportcontainer_id_seq') INTO vbReportContainerId;

         -- добавили Аналитики
         INSERT INTO ReportContainerLink (ReportContainerId, ContainerId, isActive)
            SELECT vbReportContainerId, ContainerId, isActive FROM _tmpReportContainer;

     END IF;  

     -- Возвращаем значение
     RETURN (vbReportContainerId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_ReportContainer (Integer, Integer, Boolean, Integer, Boolean, Integer, Boolean, Integer, Boolean, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.13                                        *
*/

-- тест
/*
CREATE TEMP TABLE _tmpReportContainer (isActive Boolean, ContainerId Integer) ON COMMIT DROP;
SELECT * FROM lpInsertFind_ReportContainer (inContainerId_Active  := 1
                                          , inContainerId_Passive := 2
                                          , inIsActive_1          := TRUE
                                          , inContainerId_1       := 3
                                           )
*/
