-- Function: gpGet_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnion (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnion(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InvNumberInvoice TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , VATPercent TFloat
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             , isScan Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbisScan Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE :: TDateTime AS OperDate
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , CAST ('' AS TVarChar)     AS InvNumberInvoice
             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , 0                         AS ToId
             , CAST ('' AS TVarChar)     AS ToName 
             , 0                         AS PartnerId
             , CAST ('' AS TVarChar)     AS PartnerName
             
             , 0 ::TFloat                AS VATPercent

             , CAST ('' AS TVarChar)     AS Comment

             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate

             , 0                          AS MovementId_parent
             , CAST ('' as TVarChar)      AS InvNumber_parent
             , False                      AS isScan
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE
     
       vbisScan := EXISTS (SELECT MovementItem.Id
                           FROM MovementItem 
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Scan());

     RETURN QUERY

        SELECT
            Movement_ProductionUnion.Id
          , Movement_ProductionUnion.InvNumber
          , Movement_ProductionUnion.OperDate         AS OperDate
          , Object_Status.ObjectCode       AS StatusCode
          , Object_Status.ValueData        AS StatusName
          , MovementString_InvNumberInvoice.ValueData  AS InvNumberInvoice
          , Object_From.Id                 AS FromId
          , Object_From.ValueData          AS FromName
          , Object_To.Id                   AS ToId
          , Object_To.ValueData            AS ToName
          , Object_Partner.Id                          AS PartnerId
          , Object_Partner.ValueData                   AS PartnerName 
          , MovementFloat_VATPercent.ValueData         AS VATPercent

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

          , Object_Insert.Id               AS InsertId
          , Object_Insert.ValueData        AS InsertName
          , MovementDate_Insert.ValueData  AS InsertDate

          , Movement_Parent.Id             ::Integer  AS MovementId_parent
          , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent
          , vbisScan                       AS isScan
        FROM Movement AS Movement_ProductionUnion
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ProductionUnion.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_ProductionUnion.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_ProductionUnion.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ProductionUnion.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement_ProductionUnion.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_ProductionUnion.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_InvNumberInvoice
                                     ON MovementString_InvNumberInvoice.MovementId = Movement_ProductionUnion.Id
                                    AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_ProductionUnion.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_ProductionUnion.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement_ProductionUnion.ParentId
            LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

        WHERE Movement_ProductionUnion.Id = inMovementId
          AND Movement_ProductionUnion.DescId = zc_Movement_ProductionUnion()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.07.23         *
 12.07.21         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_ProductionUnion (inMovementId:= 3171 , inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')