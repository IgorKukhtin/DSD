-- Function: gpGet_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS gpGet_Movement_TransferDebtOut (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_TransferDebtOut (Integer,  Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TransferDebtOut(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, isMask Boolean, InvNumber TVarChar, InvNumberPartner TVarChar, InvNumberOrder TVarChar
             , OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PartnerFromId Integer, PartnerFromName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar, ContractToId Integer, ContractToName TVarChar
             , PaidKindFromId Integer, PaidKindFromName TVarChar, PaidKindToId Integer, PaidKindToName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_Order Integer
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_TransferDebtOut_Mask (ioId        := inMovementId
                                                           , inOperDate  := inOperDate
                                                           , inSession   := inSession); 
     END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
           WITH tmpParams AS (SELECT 131931 AS FromId -- �������
                                   , (SELECT MAX (ContractId) FROM Object_Contract_View WHERE JuridicalId = 131931 AND InfoMoneyId = zc_Enum_InfoMoney_30103()) AS ContractFromId
                                   , zc_PriceList_Bread() AS PriceListId
                              WHERE EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Bread() AND UserId = vbUserId)
                             )
         SELECT
               0 	     	                    AS Id
             , FALSE                                AS isMask
             , tmpInvNum.InvNumber                  AS InvNumber
             , CAST ('' as TVarChar)                AS InvNumberPartner
             , CAST ('' as TVarChar)                AS InvNumberOrder 
             , inOperDate			    AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name              	    AS StatusName

             , CAST (FALSE AS Boolean)              AS Checked
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 AS TFloat)                   AS ChangePercent

             , CAST (0 as TFloat)                   AS TotalCountKg
             , CAST (0 as TFloat)                   AS TotalCountSh
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , CAST (0 as TFloat)                   AS TotalSumm

             , Object_From.Id                       AS FromId
             , Object_From.ValueData                AS FromName
             , 0                     	            AS ToId
             , CAST ('' as TVarChar)                AS ToName
             , 0                               	    AS PartnerId
             , CAST ('' as TVarChar)           	    AS PartnerName
             , 0                                    AS PartnerFromId
             , CAST ('' as TVarChar)                AS PartnerFromName

             , View_Contract_InvNumber.ContractId   AS ContractFromId
             , View_Contract_InvNumber.InvNumber    AS ContractFromName
             , 0                     	            AS ContractToId
             , CAST ('' as TVarChar) 	            AS ContractToName

             , Object_PaidKindFrom.Id 	            AS PaidKindFromId
             , Object_PaidKindFrom.ValueData        AS PaidKindFromName
             , 0                     	            AS PaidKindToId
             , CAST ('' as TVarChar) 	            AS PaidKindToName

             , Object_PriceList.Id                  AS PriceListId
             , Object_PriceList.ValueData           AS PriceListName

             , 0                     	    	    AS DocumentTaxKindId
             , CAST ('' AS TVarChar) 		    AS DocumentTaxKindName
             , 0                     		    AS MovementId_Master
             , CAST ('' AS TVarChar) 		    AS InvNumberPartner_Master
             , 0                     		    AS MovementId_Order

             , 0                   		    AS MovementId_TransportGoods 
             , '' :: TVarChar                  	    AS InvNumber_TransportGoods 
             , inOperDate                           AS OperDate_TransportGoods
             , CAST ('' as TVarChar) 		    AS Comment

          FROM (SELECT CAST (NEXTVAL ('movement_transferdebtout_seq') AS TVarChar) AS InvNumber) AS tmpInvNum
               LEFT JOIN lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status ON 1 = 1
               LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
               LEFT JOIN tmpParams ON 1 = 1
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (tmpParams.PriceListId, zc_PriceList_Basis())
               LEFT JOIN Object AS Object_From ON Object_From.Id = tmpParams.FromId
               LEFT JOIN Object AS Object_PaidKindFrom ON Object_PaidKindFrom.Id = zc_Enum_PaidKind_SecondForm()
               LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpParams.ContractFromId
         ;

     ELSE

     RETURN QUERY
           WITH tmpParams AS (SELECT zc_PriceList_Bread() AS PriceListId
                              WHERE EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Bread() AND UserId = vbUserId)
                             )
       SELECT
             Movement.Id		                AS Id
           , FALSE                                      AS isMask
           , Movement.InvNumber			        AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
           , Movement.OperDate			        AS OperDate
          
           , Object_Status.ObjectCode    	        AS StatusCode
           , Object_Status.ValueData     	        AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)        AS Checked
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)   AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent

           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalCount.ValueData         AS TotalCount

           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm

           , Object_From.Id                    		AS FromId
           , Object_From.ValueData             		AS FromName
           , Object_To.Id                      		AS ToId
           , Object_To.ValueData               		AS ToName
           , Object_Partner.Id                     	AS PartnerId
           , Object_Partner.ValueData              	AS PartnerName

           , Object_PartnerFrom.Id                     	AS PartnerFromId
           , Object_PartnerFrom.ValueData              	AS PartnerFromName

           , View_ContractFrom.ContractId     	        AS ContractFromId
           , View_ContractFrom.InvNumber                AS ContractFromName
           , View_ContractTo.ContractId                 AS ContractToId
           , View_ContractTo.InvNumber                  AS ContractToName

           , Object_PaidKindFrom.Id           	        AS PaidKindFromId
           , Object_PaidKindFrom.ValueData              AS PaidKindFromName
           , Object_PaidKindTo.Id                       AS PaidKindToId
           , Object_PaidKindTo.ValueData                AS PaidKindToName

           , Object_PriceList.id                        AS PriceListId
           , Object_PriceList.valuedata                 AS PriceListName

           , Object_TaxKind.Id                		    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         		    AS DocumentTaxKindName
           , MovementLinkMovement_Master.MovementChildId    AS MovementId_Master
           , MS_InvNumberPartner_Master.ValueData           AS InvNumberPartner_Master

           , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) AS OperDate_TransportGoods
           , MovementString_Comment.ValueData               AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerFrom						--����������(�� ����)
                                         ON MovementLinkObject_PartnerFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerFrom.DescId = zc_MovementLinkObject_PartnerFrom()
            LEFT JOIN Object AS Object_PartnerFrom ON Object_PartnerFrom.Id = MovementLinkObject_PartnerFrom.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                         ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
            LEFT JOIN Object_Contract_InvNumber_View AS View_ContractFrom ON View_ContractFrom.ContractId = MovementLinkObject_ContractFrom.ObjectId
            --LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                         ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                        AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
            LEFT JOIN Object_Contract_InvNumber_View AS View_ContractTo ON View_ContractTo.ContractId = MovementLinkObject_ContractTo.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindFrom
                                         ON MovementLinkObject_PaidKindFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKindFrom.DescId = zc_MovementLinkObject_PaidKindFrom()
            LEFT JOIN Object AS Object_PaidKindFrom ON Object_PaidKindFrom.Id = MovementLinkObject_PaidKindFrom.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                         ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
            LEFT JOIN Object AS Object_PaidKindTo ON Object_PaidKindTo.Id = MovementLinkObject_PaidKindTo.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                         AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId -- Movement_DocumentMaster.Id
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement_DocumentMaster.Id -- MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpParams ON 1 = 1
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (MovementLinkObject_PriceList.ObjectId, tmpParams.PriceListId, zc_PriceList_Basis())

--            LEFT JOIN tmpParams ON 1 = 1
--            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (tmpParams.PriceListId, zc_PriceList_Basis())

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TransferDebtOut();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TransferDebtOut (Integer, Boolean, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.08.21         * 
 13.01.16         * add inMask
 14.01.15         * add MovementId_Order
 17.12.14         * add InvNumberOrder
 03.09.14         * add Checked
 20.06.14                                                       * add InvNumberPartner
 17.05.14                                        * add Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
 07.05.14                                        * add tmpParams
 07.05.14                                        * add Partner...
 03.05.14                                        * all
 29.04.14  		                                         *
 22.04.14  		  *
*/

-- ����
-- SELECT * FROM gpGet_Movement_TransferDebtOut(inMovementId := 40859 , inMask:= FALSE, inOperDate := '25.01.2014',  inSession := '5'::TVarChar);