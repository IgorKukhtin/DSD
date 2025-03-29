-- Function: gpSelect_Movement_ZakazInternal()

 DROP FUNCTION IF EXISTS gpSelect_Movement_EDI (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, InvNumberRecadv TVarChar, OperDateTax TDateTime, InvNumberTax TVarChar
             , TotalCountPartner TFloat
             , TotalSumm TFloat
             , OKPO TVarChar, JuridicalName TVarChar
             , GLNCode TVarChar,  GLNPlaceCode TVarChar
             , JuridicalId_Find Integer, JuridicalNameFind TVarChar, PartnerNameFind TVarChar

             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , UnitId Integer, UnitName TVarChar
             , GoodsPropertyName TVarChar

             , MovementId_Sale Integer
             , OperDatePartner_Sale TDateTime, InvNumber_Sale TVarChar
             , FromName_Sale TVarChar, ToName_Sale TVarChar
             , TotalCountPartner_Sale TFloat
             , TotalSumm_Sale TFloat

             , MovementId_Tax Integer
             , OperDate_Tax TDateTime, InvNumberPartner_Tax TVarChar

             , MovementId_TaxCorrective Integer
             , OperDate_TaxCorrective TDateTime, InvNumberPartner_TaxCorrective TVarChar

             , MovementId_Order Integer
             , OperDate_Order TDateTime, InvNumber_Order TVarChar

             , DescName TVarChar
             , FileName TVarChar
             , DateRegistered  TDateTime
             , InvNumberRegistered TVarChar
             , PersonalSigningName TVarChar
             , isCheck Boolean
             , isElectron Boolean
             , isError Boolean
             , UserSign TVarChar
             , UserSeal TVarChar
             , UserKey  TVarChar
             , NameExite  TBlob
             , NameFiscal  TBlob
             , DealId         TVarChar
             , DocumentId_vch TVarChar
             , VchasnoId      TVarChar
             , isVchasno      Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUserSign TVarChar;
   DECLARE vbUserSeal TVarChar;
   DECLARE vbUserKey  TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_EDI());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


   if vbUserId = 5 and inStartDate   = inEndDate
   then inStartDate := DATE_TRUNC ('MONTH', inStartDate);
   end if;

     -- определяется
     SELECT CASE WHEN ObjectString_UserSign.ValueData <> '' THEN ObjectString_UserSign.ValueData ELSE '24447183_3524907224_SS181220125402.ZS2' /*'Ключ - Неграш О.В..ZS2'*/                                                  END AS UserSign
          , CASE WHEN ObjectString_UserSeal.ValueData <> '' THEN ObjectString_UserSeal.ValueData ELSE '24447183_S181220141414.ZS2' /*'Ключ - для в_дтиску - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2'*/   END AS UserSeal
          , CASE WHEN ObjectString_UserKey.ValueData  <> '' THEN ObjectString_UserKey.ValueData  ELSE '24447183_C181220141414.ZS2' /*'Ключ - для шифрування - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2'*/ END AS UserKey
            INTO vbUserSign, vbUserSeal, vbUserKey
     FROM Object AS Object_User
          LEFT JOIN ObjectString AS ObjectString_UserSign
                                 ON ObjectString_UserSign.DescId = zc_ObjectString_User_Sign()
                                AND ObjectString_UserSign.ObjectId = Object_User.Id
          LEFT JOIN ObjectString AS ObjectString_UserSeal
                                 ON ObjectString_UserSeal.DescId = zc_ObjectString_User_Seal()
                                AND ObjectString_UserSeal.ObjectId = Object_User.Id
          LEFT JOIN ObjectString AS ObjectString_UserKey
                                 ON ObjectString_UserKey.DescId = zc_ObjectString_User_Key()
                                AND ObjectString_UserKey.ObjectId = Object_User.Id
     WHERE Object_User.Id = vbUserId;


     --
     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode    AS StatusCode
           , Object_Status.ValueData     AS StatusName

           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , MovementString_InvNumberRecadv.ValueData       AS InvNumberRecadv

           , MovementDate_OperDateTax.ValueData             AS OperDateTax
           , MovementString_InvNumberTax.ValueData          AS InvNumberTax

           , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm

           , MovementString_OKPO.ValueData          AS OKPO
           , MovementString_JuridicalName.ValueData AS JuridicalName

           , MovementString_GLNCode.ValueData       AS GLNCode
           , MovementString_GLNPlaceCode.ValueData  AS GLNPlaceCode
           , Object_Juridical.Id                    AS JuridicalId_Find
           , Object_Juridical.ValueData             AS JuridicalNameFind
           , Object_Partner.ValueData               AS PartnerNameFind

           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName

           , Object_Unit.Id                         AS UnitId
           , Object_Unit.ValueData                  AS UnitName

           , Object_GoodsProperty.ValueData         AS GoodsPropertyName

           , COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId) :: Integer AS MovementId_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale
           , zfCalc_InvNumber_isErased_sh (Movement_Sale.InvNumber, Movement_Sale.StatusId) AS InvNumber_Sale
           , Object_From_Sale.ValueData                     AS FromName_Sale
           , Object_To_Sale.ValueData                       AS ToName_Sale
           , MovementFloat_TotalCountPartner_Sale.ValueData AS TotalCountPartner_Sale
           , MovementFloat_TotalSumm_Sale.ValueData         AS TotalSumm_Sale

           , COALESCE (MovementLinkMovement_Tax.MovementId, MovementLinkMovement_TaxCorrective_Tax.MovementChildId) :: Integer AS MovementId_Tax
           , Movement_Tax.OperDate                          AS OperDate_Tax
           , MovementString_InvNumberPartner_Tax.ValueData  AS InvNumberPartner_Tax

           , MovementLinkMovement_ChildEDI.MovementId                 AS MovementId_TaxCorrective
           , Movement_TaxCorrective.OperDate                          AS OperDate_Tax
           , MovementString_InvNumberPartner_TaxCorrective.ValueData  AS InvNumberPartner_Tax

           , MovementLinkMovement_Order.MovementId          AS MovementId_Order
           , Movement_Order.OperDate                        AS OperDate_Order
           , zfCalc_InvNumber_isErased_sh (Movement_Order.InvNumber, Movement_Order.StatusId) AS InvNumber_Order

           , MovementDesc.ItemName AS DescName
           , MovementString_FileName.ValueData              AS FileName
           , MovementDate_DateRegistered.ValueData          AS DateRegistered
           , MovementString_InvNumberRegistered.ValueData   AS InvNumberRegistered

           , COALESCE (Object_PersonalSigning.ValueData, COALESCE (ObjectString_PersonalBookkeeper.ValueData, Object_PersonalBookkeeper.ValueData, ''))  ::TVarChar    AS PersonalSigningName

           , CASE WHEN (MovementLinkMovement_Sale.MovementId IS NOT NULL OR MovementLinkMovement_MasterEDI.MovementId IS NOT NULL)
                   AND (COALESCE (MovementFloat_TotalCountPartner.ValueData, 0) <> COALESCE (MovementFloat_TotalCountPartner_Sale.ValueData, 0)
                     OR COALESCE (MovementFloat_TotalSumm_Sale.ValueData, 0) <> COALESCE (MovementFloat_TotalSumm.ValueData, 0))
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isCheck
           , COALESCE(MovementBoolean_Electron.ValueData, false) AS isElectron
           , COALESCE(MovementBoolean_Error.ValueData, false) AS isError

           , vbUserSign AS UserSign
           , vbUserSeal AS UserSeal
           , vbUserKey  AS UserKey

           , 'O=ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "Е-КОМ";PostalCode=01042;CN=ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "Е-КОМ";Serial=34241719;C=UA;L=місто КИЇВ;StreetAddress=провулок Новопечерський, буд. 19/3, корпус 1, к. 6'
              :: TBlob AS NameExite
           , 'O=Державна фіскальна служба України;CN=Державна фіскальна служба України.  ОТРИМАНО;Serial=2122385;C=UA;L=Київ'
              :: TBlob AS NameFiscal

           , MovementString_DealId.ValueData         ::TVarChar AS DealId
           , MovementString_DocumentId_vch.ValueData ::TVarChar AS DocumentId_vch
           , MovementString_VchasnoId.ValueData      ::TVarChar AS VchasnoId
           , CASE WHEN COALESCE (TRIM (MovementString_DealId.ValueData), '') <> '' THEN TRUE ELSE FALSE END ::Boolean AS isVchasno

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementBoolean AS MovementBoolean_Error
                                      ON MovementBoolean_Error.MovementId =  Movement.Id
                                     AND MovementBoolean_Error.DescId = zc_MovementBoolean_Error()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId =  Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
            LEFT JOIN MovementString AS MovementString_FileName
                                     ON MovementString_FileName.MovementId =  Movement.Id
                                    AND MovementString_FileName.DescId = zc_MovementString_FileName()

            LEFT JOIN MovementString AS MovementString_Desc
                                     ON MovementString_Desc.MovementId =  Movement.Id
                                    AND MovementString_Desc.DescId = zc_MovementString_Desc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_JuridicalName
                                     ON MovementString_JuridicalName.MovementId =  Movement.Id
                                    AND MovementString_JuridicalName.DescId = zc_MovementString_JuridicalName()
            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
            LEFT JOIN MovementString AS MovementString_GLNCode
                                     ON MovementString_GLNCode.MovementId =  Movement.Id
                                    AND MovementString_GLNCode.DescId = zc_MovementString_GLNCode()
            LEFT JOIN MovementString AS MovementString_GLNPlaceCode
                                     ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                    AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberRecadv
                                     ON MovementString_InvNumberRecadv.MovementId =  Movement.Id
                                    AND MovementString_InvNumberRecadv.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementDate AS MovementDate_OperDateTax
                                   ON MovementDate_OperDateTax.MovementId =  Movement.Id
                                  AND MovementDate_OperDateTax.DescId = zc_MovementDate_OperDateTax()
            LEFT JOIN MovementString AS MovementString_InvNumberTax
                                     ON MovementString_InvNumberTax.MovementId =  Movement.Id
                                    AND MovementString_InvNumberTax.DescId = zc_MovementString_InvNumberTax()

            LEFT JOIN MovementString AS MovementString_MovementDesc
                                     ON MovementString_MovementDesc.MovementId =  Movement.Id
                                    AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
            LEFT JOIN MovementDesc ON MovementDesc.Code =  MovementString_MovementDesc.ValueData

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                         ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                        AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = MovementLinkObject_GoodsProperty.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                           ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId)
                                               -- AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Sale
                                   ON MovementDate_OperDatePartner_Sale.MovementId =  Movement_Sale.Id
                                  AND MovementDate_OperDatePartner_Sale.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner_Sale
                                    ON MovementFloat_TotalCountPartner_Sale.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountPartner_Sale.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_Sale
                                    ON MovementFloat_TotalSumm_Sale.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalSumm_Sale.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Sale
                                         ON MovementLinkObject_From_Sale.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From_Sale.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From_Sale ON Object_From_Sale.Id = MovementLinkObject_From_Sale.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To_Sale
                                         ON MovementLinkObject_To_Sale.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To_Sale.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To_Sale ON Object_To_Sale.Id = MovementLinkObject_To_Sale.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                           ON MovementLinkMovement_ChildEDI.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TaxCorrective_Tax
                                           ON MovementLinkMovement_TaxCorrective_Tax.MovementId = MovementLinkMovement_ChildEDI.MovementId
                                          AND MovementLinkMovement_TaxCorrective_Tax.DescId = zc_MovementLinkMovement_Child()

            LEFT JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = MovementLinkMovement_ChildEDI.MovementId
                                                        -- AND Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner_TaxCorrective
                                     ON MovementString_InvNumberPartner_TaxCorrective.MovementId =  Movement_TaxCorrective.Id
                                    AND MovementString_InvNumberPartner_TaxCorrective.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Tax()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = COALESCE (MovementLinkMovement_Tax.MovementId, MovementLinkMovement_TaxCorrective_Tax.MovementChildId)
                                              AND Movement_Tax.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Tax
                                     ON MovementString_InvNumberPartner_Tax.MovementId =  Movement_Tax.Id
                                    AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                              --AND Movement_Order.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                 ON ObjectLink_Contract_PersonalSigning.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
            LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Contract_PersonalSigning.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement_Tax.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MovementLinkObject_Branch.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object AS Object_PersonalBookkeeper ON Object_PersonalBookkeeper.Id = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                   ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                  AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()

            LEFT JOIN MovementString AS MovementString_DealId
                                     ON MovementString_DealId.MovementId = Movement.Id
                                    AND MovementString_DealId.DescId     = zc_MovementString_DealId()
            LEFT JOIN MovementString AS MovementString_DocumentId_vch
                                     ON MovementString_DocumentId_vch.MovementId = Movement.Id
                                    AND MovementString_DocumentId_vch.DescId     = zc_MovementString_DocumentId_vch()
            LEFT JOIN MovementString AS MovementString_VchasnoId
                                     ON MovementString_VchasnoId.MovementId = Movement.Id
                                    AND MovementString_VchasnoId.DescId     = zc_MovementString_VchasnoId()
       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND Movement.StatusId <> zc_Enum_Status_Erased()
         -- AND MovementString_OKPO.ValueData IN ('36387233', '36387249', '38916588')
         -- *** AND (Movement_TaxCorrective.Id IS NULL OR Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete())
         -- *** AND (Movement_Sale.Id IS NULL OR Movement_Sale.StatusId = zc_Enum_Status_Complete())

       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.25         * DocumentId_vch, VchasnoId 
 16.02.15                         *
 19.10.14                                        * add Contract... AND Unit...
 09.10.14                                        * rem --***
 20.07.14                                        * ALL
 15.05.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_EDI (inStartDate:= '23.11.2016', inEndDate:= '23.11.2016', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_EDI (inStartDate:= CURRENT_DATE - INTERVAL '7 DAY', inEndDate:= CURRENT_DATE, inSession:= '412575')
