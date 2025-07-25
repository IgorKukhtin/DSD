-- Function: gpSelect_Movement_Quality_Condra()

DROP FUNCTION IF EXISTS gpSelect_Movement_Quality_Condra (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Quality_Condra(
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId_edi         Integer
             , DocumentId_vch         TVarChar
             , DealId                 TVarChar
             , VchasnoId              TVarChar
             , DocId_vch              TVarChar
             , InvNumber_order        TVarChar
             , InvNumber              TVarChar
             , FileName               TVarChar
             , sender_gln             TVarChar
             , recipient_gln          TVarChar
             , buyer_gln              TVarChar
             , number                 TVarChar
             , document_function_code TVarChar
             , FileName_pdf           TVarChar
             , doc_to_attach_id       TVarChar
             , doc_to_attach_number   TVarChar
             , MetaData               Text
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     vbPaidKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo()));
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo()));

     --
     RETURN QUERY
       WITH tmpData AS (SELECT Movement.Id               AS MovementId
                             , Movement.InvNumber        AS InvNumber
                             , Movement_order.Id         AS MovementId_order
                             , Movement_EDI.Id           AS MovementId_edi
                           --, MovementString_InvNumberPartner.ValueData AS InvNumber_order
                             , MovementString_InvNumberPartner_order.ValueData AS InvNumber_order
                               --
                             , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                                      , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                                      , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                                      , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                                       ) AS SenderGLNCode
                               -- GLN одержувача повідомлення
                             , zfCalc_GLNCodeRetail
                                          (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                         , inGLNCodeRetail_partner := CASE WHEN TRIM (ObjectString_Partner_GLNCodeRetail.ValueData) = '4823036500001' THEN ObjectString_Partner_GLNCodeJuridical.ValueData ELSE ObjectString_Partner_GLNCodeRetail.ValueData END
                                         , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                         , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                          ) AS RecipientGLNCode

                               -- GLN покупця
                             , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                                      , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                                      , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                                       ) AS BuyerGLNCode

                               -- GLN місця доставки
                             , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode
                               --
                             , MovementString_DocumentId_vch.ValueData    AS DocumentId_vch
                             , MovementString_DealId.ValueData            AS DealId
                             , MovementString_VchasnoId.ValueData         AS VchasnoId
                             , MovementString_DocId_vch.ValueData         AS DocId_vch

                        FROM MovementLinkMovement AS MovementLinkMovement_Order
                             LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
                             LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                                      ON MovementString_InvNumberPartner_order.MovementId = Movement_order.Id
                                                     AND MovementString_InvNumberPartner_order.DescId     = zc_MovementString_InvNumberPartner()

                             LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_edi
                                                            ON MovementLinkMovement_Order_edi.MovementId = Movement_order.Id
                                                           AND MovementLinkMovement_Order_edi.DescId = zc_MovementLinkMovement_Order()
                             LEFT JOIN Movement AS Movement_EDI ON Movement_EDI.Id = MovementLinkMovement_Order_edi.MovementChildId
                             LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                      ON MovementString_InvNumberPartner.MovementId = Movement_EDI.Id
                                                     AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                             LEFT JOIN MovementString AS MovementString_DealId
                                                      ON MovementString_DealId.MovementId = Movement_EDI.Id
                                                     AND MovementString_DealId.DescId = zc_MovementString_DealId()
                             LEFT JOIN MovementString AS MovementString_DocumentId_vch
                                                      ON MovementString_DocumentId_vch.MovementId = Movement_EDI.Id
                                                     AND MovementString_DocumentId_vch.DescId = zc_MovementString_DocumentId_vch()
                             LEFT JOIN MovementString AS MovementString_VchasnoId
                                                      ON MovementString_VchasnoId.MovementId = Movement_EDI.Id
                                                     AND MovementString_VchasnoId.DescId = zc_MovementString_VchasnoId()
                             LEFT JOIN MovementString AS MovementString_DocId_vch
                                                      ON MovementString_DocId_vch.MovementId = Movement_EDI.Id
                                                     AND MovementString_DocId_vch.DescId     = zc_MovementString_DocId_vch()


                             LEFT JOIN Movement ON Movement.Id = inMovementId
                             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                    ON MovementDate_OperDatePartner.MovementId = inMovementId
                                                   AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = inMovementId
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                 AND vbContractId = 0


                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                          ON MovementLinkObject_Partner.MovementId = inMovementId
                                                         AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = inMovementId
                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                                 AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                             LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
                             LEFT JOIN ObjectDate AS ObjectDate_Signing
                                                  ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                                 AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                                 AND View_Contract.InvNumber <> '-'

                             -- Юридическое лицо(печать док.)
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                                  ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                                 AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                                 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                             -- Дата для Юр. лица история(печать док.)
                             LEFT JOIN ObjectDate AS ObjectDate_JuridicalDoc_Next
                                                  ON ObjectDate_JuridicalDoc_Next.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                                 AND ObjectDate_JuridicalDoc_Next.DescId   = zc_ObjectDate_Contract_JuridicalDoc_Next()
                                                 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                                                 AND ObjectDate_JuridicalDoc_Next.ValueData <= MovementDate_OperDatePartner.ValueData
                             -- Юридическое лицо история(печать док.)
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDoc_Next
                                                  ON ObjectLink_Contract_JuridicalDoc_Next.ObjectId = ObjectDate_JuridicalDoc_Next.ObjectId
                                                 AND ObjectLink_Contract_JuridicalDoc_Next.DescId   = zc_ObjectLink_Contract_JuridicalDoc_Next()
                                                 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()

                             LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                                                                         AS OH_JuridicalDetails_From
                                                                         ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDoc_Next.ChildObjectId
                                                                                                                           , ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                                           , View_Contract.JuridicalBasisId
                                                                                                                           , ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                           , Object_From.Id
                                                                                                                            )
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
                             LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                                    ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                                   AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

                             LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                                                                         AS OH_JuridicalDetails_To
                                                                         ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
                             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                             LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                                    ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                                   AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
                             LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                                    ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                   AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
                             LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                                    ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                   AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

                             LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                                    ON ObjectString_Partner_GLNCode.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                                   AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
                             LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                                    ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                                   AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
                             LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeRetail
                                                    ON ObjectString_Partner_GLNCodeRetail.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                                   AND ObjectString_Partner_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
                             LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                                    ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                                   AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

                        WHERE MovementLinkMovement_Order.MovementId = inMovementId
                          AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()
                       )
       SELECT
              tmpData.MovementId_edi
            , tmpData.DocumentId_vch
            , tmpData.DealId
            , tmpData.VchasnoId
            , tmpData.DocId_vch
            , tmpData.InvNumber_order
            , tmpData.InvNumber
              -- имя отправляемого файла (с диска)
            , (gpGet.outFileName || '.pdf') :: TVarChar AS FileName
              --
            , COALESCE (tmpData.SenderGLNCode, '')         :: TVarChar  AS sender_gln
            , CASE WHEN tmpData.RecipientGLNCode <> '' THEN tmpData.RecipientGLNCode ELSE COALESCE (tmpData.BuyerGLNCode, '') END :: TVarChar AS recipient_gln
            , COALESCE (tmpData.BuyerGLNCode, '')          :: TVarChar AS buyer_gln
            , ('Doc_' || COALESCE (tmpData.InvNumber, '')) :: TVarChar AS number -- tmpData.InvNumber_order
            , '2002'                                       :: TVarChar AS document_function_code
            , ''                                           :: TVarChar AS FileName_pdf
          --, COALESCE (gpGet.outFileName, '')             :: TVarChar AS FileName_pdf
            , COALESCE (tmpData.DocId_vch, '')             :: TVarChar AS doc_to_attach_id -- DocumentId_vch -- VchasnoId -- tmpData.DealId
            , COALESCE (tmpData.InvNumber_order, '')       :: TVarChar AS doc_to_attach_number

              -- джейсон с описанием
            , ('{"sender_gln": "' || COALESCE (tmpData.SenderGLNCode, '') || '",'
             ||'"recipient_gln": "' || CASE WHEN tmpData.RecipientGLNCode <> '' THEN tmpData.RecipientGLNCode ELSE COALESCE (tmpData.BuyerGLNCode, '') END || '",'
             ||'"buyer_gln": "' || COALESCE (tmpData.BuyerGLNCode, '') || '",'
             ||'"number": "' || COALESCE (tmpData.InvNumber, '') || '",' -- tmpData.InvNumber
             ||'"document_function_code": "2002",'
             ||'"file": "' || COALESCE (gpGet.outFileName, '') || '.pdf' || '",'
             ||'"doc_to_attach_id": "'  || COALESCE (tmpData.DocId_vch, '') || '",' -- DocumentId_vch -- VchasnoId
             ||'"doc_to_attach_number": "' || COALESCE (tmpData.InvNumber_order, '') || '"'
             ||'}') :: Text AS MetaData

       FROM gpGet_Movement_Quality_ReportName_export (inMovementId, inSession) AS gpGet
            LEFT JOIN tmpData ON tmpData.MovementId = inMovementId
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.07.25                                        *
*/

-- тест
-- SELECT *, right (MetaData, 200) FROM gpSelect_Movement_Quality_Condra (inMovementId:= 31811109 , inSession:= zfCalc_UserAdmin());
