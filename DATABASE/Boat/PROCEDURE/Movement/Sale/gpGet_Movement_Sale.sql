-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementId_Parent Integer, InvNumber_Parent TVarChar, Comment_parent TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_Sale_seq') AS TVarChar) AS InvNumber
             , inOperDate   ::TDateTime  AS OperDate     --CURRENT_DATE
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , 0                         AS MovementId_Parent
             , CAST ('' AS TVarChar)     AS InvNumber_Parent
             , CAST ('' AS TVarChar)     AS Comment_parent
             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , 0                         AS ToId
             , CAST ('' AS TVarChar)     AS ToName
             , CAST ('' AS TVarChar)     AS Comment
             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                     ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis()
                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY

        SELECT 
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate      AS OperDate
          , Object_Status.ObjectCode    AS StatusCode
          , Object_Status.ValueData     AS StatusName
          , Movement_Parent.Id               AS MovementId_Parent
          , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_Parent
          , MovementString_Comment_parent.ValueData ::TVarChar AS Comment_parent
          , Object_From.Id              AS FromId
          , Object_From.ValueData       AS FromName
          , Object_To.Id                AS ToId      
          , Object_To.ValueData         AS ToName

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate

        FROM Movement AS Movement_Sale 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Sale.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement_Sale.ParentId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Sale.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Sale.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Sale.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment_parent
                                     ON MovementString_Comment_parent.MovementId = Movement_Parent.Id
                                    AND MovementString_Comment_parent.DescId = zc_MovementString_Comment()

        WHERE Movement_Sale.Id = inMovementId
          AND Movement_Sale.DescId = zc_Movement_Sale()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.21         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 0, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')