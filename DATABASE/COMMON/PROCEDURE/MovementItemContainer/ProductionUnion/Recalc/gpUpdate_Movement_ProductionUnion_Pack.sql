-- Function: gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Pack(
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
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Pack());

   IF DATE_TRUNC ('MONTH', inStartDate) < DATE_TRUNC ('MONTH', CURRENT_DATE)
      AND (EXTRACT (DAY FROM inStartDate)  / 2 - FLOOR (EXTRACT (DAY FROM inStartDate)  / 2)
        <> EXTRACT (DAY FROM CURRENT_DATE) / 2 - FLOOR (EXTRACT (DAY FROM CURRENT_DATE) / 2)
      --OR EXTRACT (DAY FROM inStartDate) < 14
          )
   THEN
       RETURN;
   END IF;

   -- Пересчет
   PERFORM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate  := TRUE
                                                 , inStartDate := inStartDate
                                                 , inEndDate   := inEndDate
                                                 , inUnitId    := inUnitId
                                                 , inUserId    := zc_Enum_Process_Auto_Pack() -- vbUserId
                                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Pack (inStartDate:= '01.10.2016', inEndDate:= '01.10.2016', inUnitId:= 8451, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar) -- Цех Упаковки
