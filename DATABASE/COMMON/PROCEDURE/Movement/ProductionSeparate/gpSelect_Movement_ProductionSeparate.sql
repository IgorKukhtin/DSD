-- Function: gpSelect_Movement_ProductionSeparate()

-- DROP FUNCTION gpSelect_Movement_ProductionSeparate (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate(
    IN inStartDate   TDateTime,
    IN inEndDate     TDateTime,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
               , TotalCount TFloat, PartionGoods TVarChar
               , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar)
AS
$BODY$
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Movement_ProductionSeparate());

   RETURN QUERY 
     SELECT 
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ObjectCode  AS StatusCode
         , Object_Status.ValueData   AS StatusName
         
         , MovementFloat_TotalCount.ValueData AS TotalCount
         , MovementString_PartionGoods.ValueData AS PartionGoods

         , Object_From.Id          AS FromId
         , Object_From.ValueData   AS ObjectFromName
         , Object_To.Id            AS ToId
         , Object_To.ValueData     AS ObjectToName
         
     FROM Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

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
            
     WHERE Movement.DescId = zc_Movement_ProductionSeparate()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
 

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.07.13         *
 
*/

-- ����
-- SELECT * FROM gpSelect_Movement_ProductionSeparate (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
