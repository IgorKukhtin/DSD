-- FunctiON: gpReport_CheckTaxCorrective ()

DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTaxCorrective (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inDocumentTaxKindId   Integer   , -- тип корректировки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber_ReturnIn TVarChar, InvNumber_TaxCorrective TVarChar
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , DocumentTaxKindName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Price TFloat
             , Amount_ReturnIn TFloat
             , Amount_TaxCorrective TFloat
             , Summ_ReturnIn TFloat
             , Summ_TaxCorrective TFloat
             , Summ_Diff TFloat
             , Difference Boolean
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

    WITH tmpMovement_TaxCorrective AS
                -- Корректировки
               (SELECT Movement.Id                                       AS MovementId_TaxCorrective
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , MovementLinkObject_From.ObjectId                  AS FromId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                WHERE Movement.DescId = zc_Movement_TaxCorrective()
                  AND Movement.StatusId = zc_Enum_Status_Complete() 
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  AND MovementLO_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_Prepay())
               )
       , tmpPartner_Corrective AS
               (SELECT PartnerId, ContractId FROM tmpMovement_TaxCorrective GROUP BY PartnerId, ContractId
               UNION
                SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId, tmpMovement_TaxCorrective.ContractId
                FROM tmpMovement_TaxCorrective
                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ChildObjectId = tmpMovement_TaxCorrective.FromId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                WHERE tmpMovement_TaxCorrective.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR())
                GROUP BY ObjectLink_Partner_Juridical.ObjectId, tmpMovement_TaxCorrective.ContractId
               )
       , tmpJuridical_Corrective AS
               (SELECT FromId AS JuridicalId, ContractId FROM tmpMovement_TaxCorrective GROUP BY FromId, ContractId
               )

    SELECT Movement_ReturnIn.InvNumber AS InvNumber_ReturnIn
         , Movement_TaxCorrective.InvNumber AS InvNumber_TaxCorrective
         , Object_From.ObjectCode AS FromCode
         , Object_From.ValueData AS FromName
         , Object_To.ObjectCode AS ToCode
         , Object_To.ValueData AS ToName
         , View_Contract_InvNumber.InvNumber AS ContractName
         , View_Contract_InvNumber.ContractTagName
         , Object_DocumentTaxKind.ValueData AS DocumentTaxKindName
         , Object_Partner.ObjectCode AS PartnerCode
         , Object_Partner.ValueData AS PartnerName
     
         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyName

         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , tmpGroupMovement.Price :: TFloat AS Price
         , tmpGroupMovement.Amount_ReturnIn :: TFloat AS Amount_ReturnIn
         , tmpGroupMovement.Amount_TaxCorrective :: TFloat AS Amount_TaxCorrective
        
           -- сумма
         , CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_ReturnIn
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_ReturnIn AS NUMERIC (16, 2))
           END :: TFloat AS Summ_ReturnIn
           -- сумма
         , CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_TaxCorrective
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_TaxCorrective AS NUMERIC (16, 2))
           END :: TFloat AS Summ_TaxCorrective

           -- сумма Diff
         , (CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_ReturnIn
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_ReturnIn AS NUMERIC (16, 2))
           END
         - CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_TaxCorrective
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_TaxCorrective AS NUMERIC (16, 2))
           END) :: TFloat AS Summ_Diff

         , CASE WHEN tmpGroupMovement.Amount_ReturnIn <> tmpGroupMovement.Amount_TaxCorrective
                     THEN TRUE 
                ELSE FALSE
           END :: Boolean AS Difference

    FROM (SELECT tmpMovement.FromId
               , tmpMovement.ToId
               , tmpMovement.PriceWithVAT
               , tmpMovement.VATPercent
               , tmpMovement.ContractId
               , tmpMovement.DocumentTaxKindId
               , tmpMovement.PartnerId
               , tmpMovement.MovementId_ReturnIn
               , MAX (tmpMovement.MovementId_TaxCorrective) AS MovementId_TaxCorrective
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId   
               , tmpMovement.Price
               , CASE WHEN SUM (tmpMovement.Amount_ReturnIn) > 0 THEN SUM (tmpMovement.Amount_ReturnIn) ELSE 0 END AS Amount_ReturnIn
               , SUM (tmpMovement.Amount_TaxCorrective)  AS Amount_TaxCorrective
               , CASE WHEN SUM (tmpMovement.Amount_ReturnIn) > 0 THEN SUM (CAST (tmpMovement.Amount_ReturnIn * tmpMovement.Price / tmpMovement.CountForPrice AS NUMERIC (16, 2))) ELSE 0 END AS Summ_ReturnIn
               , SUM (CAST (tmpMovement.Amount_TaxCorrective * tmpMovement.Price / tmpMovement.CountForPrice AS NUMERIC (16, 2))) AS Summ_TaxCorrective

          FROM  -- Продажа покупателю
               (SELECT ObjectLink_Partner_Juridical.ChildObjectId        AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                 THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                            WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                 THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                       END AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_To.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , 0 AS MovementId_ReturnIn
                     , 0 AS MovementId_TaxCorrective
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData             AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , -1 * SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                FROM (SELECT Movement.Id
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId = zc_Movement_Sale()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     ) AS Movement
                     INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                        AND Movement_Tax.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                                     
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                 AND MIFloat_Price.ValueData <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                     
                     LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                               ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                     LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                             ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                            AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

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
                GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                       , ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_To.ObjectId, 0)
                              ELSE 0
                         END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
               UNION ALL
                -- Возврат от покупателя
                SELECT ObjectLink_Partner_Juridical.ChildObjectId        AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                              OR MovementLO_DocumentTaxKind.ObjectId IS NULL
                                 THEN COALESCE (MovementLinkObject_From.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Corrective() OR MovementLO_DocumentTaxKind.ObjectId IS NULL THEN Movement.Id ELSE 0 END AS MovementId_ReturnIn
                     , 0 AS MovementId_TaxCorrective
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                FROM (SELECT Movement.Id
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId = zc_Movement_ReturnIn()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     ) AS Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN tmpPartner_Corrective ON tmpPartner_Corrective.PartnerId = MovementLinkObject_From.ObjectId
                                                    AND tmpPartner_Corrective.ContractId = MovementLinkObject_Contract.ObjectId

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                 AND MIFloat_Price.ValueData <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                     
                     LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                               ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                     LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                             ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                            AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                WHERE (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  AND (tmpPartner_Corrective.PartnerId > 0 OR MovementLO_DocumentTaxKind.ObjectId > 0)
                GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                       , ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                OR MovementLO_DocumentTaxKind.ObjectId IS NULL
                                   THEN COALESCE (MovementLinkObject_From.ObjectId, 0)
                              ELSE 0 
                         END
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Corrective() OR MovementLO_DocumentTaxKind.ObjectId IS NULL THEN Movement.Id ELSE 0 END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
               UNION ALL
                -- Перевод долга (приход)
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Corrective() THEN Movement.Id ELSE 0 END AS MovementId_ReturnIn
                     , 0 AS MovementId_TaxCorrective
                     , MovementItem.ObjectId               AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData             AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (MovementItem.Amount)           AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                FROM Movement 
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractFrom()
                     LEFT JOIN tmpPartner_Corrective ON tmpPartner_Corrective.PartnerId = MovementLinkObject_Partner.ObjectId
                                                    AND tmpPartner_Corrective.ContractId = MovementLinkObject_Contract.ObjectId
                     LEFT JOIN tmpJuridical_Corrective ON tmpJuridical_Corrective.JuridicalId = MovementLinkObject_From.ObjectId
                                                      AND tmpJuridical_Corrective.ContractId = MovementLinkObject_Contract.ObjectId

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                                     
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                 AND MIFloat_Price.ValueData <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                     
                     LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                               ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                     LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                             ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                            AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                WHERE Movement.DescId = zc_Movement_TransferDebtIn()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  AND (tmpPartner_Corrective.PartnerId > 0 OR tmpJuridical_Corrective.JuridicalId > 0 OR MovementLO_DocumentTaxKind.ObjectId > 0)

                GROUP BY MovementLinkObject_From.ObjectId
                       , ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                              ELSE 0 
                         END
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Corrective() THEN Movement.Id ELSE 0 END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
               UNION ALL
                -- Корректировки
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , MovementLinkObject_To.ObjectId                    AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , COALESCE (MovementLinkMovement.MovementChildId, 0) AS MovementId_ReturnIn
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_Corrective()
                                 THEN Movement.Id
                            ELSE 0 
                       END AS MovementId_TaxCorrective
                     , MovementItem.ObjectId   AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                     , MIFloat_Price.ValueData AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , 0 AS Amount_ReturnIn
                     , SUM (MovementItem.Amount) AS Amount_TaxCorrective
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId  = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()

                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                               ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                     LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                             ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                            AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     
                WHERE Movement.DescId = zc_Movement_TaxCorrective()
                  AND Movement.StatusId = zc_Enum_Status_Complete() 
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  AND MovementLO_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_Prepay())
                  
                GROUP BY MovementLinkObject_From.ObjectId
                       , MovementLinkObject_To.ObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , MovementLinkObject_Partner.ObjectId
                       , MovementLinkMovement.MovementChildId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_Corrective()
                                   THEN Movement.Id
                              ELSE 0 
                         END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
          ) AS tmpMovement 
          GROUP BY tmpMovement.FromId
                 , tmpMovement.ToId
                 , tmpMovement.PriceWithVAT
                 , tmpMovement.VATPercent
                 , tmpMovement.ContractId
                 , tmpMovement.DocumentTaxKindId
                 , tmpMovement.PartnerId
                 , tmpMovement.MovementId_ReturnIn
                 , tmpMovement.GoodsId
                 , tmpMovement.GoodsKindId
                 , tmpMovement.Price
       ) AS tmpGroupMovement
       
         LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = tmpGroupMovement.MovementId_ReturnIn
         LEFT JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = tmpGroupMovement.MovementId_TaxCorrective
         LEFT JOIN Object AS Object_From ON Object_From.Id = tmpGroupMovement.FromId
         LEFT JOIN Object AS Object_To ON Object_To.Id = tmpGroupMovement.ToId
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpGroupMovement.PartnerId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId
         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId
         LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpGroupMovement.ContractId
         LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId
    WHERE tmpGroupMovement.Amount_ReturnIn <> tmpGroupMovement.Amount_TaxCorrective
       OR (inDocumentTaxKindId <> 0
           AND (tmpGroupMovement.Amount_ReturnIn <> 0
                OR tmpGroupMovement.Amount_TaxCorrective <> 0)
          )
   ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckTaxCorrective (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.14                                        * add Summ_... 
 03.05.14                                        * all
 18.02.14         *  
*/

-- тест
-- SELECT * FROM gpReport_CheckTaxCorrective (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDocumentTaxKindId:= 0, inSession:= zfCalc_UserAdmin());
