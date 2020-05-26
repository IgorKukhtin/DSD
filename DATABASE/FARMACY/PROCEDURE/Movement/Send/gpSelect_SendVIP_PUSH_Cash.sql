-- Function: gpSelect_SendVIP_PUSH_Cash()

DROP FUNCTION IF EXISTS gpSelect_SendVIP_PUSH_Cash (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_SendVIP_PUSH_Cash(
    IN inMovementID    Integer    , -- Movement PUSH
    IN inUnitID        Integer    , -- Подразделение
    IN inUserId        Integer     -- Мотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar)

AS
$BODY$
  DECLARE vbDateViewed TDateTime;
BEGIN

  IF EXISTS(SELECT MovementItemDate_Viewed.ValueData
            FROM MovementItem

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                 LEFT JOIN MovementItemDate AS MovementItemDate_Viewed
                                            ON MovementItemDate_Viewed.MovementItemId = MovementItem.Id
                                           AND MovementItemDate_Viewed.DescId = zc_MIDate_Viewed()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND MovementItem.ObjectId = inUserId
              AND COALESCE(MILinkObject_Unit.ObjectId, 0) = inUnitId)
  THEN
    SELECT MovementItemDate_Viewed.ValueData
    INTO vbDateViewed
    FROM MovementItem

         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                         AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

         LEFT JOIN MovementItemDate AS MovementItemDate_Viewed
                                    ON MovementItemDate_Viewed.MovementItemId = MovementItem.Id
                                   AND MovementItemDate_Viewed.DescId = zc_MIDate_Viewed()
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.ObjectId = inUserId
      AND COALESCE(MILinkObject_Unit.ObjectId, 0) = inUnitId;
  ELSE
    vbDateViewed := Null;
  END IF;

  RETURN QUERY
  WITH tmpMovementID AS (SELECT Movement.id
                         FROM Movement
                              LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                                        ON MovementBoolean_VIP.MovementId = Movement.Id
                                                       AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

                         WHERE Movement.DescId = zc_Movement_Send()
                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE
                        ),
       tmpPUSHCollect AS (SELECT ('Соберите товар по ВИП перемещению.')::TBlob AS Message,
                                 'TSendCashJournalVIPForm'::TVarChar           AS FormName,
                                 'Перемещение VIP'::TVarChar                   AS Button,
                                 'VIPType'::TVarChar                           AS Params,
                                 'ftInteger'::TVarChar                         AS TypeParams,
                                 '1'::TVarChar                                 AS ValueParams
                          FROM tmpMovementID AS Movement
                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                            AND MovementLinkObject_From.ObjectId = inUnitId
                               LEFT JOIN MovementBoolean AS MovementBoolean_Confirmed
                                                         ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                                        AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()
                          WHERE MovementBoolean_Confirmed.ValueData is Null
                          LIMIT 1),
       tmpPUSHCreated AS (SELECT ('Создан отложенный чек по ВИП перемещению.')::TBlob AS Message,
                                  'TSendCashJournalVIPForm'::TVarChar                 AS FormName,
                                  'Перемещение VIP'::TVarChar                         AS Button,
                                  'VIPType'::TVarChar                                 AS Params,
                                  'ftInteger'::TVarChar                               AS TypeParams,
                                  '2'::TVarChar                                       AS ValueParams
                          FROM tmpMovementID AS Movement
                               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                            AND MovementLinkObject_To.ObjectId = inUnitId
                               LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                        AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                               LEFT JOIN MovementDate AS MovementDate_Deferred
                                                      ON MovementDate_Deferred.MovementId = Movement.Id
                                                     AND MovementDate_Deferred.DescId = zc_MovementDate_Deferred()
                          WHERE COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                            AND MovementDate_Deferred.ValueData >= COALESCE (vbDateViewed, MovementDate_Deferred.ValueData)
                          LIMIT 1),
       tmpPUSHshould AS (SELECT ('К вам следует ВИП перемещение.')::TBlob AS Message,
                                 'TSendCashJournalVIPForm'::TVarChar      AS FormName,
                                 'Перемещение VIP'::TVarChar              AS Button,
                                 'VIPType'::TVarChar                      AS Params,
                                 'ftInteger'::TVarChar                    AS TypeParams,
                                 '3'::TVarChar                            AS ValueParams
                         FROM tmpMovementID AS Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                           AND MovementLinkObject_To.ObjectId = inUnitId
                              LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                                        ON MovementBoolean_Sent.MovementId = Movement.Id
                                                       AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                              LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                                        ON MovementBoolean_Received.MovementId = Movement.Id
                                                       AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                              LEFT JOIN MovementDate AS MovementDate_Sent
                                                     ON MovementDate_Sent.MovementId = Movement.Id
                                                    AND MovementDate_Sent.DescId = zc_MovementDate_Sent()
                         WHERE COALESCE (MovementBoolean_Sent.ValueData, FALSE) = TRUE
                           AND COALESCE (MovementBoolean_Received.ValueData, FALSE) = FALSE
                           AND MovementDate_Sent.ValueData >= COALESCE (vbDateViewed, MovementDate_Sent.ValueData)
                         LIMIT 1)

  SELECT * FROM tmpPUSHCollect
  UNION ALL
  SELECT * FROM tmpPUSHCreated
  UNION ALL
  SELECT * FROM tmpPUSHshould;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 25.05.20         *
*/

-- SELECT * FROM gpSelect_SendVIP_PUSH_Cash(18971753 , 183292 , 3);