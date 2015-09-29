DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportSoldParams (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportSoldParams(
 INOUT ioId             Integer,    -- ИД плана
    IN inUnitId         Integer,   -- ИД подразделения
 INOUT ioPlanDate       TDateTime, -- Месяц плана
    IN inPlanAmount     TFloat,    -- Сумма плана
    IN inSession        TVarChar   -- Сессия
)
AS
$BODY$
    DECLARE vbPlanAmount TFloat;
    DECLARE vbUserId Integer;
BEGIN
    -- Определяем пользователя
    vbUserId := inSession;
    -- Приводим дату к началу месяца
    ioPlanDate := date_trunc('month', ioPlanDate);
    -- Если такая запись есть - достаем её ключу подр.-дата
    SELECT
        Id, 
        PlanAmount
    INTO 
        ioId, 
        vbPlanAmount
    FROM 
        Object_ReportSoldParams_View
    WHERE
        UnitId = inUnitId
        AND
        PlanDate = ioPlanDate;
    IF COALESCE(ioId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportSoldParams(), 0, '');

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportSoldParams_Unit(), ioId, inUnitId);
        
        --сохранили месяц плана
        PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ReportSoldParams_PlanDate(), ioId, ioPlanDate);
    END IF;
  
    IF (vbPlanAmount is null or vbPlanAmount <> inPlanAmount)
    THEN
        -- сохранили св-во < Сумма плана >
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_ReportSoldParams_PlanAmount(), ioId, inPlanAmount);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReportSoldParams (Integer, Integer, TDateTime, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 27.09.15                                                                      *
 */