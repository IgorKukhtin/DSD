-- Function: gpGet_Movement_GoodsSP()

DROP FUNCTION IF EXISTS gpGet_Movement_GoodsSP (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_GoodsSP (Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_GoodsSP(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ���� ���������
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

     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_GoodsSP_Mask (ioId        := inMovementId
                                                   , inOperDate  := inOperDate
                                                   , inSession   := inSession); 
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT 0                            AS Id
              , CAST (NEXTVAL ('Movement_GoodsSP_seq') AS TVarChar) AS InvNumber
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
           AND Movement.DescId = zc_Movement_GoodsSP();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.18         *
 */

-- ����
-- SELECT * FROM gpGet_Movement_GoodsSP (inMovementId:= 1, inOperDate:= '01.01.2018', inSession:= '3')