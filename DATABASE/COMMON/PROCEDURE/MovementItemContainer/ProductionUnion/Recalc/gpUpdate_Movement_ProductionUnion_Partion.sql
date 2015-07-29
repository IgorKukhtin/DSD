-- Function: gpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Partion(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inFromId       Integer,    -- 
    IN inToId         Integer,    -- 
    IN inSession      TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Partion());

   -- Пересчет
   PERFORM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate  := TRUE
                                                 , inStartDate := inStartDate
                                                 , inEndDate   := inEndDate
                                                 , inFromId    := inFromId
                                                 , inToId      := inToId
                                                 , inUserId    := zc_Enum_Process_Auto_PartionClose() -- vbUserId
                                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Partion (inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inFromId:= 8448, inToId:=8458 , inUserId:= zfCalc_UserAdmin()) -- ЦЕХ деликатесов + Склад База ГП
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Partion (inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inFromId:= 8447, inToId:=8458 , inUserId:= zfCalc_UserAdmin()) -- ЦЕХ колбасный   + Склад База ГП
