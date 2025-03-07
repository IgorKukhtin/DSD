-- Function: gpUpdate_Movement_ProductionUnion_Defroster (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Defroster (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Defroster(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inSession      TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Defroster());


   -- Пересчет
   PERFORM lpUpdate_Movement_ProductionUnion_Defroster (inIsUpdate  := TRUE
                                                      , inStartDate := inStartDate
                                                      , inEndDate   := inEndDate
                                                      , inUnitId    := inUnitId
                                                      , inUserId    := vbUserId
                                                       );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Defroster (inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inUnitId:= 8440, inUserId:= zfCalc_UserAdmin()) -- Дефростер

