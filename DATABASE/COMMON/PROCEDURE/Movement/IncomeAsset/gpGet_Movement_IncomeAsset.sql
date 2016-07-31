-- Function: gpGet_Movement_IncomeAsset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeAsset (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeAsset(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , CurrencyValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, ToParentId Integer
             , PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar
             , PersonalPackerId Integer, PersonalPackerName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , PaidKindToId Integer, PaidKindToName TVarChar
             , ContractToId Integer, ContractToName TVarChar
             , ChangePercentTo TFloat
             , Comment TVarChar 
             , MovementId_Transport Integer, InvNumber_Transport TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_IncomeAsset_seq') AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , inOperDate                       AS OperDatePartner
             , CAST ('' as TVarChar)            AS InvNumberPartner

             , CAST (False as Boolean)          AS PriceWithVAT
             , CAST (20 as TFloat)              AS VATPercent
             , CAST (0 as TFloat)               AS ChangePercent
             
             , CAST (1 as TFloat)               AS CurrencyValue

             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName
             , 0                     AS ToParentId
             , 0                     AS PaidKindId
             , CAST ('' as TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' as TVarChar) AS ContractName
             , 0                     AS PersonalPackerId
             , CAST ('' as TVarChar) AS PersonalPackerName

             , ObjectCurrency.Id      AS CurrencyDocumentId	-- ���
             , ObjectCurrency.ValueData  AS CurrencyDocumentName
           
             , 0                     AS CurrencyPartnerId
             , CAST ('' as TVarChar) AS CurrencyPartnerName


             , 0                     		    AS PaidKindToId
             , CAST ('' as TVarChar) 		    AS PaidKindToName
             , 0                     		    AS ContractToId
             , CAST ('' as TVarChar) 		    AS ContractToName
             , CAST (0 as TFloat)                   AS ChangePercentTo
             , CAST ('' as TVarChar) 		    AS Comment

             , 0                                    AS MovementId_Transport
             , '' :: TVarChar                       AS InvNumber_Transport 

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              JOIN Object as ObjectCurrency on ObjectCurrency.descid= zc_Object_Currency()
                                            and ObjectCurrency.id = 14461;	             -- ���
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

             , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData          AS VATPercent
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent

             , MovementFloat_CurrencyValue.ValueData       AS CurrencyValue

             , Object_From.Id                        AS FromId
             , Object_From.ValueData                 AS FromName
             , Object_To.Id                          AS ToId
             , Object_To.ValueData                   AS ToName
             , ObjectLink_Unit_Parent.ChildObjectId  AS ToParentId
             , Object_PaidKind.Id                    AS PaidKindId
             , Object_PaidKind.ValueData             AS PaidKindName
             , View_Contract_InvNumber.ContractId    AS ContractId
             , View_Contract_InvNumber.InvNumber     AS ContractName
             , Object_Member.Id                      AS PersonalPackerId
             , Object_Member.ValueData               AS PersonalPackerName

             , COALESCE (Object_CurrencyDocument.Id, ObjectCurrencycyDocumentInf.Id)                AS CurrencyDocumentId
             , COALESCE (Object_CurrencyDocument.ValueData, ObjectCurrencycyDocumentInf.ValueData)  AS CurrencyDocumentName
             , Object_CurrencyPartner.Id             AS CurrencyPartnerId
             , Object_CurrencyPartner.ValueData      AS CurrencyPartnerName

             , Object_PaidKindTo.Id                	AS PaidKindToId
             , Object_PaidKindTo.ValueData         	AS PaidKindToName
             , View_ContractTo_InvNumber.ContractId     AS ContractToId
             , View_ContractTo_InvNumber.InvNumber      AS ContractToName

             , MovementFloat_ChangePercentTo.ValueData  AS ChangePercentTo
             , MovementString_Comment.ValueData         AS Comment

             , Movement_Transport.Id                     AS MovementId_Transport
             , ('� ' || Movement_Transport.InvNumber || ' �� ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar AS InvNumber_Transport

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()


            LEFT JOIN MovementFloat AS MovementFloat_ChangePercentTo
                                    ON MovementFloat_ChangePercentTo.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercentTo.DescId = zc_MovementFloat_ChangePercentPartner()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent ON ObjectLink_Unit_Parent.ObjectId = Object_To.Id AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                         ON MovementLinkObject_PersonalPacker.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_PersonalPacker.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId
	    
            LEFT JOIN Object as ObjectCurrencycyDocumentInf on ObjectCurrencycyDocumentInf.descid= zc_Object_Currency()
                                            and ObjectCurrencycyDocumentInf.id = 14461

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                         ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
            LEFT JOIN Object AS Object_PaidKindTo ON Object_PaidKindTo.Id = MovementLinkObject_PaidKindTo.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                         ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                        AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
            LEFT JOIN Object_Contract_InvNumber_View AS View_ContractTo_InvNumber ON View_ContractTo_InvNumber.ContractId = MovementLinkObject_ContractTo.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_IncomeAsset();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.07.16         * 
*/

-- ����
-- SELECT * FROM gpGet_Movement_IncomeAsset (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
