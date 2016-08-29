-- Function: gpGet_Movement_EntryAsset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_EntryAsset (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_EntryAsset(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_EntryAsset());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_EntryAsset_seq') AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

         FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_EntryAsset();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.08.16         * 
*/

-- ����
-- SELECT * FROM gpGet_Movement_EntryAsset (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
