-- Function: gpCheckDesc_Movement_IncomeCost()

DROP FUNCTION IF EXISTS gpCheckDesc_Movement_IncomeCost (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpCheckDesc_Movement_IncomeCost (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckDesc_Movement_IncomeCost(
    IN inDescId           Integer,
    IN inDescCode_open    TVarChar,
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS VOID

AS
$BODY$
BEGIN

    
    -- проверка деск документа должен соответствовать кнопке открытия документа 
    IF inDescId <> (select Id from MovementDesc where Code = inDescCode_open)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный вид документа.';
    END IF;   

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.01.19         *
*/

--select * from gpCheckDesc_Movement_IncomeCost(inDescId := 25 , inDescCode_open := 'zc_Movement_TransportService()' ,  inSession := '5');

