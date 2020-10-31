-- Function: gpGet_Movement_SaleExternal()

DROP FUNCTION IF EXISTS gpGet_Movement_SaleExternal (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SaleExternal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar
             , PartnerId_From Integer, PartnerName_From TVarChar
             --, ToId Integer, ToName TVarChar
             --, PaidKindId Integer, PaidKindName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SaleExternal());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_SaleExternal_seq') AS TVarChar) AS InvNumber
             , inOperDate				AS OperDate
             , zc_Enum_Status_UnComplete()              AS StatusId
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , 0                     	                AS FromId
             , CAST ('' as TVarChar) 	                AS FromName
             , 0                                        AS PartnerId_From
             , CAST ('' as TVarChar)                    AS PartnerName_From

--             , 0                                      AS ToId
--             , CAST ('' as TVarChar)                  AS ToName
--             , 0                     		        AS PaidKindId
--             , CAST ('' as TVarChar)		        AS PaidKindName
             , 0                                        AS GoodsPropertyId
             , CAST ('' as TVarChar)                    AS GoodsPropertyName

             , CAST ('' as TVarChar) 		        AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
          ;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusId
           , Object_Status.ObjectCode          	    AS StatusCode
           , Object_Status.ValueData         	    AS StatusName
           , Object_From.Id                    	    AS FromId
           , Object_From.ValueData             	    AS FromName
           , Object_PartnerFrom.id                  AS PartnerId_From
           , Object_PartnerFrom.ValueData           AS PartnerName_From

--           , Object_To.Id                      	    AS ToId
--           , Object_To.ValueData               	    AS ToName
--           , Object_PaidKind.Id                	    AS PaidKindId
--           , Object_PaidKind.ValueData         	    AS PaidKindName
           , Object_GoodsProperty.Id                AS GoodsPropertyId
           , Object_GoodsProperty.ValueData         AS GoodsPropertyName

           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
           
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PartnerExternal_Partner
                                 ON ObjectLink_PartnerExternal_Partner.ObjectId = Object_From.Id
                                AND ObjectLink_PartnerExternal_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
            LEFT JOIN Object AS Object_PartnerFrom ON Object_PartnerFrom.Id = ObjectLink_PartnerExternal_Partner.ChildObjectId

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId*/

         WHERE Movement.Id     =  inMovementId
           AND Movement.DescId = zc_Movement_SaleExternal();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
31.10.20          *
*/

-- ����
-- SELECT * FROM gpGet_Movement_SaleExternal (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
