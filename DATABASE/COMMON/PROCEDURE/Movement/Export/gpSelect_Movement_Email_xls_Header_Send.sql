-- Function: gpSelect_Movement_Email_xls_Header_Send(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Email_xls_Header_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Email_xls_Header_Send(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Title TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartnerId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbOperDate        TDateTime;

   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
   DECLARE vbExportKindId Integer;

   DECLARE vbPaidKindId Integer;
   DECLARE vbChangePercent TFloat;

   DECLARE vbIsChangePrice Boolean;
   DECLARE vbIsDiscountPrice Boolean;
   
   DECLARE vbOKPO TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);

     vbOKPO:= (SELECT OH_JuridicalDetails.OKPO
               FROM MovementLinkObject
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails
                                                                  ON OH_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
               WHERE MovementLinkObject.MovementId = inMovementId
                 AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
               );


     -- параметры из документа
     RETURN QUERY
     WITH tmpBankAccount AS (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId             AS BankAccountId
                                    , COALESCE (ObjectLink_BankAccountContract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                                    , COALESCE (ObjectLink_BankAccountContract_Unit.ChildObjectId, 0)      AS UnitId
                               FROM ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                                                         ON ObjectLink_BankAccountContract_InfoMoney.ObjectId = ObjectLink_BankAccountContract_BankAccount.ObjectId
                                                        AND ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_Unit
                                                          ON ObjectLink_BankAccountContract_Unit.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                         AND ObjectLink_BankAccountContract_Unit.DescId = zc_ObjectLink_BankAccountContract_Unit()
                               WHERE ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                 AND ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NOT NULL
                              )
        , tmpObject_Bank_View AS(SELECT *
                                 FROM Object_Bank_View
                                 )

        , tmpData AS (SELECT Movement.InvNumber
                           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                           , Object_From.ValueData                  AS FromName
                           , OH_JuridicalDetails_From.FullName      AS JuridicalName_From
                           , OH_JuridicalDetails_From.JuridicalAddress AS JuridicalAddress_From
                           , OH_JuridicalDetails_From.OKPO          AS OKPO_from
                           , OH_JuridicalDetails_From.INN           AS INN_From
                           , OH_JuridicalDetails_From.NumberVAT     AS NumberVAT_From
                           , Object_Contract.ValueData              AS ContractName
                           , ObjectDate_Signing.ValueData           AS ContractSigningDate
                           , Object_ContractKind.ValueData          AS ContractKindName

                           , CASE WHEN COALESCE (OH_JuridicalDetails_From.BankAccount,'') <> '' THEN OH_JuridicalDetails_From.BankAccount ELSE Object_BankAccount.Name END   AS BankAccount_from
                           , CASE WHEN COALESCE (OH_JuridicalDetails_From.BankAccount,'') <> '' THEN OH_JuridicalDetails_From.BankName ELSE Object_BankAccount.BankName END  AS BankName_from
                           , CASE WHEN COALESCE (OH_JuridicalDetails_From.BankAccount,'') <> '' THEN OH_JuridicalDetails_From.MFO ELSE Object_BankAccount.MFO END            AS MFO_from
                           
                           , COALESCE (Object_BankAccount.Name,'')                 AS BankAccount_ByContract
                           , COALESCE (Object_BankAccount.BankName,'')             AS BankName_ByContract
                           , COALESCE (Object_BankAccount.MFO,'')                  AS BankMFO_ByContract
                           , COALESCE (Object_BankAccount.IBAN,'')                 AS BankIBAN_ByContract
                           , COALESCE (OHS_JD_JuridicalAddress_Bank_From.ValueData,'') AS JuridicalAddressBankFrom

                           , Object_To.ValueData                     AS ToName
                           , OH_JuridicalDetails_To.FullName         AS JuridicalName_To
                           , OH_JuridicalDetails_To.JuridicalAddress AS JuridicalAddress_to
                           , ObjectString_ToAddress.ValueData        AS PartnerAddress_To
                           , COALESCE (OH_JuridicalDetails_To.OKPO,'')             AS OKPO_To
                           , COALESCE (OH_JuridicalDetails_To.INN,'')              AS INN_To
                           , COALESCE (OH_JuridicalDetails_To.NumberVAT,'')        AS NumberVAT_To
                           , COALESCE (OH_JuridicalDetails_To.BankAccount,'')      AS BankAccount_To
                           , CASE WHEN COALESCE (OH_JuridicalDetails_To.BankName,'')= '' THEN Object_Bank_View_To.JuridicalName ELSE OH_JuridicalDetails_To.BankName END AS BankName_To
                           , CASE WHEN COALESCE (OH_JuridicalDetails_To.BankName,'')= '' THEN BankAccount_To.MFO ELSE OH_JuridicalDetails_To.MFO END AS BankMFO_To

                           , BankAccount_To.MFO                                 AS BankMFO_Int
                           , BankAccount_To.SWIFT                               AS BankSWIFT_Int
                           , BankAccount_To.IBAN                                AS BankIBAN_Int
                           , Object_Bank_View_To.JuridicalName                  AS BankJuridicalName_Int
                           , OHS_JD_JuridicalAddress_To.ValueData               AS BankJuridicalAddress_Int
                           , BankAccount_To.BeneficiarysAccount                 AS BenefAccount_Int
                           , BankAccount_To.Name                                AS BankAccount_Int

                           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                                  ELSE '' -- 'м.Днiпро'
                                  END  :: TVarChar   AS PlaceOf
                                  
                           , CASE WHEN MovementString_InvNumberPartner_order.ValueData <> ''
                                       THEN CASE WHEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) <> 0
                                                      THEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) :: TVarChar
                                                 ELSE MovementString_InvNumberPartner_order.ValueData
                                            END
                                  WHEN MovementString_InvNumberOrder.ValueData <> ''
                                       THEN MovementString_InvNumberOrder.ValueData
                                  ELSE COALESCE (Movement_order.InvNumber, '')
                             END AS InvNumberOrder
                           , COALESCE (Movement_order.OperDate, Movement.OperDate) :: TDateTime AS OperDateOrder
                           
                           , MS_InvNumberPartner_Master.ValueData               AS InvNumberPartner_Master
                      FROM Movement
                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                 AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                           LEFT JOIN Object AS Object_To   ON Object_To.Id   = MovementLinkObject_To.ObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       --
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                    ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                   AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                       LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                         ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                       LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
                       LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                                       ON MovementString_InvNumberPartner_order.MovementId = Movement_order.Id
                                                      AND MovementString_InvNumberPartner_order.DescId = zc_MovementString_InvNumberPartner()

                       LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                   ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                                  AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                    ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                   AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                       --LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

                       LEFT JOIN ObjectString AS ObjectString_ToAddress
                                              ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                             AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                            ON ObjectLink_Contract_JuridicalDocument.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                           AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                            ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                            ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                           AND COALESCE (MovementLinkObject_Contract.ObjectId,0) = 0

                       LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                           ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                                             , ObjectLink_Contract_JuridicalBasis.ChildObjectId
                                                                                                                             , ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                             , Object_From.Id)
                                                                          AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                          AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

                       LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                           ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                                          AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                                          AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

                       LEFT JOIN ObjectDate AS ObjectDate_Signing
                                            ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                           AND Object_Contract.ValueData <> '-'
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                            ON ObjectLink_Contract_ContractKind.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
                                           AND Object_Contract.ValueData <> '-'
                       LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                            ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                    -- bank account
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                            ON ObjectLink_Contract_BankAccount.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
           
                       LEFT JOIN tmpBankAccount AS tmpBankAccount1 ON tmpBankAccount1.UnitId      = MovementLinkObject_From.ObjectId
                                                                  AND tmpBankAccount1.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                                                                  AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                       LEFT JOIN tmpBankAccount AS tmpBankAccount2 ON tmpBankAccount2.UnitId      = MovementLinkObject_From.ObjectId
                                                                  AND tmpBankAccount2.InfoMoneyId = 0
                                                                  AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                                  AND tmpBankAccount1.BankAccountId IS NULL
                       LEFT JOIN tmpBankAccount AS tmpBankAccount3 ON tmpBankAccount3.UnitId      = 0
                                                                  AND tmpBankAccount3.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                                                                  AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                                  AND tmpBankAccount1.BankAccountId IS NULL
                                                                  AND tmpBankAccount2.BankAccountId IS NULL
                       LEFT JOIN tmpBankAccount AS tmpBankAccount4 ON tmpBankAccount4.UnitId      = 0
                                                                  AND tmpBankAccount4.InfoMoneyId = 0
                                                                  AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                                  AND tmpBankAccount1.BankAccountId IS NULL
                                                                  AND tmpBankAccount2.BankAccountId IS NULL
                                                                  AND tmpBankAccount3.BankAccountId IS NULL
                       LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (tmpBankAccount1.BankAccountId, COALESCE (tmpBankAccount2.BankAccountId, COALESCE (tmpBankAccount3.BankAccountId, tmpBankAccount4.BankAccountId))))

                       LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Bank_From
                                                                           ON OH_JuridicalDetails_Bank_From.JuridicalId = Object_BankAccount.BankJuridicalId
                                                                          AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Bank_From.StartDate
                                                                          AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Bank_From.EndDate

                       LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_Bank_From
                                                     ON OHS_JD_JuridicalAddress_Bank_From.ObjectHistoryId = OH_JuridicalDetails_Bank_From.ObjectHistoryId
                                                    AND OHS_JD_JuridicalAddress_Bank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

                       -- +++++++++++++++++ BANK TO
                       LEFT JOIN
                                  (SELECT *
                                   FROM Object_BankAccount_View
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = inMovementId
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                   LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            
            
                                  WHERE Object_BankAccount_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                  LIMIT 1
                                  ) AS BankAccount_To ON 1=1
            
                        LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
                        LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
                        LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

                        LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_To
                                                                            ON OH_JuridicalDetails_BenifBank_To.JuridicalId = Object_Bank_View_BenifBank.JuridicalId
                                                                           AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_To.StartDate
                                                                           AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) < OH_JuridicalDetails_BenifBank_To.EndDate
            
                        LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_BenifBank_To
                                                      ON OHS_JD_JuridicalAddress_BenifBank_To.ObjectHistoryId = OH_JuridicalDetails_BenifBank_To.ObjectHistoryId
                                                     AND OHS_JD_JuridicalAddress_BenifBank_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
            
            
                        LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetailsBank_To
                                                                            ON OH_JuridicalDetailsBank_To.JuridicalId = Object_Bank_View_To.JuridicalId
                                                                           AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetailsBank_To.StartDate
                                                                           AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetailsBank_To.EndDate
            
                        LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_To
                                                      ON OHS_JD_JuridicalAddress_To.ObjectHistoryId = OH_JuridicalDetailsBank_To.ObjectHistoryId
                                                     AND OHS_JD_JuridicalAddress_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()


                        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                             ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                        LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                               ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                              AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
                                             
                        --
                        LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                          ON MovementLinkMovement_Master.MovementId = Movement.Id
                                                         AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                        LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                                        ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                       AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
  
                      WHERE Movement.Id = inMovementId
                     )
   
   -- для vbOKPO = 2244900110  Недавній Олександр Миколайович ФОП  - максимально как печ. форма
      --- 
       SELECT ('Видаткова накладна № ' || tmpData.InvNumber||' від ' ||zfConvert_DateToString (tmpData.OperDatePartner)) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('') :: TBlob
         UNION ALL   --для 2244900110
       SELECT ('                                                                              № ПНЕ '||tmpData.InvNumberPartner_Master) :: TBlob
       FROM tmpData
       WHERE vbOKPO = '2244900110'
         UNION ALL   --для 2244900110
       SELECT ('                                                                              '||tmpData.ToName) :: TBlob
       FROM tmpData
       WHERE vbOKPO = '2244900110'
         UNION ALL
       SELECT ('Постачальник:  '||tmpData.JuridicalName_From) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('               П/р '||tmpData.BankAccount_ByContract||' у '||tmpData.BankName_ByContract||' МФО '||tmpData.BankMFO_ByContract) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('               '||tmpData.JuridicalAddressBankFrom) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('               код за ЄДРПОУ '||tmpData.OKPO_from||', IПН '||tmpData.INN_From ||', номер свiдоцтва '||tmpData.NumberVAT_From) :: TBlob
       FROM tmpData
         UNION ALL   --для 2244900110
       SELECT ('               адреса: '||tmpData.JuridicalAddress_From) :: TBlob
       FROM tmpData
       WHERE vbOKPO = '2244900110'
         UNION ALL
       SELECT ('') :: TBlob
         UNION ALL
       SELECT ('Одержувач:     '||tmpData.JuridicalName_To) :: TBlob
       FROM tmpData
         UNION ALL   --для 2244900110
       SELECT ('               адреса: '||tmpData.JuridicalAddress_to) :: TBlob
       FROM tmpData
       WHERE vbOKPO = '2244900110'
         UNION ALL
       SELECT ('               П/р '||tmpData.BankAccount_To||' у '||tmpData.BankName_To||' МФО '||tmpData.BankMFO_To) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('               '||tmpData.BankJuridicalAddress_Int) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('               код за ЄДРПОУ '||tmpData.OKPO_To||', IПН '||tmpData.INN_To || CASE WHEN tmpData.NumberVAT_To <> '' THEN ', номер свiдоцтва '||tmpData.NumberVAT_To ELSE '' END) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('') :: TBlob
         UNION ALL
       SELECT ('Договір:       '||tmpData.ContractKindName||' № '||tmpData.ContractName ||' від '||zfConvert_DateToString (tmpData.ContractSigningDate) ) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('Замовлення:    Замовлення покупця № '||tmpData.InvNumberOrder||'  від '||zfConvert_DateToString (tmpData.OperDateOrder) ) :: TBlob
       FROM tmpData
         UNION ALL
       SELECT ('Адреса доставки: '||tmpData.PartnerAddress_To) :: TBlob
       FROM tmpData
       WHERE vbOKPO <> '2244900110'
         UNION ALL
       SELECT '' :: TBlob

         UNION ALL   --для 2244900110
       SELECT ('Місце складання: '||tmpData.PlaceOf) :: TBlob
       FROM tmpData
       WHERE vbOKPO = '2244900110'

         UNION ALL
       SELECT '' :: TBlob
         UNION ALL
       SELECT '' :: TBlob

    -- || CHR (13) || 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.21         *
 01.04.21                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Email_xls_Header_Send (inMovementId:= 19556147 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_Email_xls_Header_Send (inMovementId:= 21495529 , inSession:= zfCalc_UserAdmin())
-- 2244900110  Недавній Олександр Миколайович ФОП
