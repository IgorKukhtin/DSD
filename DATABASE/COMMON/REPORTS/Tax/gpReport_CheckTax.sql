-- FunctiON: gpReport_CheckTax ()

DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTax (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inDocumentTaxKindId   Integer   , -- òèï íàëîãîâîé
    IN inSession             TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (InvNumber_Sale TVarChar, InvNumber_Tax TVarChar
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , DocumentTaxKindName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Price TFloat
             , Amount_Sale TFloat
             , Amount_Tax TFloat
             , Difference Boolean
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

    SELECT Movement_Sale.InvNumber AS InvNumber_Sale
         , Movement_Tax.InvNumber AS InvNumber_Tax
         , Object_From.ObjectCode AS FromCode
         , Object_From.ValueData AS FromName
         , Object_To.ObjectCode AS ToCode
         , Object_To.ValueData AS ToName
         , View_Contract_InvNumber.InvNumber AS ContractName
         , View_Contract_InvNumber.ContractTagName
         , Object_DocumentTaxKind.ValueData AS DocumentTaxKindName
         , Object_Partner.ObjectCode AS PartnerCode
         , Object_Partner.ValueData AS PartnerName
     
         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , tmpGroupMovement.Price :: TFloat AS Price
         , tmpGroupMovement.Amount_Sale :: TFloat AS Amount_Sale
         , tmpGroupMovement.Amount_Tax :: TFloat AS Amount_Tax
        
         , CASE WHEN tmpGroupMovement.Amount_Sale <> tmpGroupMovement.Amount_Tax
                     THEN TRUE 
                ELSE FALSE
           END :: Boolean AS Difference

    FROM (SELECT tmpMovement.FromId
               , tmpMovement.ToId
               , tmpMovement.ContractId
               , tmpMovement.DocumentTaxKindId
               , tmpMovement.PartnerId
               , tmpMovement.MovementId_Sale
               , MAX (tmpMovement.MovementId_Tax) AS MovementId_Tax
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId   
               , tmpMovement.Price
               , CASE WHEN SUM (tmpMovement.Amount_Sale) > 0 THEN SUM (tmpMovement.Amount_Sale) ELSE 0 END AS Amount_Sale
               , SUM (tmpMovement.Amount_Tax)  AS Amount_Tax
          FROM (SELECT ObjectLink_Contract_JuridicalBasis.ChildObjectId AS FromId
                     , ObjectLink_Partner_Juridical.ChildObjectId       AS ToId
                     , MovementLinkObject_Contract.ObjectId             AS ContractId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                 THEN zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                            WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                 THEN zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                       END AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_From.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , 0 AS MovementId_Sale
                     , 0 AS MovementId_Tax
                     , MovementItem.ObjectId               AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData             AS Price
                     , -1 * SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_Sale
                     , 0 AS Amount_Tax
                FROM Movement 
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                                     
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                 AND MIFloat_Price.ValueData <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                     
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                WHERE Movement.DescId = zc_Movement_ReturnIn()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND COALESCE (inDocumentTaxKindId, 0) IN (0, zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())

                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , ObjectLink_Partner_Juridical.ChildObjectId
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_From.ObjectId, 0)
                              ELSE 0
                         END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
               UNION ALL
                SELECT ObjectLink_Contract_JuridicalBasis.ChildObjectId AS FromId
                     , ObjectLink_Partner_Juridical.ChildObjectId       AS ToId
                     , MovementLinkObject_Contract.ObjectId             AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId              AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_To.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() THEN Movement.Id ELSE 0 END AS MovementId_Sale
                     , MovementLinkMovement.MovementChildId AS MovementId_Tax
                     , MovementItem.ObjectId                AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData              AS Price
                     , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_Sale
                     , 0 AS Amount_Tax
                FROM Movement 
                     INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                        AND Movement_Tax.StatusId <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId > 0

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                                     
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                 AND MIFloat_Price.ValueData <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                     
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                WHERE Movement.DescId = zc_Movement_Sale()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)

                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , ObjectLink_Partner_Juridical.ChildObjectId
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_To.ObjectId, 0)
                              ELSE 0 
                         END
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() THEN Movement.Id ELSE 0 END
                       , MovementLinkMovement.MovementChildId
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
               UNION ALL
                SELECT ObjectLink_Contract_JuridicalBasis.ChildObjectId AS FromId
                     , MovementLinkObject_To.ObjectId                   AS ToId
                     , MovementLinkObject_Contract.ObjectId             AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId              AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() THEN Movement.Id ELSE 0 END AS MovementId_Sale
                     , MovementLinkMovement.MovementChildId AS MovementId_Tax
                     , MovementItem.ObjectId                AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData              AS Price
                     , SUM (MovementItem.Amount)            AS Amount_Sale
                     , 0 AS Amount_Tax
                FROM Movement 
                     INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                        AND Movement_Tax.StatusId <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId > 0

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                                     
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                 AND MIFloat_Price.ValueData <> 0
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractTo()
                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                WHERE Movement.DescId = zc_Movement_TransferDebtOut()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)

                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementLinkObject_To.ObjectId
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                              ELSE 0 
                         END
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() THEN Movement.Id ELSE 0 END
                       , MovementLinkMovement.MovementChildId
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
               UNION ALL
                SELECT MovementLinkObject_From.ObjectId     AS FromId
                     , MovementLinkObject_To.ObjectId       AS ToId
                     , MovementLinkObject_Contract.ObjectId AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId  AS DocumentTaxKindId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , COALESCE (MovementLinkMovement.MovementId, 0) AS MovementId_Sale
                     , Movement.Id AS MovementId_Tax
                     , MovementItem.ObjectId AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                     , MIFloat_Price.ValueData AS Price
                     , 0 AS Amount_Sale
                     , SUM (MovementItem.Amount) AS Amount_Tax
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                                   AND MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()

                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.StatusId = zc_Enum_Status_Complete() 
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  
                GROUP BY MovementLinkObject_From.ObjectId
                       , MovementLinkObject_To.ObjectId
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , MovementLinkObject_Partner.ObjectId
                       , MovementLinkMovement.MovementId
                       , Movement.Id
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData

          ) AS tmpMovement 
          GROUP BY tmpMovement.FromId
                 , tmpMovement.ToId
                 , tmpMovement.ContractId
                 , tmpMovement.DocumentTaxKindId
                 , tmpMovement.PartnerId
                 , tmpMovement.MovementId_Sale
                 , tmpMovement.GoodsId
                 , tmpMovement.GoodsKindId
                 , tmpMovement.Price
       ) AS tmpGroupMovement
       
         LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpGroupMovement.MovementId_Sale
         LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = tmpGroupMovement.MovementId_Tax
         LEFT JOIN Object AS Object_From ON Object_From.Id = tmpGroupMovement.FromId
         LEFT JOIN Object AS Object_To ON Object_To.Id = tmpGroupMovement.ToId
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpGroupMovement.PartnerId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId
         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId
         LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpGroupMovement.ContractId
    WHERE tmpGroupMovement.Amount_Sale <> tmpGroupMovement.Amount_Tax
       OR (inDocumentTaxKindId <> 0
           AND (tmpGroupMovement.Amount_Sale <> 0
                OR tmpGroupMovement.Amount_Tax <> 0)
          )
   ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckTax (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 03.05.14                                        * all
 27.03.14         *
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 18.03.14         *
 17.02.14         * change Amount =  MIFloat_AmountPartner, - summ
 14.02.14         *  
*/

-- òåñò
-- SELECT * FROM gpReport_CheckTax (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDocumentTaxKindId:= 0, inSession:= zfCalc_UserAdmin());
