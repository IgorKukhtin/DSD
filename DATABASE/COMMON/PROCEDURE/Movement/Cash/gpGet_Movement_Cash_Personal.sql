-- Function: gpGet_Movement_Cash_Personal()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalCash (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Personal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Personal (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash_Personal(
    IN inMovementId        Integer   , -- ���� ���������
    IN inOperDate          TDateTime , -- 
    IN inCashId            Integer   , -- �����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ParentId Integer, ParentName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
             , PersonalServiceListName TVarChar
           
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash_Personal());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_cash_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                AS OperDate
           , inOperDate                                        AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
     
           , 0                      AS ParentId
           , '' :: TVarChar         AS ParentName
           
           , 0::TFloat                                         AS Amount

           , DATE_TRUNC ('Month', inOperDate - INTERVAL '1 MONTH') :: TDateTime AS ServiceDate
           , '' :: TVarChar         AS Comment
           , COALESCE (Object_Cash.Id, 0)                      AS CashId
           , COALESCE (Object_Cash.ValueData, '') :: TVarChar  AS CashName
           , '' :: TVarChar         AS PersonalServiceListName
   

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
           LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = inCashId 
                                                                        -- IN (SELECT MIN (Object.Id) FROM Object WHERE Object.AccessKeyId IN (SELECT MIN (lpGetAccessKey) FROM lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Cash())))
            
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementPersonalService.Id         AS ParentId
           , MovementPersonalService.InvNumber  AS ParentName  
                    
           , MovementItem.Amount

           , COALESCE (MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
           , MIString_Comment.ValueData        AS Comment

           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName
           , Object_PersonalServiceList.ValueData AS PersonalServiceListName
         
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Movement AS MovementPersonalService 
                               ON MovementPersonalService.Id = Movement.ParentId
                              AND MovementPersonalService.DescId = zc_Movement_PersonalService()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = MovementPersonalService.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId
        
       WHERE Movement.Id =  inMovementId;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Cash_Personal (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 16.09.14         * 

*/

-- ����
-- SELECT * FROM gpGet_Movement_Cash_Personal (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin());
