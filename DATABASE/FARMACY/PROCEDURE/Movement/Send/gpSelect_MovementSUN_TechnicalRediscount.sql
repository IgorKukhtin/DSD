-- Function: gpSelect_MovementSUN_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpSelect_MovementSUN_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementSUN_TechnicalRediscount(
    IN inMovementID    Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbUnitId        Integer;
  DECLARE vbIsSUN         Boolean;
  DECLARE vbStatusId      Integer;
  DECLARE vbisDeferred    Boolean;
  DECLARE vbNotDisplaySUN Boolean;
  DECLARE vbAmount        TFloat;
  DECLARE vbInsertDate    TDateTime;

  DECLARE vbisAddTR       Boolean;

  DECLARE vbMovementTRId        Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
    vbUserId:= lpGetUserBySession (inSession);

    --определяем
    SELECT Movement.StatusId
         , MovementLinkObject_From.ObjectId                               AS UnitId
         , COALESCE (MovementBoolean_SUN.ValueData, FALSE)::Boolean     AS isSUN
         , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)
         , COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE)
         , DATE_TRUNC ('DAY', MovementDate_Insert.ValueData)
    INTO vbStatusId, vbUnitId, vbIsSUN, vbisDeferred, vbNotDisplaySUN, vbInsertDate
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

          LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

          LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                    ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                   AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    WHERE Movement.Id = inMovementId;

    IF vbIsSUN = FALSE OR vbInsertDate < '25.08.2020' AND inSession <> '3' ---OR inMovementID in (20332711, 20332376, 20332346, 20332680  )
    THEN
      RETURN;
    END IF;

    -- Перемещаеться всего
    SELECT Sum(MovementItem.Amount)
    INTO vbAmount
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;


    IF COALESCE(vbAmount, 0) = 0 AND vbisDeferred = FALSE
    THEN
      vbisAddTR := True;
      IF vbNotDisplaySUN = FALSE
      THEN
         -- сохранили признак
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotDisplaySUN(), inMovementId, TRUE);
      END IF;
      IF vbStatusId <> zc_Enum_Status_Erased() AND 
         NOT EXISTS(SELECT 1
                    FROM Movement
                    
                         INNER JOIN MovementItem AS MovementItem
                                                 ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master() 
                                                      
                         INNER JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                           ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                                          AND MILinkObject_CommentSend.ObjectId = 16978916

                    WHERE Movement.Id = inMovementId)
      THEN
         -- сохранили признак
         PERFORM gpSetErased_Movement_Send(inMovementId, inSession);
      END IF;
    ELSEIF vbStatusId = zc_Enum_Status_Complete() OR vbisDeferred = TRUE
    THEN
      vbisAddTR := True;
    ELSE
      vbisAddTR := FALSE;
    END IF;

    IF vbisAddTR = TRUE
    THEN
      -- Ищем текущий технический переучет СУН
      IF EXISTS(SELECT Movement.Id
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                               ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                              AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
                     LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                               ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                              AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
                     LEFT JOIN MovementBoolean AS MovementBoolean_CorrectionSUN
                                               ON MovementBoolean_CorrectionSUN.MovementId = Movement.Id
                                              AND MovementBoolean_CorrectionSUN.DescId = zc_MovementBoolean_CorrectionSUN()
                WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                  AND MovementLinkObject_Unit.ObjectId = vbUnitId
                  AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = FALSE
                  AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = FALSE
                  AND COALESCE (MovementBoolean_CorrectionSUN.ValueData, False) = FALSE)
      THEN
         SELECT Max(Movement.Id) AS Id
         INTO vbMovementTRId
         FROM Movement
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
              LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                        ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                       AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
              LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                        ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                       AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
              LEFT JOIN MovementBoolean AS MovementBoolean_CorrectionSUN
                                        ON MovementBoolean_CorrectionSUN.MovementId = Movement.Id
                                       AND MovementBoolean_CorrectionSUN.DescId = zc_MovementBoolean_CorrectionSUN()
         WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
           AND Movement.StatusId = zc_Enum_Status_UnComplete()
           AND MovementLinkObject_Unit.ObjectId = vbUnitId
           AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = FALSE
           AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = FALSE
           AND COALESCE (MovementBoolean_CorrectionSUN.ValueData, False) = FALSE;
      ELSE
        vbMovementTRId := 0;
      END IF;

      -- Обнуляем в техническом переучете что ненадо и что в других
      IF EXISTS(SELECT 1
                FROM MovementItem AS MISend

                     INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                                  ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.ID
                                                 AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                     INNER JOIN MovementItem AS MITechnicalRediscount
                                             ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                     INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                      ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                     AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

                WHERE MISend.MovementId = inMovementId
                  AND MISend.DescId = zc_MI_Master()
                  AND (MISend.isErased = FALSE
                    OR MISend.Amount = 0
                    OR MITechnicalRediscount.MovementId <> vbMovementTRId)
                  AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
      THEN
        -- Обнулили
        PERFORM lpInsertUpdate_MovementItem (MITechnicalRediscount.Id, zc_MI_Master(), MITechnicalRediscount.ObjectId, MITechnicalRediscount.MovementId, 0, Null)
        FROM MovementItem AS MISend

             INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                          ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.ID
                                         AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

             INNER JOIN MovementItem AS MITechnicalRediscount
                                     ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

             INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                              ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                             AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

        WHERE MISend.MovementId = inMovementId
          AND MISend.DescId = zc_MI_Master()
          AND MITechnicalRediscount.Amount <> 0
          AND (MISend.isErased = FALSE
            OR MISend.Amount = 0
            OR MITechnicalRediscount.MovementId <> vbMovementTRId)
          AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete();

        -- Грохнули связи на то что в не текущем ТП
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MITechnicalRediscountId(), MISend.ID, 0)
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), MITechnicalRediscount.ID, 0)
              , gpSetErased_MovementItem_TechnicalRediscount_Auto (MITechnicalRediscount.ID, inSession)
        FROM MovementItem AS MISend

             INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                          ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.ID
                                         AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

             INNER JOIN MovementItem AS MITechnicalRediscount
                                     ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

             INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                              ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                             AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

        WHERE MISend.MovementId = inMovementId
          AND MISend.DescId = zc_MI_Master()
          AND MITechnicalRediscount.MovementId <> vbMovementTRId
          AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete();
      END IF;

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpoccupancysun'))
      THEN
        DROP TABLE _tmpOccupancySUN;
      END IF;

      CREATE TEMP TABLE _tmpOccupancySUN ON COMMIT DROP AS
      SELECT * FROM gpSelect_MovementOccupancySUN (inMovementID:= inMovementID, inSession:= inSession);

      IF EXISTS(SELECT 1
            FROM _tmpOccupancySUN AS MISend

                 LEFT JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                             ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.MovementItemId
                                            AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                 LEFT JOIN MovementItem AS MITechnicalRediscount
                                        ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                 LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                  ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                 AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
            WHERE CASE WHEN COALESCE (MISend.CommentTRId, 0) <> 0 AND COALESCE (MISend.AmountDelta, 0) > 0
                       THEN MISend.AmountDelta ELSE 0 END > COALESCE (MITechnicalRediscount.Amount, 0)
              AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
      THEN
        IF COALESCE(vbMovementTRId, 0) = 0
           AND EXISTS(SELECT 1
                      FROM _tmpOccupancySUN AS MISend

                           LEFT JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                                       ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.MovementItemId
                                                      AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                           LEFT JOIN MovementItem AS MITechnicalRediscount
                                                  ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                           LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                            ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                           AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                      WHERE CASE WHEN COALESCE (MISend.CommentTRId, 0) <> 0 AND COALESCE (MISend.AmountDelta, 0) > 0
                                 THEN MISend.AmountDelta ELSE 0 END > COALESCE (MITechnicalRediscount.Amount, 0)
                        AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
        THEN
          vbMovementTRId := lpInsertUpdate_Movement_TechnicalRediscount (ioId               := 0
                                                                       , inInvNumber        := CAST (NEXTVAL ('Movement_TechnicalRediscount_seq') AS TVarChar)
                                                                       , inOperDate         := CURRENT_DATE
                                                                       , inUnitId           := vbUnitId
                                                                       , inComment          := ''
                                                                       , inisRedCheck       := False
                                                                       , inisAdjustment     := False
                                                                       , inUserId           := vbUserId
                                                                         );
        END IF;

        -- Добавили в технический переучет
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MITechnicalRediscountId(), tmpMovementItem.MovementItemId, tmpMovementItem.MITechnicalRediscountId::TFloat)
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), tmpMovementItem.MITechnicalRediscountId, tmpMovementItem.MovementItemId::TFloat)
        FROM (SELECT MISend.MovementItemId
                   , lpInsertUpdate_MovementItem_TechnicalRediscount (
                             ioId           := COALESCE(MITechnicalRediscount.Id, 0)
                           , inMovementId   := vbMovementTRId
                           , inGoodsId      := MISend.GoodsId
                           , inAmount       := CASE WHEN COALESCE (MISend.CommentTRId, 0) <> 0 AND COALESCE (MISend.AmountDelta, 0) > 0 THEN - MISend.AmountDelta ELSE 0 END
                           , inCommentTRID  := COALESCE (MISend.CommentTRId, MILinkObject_CommentTR.ObjectId)
                           , isExplanation  := COALESCE (MIString_Explanation.ValueData , '')
                           , isComment      := 'Коррекция СУН'
                           , inUserId       := vbUserId)                                  AS MITechnicalRediscountId
              FROM _tmpOccupancySUN AS MISend

                   LEFT JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                               ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.MovementItemId
                                              AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                   LEFT JOIN MovementItem AS MITechnicalRediscount
                                          ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                   LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                    ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                   AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

                   LEFT JOIN MovementItemString AS MIString_Explanation
                                                ON MIString_Explanation.MovementItemId = MITechnicalRediscount.Id
                                               AND MIString_Explanation.DescId = zc_MIString_Explanation()

              WHERE CASE WHEN COALESCE (MISend.CommentTRId, 0) <> 0 AND COALESCE (MISend.AmountDelta, 0) > 0
                         THEN MISend.AmountDelta ELSE 0 END > COALESCE (MITechnicalRediscount.Amount, 0)
                AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete()) AS tmpMovementItem;
      END IF;

    ELSE
      -- Обнуляем в техническом переучете
      IF EXISTS(SELECT 1
                FROM MovementItem AS MISend

                     INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                                  ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.ID
                                                 AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                     INNER JOIN MovementItem AS MITechnicalRediscount
                                             ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                     INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                WHERE MISend.MovementId = inMovementId
                  AND MISend.DescId = zc_MI_Master()
                  AND MISend.isErased = FALSE
                  AND MITechnicalRediscount.Amount <> 0
                  AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
      THEN
        PERFORM lpInsertUpdate_MovementItem (MITechnicalRediscount.Id, zc_MI_Master(), MITechnicalRediscount.ObjectId, MITechnicalRediscount.MovementId, 0, Null)
        FROM MovementItem AS MISend

             INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                          ON MIFloat_MITechnicalRediscountId.MovementItemId = MISend.ID
                                         AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

             INNER JOIN MovementItem AS MITechnicalRediscount
                                     ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

             INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

        WHERE MISend.MovementId = inMovementId
          AND MISend.DescId = zc_MI_Master()
          AND MISend.isErased = FALSE
          AND MITechnicalRediscount.Amount <> 0
          AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete();
      END IF;

    END IF;

--    raise notice 'Value 05: % %', vbisAddTR, (SELECT Movement.invnumber FROM Movement WHERE Movement.ID = vbMovementTRId);

--    RAISE EXCEPTION 'Прошло. %', vbMovementTRId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementOccupancySUN (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.20                                                       *
*/

-- тест
-- SELECT * FROM Movement where ID = 19363037
--
-- SELECT * FROM gpSelect_MovementSUN_TechnicalRediscount (inMovementID:= 23522963   , inSession:= '3')