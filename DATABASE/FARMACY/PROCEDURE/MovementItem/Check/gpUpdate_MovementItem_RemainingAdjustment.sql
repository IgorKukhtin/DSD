-- Function: gpUpdate_MovementItem_RemainingAdjustment()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_RemainingAdjustment (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_RemainingAdjustment(
    IN inSession           TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS VOID AS
$BODY$
BEGIN

    PERFORM gpUpdate_MovementItem_Check_AmountAdmin(inId           := T1.MovementItemId
                                                  , inMovementId   := T1.MovementId
                                                  , inAmount       := (T1.Amount - T1.Delta) :: TFloat
                                                  , inSession      := inSession)
    FROM (WITH tmpMov_UnC AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                              FROM Movement
                              WHERE Movement.DescId   =  zc_Movement_Check()
                                AND Movement.StatusId =  zc_Enum_Status_UnComplete()
                                AND Movement.OperDate >= CURRENT_DATE - INTERVAL '100 DAY'
                             )
             , tmpMov_all AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MovementLinkObject_Unit.ObjectId AS UnitId
                                   , COALESCE (MovementLinkObject_ConfirmedKind.ObjectID, zc_Enum_ConfirmedKind_UnComplete()) AS ConfirmedKindID
                                   , COALESCE(MovementBoolean_Deferred.ValueData, FALSE)   AS isDeferred
                              FROM tmpMov_UnC AS Movement

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                               AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                            AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()

                                   LEFT JOIN MovementString AS MovementString_CommentError
                                                            ON MovementString_CommentError.MovementId = Movement.Id
                                                           AND MovementString_CommentError.DescId     = zc_MovementString_CommentError()

                              WHERE COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                                 OR MovementString_CommentError.ValueData <> ''
                             )
             , tmpMov AS (SELECT Movement.Id
                               , Movement.InvNumber
                               , Movement.OperDate
                               , Movement.UnitId
                          FROM tmpMov_all AS Movement

                               INNER JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                             ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                                            AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                                            AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki()

                          WHERE Movement.ConfirmedKindID = zc_Enum_ConfirmedKind_UnComplete()
                         )
             , tmpMI_all AS (SELECT tmpMov.UnitId
                                  , tmpMov.Id              AS MovementId
                                  , MovementItem.ID        AS MovementItemId
                                  , MovementItem.ObjectId  AS GoodsId
                                  , MovementItem.Amount    AS Amount
                             FROM tmpMov
                                  INNER JOIN MovementItem
                                          ON MovementItem.MovementId = tmpMov.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                                         AND MovementItem.Amount     > 0.1
                             )
             , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                         FROM tmpMI_all
                         GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                        )
             , tmpMov_Res AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , Movement.UnitId
                              FROM tmpMov_all AS Movement

                              WHERE Movement.ConfirmedKindID = zc_Enum_ConfirmedKind_Complete()
                                 OR Movement.isDeferred = False
                             )
             , tmpMI_Res AS (SELECT Movement.UnitId
                                  , MovementItem.ObjectId       AS GoodsId
                                  , Sum(MovementItem.Amount)    AS Amount
                             FROM tmpMov_Res AS Movement
                                  INNER JOIN MovementItem
                                          ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                             GROUP BY Movement.UnitId, MovementItem.ObjectId
                             )
             , tmpRemains AS (SELECT tmpMI.GoodsId
                                   , tmpMI.UnitId
                                   , COALESCE (SUM (Container.Amount), 0) AS Amount
                              FROM tmpMI
                                   LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                      AND Container.ObjectId = tmpMI.GoodsId
                                                      AND Container.WhereObjectId = tmpMI.UnitId
                                                      AND Container.Amount <> 0
                              GROUP BY tmpMI.GoodsId
                                     , tmpMI.UnitId
                                     , tmpMI.Amount
                            )

     SELECT tmpMI_all.MovementId
          , tmpMI_all.MovementItemId
          , tmpMI_all.GoodsId
          , tmpMI_all.Amount
          , (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0)) AS Remains
          , (tmpMI_all.Amount - (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0))) AS Delta
     FROM tmpMI_all

          LEFT JOIN tmpRemains ON tmpRemains.UnitId = tmpMI_all.UnitId
                              AND tmpRemains.GoodsId = tmpMI_all.GoodsId

          LEFT JOIN tmpMI_Res ON tmpMI_Res.UnitId = tmpMI_all.UnitId
                             AND tmpMI_Res.GoodsId = tmpMI_all.GoodsId

     WHERE (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0)) > 0
       AND tmpMI_all.Amount > (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0))
       AND (tmpMI_all.Amount - (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0))) <= 0.05) AS T1;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_RemainingAdjustment (TVarChar) OWNER TO postgres;


/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 26.11.20                                                       *

*/

-- SELECT * FROM gpUpdate_MovementItem_RemainingAdjustment (inSession := zfCalc_UserAdmin());