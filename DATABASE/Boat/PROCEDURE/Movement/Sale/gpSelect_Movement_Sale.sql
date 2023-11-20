-- Function: gpSelect_Movement_Sale()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementId_Parent Integer, InvNumber_Parent TVarChar, InvNumber_Parent_choice TVarChar, Comment_parent TVarChar
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , Value_TaxKind TFloat, TaxKindId Integer, TaxKindName TVarChar, TaxKindName_info TVarChar
             )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!�������� ������!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_Sale AS (SELECT Movement_Sale.Id
                                 , Movement_Sale.ParentId
                                 , Movement_Sale.InvNumber
                                 , Movement_Sale.OperDate             AS OperDate
                                 , Movement_Sale.StatusId             AS StatusId
                                 , MovementLinkObject_To.ObjectId             AS ToId
                                 , MovementLinkObject_From.ObjectId           AS FromId
                            FROM tmpStatus
                                 INNER JOIN Movement AS Movement_Sale
                                                     ON Movement_Sale.StatusId = tmpStatus.StatusId
                                                    AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND Movement_Sale.DescId = zc_Movement_Sale()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           )


        SELECT Movement_Sale.Id
             , zfConvert_StringToNumber (Movement_Sale.InvNumber) ::Integer AS InvNumber
             , Movement_Sale.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , Movement_Parent.Id               AS MovementId_Parent
             , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_Parent
             , Movement_Parent.InvNumber               ::TVarChar AS InvNumber_Parent_choice
             , MovementString_Comment_parent.ValueData ::TVarChar AS Comment_parent

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)) :: TFloat AS TotalSummVAT

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName

             , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData        AS VATPercent

             , MovementString_Comment.ValueData :: TVarChar AS Comment
             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             , ObjectFloat_TaxKind_Value.ValueData          AS Value_TaxKind
             , Object_TaxKind.Id                            AS TaxKindId
             , Object_TaxKind.ValueData                     AS TaxKindName
             , ObjectString_TaxKind_Info.ValueData          AS TaxKindName_info
        FROM Movement_Sale

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Sale.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_Sale.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_Sale.ToId
        LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement_Sale.ParentId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_Sale.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Sale.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                ON MovementFloat_TotalSummPVAT.MovementId = Movement_Sale.Id
                               AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId = Movement_Sale.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement_Sale.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_Sale.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

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

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_Sale.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_Sale.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

        LEFT JOIN MovementString AS MovementString_Comment_parent
                                 ON MovementString_Comment_parent.MovementId = Movement_Parent.Id
                                AND MovementString_Comment_parent.DescId = zc_MovementString_Comment()

        --
        LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                             ON ObjectLink_TaxKind.ObjectId = Object_To.Id
                            AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
        LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
        LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                               ON ObjectString_TaxKind_Info.ObjectId = ObjectLink_TaxKind.ChildObjectId
                              AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.08.23         *
 12.08.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Sale (inStartDate:= '29.01.2016'::TDateTime, inEndDate:= '01.02.2016'::TDateTime, inIsErased := FALSE ::Boolean, inSession:= '2'::TVarChar)
