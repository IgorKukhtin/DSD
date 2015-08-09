-- Function: gpUpdate_Movement_ProductionUnion_Kopchenie (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Kopchenie (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Kopchenie(
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
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Kopchenie());


    -- Пересчет
    PERFORM lpUpdate_Movement_ProductionUnion_Kopchenie (inIsUpdate  := TRUE
                                                       , inStartDate := inStartDate
                                                       , inEndDate   := inEndDate
                                                       , inUnitId    := inUnitId
                                                       , inUserId    := zc_Enum_Process_Auto_Kopchenie()
                                                        );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Kopchenie (inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inUnitId:= 8450, inUserId:= zfCalc_UserAdmin()) -- ЦЕХ копчения
