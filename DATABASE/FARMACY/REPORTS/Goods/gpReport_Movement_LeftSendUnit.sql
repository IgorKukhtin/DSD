-- Function: gpReport_Movement_LeftSendUnit()

DROP FUNCTION IF EXISTS gpReport_Movement_LeftSendUnit (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_LeftSendUnit(
    IN inOperDate      TDateTime , --
    IN inUnitID        Integer , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, ReturnRate TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- 1. Все что перемещалось
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpwassent'))
     THEN
       DELETE FROM _tmpWasSent;
     ELSE
       CREATE TEMP TABLE _tmpWasSent (GuudsId Integer, Amount TFloat ) ON COMMIT DROP;
     END IF;

     --2. Получаем все что перемещалось
     INSERT INTO _tmpWasSent (GuudsId, Amount)
     SELECT MovementItem.ObjectId, SUM(MovementItem.Amount)
     FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                       AND MovementLinkObject_From.ObjectId = inUnitID

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                    ON MovementBoolean_VIP.MovementId = Movement.Id
                                   AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE

     WHERE Movement.OperDate BETWEEN inOperDate - INTERVAL '7 DAY' AND inOperDate
       AND Movement.DescId = zc_Movement_Send()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND COALESCE (MovementBoolean_isAuto.ValueData, FALSE) = FALSE
       AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = FALSE
     GROUP BY MovementItem.ObjectId;

     -- 3. Все что получили
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpwasgot'))
     THEN
       DELETE FROM _tmpWasGot;
     ELSE
       CREATE TEMP TABLE _tmpWasGot (Id Integer, GuudsId Integer, Amount TFloat, AmountReturn  TFloat) ON COMMIT DROP;
     END IF;

     --4. Получаем все что получили
     INSERT INTO _tmpWasGot (ID, GuudsId, Amount, AmountReturn)
     SELECT Movement.ID, MovementItem.ObjectId, SUM(MovementItem.Amount), 0
     FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                       AND MovementLinkObject_To.ObjectId = inUnitID

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                    ON MovementBoolean_VIP.MovementId = Movement.Id
                                   AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE

     WHERE Movement.OperDate BETWEEN inOperDate AND inOperDate + INTERVAL '30 DAY'
       AND Movement.DescId = zc_Movement_Send()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND COALESCE (MovementBoolean_isAuto.ValueData, FALSE) = FALSE
       AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = FALSE
     GROUP BY Movement.ID, MovementItem.ObjectId;

     --4. Прописуем камбэк

     UPDATE _tmpWasGot SET AmountReturn = CASE WHEN _tmpWasGot.Amount > _tmpWasGot.Amount THEN _tmpWasGot.Amount ELSE _tmpWasGot.Amount END
     FROM _tmpWasSent
     WHERE _tmpWasGot.GuudsId = _tmpWasSent.GuudsId;

/*raise notice 'Value 05: % % %', (SELECT COUNT(*) FROM _tmpWasSent)
                              , (SELECT COUNT(*) FROM _tmpWasGot)
                              , (SELECT COUNT(*) FROM _tmpWasGot WHERE _tmpWasGot.AmountReturn > 0) ;
*/
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpresult'))
     THEN
         WITH tmpData AS (SELECT _tmpWasGot.ID
                               , SUM(_tmpWasGot.Amount)         AS Amount
                               , SUM(_tmpWasGot.AmountReturn)   AS AmountReturn
                          FROM _tmpWasGot
                          GROUP BY _tmpWasGot.ID
                          HAVING SUM(_tmpWasGot.AmountReturn) > 0 AND SUM(_tmpWasGot.Amount) > 0)

         INSERT INTO _tmpResult (ID, ReturnRate)
         SELECT tmpData.Id
              , (tmpData.AmountReturn / tmpData.Amount * 100)::TFloat     AS ReturnRate
         FROM tmpData
         WHERE (tmpData.AmountReturn / tmpData.Amount * 100) >= 80;
     ELSE
       -- Результат
       RETURN QUERY
         WITH tmpData AS (SELECT _tmpWasGot.ID
                               , SUM(_tmpWasGot.Amount)         AS Amount
                               , SUM(_tmpWasGot.AmountReturn)   AS AmountReturn
                          FROM _tmpWasGot
                          GROUP BY _tmpWasGot.ID
                          HAVING SUM(_tmpWasGot.AmountReturn) > 0 AND SUM(_tmpWasGot.Amount) > 0)

         SELECT tmpData.Id
              , (tmpData.AmountReturn / tmpData.Amount * 100)::TFloat     AS ReturnRate
         FROM tmpData
         WHERE (tmpData.AmountReturn / tmpData.Amount * 100) >= 80;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_LeftSendUnit (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.08.20                                                       *
*/

-- тест
-- SELECT * FROM gpReport_Movement_LeftSendUnit (inOperDate:= '19.06.2020', inUnitID := 12607257, inSession:= '3')