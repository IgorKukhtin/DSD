-- Function: gpGet_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpGet_Movement_ServiceItem (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ServiceItem(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMovementId_Value  Integer   ,    
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime 
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar)  AS InvNumber
           , CURRENT_DATE                          :: TDateTime       AS OperDate
           , Object_Status.ObjectCode                                 AS StatusCode
           , Object_Status.ValueData                                  AS StatusName
           , Object_Insert.ValueData               :: TVarChar        AS InsertName
           , CURRENT_TIMESTAMP                     :: TDateTime       AS InsertDate
           , ''                                    :: TVarChar        AS UpdateName
           , NULL                                  :: TDateTime       AS UpdateDate
       FROM Object AS Object_Insert
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = zc_Enum_Status_UnComplete()
       WHERE Object_Insert.Id = vbUserId
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate   

           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

       WHERE Movement.Id = inMovementId_Value;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.22         *
 */

-- ����
-- select * from gpGet_Movement_ServiceItem(inMovementId := 0 , inMovementId_Value := 0 , inOperDate := ('01.06.2022')::TDateTime ,  inSession := '5');