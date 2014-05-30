-- Function: gpGet_Movement_ProductionSeparate()

-- DROP FUNCTION gpGet_Movement_ProductionSeparate (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionSeparate (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionSeparate (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionSeparate(
    IN inMovementId  Integer,       -- ���� ���������
    IN inOperDate    TDateTime,     -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             --, TotalCount TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PartionGoods TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionSeparate());
     vbUserId := inSession;
     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_productionseparate_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
--             , CAST (0 AS TFloat)                               AS TotalCount
             , 0                     				            AS FromId
             , CAST ('' AS TVarChar) 				            AS FromName
             , 0                     				            AS ToId
             , CAST ('' AS TVarChar) 				            AS ToName
             , CAST ('' AS TVarChar) 				            AS PartionGoods

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
     SELECT
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ObjectCode                             AS StatusCode
         , Object_Status.ValueData                              AS StatusName
--         , MovementFloat_TotalCount.ValueData                 AS TotalCount
         , Object_From.Id                                       AS FromId
         , Object_From.ValueData                                AS FromName
         , Object_To.Id                                         AS ToId
         , Object_To.ValueData                                  AS ToName
         , MovementString_PartionGoods.ValueData                AS PartionGoods

     FROM Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
/*
          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
*/
          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionSeparate();

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ProductionSeparate (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.05.14                                                        *
 16.07.13         *

*/

-- ����
 SELECT * FROM gpGet_Movement_ProductionSeparate (inMovementId := 0, inOperDate := '01.01.2014', inSession:= '2')