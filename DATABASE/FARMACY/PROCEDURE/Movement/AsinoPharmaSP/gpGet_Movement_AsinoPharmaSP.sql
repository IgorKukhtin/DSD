-- Function: gpGet_Movement_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpGet_Movement_AsinoPharmaSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_AsinoPharmaSP(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT 0                            AS Id
              , CAST (NEXTVAL ('Movement_AsinoPharmaSP_seq') AS TVarChar) AS InvNumber
              , CURRENT_DATE::TDateTime      AS OperDate
              , Object_Status.Code           AS StatusCode
              , Object_Status.Name           AS StatusName
              , CURRENT_DATE::TDateTime      AS OperDateStart
              , CURRENT_DATE::TDateTime      AS OperDateEnd
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     
     RETURN QUERY
         SELECT Movement.Id                            AS Id
              , Movement.InvNumber                     AS InvNumber
              , Movement.OperDate                      AS OperDate
              , Object_Status.ObjectCode               AS StatusCode
              , Object_Status.ValueData                AS StatusName
              , MovementDate_OperDateStart.ValueData   AS OperDateStart
              , MovementDate_OperDateEnd.ValueData     AS OperDateEnd
         FROM Movement
               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
   
               LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                      ON MovementDate_OperDateStart.MovementId = Movement.Id
                                     AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
   
               LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                      ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                     AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_AsinoPharmaSP();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.02.23                                                       *
 */

-- ����
-- SELECT * FROM gpGet_Movement_AsinoPharmaSP (inMovementId:= 1, inSession:= '3')