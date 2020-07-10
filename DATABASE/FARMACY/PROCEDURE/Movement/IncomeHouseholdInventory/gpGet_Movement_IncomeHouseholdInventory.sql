-- Function: gpGet_Movement_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeHouseholdInventory (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
             , UpdateId Integer, UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_IncomeHouseholdInventory());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN

     IF vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (308121)) -- ������ ������
     THEN 
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;   
       vbUnitId := vbUnitKey::Integer;

        IF EXISTS(SELECT Movement.id
                  FROM Movement 
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                  WHERE Movement.DescId = zc_Movement_IncomeHouseholdInventory() 
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                    AND MovementLinkObject_Unit.ObjectId = vbUnitId)
        THEN
          RAISE EXCEPTION '������. �� ������������� <%> ��� ������ �������� ������� ���. ���������.', (SELECT Object.ValueData FROM Object WHERE Object.ID = vbUnitId);             
        END IF;
     ELSE
       vbUnitId := 0;
     END IF;

     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_IncomeHouseholdInventory_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , Object_Unit.Id                                   AS UnitId
             , Object_Unit.ValueData                            AS UnitName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , Object_Insert.Id                                 AS InsertId
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP                   :: TDateTime AS InsertDate
             , NULL  ::Integer                                  AS UpdateId
             , NULL  ::TVarChar                                 AS UpdateName
             , Null  :: TDateTime                               AS UpdateDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_Unit ON Object_Insert.Id = vbUnitId;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , COALESCE (MovementString_Comment.ValueData,'') ::TVarChar AS Comment
           , Object_Insert.Id                     AS InsertId
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.Id                     AS UpdateId
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()


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

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_IncomeHouseholdInventory();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
 */

-- ����
-- SELECT * FROM gpGet_Movement_IncomeHouseholdInventory (inMovementId:= 1, inOperDate := CURRENT_TIMESTAMP, inSession:= '9818')