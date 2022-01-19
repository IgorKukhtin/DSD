-- Function: gpInsert_Movement_FinalSUA_Auto()

DROP FUNCTION IF EXISTS gpInsert_Movement_FinalSUA_Auto (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_FinalSUA_Auto(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;

  DECLARE vbUnitName TVarChar;
  DECLARE vbMovementId Integer;
	
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_FinalSUA());
    vbUserId := inSession;
    
    vbOperDate := CURRENT_DATE + ((8 - date_part('DOW', CURRENT_DATE)::Integer)::TVarChar||' DAY')::INTERVAL;

    IF EXISTS(SELECT Movement.id
              FROM Movement 
              WHERE Movement.OperDate = vbOperDate  
                AND Movement.DescId = zc_Movement_FinalSUA() 
                AND Movement.StatusId <> zc_Enum_Status_Erased()
              )
    THEN 
      RETURN;
    END IF;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpCalculation'))
     THEN
       DROP TABLE tmpCalculation;
     END IF;
    
    CREATE TEMP TABLE tmpCalculation ON COMMIT DROP AS
    SELECT Calculation.*
    FROM gpGet_AutoCalculation_SAUA(inSession := inSession) AS Get
         LEFT JOIN gpSelect_Calculation_SAUA(inDateStart         := Get.DateStart
                                           , inDateEnd           := Get.DateEnd
                                           , inRecipientList     := Get.UnitRecipient
                                           , inAssortmentList    := Get.UnitAssortment
                                           , inThreshold         := Get.Threshold
                                           , inDaysStock         := Get.DaysStock
                                           , inCountPharmacies   := Get.CountPharmacies
                                           , inisGoodsClose      := Get.isGoodsClose
                                           , inisMCSIsClose      := Get.isMCSIsClose
                                           , inisNotCheckNoMCS   := Get.isNotCheckNoMCS
                                           , inisMCSValue        := False 
                                           , inThresholdMCS      := 0 
                                           , inThresholdMCSLarge := 0 
                                           , inisRemains         := False
                                           , inThresholdRemains  := 0 
                                           , inThresholdRemainsLarge := 0 
                                           , inisAssortmentRound := Get.isAssortmentRound
                                           , inisNeedRound       := Get.isNeedRound 
                                           , inUnitFromId        := 0
                                           , inSession           := inSession) AS Calculation ON 1 = 1;    

    IF NOT EXISTS(SELECT * FROM tmpCalculation)        
    THEN 
      RETURN;
    END IF;
    
    SELECT UnitName
    INTO vbUnitName 
    FROM tmpCalculation
    LIMIT 1;

    vbMovementId := gpInsertUpdate_Movement_FinalSUA(0, CAST (NEXTVAL ('Movement_FinalSUA_seq') AS TVarChar), vbOperDate, vbUnitName, inSession);

    PERFORM lpInsertUpdate_MI_FinalSUA (ioId                 := 0
                                      , inMovementId         := vbMovementId
                                      , inGoodsId            := tmpCalculation.GoodsId
                                      , inUnitId             := tmpCalculation.UnitId
                                      , inAmount             := tmpCalculation.Need
                                      , inUserId             := vbUserId
                                       )
    FROM tmpCalculation
    WHERE tmpCalculation.Need > 0;
    
    PERFORM gpComplete_Movement_FinalSUA (inMovementId:= vbMovementId, inSession:= inSession);
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.05.21                                                       *
 */

-- тест
-- SELECT * FROM gpInsert_Movement_FinalSUA_Auto (inSession:= '3')    