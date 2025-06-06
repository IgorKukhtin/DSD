-- Function: gpSelect_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement_EDI_Send (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI_Send(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inIsErased            Boolean   , --
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS TABLE (-- �������� ��� �������� � EDI
               Id Integer
               -- �������� ������� - �������� � EDI
             , ParentId Integer
               -- �������� ������
             , MovementId_order Integer
               --
             , isEdiOrdspr Boolean, isEdiInvoice Boolean, isEdiDesadv Boolean
               -- ����� Vchasno - EDI
             , isVchasnoEDI Boolean
               -- ������ ��� ��������
             , isError      Boolean
             , isError_EDI  Boolean
               -- �� - Comdoc, �������������� ��������
             , isEdiComdoc Boolean
               -- �� - Delnot, �������������� ��������
             , isEdiDelnot Boolean
               --
             , InvNumber TVarChar, OperDate TDateTime, UpdateDate TDateTime, OperDatePartner TDateTime
             , InvNumber_Parent TVarChar, OperDate_Parent TDateTime, OperDatePartner_Parent TDateTime
             , InvNumber_order TVarChar, InvNumberPartner_order TVarChar, OperDate_order TDateTime

             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, RetailId Integer, RetailName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , JuridicalName_To TVarChar
             , StatusCode Integer, StatusName TVarChar
             , StatusCode_sale Integer, StatusName_sale TVarChar
             , MovementDescName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_EDI());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ���������
    RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
           SELECT
                 -- �������� ��� �������� � EDI
                 Movement.Id                                    AS Id
                 -- �������� ������� - �������� � EDI
               , Movement.ParentId                              AS ParentId
                 -- �������� ������
               , Movement_order.Id                              AS MovementId_order
                 --
               , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
               , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
               , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv
                 -- ����� Vchasno - EDI
               , CASE WHEN COALESCE (TRIM (MovementString_DealId.ValueData), '') <> '' THEN TRUE ELSE FALSE END ::Boolean AS isVchasnoEDI
                 -- ������ ��� ��������
               , COALESCE (MovementBoolean_Error.ValueData, FALSE)      :: Boolean AS isError
                 -- ������ ��� ��������
               , COALESCE (MovementBoolean_Error_EDI.ValueData, FALSE)  :: Boolean AS isError_EDI
                 -- �� - Comdoc, �������������� ��������
               , COALESCE (MovementBoolean_EdiComdoc.ValueData, FALSE)  :: Boolean AS isEdiComdoc
                 -- �� - Delnot, �������������� ��������
               , COALESCE (MovementBoolean_EdiDelnot.ValueData, FALSE)  :: Boolean AS isEdiDelnot

               , Movement.InvNumber                             AS InvNumber
               , Movement.OperDate                              AS OperDate
               , MovementDate_Update.ValueData                  AS UpdateDate
               , MovementDate_OperDatePartner.ValueData         AS OperDatePartner

               , Movement_Parent.InvNumber                      AS InvNumber_Parent
               , Movement_Parent.OperDate                       AS OperDate_Parent
               , MovementDate_OperDatePartner_Parent.ValueData  AS OperDatePartner_Parent

               , Movement_order.InvNumber                       AS InvNumber_order
               , MS_InvNumberPartner_order.ValueData            AS InvNumberPartner_order
               , Movement_order.OperDate                        AS OperDate_order

               , Object_From.Id                         AS FromId
               , Object_From.ValueData                  AS FromName
               , Object_To.Id                           AS ToId
               , Object_To.ValueData                    AS ToName
               , Object_Retail.Id                       AS RetailId
               , Object_Retail.ValueData                AS RetailName
               , Object_PaidKind.Id                     AS PaidKindId
               , Object_PaidKind.ValueData              AS PaidKindName
               , Object_JuridicalTo.ValueData           AS JuridicalName_To

               , Object_Status.ObjectCode               AS StatusCode
               , Object_Status.ValueData                AS StatusName
               , Object_Status_sale.ObjectCode          AS StatusCode_sale
               , Object_Status_sale.ValueData           AS StatusName_sale
               , MovementDesc.ItemName     	            AS MovementDescName
               , MovementString_Comment.ValueData       AS Comment

           FROM (SELECT Movement.*
                 FROM tmpStatus
                      JOIN Movement ON Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 day'
                                   AND Movement.DescId = zc_Movement_EDI_Send()
                                   AND Movement.StatusId = tmpStatus.StatusId
                ) AS Movement
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementDate AS MovementDate_Update
                                       ON MovementDate_Update.MovementId = Movement.Id
                                      AND MovementDate_Update.DescId     = zc_MovementDate_Update()
                LEFT JOIN MovementString AS MovementString_Comment
                                         ON MovementString_Comment.MovementId = Movement.Id
                                        AND MovementString_Comment.DescId     = zc_MovementString_Comment()

                --  EDI - ������������� ������ 
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                          ON MovementBoolean_EdiOrdspr.MovementId = Movement.Id
                                         AND MovementBoolean_EdiOrdspr.DescId     = zc_MovementBoolean_EdiOrdspr()
                --  EDI - ����
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                          ON MovementBoolean_EdiInvoice.MovementId = Movement.Id
                                         AND MovementBoolean_EdiInvoice.DescId     = zc_MovementBoolean_EdiInvoice()
                --  EDI - ����������� �� ��������
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                          ON MovementBoolean_EdiDesadv.MovementId = Movement.Id
                                         AND MovementBoolean_EdiDesadv.DescId     = zc_MovementBoolean_EdiDesadv()

                -- COMDOC-��������� ��������
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiComdoc
                                          ON MovementBoolean_EdiComdoc.MovementId = Movement.Id
                                         AND MovementBoolean_EdiComdoc.DescId     = zc_MovementBoolean_EdiComdoc()
                -- DELNOT-��������� �������� 
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiDelnot
                                          ON MovementBoolean_EdiDelnot.MovementId = Movement.Id
                                         AND MovementBoolean_EdiDelnot.DescId     = zc_MovementBoolean_EdiDelnot()
                -- DELNOT-��������� �������� 
                LEFT JOIN MovementBoolean AS MovementBoolean_Error
                                          ON MovementBoolean_Error.MovementId = Movement.Id
                                         AND MovementBoolean_Error.DescId     = zc_MovementBoolean_Error()

                LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Parent.DescId
                LEFT JOIN Object AS Object_Status_sale ON Object_Status_sale.Id = Movement_Parent.StatusId
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Parent
                                       ON MovementDate_OperDatePartner_Parent.MovementId = Movement_Parent.Id
                                      AND MovementDate_OperDatePartner_Parent.DescId = zc_MovementDate_OperDatePartner()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement_Parent.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement_Parent.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement_Parent.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_JuridicalTo.Id
                                    AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                -- ������ ����������
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                               ON MovementLinkMovement_Order.MovementId = Movement_Parent.Id
                                              AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()
                LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
                LEFT JOIN MovementString AS MS_InvNumberPartner_order
                                         ON MS_InvNumberPartner_order.MovementId =  Movement_order.Id
                                        AND MS_InvNumberPartner_order.DescId     = zc_MovementString_InvNumberPartner()

                -- zc_Movement_EDI - ����� ����� ����������
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_EDI
                                               ON MovementLinkMovement_Order_EDI.MovementId = MovementLinkMovement_Order.MovementChildId
                                              AND MovementLinkMovement_Order_EDI.DescId     = zc_MovementLinkMovement_Order()

                LEFT JOIN MovementString AS MovementString_DealId
                                         ON MovementString_DealId.MovementId = MovementLinkMovement_Order_EDI.MovementChildId
                                        AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                LEFT JOIN MovementBoolean AS MovementBoolean_Error_EDI
                                          ON MovementBoolean_Error_EDI.MovementId = MovementLinkMovement_Order_EDI.MovementChildId
                                         AND MovementBoolean_Error_EDI.DescId     = zc_MovementBoolean_Error()
                                         
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_EDI_Send (inStartDate:= '28.03.2025', inEndDate:= '29.03.2025', inIsErased := FALSE, inSession:= '2')
