-- Function: gpGet_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnOut (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnOut(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnOut());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar) AS InvNumber
             , inOperDate  ::TDateTime   AS OperDate     --CURRENT_DATE
             , NULL ::TDateTime          AS OperDatePartner 
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , CAST (False as Boolean)   AS PriceWithVAT
             , CAST (0 as TFloat)        AS VATPercent
             , CAST (0 as TFloat)        AS ChangePercent
             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , 0                         AS ToId
             , CAST ('' AS TVarChar)     AS ToName
             , 0                         AS PaidKindId
             , CAST ('' AS TVarChar)     AS PaidKindName
             , CAST ('' AS TVarChar)     AS Comment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY

        SELECT 
            Movement_ReturnOut.Id
          , Movement_ReturnOut.InvNumber
          , Movement_ReturnOut.OperDate               AS OperDate
          , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
          , Object_Status.ObjectCode                  AS StatusCode
          , Object_Status.ValueData                   AS StatusName

          , MovementBoolean_PriceWithVAT.ValueData    AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_ChangePercent.ValueData     AS ChangePercent

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , Object_PaidKind.Id                        AS PaidKindId      
          , Object_PaidKind.ValueData                 AS PaidKindName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_ReturnOut 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ReturnOut.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId 

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_ReturnOut.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()       

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_ReturnOut.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
    
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_ReturnOut.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_ReturnOut.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
    
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_ReturnOut.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_ReturnOut.Id = inMovementId
          AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.21         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_ReturnOut (inMovementId:= 0, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')