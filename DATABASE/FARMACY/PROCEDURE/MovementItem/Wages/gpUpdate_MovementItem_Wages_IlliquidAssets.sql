-- Function: gpUpdate_MovementItem_Wages_IlliquidAssets()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_IlliquidAssets(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_IlliquidAssets(
    IN inOperDate            TDateTime , -- Дата расчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- Получаем vbMovementId
    SELECT Movement.Id, Movement.StatusId
    INTO vbMovementId, vbStatusId
    FROM Movement
    WHERE Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
      AND Movement.DescId = zc_Movement_Wages();

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ ЗП не найден.';
    END IF;

    PERFORM gpInsertUpdate_MovementItem_Wages_IlliquidAssets (ioId              := T1.Id
                                                            , inMovementId      := vbMovementId
                                                            , inUserId          := T1.UserID
                                                            , inUnitId          := T1.UnitID
                                                            , inIlliquidAssets  := T1.SummaPenalty
                                                            , inSession         := inSession)
    FROM (SELECT COALESCE(MovementItem.id, 0) AS Id, IPE.UnitID, IPE.UserID, ROUND(COALESCE (- IPE.SummaPenalty, 0)) AS SummaPenalty
          FROM gpReport_IlliquidReductionPlanAll(inStartDate := DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY',  
                                                 inProcGoods := 20 , 
                                                 inProcUnit := 10, 
                                                 inPlanAmount := 0, 
                                                 inPenalty := 500, 
                                                 inisPenaltySumInfo := FALSE,
                                                 inPenaltySum := 0, 
                                                 inisPenaltySumInfo := TRUE,
                                                 inSession := inSession) AS IPE
         
               LEFT JOIN MovementItem ON MovementItem.MovementId = vbMovementId
                                     AND MovementItem.ObjectId = IPE.UserID
                                     AND MovementItem.DescId = zc_MI_Master()

               LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                           ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                          AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()
                                           
          WHERE COALESCE (MIFloat_IlliquidAssets.ValueData, 0) <> ROUND(COALESCE (- IPE.SummaPenalty, 0))
            AND COALESCE (IPE.SummaPenalty, 0) > 0
            AND COALESCE (IPE.ManDays, 0) > 0
          ) AS T1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Wages_IlliquidAssets (CURRENT_DATE, inSession:= '3')