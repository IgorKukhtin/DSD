-- Function: gpGet_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Inventory (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Inventory(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , isList Boolean 
             , isScan Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisScan Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_Inventory_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE :: TDateTime AS OperDate
             , Object_Status.Code    AS StatusCode
             , Object_Status.Name    AS StatusName

             , 0                     AS UnitId
             , CAST ('' as TVarChar) AS UnitName

             , CAST ('' as TVarChar) AS Comment
             , FALSE   ::Boolean     AS isList
             , False                      AS isScan
           
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE

       vbisScan := EXISTS (SELECT MovementItem.Id
                           FROM MovementItem 
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Scan());

       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode  AS StatusCode
             , Object_Status.ValueData   AS StatusName

             , Object_Unit.Id            AS UnitId
             , Object_Unit.ValueData     AS UnitName
             
             , MovementString_Comment.ValueData  AS Comment 
             , COALESCE (MovementBoolean_List.ValueData, FALSE) ::Boolean AS isList
             , vbisScan                       AS isScan
          
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_List 
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Inventory();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 10.05.22         *
 17.02.22         *
*/

-- ����
-- 