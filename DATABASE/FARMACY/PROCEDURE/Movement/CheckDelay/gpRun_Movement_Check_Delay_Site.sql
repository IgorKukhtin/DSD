-- Function: gpRun_Movement_Check_Delay_Site()

DROP FUNCTION IF EXISTS gpRun_Movement_Check_Delay_Site (TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Movement_Check_Delay_Site(
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

    PERFORM gpUpdate_Movement_Check_Delay (Movement.Id, inSession) FROM
    (WITH
         tmpMovAll AS (SELECT Movement.Id
                      FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                       ON Movement.Id = MovementBoolean_Deferred.MovementId
                                                      AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                                      AND MovementBoolean_Deferred.ValueData = TRUE
                      WHERE Movement.DescId = zc_Movement_Check()
                        AND zc_Enum_Status_UnComplete() = Movement.StatusId
                    )
       , tmpMov AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM tmpMovAll AS Movement

                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     )

    SELECT Movement.Id
    FROM tmpMov

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

         LEFT JOIN MovementDate AS MovementDate_Delay
                                ON MovementDate_Delay.MovementId = Movement.Id
                               AND MovementDate_Delay.DescId = zc_MovementDate_Delay()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                      ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                     AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

         LEFT JOIN MovementBoolean AS MovementBoolean_AutoVIPforSales
                                   ON MovementBoolean_AutoVIPforSales.MovementId = Movement.Id
                                  AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()

    WHERE COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
      AND MovementDate_UserConfirmedKind.ValueData is not Null
      AND MovementDate_UserConfirmedKind.ValueData <= DATE_TRUNC ('DAY', CURRENT_DATE)
      AND COALESCE(MovementBoolean_AutoVIPforSales.ValueData, False) = False) AS Movement;
               
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 03.03.22                                                                    *
*/
-- ����
-- select * from gpRun_Movement_Check_Delay_Site(inSession := '3');