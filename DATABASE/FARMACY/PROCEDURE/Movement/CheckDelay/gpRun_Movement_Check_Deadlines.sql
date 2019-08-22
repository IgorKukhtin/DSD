  -- Function: gpRun_Movement_Check_Deadlines()

  DROP FUNCTION IF EXISTS gpRun_Movement_Check_Deadlines (TVarChar);

  CREATE OR REPLACE FUNCTION gpRun_Movement_Check_Deadlines(
      IN inSession           TVarChar    -- ������ ������������
  )
  RETURNS void
  AS
  $BODY$
     DECLARE vbUserId Integer;
  BEGIN
      -- �������� ���� ������������ �� ����� ���������
      --vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION '������ ��������� ���� ��������� �������� <���������.> ��� ���������.';
    END IF;

    PERFORM gpUpdate_Movement_Check_Deadlines (Movement.Id, inSession) FROM
    (WITH
         tmpMovAll AS (SELECT Movement.Id
                      FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_Delay
                                                       ON Movement.Id = MovementBoolean_Delay.MovementId
                                                      AND MovementBoolean_Delay.DescId    = zc_MovementBoolean_Delay()
                                                      AND MovementBoolean_Delay.ValueData = TRUE
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                            LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId


                            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                         ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                            LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

                      WHERE Movement.DescId = zc_Movement_Check()
                        AND zc_Enum_Status_Erased() = Movement.StatusId
                        AND COALESCE(MovementString_InvNumberOrder.ValueData, '') = ''
                    )
       , tmpMov AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM tmpMovAll AS Movement

                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
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
          , tmpRemains AS (SELECT tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , COALESCE (SUM (Container.Amount), 0) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                           GROUP BY tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING COALESCE (SUM (Container.Amount), 0) < tmpMI.Amount
                          )
          , tmpOk AS (SELECT DISTINCT tmpMov.Id AS MovementId
                       FROM tmpMov
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                      )
          , tmpErr AS (SELECT DISTINCT tmpMov.Id AS MovementId
                       FROM tmpMov
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                            INNER JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_all.GoodsId
                                                 AND tmpRemains.UnitId  = tmpMI_all.UnitId
                      )

       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate


            , CASE WHEN COALESCE(tmpErr.MovementId, 0) = 0 THEN True ELSE False END AS IsPresent
            , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN True ELSE False END AS IsSite
            , CASE WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_Complete() THEN True ELSE False END AS IsConfirmed
            , MovementDate_UserConfirmedKind.ValueData   AS ConfirmedDate

            , DATE_TRUNC ('DAY', Movement.OperDate) + INTERVAL '31 DAY' AS DateRun

       FROM tmpMov

            LEFT JOIN tmpErr ON tmpErr.MovementId = tmpMov.Id

            LEFT JOIN tmpOk ON tmpOk.MovementId = tmpMov.Id

            LEFT JOIN Movement ON Movement.Id = tmpMov.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	        LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId


            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                         ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
            LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId


            LEFT JOIN MovementDate AS MovementDate_UserConfirmedKind
                                   ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                                  AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()
       WHERE COALESCE(tmpErr.MovementId, 0) = 0
         AND COALESCE(tmpOk.MovementId, 0) = tmpMov.Id) AS Movement;

  END;
  $BODY$
    LANGUAGE PLPGSQL VOLATILE;

  /*
   ������� ����������: ����, �����
                 ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
   04.04.19                                                                    *
  */
  -- ����
--  select * from gpRun_Movement_Check_Deadlines(inSession := '3');