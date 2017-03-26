-- Function: gpGet_Movement_Visit()

DROP FUNCTION IF EXISTS gpGet_Movement_Visit(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Visit (
    IN inMovementId Integer  , -- ���� ���������
    IN inOperDate   TDateTime, -- ���� ���������
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , GUID TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , InsertName TVarChar
             , PartnerId Integer
             , PartnerName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUserName TVarChar;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Visit());
      vbUserId:= lpGetUserBySession (inSession);
      vbUserName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId);

      IF COALESCE(inMovementId, 0) = 0 
      THEN
           RETURN QUERY
             SELECT 0::Integer                                  AS Id
                  , NEXTVAL('movement_visit_seq')::TVarChar AS InvNumber
                  , CURRENT_DATE::TDateTime                     AS OperDate
                  , Object_Status.Code                          AS StatusCode
                  , Object_Status.Name                          AS StatusName
                  , ''::TVarChar                                AS GUID
                  , CURRENT_TIMESTAMP::TDateTime                AS InsertDate
                  , Null ::TDateTime                            AS InsertMobileDate
                  , vbUserName                                  AS InserName 
                  , 0::Integer                                  AS PartnerId
                  , ''::TVarChar                                AS PartnerName
                  , ''::TVarChar                                AS Comment   
             FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
      ELSE
           RETURN QUERY
             SELECT Movement.Id                           
                  , Movement.InvNumber                        
                  , Movement.OperDate                      
                  , Object_Status.ObjectCode         AS StatusCode
                  , Object_Status.ValueData          AS StatusName
                  , MovementString_GUID.ValueData    AS GUID
                  , MovementDate_Insert.ValueData    AS InsertDate
                  , MovementDate_InsertMobile.ValueData AS InsertMobileDate
                  , Object_User.ValueData            AS InsertName
                  , Object_Partner.Id                AS PartnerId
                  , Object_Partner.ValueData         AS PartnerName
                  , MovementString_Comment.ValueData AS Comment
             FROM Movement
                  LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                  LEFT JOIN MovementString AS MovementString_GUID 
                                           ON MovementString_GUID.MovementId = Movement.Id
                                          AND MovementString_GUID.DescId = zc_MovementString_GUID()

                  LEFT JOIN MovementString AS MovementString_Comment
                                           ON MovementString_Comment.MovementId = Movement.Id
                                          AND MovementString_Comment.DescId = zc_MovementString_Comment()

                  LEFT JOIN MovementDate AS MovementDate_Insert 
                                         ON MovementDate_Insert.MovementId = Movement.Id
                                        AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                  LEFT JOIN MovementDate AS MovementDate_InsertMobile 
                                         ON MovementDate_InsertMobile.MovementId = Movement.Id
                                        AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert 
                                               ON MovementLinkObject_Insert.MovementId = Movement.Id
                                              AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                  LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                               ON MovementLinkObject_Partner.MovementId = Movement.Id
                                              AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                  LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
             
             WHERE Movement.Id = inMovementId
               AND Movement.DescId = zc_Movement_Visit();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 26.03.17         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Visit (inMovementId := 1, inOperDate := CURRENT_DATE, inSession := '9818')
