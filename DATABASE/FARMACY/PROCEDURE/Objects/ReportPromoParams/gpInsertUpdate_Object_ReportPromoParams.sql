-- Function: gpinsertupdate_object_reportpromoparams(integer, integer, tdatetime, tfloat, tvarchar)

 DROP FUNCTION gpinsertupdate_object_reportpromoparams(integer, integer, tdatetime, tfloat, tvarchar);

CREATE OR REPLACE FUNCTION gpinsertupdate_object_reportpromoparams(
    INOUT ioid           integer,
    IN    inunitid       integer,
    INOUT ioplandate     tdatetime,
    IN    inplanamount   tfloat,
    IN    insession      tvarchar
)
  RETURNS record AS
$BODY$
    DECLARE vbPlanAmount TFloat;
    DECLARE vbUserId Integer;
BEGIN
    -- Определяем пользователя
    vbUserId := inSession;
    -- Приводим дату к началу месяца
    ioPlanDate := date_trunc('month', ioPlanDate);

    -- Если такая запись есть - достаем её по ключу подр.-дата
    SELECT Id, PlanAmount
    INTO ioId, vbPlanAmount
    FROM Object_ReportPromoParams_View
    WHERE UnitId = inUnitId
      AND PlanDate = ioPlanDate;

    IF COALESCE(ioId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportPromoParams(), 0, '');

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportPromoParams_Unit(), ioId, inUnitId);
        
        --сохранили месяц плана
        PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ReportPromoParams_PlanDate(), ioId, ioPlanDate);
    END IF;
  
    IF (vbPlanAmount is null or vbPlanAmount <> inPlanAmount)
    THEN
        -- сохранили св-во < Сумма плана >
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_ReportPromoParams_PlanAmount(), ioId, inPlanAmount);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 09.01.17         *
 */