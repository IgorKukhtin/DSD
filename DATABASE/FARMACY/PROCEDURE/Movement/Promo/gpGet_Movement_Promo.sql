-- Function: gpGet_Movement_Promo()

DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Promo(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , StartPromo TDateTime
             , EndPromo TDateTime
             , ChangePercent TFloat
             , Amount TFloat
             , TotalCount TFloat
             , TotalSumm TFloat
             , MakerId Integer
             , MakerName TVarChar
             , PersonalId Integer
             , PersonalName TVarChar
             , Comment TVarChar
             , Prescribe TVarChar)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_Promo_seq') AS TVarChar) AS InvNumber
          , inOperDate		                             AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name            	             AS StatusName
          , Null :: TDateTime                                AS StartPromo
          , Null :: TDateTime                                AS EndPromo 
          , 0::TFloat                                        AS ChangePercent
          , 0::TFloat                                        AS Amount
          , 0::TFloat                                        AS TotalCount
          , 0::TFloat                                        AS TotalSumm
          , NULL::Integer                                    AS MakerId
          , NULL::TVarChar                                   AS MakerName
          , NULL::Integer                                    AS PersonalId
          , NULL::TVarChar                                   AS PersonalName
          , NULL::TVarChar                                   AS Comment
          , NULL::TVarChar                                   AS Prescribe
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
  
   ELSE
 
  RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          --, Movement.StatusId
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
          , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat      AS ChangePercent
          , COALESCE(MovementFloat_Amount.ValueData,0)::TFloat             AS Amount
          , COALESCE(MovementFloat_TotalCount.ValueData,0) ::TFloat        AS TotalCount
          , COALESCE(MovementFloat_TotalSumm.ValueData,0)  ::TFloat        AS TotalSumm
          , MovementLinkObject_Maker.ObjectId                              AS MakerId
          , Object_Maker.ValueData                                         AS MakerName
          , MovementLinkObject_Personal.ObjectId                           AS PersonalId  
          , Object_Personal.ValueData                                      AS PersonalName 
          , MovementString_Comment.ValueData                               AS Comment
          , CASE WHEN COALESCE(MovementBoolean_Prescribe.ValueData, FALSE)
            THEN '������� �������'
            ELSE '���������' END::TVarChar                                 AS Prescribe
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId =  Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId =  Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                   
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement.Id
                                    AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
        LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                     ON MovementLinkObject_Personal.MovementId = Movement.Id
                                    AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
        LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementBoolean AS MovementBoolean_Prescribe
                                  ON MovementBoolean_Prescribe.MovementId =  Movement.Id
                                 AND MovementBoolean_Prescribe.DescId = zc_MovementBoolean_Promo_Prescribe()

     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 16.10.18                                                                                    *
 24.04.16         *
*/

--���� 
--select * from gpGet_Movement_Promo(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_Promo(inMovementId := 1923638 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');