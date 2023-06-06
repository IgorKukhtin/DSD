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

    --
    -- IF EXTRACT (MONTH FROM inStartDate) IN (2, 3) THEN RETURN; END IF;

    -- Пересчет
 -- PERFORM lpUpdate_Movement_ProductionUnion_Kopchenie (inIsUpdate  := TRUE
    PERFORM lpUpdate_Movement_ProductionUnion_KopchenieAll (inIsUpdate  := TRUE
                                                          , inStartDate := inStartDate
                                                          , inEndDate   := inEndDate
                                                          , inUnitId    := inUnitId
                                                          , inUserId    := zc_Enum_Process_Auto_Kopchenie()
                                                           );


    -- !!!Удалили, временно пока Пересчет Send здесь!!!
    /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult'))      THEN DROP TABLE _tmpResult; END IF;
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_pr'))     THEN DROP TABLE _tmpItem_pr; END IF;
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItemSumm_pr')) THEN DROP TABLE _tmpItemSumm_pr; END IF;

    -- Пересчет, !!!Временно здесь, потом надо будет независимо!!!
    PERFORM lpUpdate_Movement_Send_DocumentKind (inIsUpdate  := TRUE
                                               , inStartDate := inStartDate
                                               , inEndDate   := inEndDate
                                               , inUnitId    := 0
                                               , inUserId    := zc_Enum_Process_Auto_Send()
                                                );*/

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Kopchenie (inStartDate:= '30.11.2015', inEndDate:= '30.11.2015', inUnitId:= 8450, inSession:= zfCalc_UserAdmin() :: TvarChar) -- ЦЕХ копчения
