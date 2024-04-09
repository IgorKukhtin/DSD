-- FunctiON: gpReport_CheckTax ()

DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTax (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inDocumentTaxKindId   Integer   , -- тип налоговой
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber_Sale TVarChar, InvNumber_Tax TVarChar
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , DocumentTaxKindName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Price TFloat
             , Amount_Sale TFloat
             , Amount_Tax TFloat
             , Summ_Sale TFloat
             , Summ_Tax TFloat
             , Summ_Diff TFloat
             , Difference Boolean
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    RETURN QUERY


    WITH tmpMovement_Tax AS
                -- Налоговые
               (SELECT Movement.Id                                       AS MovementId_Tax
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , MovementLinkObject_To.ObjectId                    AS ToId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.StatusId = zc_Enum_Status_Complete() 
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                --AND MovementLO_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_Prepay())
               )
       , tmpPartner_Tax AS
               (SELECT PartnerId, ContractId FROM tmpMovement_Tax GROUP BY PartnerId, ContractId
               UNION
                SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId, tmpMovement_Tax.ContractId
                FROM tmpMovement_Tax
                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ChildObjectId = tmpMovement_Tax.ToId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                WHERE tmpMovement_Tax.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                GROUP BY ObjectLink_Partner_Juridical.ObjectId, tmpMovement_Tax.ContractId
               )
       , tmpJuridical_Tax AS
               (SELECT ToId AS JuridicalId, ContractId FROM tmpMovement_Tax GROUP BY ToId, ContractId
               )

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
     
         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyName

         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , tmpGroupMovement.Price :: TFloat AS Price
         , tmpGroupMovement.Amount_Sale :: TFloat AS Amount_Sale
         , tmpGroupMovement.Amount_Tax :: TFloat AS Amount_Tax
        
           -- сумма
         , CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_Sale
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_Sale AS NUMERIC (16, 2))
           END :: TFloat AS Summ_Sale
           -- сумма
         , CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_Tax
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_Tax AS NUMERIC (16, 2))
           END :: TFloat AS Summ_Tax

           -- сумма Diff
         , (CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_Sale
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_Sale AS NUMERIC (16, 2))
           END
         - CASE WHEN tmpGroupMovement.PriceWithVAT OR tmpGroupMovement.VATPercent = 0
                     -- если цены с НДС или %НДС=0
                     THEN tmpGroupMovement.Summ_Tax
                ELSE -- если цены без НДС
                     CAST ( (1 + tmpGroupMovement.VATPercent / 100) * tmpGroupMovement.Summ_Tax AS NUMERIC (16, 2))
           END) :: TFloat AS Summ_Diff

         , CASE WHEN tmpGroupMovement.Amount_Sale <> tmpGroupMovement.Amount_Tax
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
               , tmpMovement.MovementId_Sale
               , MAX (tmpMovement.MovementId_Tax) AS MovementId_Tax
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId   
               , tmpMovement.Price
               , CASE WHEN SUM (tmpMovement.Amount_Sale) > 0 THEN SUM (tmpMovement.Amount_Sale) ELSE 0 END AS Amount_Sale
               , SUM (tmpMovement.Amount_Tax)  AS Amount_Tax
               , CASE WHEN SUM (tmpMovement.Amount_Sale) > 0 THEN SUM (CAST (tmpMovement.Amount_Sale * tmpMovement.Price / tmpMovement.CountForPrice AS NUMERIC (16, 2))) ELSE 0 END AS Summ_Sale
               , SUM (CAST (tmpMovement.Amount_Tax * tmpMovement.Price / tmpMovement.CountForPrice AS NUMERIC (16, 2))) AS Summ_Tax
          FROM  -- Возврат от покупателя
               (SELECT ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS FromId
                     , ObjectLink_Partner_Juridical.ChildObjectId        AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
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
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                          , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                          , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            ELSE MIFloat_Price.ValueData
                       END AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , -1 * SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_Sale
                     , 0 AS Amount_Tax
                FROM (SELECT Movement.Id
                           , Movement.DescId AS MovementDescId
                           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId = zc_Movement_ReturnIn()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     ) AS Movement
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
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                 ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
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

                     LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                             ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                            AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , ObjectLink_Partner_Juridical.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_From.ObjectId, 0)
                              ELSE 0
                         END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                            , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                            , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              ELSE MIFloat_Price.ValueData
                         END
                       , MIFloat_CountForPrice.ValueData
                       , MIFloat_ChangePercent.ValueData
                       , Movement.MovementDescId
               UNION ALL
                -- Продажа покупателю
                SELECT ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS FromId
                     , ObjectLink_Partner_Juridical.ChildObjectId        AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                              OR Movement_Tax.Id IS NULL
                                 THEN COALESCE (MovementLinkObject_To.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() OR Movement_Tax.Id IS NULL THEN Movement.Id ELSE 0 END AS MovementId_Sale
                     , Movement_Tax.Id AS MovementId_Tax
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                          , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                          , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            ELSE MIFloat_Price.ValueData
                       END AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_Sale
                     , 0                                                   AS Amount_Tax
                FROM (SELECT Movement.Id
                           , Movement.DescId AS MovementDescId
                           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId = zc_Movement_Sale()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     ) AS Movement

                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                       AND Movement_Tax.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement_Tax.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN tmpPartner_Tax ON tmpPartner_Tax.PartnerId = MovementLinkObject_To.ObjectId
                                             AND tmpPartner_Tax.ContractId = MovementLinkObject_Contract.ObjectId

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased = FALSE
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                 AND MIFloat_Price.ValueData <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                 ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
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
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                     LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                             ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                            AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                WHERE (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
--                  AND Movement_Tax.Id > 0 -- AND MovementLO_DocumentTaxKind.ObjectId > 0
                  AND (tmpPartner_Tax.PartnerId > 0 OR Movement_Tax.Id > 0)

                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , ObjectLink_Partner_Juridical.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                OR Movement_Tax.Id IS NULL
                                   THEN COALESCE (MovementLinkObject_To.ObjectId, 0)
                              ELSE 0 
                         END
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() OR Movement_Tax.Id IS NULL THEN Movement.Id ELSE 0 END
                       , Movement_Tax.Id
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                            , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                            , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              ELSE MIFloat_Price.ValueData
                         END
                       , MIFloat_CountForPrice.ValueData
                       , MIFloat_ChangePercent.ValueData
                       , Movement.MovementDescId
               UNION ALL
                -- Перевод долга (расход)
                SELECT ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS FromId
                     , MovementLinkObject_To.ObjectId                    AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                              OR Movement_Tax.Id IS NULL
                                 THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() OR Movement_Tax.Id IS NULL THEN Movement.Id ELSE 0 END AS MovementId_Sale
                     , Movement_Tax.Id AS MovementId_Tax
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                                 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                            ELSE MIFloat_Price.ValueData
                       END AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (MovementItem.Amount) AS Amount_Sale
                     , 0                         AS Amount_Tax
                FROM Movement 
                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                       AND Movement_Tax.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = Movement_Tax.Id
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractTo()
                     LEFT JOIN tmpPartner_Tax ON tmpPartner_Tax.PartnerId = MovementLinkObject_Partner.ObjectId
                                             AND tmpPartner_Tax.ContractId = MovementLinkObject_Contract.ObjectId
                     LEFT JOIN tmpJuridical_Tax ON tmpJuridical_Tax.JuridicalId = MovementLinkObject_To.ObjectId
                                               AND tmpJuridical_Tax.ContractId = MovementLinkObject_Contract.ObjectId

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

                     LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                             ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                            AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                WHERE Movement.DescId = zc_Movement_TransferDebtOut()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
--                  AND Movement_Tax.Id > 0 -- AND MovementLO_DocumentTaxKind.ObjectId > 0
                  AND (tmpPartner_Tax.PartnerId > 0 OR tmpJuridical_Tax.JuridicalId > 0 OR Movement_Tax.Id > 0)

                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementLinkObject_To.ObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                OR Movement_Tax.Id IS NULL
                                   THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                              ELSE 0 
                         END
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax() OR Movement_Tax.Id IS NULL THEN Movement.Id ELSE 0 END
                       , Movement_Tax.Id
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
                       , MovementFloat_ChangePercent.ValueData

               UNION ALL
                -- Перевод долга (приход)
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                 THEN zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                            WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                 THEN zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                       END AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , 0 AS MovementId_Sale
                     , 0 AS MovementId_Tax
                     , MovementItem.ObjectId               AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData             AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , -1 * SUM (MovementItem.Amount)           AS Amount_Sale
                     , 0 AS Amount_Tax
                FROM Movement 
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractFrom()

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
                GROUP BY MovementLinkObject_From.ObjectId
                       , ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                              ELSE 0 
                         END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData

               UNION ALL
                -- Налоговые
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , MovementLinkObject_To.ObjectId                    AS ToId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId  AS DocumentTaxKindId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , COALESCE (MovementLinkMovement.MovementId, 0) AS MovementId_Sale
                     , Movement.Id AS MovementId_Tax
                     , MovementItem.ObjectId AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                     , MIFloat_Price.ValueData AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
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
                     
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.StatusId = zc_Enum_Status_Complete() 
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                --AND MovementLO_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_Prepay())
                  
                GROUP BY MovementLinkObject_From.ObjectId
                       , MovementLinkObject_To.ObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , MovementLinkObject_Partner.ObjectId
                       , MovementLinkMovement.MovementId
                       , Movement.Id
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
         LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.14                                        * add Summ_... 
 03.05.14                                        * add zc_MovementFloat_ChangePercent 
 03.05.14                                        * all
 27.03.14         *
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 18.03.14         *
 17.02.14         * change Amount =  MIFloat_AmountPartner, - summ
 14.02.14         *  
*/

-- тест
-- SELECT * FROM gpReport_CheckTax (inStartDate:= '01.01.2019', inEndDate:= '01.01.2019', inDocumentTaxKindId:= 0, inSession:= zfCalc_UserAdmin());
