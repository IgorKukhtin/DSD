-- Function: gpGet_Movement_ProductionUnion()

-- DROP FUNCTION gpGet_Movement_ProductionUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnion(
    IN inMovementId  Integer,       -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar) 
AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Movement_ProductionUnion());

     RETURN QUERY
     SELECT 
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ObjectCode  AS StatusCode
         , Object_Status.ValueData   AS StatusName
         
         , MovementFloat_TotalCount.ValueData AS TotalCount

         , Object_From.Id          AS FromId
         , Object_From.ValueData   AS ObjectFromName
         , Object_To.Id            AS ToId
         , Object_To.ValueData     AS ObjectToName
         
     FROM Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionUnion();
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.07.13                                        * DROP FUNCTION
 15.07.13         *
 30.06.13                                        *

*/

-- ����
-- SELECT * FROM gpGet_Movement_ProductionUnion (inId:= 1, inSession:= '2')
