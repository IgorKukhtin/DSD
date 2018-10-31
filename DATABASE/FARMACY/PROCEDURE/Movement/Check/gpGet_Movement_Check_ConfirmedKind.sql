-- Function: gpGet_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_ConfirmedKind (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_ConfirmedKind(
   OUT outMovementId_list  TVarChar,  -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    vbUnitId  := CASE WHEN vbUnitKey = '' THEN '0' ELSE vbUnitKey END :: Integer;


    -- ��������� - ��� ��������� - � ����� "�� �����������"
    outMovementId_list:= 
       (SELECT STRING_AGG (COALESCE (Movement.Id :: TVarChar, ''), ';') AS RetV
        FROM (SELECT 0 AS x) AS tmp
             LEFT JOIN (WITH tmpMov_all AS (SELECT Movement.Id
                                             , Movement.InvNumber
                                             , Movement.OperDate
                                             , MovementLinkObject_Unit.ObjectId AS UnitId
                                        FROM Movement
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                          AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                                          AND MovementLinkObject_Unit.ObjectId   = vbUnitId
                                        WHERE Movement.DescId   =  zc_Movement_Check()
                                          AND Movement.StatusId =  zc_Enum_Status_UnComplete()
                                          AND Movement.OperDate >= CURRENT_DATE - INTERVAL '100 DAY'
                                       )
             , tmpMLO_ConfirmedKind AS (SELECT MLO_ConfirmedKind.*
                                        FROM MovementLinkObject AS MLO_ConfirmedKind
                                        WHERE MLO_ConfirmedKind.MovementId IN (SELECT DISTINCT tmpMov_all.Id FROM tmpMov_all)
                                          AND MLO_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                       )
                           , tmpMov AS (SELECT Movement.Id
                                             , Movement.InvNumber
                                             , Movement.OperDate
                                             , Movement.UnitId
                                        FROM tmpMov_all AS Movement
                                             INNER JOIN tmpMLO_ConfirmedKind AS MovementLinkObject_ConfirmedKind
                                                                             ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                            AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_UnComplete()
                                        -- ORDER BY Movement.Id DESC
                                       )
                        , tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                                        FROM tmpMov
                                             INNER JOIN MovementItem
                                                     ON MovementItem.MovementId = tmpMov.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                        GROUP BY tmpMov.Id, tmpMov.UnitId, MovementItem.ObjectId
                                        )
                            , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                                        FROM tmpMI_all
                                        GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                                       )
                  , tmpMov_Complete AS (SELECT Movement.Id
                                             , Movement.InvNumber
                                             , Movement.OperDate
                                             , Movement.UnitId
                                        FROM tmpMov_all AS Movement
                                             INNER JOIN tmpMLO_ConfirmedKind AS MovementLinkObject_ConfirmedKind
                                                                             ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                            AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_Complete()
                                       )
                      , tmpComplete AS (SELECT tmpMov_Complete.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                                        FROM tmpMov_Complete
                                             INNER JOIN MovementItem
                                                     ON MovementItem.MovementId = tmpMov_Complete.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                        GROUP BY tmpMov_Complete.UnitId, MovementItem.ObjectId
                                       )
          , tmpRemains AS (SELECT tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , (COALESCE (SUM (Container.Amount), 0) - COALESCE (MAX (tmpComplete.Amount), 0)) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                                LEFT JOIN tmpComplete ON tmpComplete.GoodsId = tmpMI.GoodsId
                                                     AND tmpComplete.UnitId = tmpMI.UnitId
                           GROUP BY tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING (COALESCE (SUM (Container.Amount), 0) - COALESCE (MAX (tmpComplete.Amount), 0)) < tmpMI.Amount
                          )
          , tmpErr AS (SELECT DISTINCT tmpMov.Id AS MovementId
                       FROM tmpMov
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                            INNER JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_all.GoodsId
                                                 AND tmpRemains.UnitId  = tmpMI_all.UnitId
                      )

                        -- ���������
                        SELECT tmpMov.*
                        FROM tmpMov
                             LEFT JOIN tmpErr ON tmpErr.MovementId = tmpMov.Id
                        WHERE tmpErr.MovementId IS NULL
                        -- LIMIT 1
                       ) AS Movement ON 1=1
       );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 20.10.18                                                                     *
 31.08.18                                                                     *
 18.08.16                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
