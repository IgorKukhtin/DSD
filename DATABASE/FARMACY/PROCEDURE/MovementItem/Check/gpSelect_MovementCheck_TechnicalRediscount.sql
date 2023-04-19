-- Function: gpSelect_MovementCheck_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpSelect_MovementCheck_TechnicalRediscount (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementCheck_TechnicalRediscount(
    IN inMovementID    Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbUnitId          Integer;
  DECLARE vbStatusId        Integer;
  DECLARE vbInsertDate      TDateTime;
  DECLARE vbCheckSourceKindID Integer;

  DECLARE vbisAddTR         Boolean;

  DECLARE vbMovementTRId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= lpGetUserBySession (inSession);

    --определяем
    SELECT Movement.StatusId
         , MovementLinkObject_Unit.ObjectId                               AS UnitId
         , MovementLinkObject_CheckSourceKind.ObjectId                    AS CheckSourceKindID
         , DATE_TRUNC ('DAY', MovementDate_Insert.ValueData)
    INTO vbStatusId, vbUnitId, vbCheckSourceKindID, vbInsertDate
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                       ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                      AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    WHERE Movement.Id = inMovementId;

    IF vbCheckSourceKindID <> zc_Enum_CheckSourceKind_Tabletki() OR vbInsertDate < '20.04.2023' AND inSession <> '3'
    THEN
      RETURN;
    END IF;

    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
      vbisAddTR := True;
    ELSE
      vbisAddTR := FALSE;
    END IF;

    IF vbisAddTR = TRUE
    THEN
      -- Ищем текущий технический переучет
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
                FROM MovementItem AS MICheck

                     INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                                  ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.ID
                                                 AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                     INNER JOIN MovementItem AS MITechnicalRediscount
                                             ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                     INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                      ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                     AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

                WHERE MICheck.MovementId = inMovementId
                  AND MICheck.DescId = zc_MI_Master()
                  AND (MICheck.isErased = FALSE
                    OR MICheck.Amount = 0
                    OR MITechnicalRediscount.MovementId <> vbMovementTRId)
                  AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
      THEN
        -- Обнулили
        PERFORM lpInsertUpdate_MovementItem (MITechnicalRediscount.Id, zc_MI_Master(), MITechnicalRediscount.ObjectId, MITechnicalRediscount.MovementId, 0, Null)
        FROM MovementItem AS MICheck

             INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                          ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.ID
                                         AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

             INNER JOIN MovementItem AS MITechnicalRediscount
                                     ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

             INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                              ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                             AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

        WHERE MICheck.MovementId = inMovementId
          AND MICheck.DescId = zc_MI_Master()
          AND MITechnicalRediscount.Amount <> 0
          AND (MICheck.isErased = FALSE
            OR MICheck.Amount = 0
            OR MITechnicalRediscount.MovementId <> vbMovementTRId)
          AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete();

        -- Грохнули связи на то что в не текущем ТП
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MITechnicalRediscountId(), MICheck.ID, 0)
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), MITechnicalRediscount.ID, 0)
              , gpSetErased_MovementItem_TechnicalRediscount_Auto (MITechnicalRediscount.ID, inSession)
        FROM MovementItem AS MICheck

             INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                          ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.ID
                                         AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

             INNER JOIN MovementItem AS MITechnicalRediscount
                                     ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

             INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                              ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                             AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

        WHERE MICheck.MovementId = inMovementId
          AND MICheck.DescId = zc_MI_Master()
          AND MITechnicalRediscount.MovementId <> vbMovementTRId
          AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete();
      END IF;

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpoccupancyCheck'))
      THEN
        DROP TABLE _tmpOccupancyCheck;
      END IF;

      CREATE TEMP TABLE _tmpOccupancyCheck ON COMMIT DROP AS
      SELECT * FROM gpSelect_MovementOccupancyCheck (inMovementID:= inMovementID, inSession:= inSession);

      IF EXISTS(SELECT 1
            FROM _tmpOccupancyCheck AS MICheck

                 LEFT JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                             ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.MovementItemId
                                            AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                 LEFT JOIN MovementItem AS MITechnicalRediscount
                                        ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                 LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                  ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                 AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
            WHERE CASE WHEN COALESCE (MICheck.CommentTRId, 0) <> 0 AND COALESCE (MICheck.AmountDelta, 0) > 0
                       THEN MICheck.AmountDelta ELSE 0 END > COALESCE (MITechnicalRediscount.Amount, 0)
              AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
      THEN
        IF COALESCE(vbMovementTRId, 0) = 0
           AND EXISTS(SELECT 1
                      FROM _tmpOccupancyCheck AS MICheck

                           LEFT JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                                       ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.MovementItemId
                                                      AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                           LEFT JOIN MovementItem AS MITechnicalRediscount
                                                  ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                           LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                            ON MILinkObject_CommentTR.MovementItemId = MITechnicalRediscount.Id
                                                           AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                      WHERE CASE WHEN COALESCE (MICheck.CommentTRId, 0) <> 0 AND COALESCE (MICheck.AmountDelta, 0) > 0
                                 THEN MICheck.AmountDelta ELSE 0 END > COALESCE (MITechnicalRediscount.Amount, 0)
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
        FROM (SELECT MICheck.MovementItemId
                   , lpInsertUpdate_MovementItem_TechnicalRediscount (
                             ioId           := COALESCE(MITechnicalRediscount.Id, 0)
                           , inMovementId   := vbMovementTRId
                           , inGoodsId      := MICheck.GoodsId
                           , inAmount       := CASE WHEN COALESCE (MICheck.CommentTRId, 0) <> 0 AND COALESCE (MICheck.AmountDelta, 0) > 0 THEN - MICheck.AmountDelta ELSE 0 END
                           , inCommentTRID  := COALESCE (MICheck.CommentTRId, MILinkObject_CommentTR.ObjectId)
                           , isExplanation  := COALESCE (MIString_Explanation.ValueData , '')
                           , isComment      := 'Коррекция заказа таблеток'
                           , inisDeferred   := False
                           , inUserId       := vbUserId)                                  AS MITechnicalRediscountId
              FROM _tmpOccupancyCheck AS MICheck

                   LEFT JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                               ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.MovementItemId
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

              WHERE CASE WHEN COALESCE (MICheck.CommentTRId, 0) <> 0 AND COALESCE (MICheck.AmountDelta, 0) > 0
                         THEN MICheck.AmountDelta ELSE 0 END > COALESCE (MITechnicalRediscount.Amount, 0)
                AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete()) AS tmpMovementItem;
      END IF;

    ELSE
      -- Обнуляем в техническом переучете
      IF EXISTS(SELECT 1
                FROM MovementItem AS MICheck

                     INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                                  ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.ID
                                                 AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

                     INNER JOIN MovementItem AS MITechnicalRediscount
                                             ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

                     INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

                WHERE MICheck.MovementId = inMovementId
                  AND MICheck.DescId = zc_MI_Master()
                  AND MICheck.isErased = FALSE
                  AND MITechnicalRediscount.Amount <> 0
                  AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete())
      THEN
        PERFORM lpInsertUpdate_MovementItem (MITechnicalRediscount.Id, zc_MI_Master(), MITechnicalRediscount.ObjectId, MITechnicalRediscount.MovementId, 0, Null)
        FROM MovementItem AS MICheck

             INNER JOIN MovementItemFloat AS MIFloat_MITechnicalRediscountId
                                          ON MIFloat_MITechnicalRediscountId.MovementItemId = MICheck.ID
                                         AND MIFloat_MITechnicalRediscountId.DescId = zc_MIFloat_MITechnicalRediscountId()

             INNER JOIN MovementItem AS MITechnicalRediscount
                                     ON MITechnicalRediscount.ID = MIFloat_MITechnicalRediscountId.ValueData::Integer

             INNER JOIN Movement AS MovementTR ON MovementTR.ID = MITechnicalRediscount.MovementId

        WHERE MICheck.MovementId = inMovementId
          AND MICheck.DescId = zc_MI_Master()
          AND MICheck.isErased = FALSE
          AND MITechnicalRediscount.Amount <> 0
          AND COALESCE(MovementTR.StatusId, zc_Enum_Status_UnComplete()) <> zc_Enum_Status_Complete();
      END IF;

    END IF;

   -- raise notice 'Value 05: % %', vbisAddTR, (SELECT Movement.invnumber FROM Movement WHERE Movement.ID = vbMovementTRId);

   -- RAISE EXCEPTION 'Прошло. %', vbUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementCheck_TechnicalRediscount (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.04.23                                                       *
*/

-- тест
-- SELECT * FROM Movement where ID = 19363037
--
-- 
SELECT * FROM gpSelect_MovementCheck_TechnicalRediscount (inMovementID:= 31771844, inSession:= '3')