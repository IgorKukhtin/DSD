-- FunctiON: gpReport_CheckTaxCorrective ()

DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTaxCorrective (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inDocumentTaxKindId   Integer   , -- тип корректировки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber_ReturnIn TVarChar, InvNumberPartner_ReturnIn TVarChar
             , InvNumber_TaxCorrective TVarChar, InvNumberPartner_TaxCorrective TVarChar
             , OperDate_TaxCorrective TDateTime
             , InvNumber_Tax TVarChar, InvNumberPartner_Tax TVarChar
             , OperDate_Tax TDateTime
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , DocumentTaxKindName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Price TFloat
             , Amount_ReturnIn TFloat
             , Amount_TaxCorrective TFloat
             , Summ_ReturnIn TFloat
             , Summ_TaxCorrective TFloat
             , Summ_Diff TFloat
             , Difference Boolean
             , isDate_Err Boolean
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


-- update Movement set OperDate = '19.07.2022' WHERE Id = 23221889 ;


    RETURN QUERY

    WITH tmpMovement_TaxCorrective AS
                -- Корректировки
               (SELECT Movement.Id                                       AS MovementId_TaxCorrective
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , MovementLinkObject_From.ObjectId                  AS JuridicalId
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
                --AND MovementLO_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_Prepay())
               )
       , tmpUnit_Corrective AS
               (SELECT tmpMovement_TaxCorrective.DocumentTaxKindId
                     , tmpMovement_TaxCorrective.JuridicalId
                     , tmpMovement_TaxCorrective.PartnerId
                     , tmpMovement_TaxCorrective.ContractId
                     , CASE WHEN tmpMovement_TaxCorrective.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_Corrective())
                                 THEN COALESCE (MovementLinkObject_To.ObjectId, -1)
                            ELSE 0
                       END AS UnitId
                FROM tmpMovement_TaxCorrective
                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                     ON MovementLinkMovement_Master.MovementId = tmpMovement_TaxCorrective.MovementId_TaxCorrective
                                                    AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = MovementLinkMovement_Master.MovementChildId
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_DocumentTaxKind()
                GROUP BY tmpMovement_TaxCorrective.DocumentTaxKindId
                       , tmpMovement_TaxCorrective.JuridicalId
                       , tmpMovement_TaxCorrective.PartnerId
                       , tmpMovement_TaxCorrective.ContractId
                       , MovementLinkObject_To.ObjectId
               )
       , tmpPartner_Corrective AS
               (SELECT PartnerId, ContractId, UnitId FROM tmpUnit_Corrective GROUP BY PartnerId, ContractId, UnitId
               UNION
                SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId, tmpUnit_Corrective.ContractId, tmpUnit_Corrective.UnitId
                FROM tmpUnit_Corrective
                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ChildObjectId = tmpUnit_Corrective.JuridicalId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                WHERE tmpUnit_Corrective.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR())
                GROUP BY ObjectLink_Partner_Juridical.ObjectId, tmpUnit_Corrective.ContractId, tmpUnit_Corrective.UnitId
               )
       , tmpPartner_Corrective_two AS
               (SELECT PartnerId, ContractId FROM tmpPartner_Corrective GROUP BY PartnerId, ContractId
               )
       , tmpJuridical_Corrective AS
               (SELECT JuridicalId, ContractId FROM tmpUnit_Corrective GROUP BY JuridicalId, ContractId
               )
/*       , tmpReturnIn_Movement AS
                     (SELECT Movement.Id                            AS Id
                           , Movement.DescId                        AS MovementDescId
                           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
                           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id       = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId   = zc_Movement_ReturnIn()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     )*/
       , tmpReturnIn_child AS
               (SELECT MovementItem.ParentId       AS ParentId
                     , MAX (Movement_Tax.OperDate) AS OperDate_tax
             -- FROM tmpReturnIn_Movement AS Movement
                FROM (SELECT Movement.Id                            AS Id
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id       = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId   = zc_Movement_ReturnIn()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        AND vbUserId NOT IN (5, 6604558)
                     ) AS Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN tmpPartner_Corrective ON tmpPartner_Corrective.PartnerId = MovementLinkObject_From.ObjectId
                                                    AND tmpPartner_Corrective.ContractId = MovementLinkObject_Contract.ObjectId
                                                    AND (tmpPartner_Corrective.UnitId = MovementLinkObject_To.ObjectId OR tmpPartner_Corrective.UnitId = 0)

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = FALSE
                                            AND MovementItem.DescId     = zc_MI_Child()
                                            AND MovementItem.Amount     <> 0

                     LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()                         
                     LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MIFloat_MovementId.ValueData :: Integer
                     LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                    ON MovementLinkMovement_Tax.MovementId = Movement_Sale.Id
                                                   AND MovementLinkMovement_Tax.DescId     = zc_MovementLinkMovement_Master()
                     LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId

                WHERE (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                --AND (tmpPartner_Corrective.PartnerId > 0 OR MovementLO_DocumentTaxKind.ObjectId > 0)
                GROUP BY MovementItem.ParentId
               )

    -- Результат
    SELECT Movement_ReturnIn.InvNumber                        AS InvNumber_ReturnIn
         , MovementString_InvNumberPartner_ReturnIn.ValueData AS InvNumberPartner_ReturnIn

         , Movement_TaxCorrective.InvNumber                AS InvNumber_TaxCorrective
         , MovementString_InvNumberPartner_TaxCorrective.ValueData AS InvNumberPartner_TaxCorrective
         , Movement_TaxCorrective.OperDate                 AS OperDate_TaxCorrective

         , Movement_DocumentChild.InvNumber                AS InvNumber_Tax
         , MovementString_InvNumberPartner_Tax.ValueData   AS InvNumberPartner_Tax
         , Movement_DocumentChild.OperDate                 AS OperDate_Tax

         , Object_From.ObjectCode                          AS FromCode
         , Object_From.ValueData                           AS FromName
         , Object_To.ObjectCode                            AS ToCode
         , Object_To.ValueData                             AS ToName
         , View_Contract_InvNumber.InvNumber               AS ContractName
         , View_Contract_InvNumber.ContractTagName         AS ContractTagName
         , Object_DocumentTaxKind.ValueData                AS DocumentTaxKindName
         , Object_Partner.ObjectCode                       AS PartnerCode
         , Object_Partner.ValueData                        AS PartnerName

         , Object_Branch.ObjectCode                        AS BranchCode
         , Object_Branch.ValueData                         AS BranchName

         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyName

         , Object_Goods.ObjectCode           AS GoodsCode
         , Object_Goods.ValueData            AS GoodsName
         , Object_GoodsKind.ValueData        AS GoodsKindName
     
         , tmpGroupMovement.Price                :: TFloat AS Price
         , tmpGroupMovement.Amount_ReturnIn      :: TFloat AS Amount_ReturnIn
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
         , CASE WHEN Movement_TaxCorrective.OperDate < Movement_DocumentChild.OperDate THEN TRUE ELSE FALSE END ::Boolean AS isDate_Err

    FROM (SELECT tmpMovement.FromId
               , tmpMovement.ToId
               , MAX (tmpMovement.BranchId) AS BranchId
               , tmpMovement.PriceWithVAT
               , tmpMovement.VATPercent
               , tmpMovement.ContractId
               , tmpMovement.DocumentTaxKindId
               , tmpMovement.PartnerId
               , tmpMovement.MovementId_ReturnIn
               , MAX (tmpMovement.MovementId_TaxCorrective)     AS MovementId_TaxCorrective
               , MAX (tmpMovement.MovementId_TaxCorrective_err) AS MovementId_TaxCorrective_err
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId   
               , tmpMovement.Price
               , CASE WHEN SUM (tmpMovement.Amount_ReturnIn) > 0 THEN SUM (tmpMovement.Amount_ReturnIn) ELSE SUM (tmpMovement.Amount_ReturnIn) END AS Amount_ReturnIn
               , SUM (tmpMovement.Amount_TaxCorrective)  AS Amount_TaxCorrective
               , CASE WHEN SUM (tmpMovement.Amount_ReturnIn) > 0 THEN SUM (CAST (tmpMovement.Amount_ReturnIn * tmpMovement.Price / tmpMovement.CountForPrice AS NUMERIC (16, 2))) ELSE 0 END AS Summ_ReturnIn
               , SUM (CAST (tmpMovement.Amount_TaxCorrective * tmpMovement.Price / tmpMovement.CountForPrice AS NUMERIC (16, 2))) AS Summ_TaxCorrective

          FROM  -- Продажа покупателю
               (SELECT ObjectLink_Partner_Juridical.ChildObjectId        AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0) AS BranchId
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
                     , 0 AS MovementId_TaxCorrective_err
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     -- , MIFloat_Price.ValueData                       AS Price
                     , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                          , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            WHEN Movement.ChangePercent <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                          , inChangePercent:= Movement.ChangePercent
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            ELSE COALESCE (MIFloat_Price.ValueData, 0)
                       END AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , -1 * SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                     , 0 AS MovementId_Tax
                FROM (SELECT Movement.Id
                           , Movement.DescId AS MovementDescId
                           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
                           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id       = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId   = zc_Movement_Sale()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                                  AND MovementFloat_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        AND vbUserId NOT IN (5, 6604558)
                     ) AS Movement
                     INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN Movement AS Movement_Tax ON Movement_Tax.Id       = MovementLinkMovement.MovementChildId
                                                        AND Movement_Tax.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                     
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

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                          ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                     
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
                       , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                            , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              WHEN Movement.ChangePercent <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := Movement.OperDatePartner
                                                            , inChangePercent:= Movement.ChangePercent
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              ELSE COALESCE (MIFloat_Price.ValueData, 0)
                         END
                       , MIFloat_CountForPrice.ValueData
                       , Movement.MovementDescId
                       , COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0)
               UNION ALL
                -- Возврат от покупателя
                SELECT ObjectLink_Partner_Juridical.ChildObjectId        AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0) AS BranchId
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
                     , 0 AS MovementId_TaxCorrective_err
                     , MovementItem.ObjectId                         AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     -- , MIFloat_Price.ValueData                      AS Price
                     , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, Movement.OperDatePartner)
                                                          , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            WHEN Movement.ChangePercent <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                 THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, Movement.OperDatePartner)
                                                          , inChangePercent:= Movement.ChangePercent
                                                          , inPrice        := MIFloat_Price.ValueData
                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                           )
                            ELSE COALESCE (MIFloat_Price.ValueData, 0)
                       END AS Price

                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                     , 0 AS MovementId_Tax
             -- FROM tmpReturnIn_Movement AS Movement
                FROM (SELECT Movement.Id                            AS Id
                           , Movement.DescId                        AS MovementDescId
                           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
                           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      FROM MovementDate AS MovementDate_OperDatePartner
                           JOIN Movement ON Movement.Id       = MovementDate_OperDatePartner.MovementId
                                        AND Movement.DescId   = zc_Movement_ReturnIn()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                         ON MovementLinkObject_PaidKind.MovementId = MovementDate_OperDatePartner.MovementId
                                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                        AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        AND vbUserId NOT IN (5, 6604558)
                     ) AS Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN tmpPartner_Corrective ON tmpPartner_Corrective.PartnerId = MovementLinkObject_From.ObjectId
                                                    AND tmpPartner_Corrective.ContractId = MovementLinkObject_Contract.ObjectId
                                                    AND (tmpPartner_Corrective.UnitId = MovementLinkObject_To.ObjectId OR tmpPartner_Corrective.UnitId = 0)

                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                          ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
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
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                     LEFT JOIN tmpReturnIn_child ON tmpReturnIn_child.ParentId = MovementItem.Id

                WHERE (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  --AND (tmpPartner_Corrective.PartnerId > 0 OR MovementLO_DocumentTaxKind.ObjectId > 0)
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
                       , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, Movement.OperDatePartner)
                                                            , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              WHEN Movement.ChangePercent <> 0 AND Movement.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                   THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, Movement.OperDatePartner)
                                                            , inChangePercent:= Movement.ChangePercent
                                                            , inPrice        := MIFloat_Price.ValueData
                                                            , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                             )
                              ELSE COALESCE (MIFloat_Price.ValueData, 0)
                         END
                       , MIFloat_CountForPrice.ValueData
                       , Movement.MovementDescId
                       , COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0)
               UNION ALL
                -- Перевод долга (расход)
                SELECT MovementLinkObject_To.ObjectId                    AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , 0                                                 AS BranchId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId

                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                 THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                            WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                 THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                       END AS DocumentTaxKindId
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                 THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                            ELSE 0
                       END AS PartnerId
                     , 0 AS MovementId_ReturnIn
                     , 0 AS MovementId_TaxCorrective
                     , 0 AS MovementId_TaxCorrective_err
                     , MovementItem.ObjectId               AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData             AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , -1 * SUM (MovementItem.Amount)      AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                     , 0 AS MovementId_Tax
                FROM Movement 
                     INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                        AND Movement_Tax.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractFrom()

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                     
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

                WHERE Movement.DescId = zc_Movement_TransferDebtOut()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND vbUserId NOT IN (5, 6604558)
                GROUP BY MovementLinkObject_To.ObjectId
                       , ObjectLink_Contract_JuridicalBasis.ChildObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   THEN COALESCE (MovementLinkObject_Partner.ObjectId, 0)
                              ELSE 0
                         END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData

               UNION ALL
                -- Перевод долга (приход)
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  AS ToId
                     , 0                                                 AS BranchId
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
                     , 0 AS MovementId_TaxCorrective_err
                     , MovementItem.ObjectId               AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                     , MIFloat_Price.ValueData             AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (MovementItem.Amount)           AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                     , 0 AS MovementId_Tax
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
                     LEFT JOIN tmpPartner_Corrective_two AS tmpPartner_Corrective
                                                         ON tmpPartner_Corrective.PartnerId = MovementLinkObject_Partner.ObjectId
                                                        AND tmpPartner_Corrective.ContractId = MovementLinkObject_Contract.ObjectId
                     LEFT JOIN tmpJuridical_Corrective ON tmpJuridical_Corrective.JuridicalId = MovementLinkObject_From.ObjectId
                                                      AND tmpJuridical_Corrective.ContractId = MovementLinkObject_Contract.ObjectId

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                     
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
                  AND vbUserId NOT IN (5, 6604558)

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
                -- Корректировка цены
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , MovementLinkObject_To.ObjectId                    AS ToId
                     , COALESCE (MovementLinkObject_Branch.ObjectId,0)   AS BranchId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , Movement.Id                                       AS MovementId_ReturnIn
                     , 0 AS MovementId_TaxCorrective
                     , 0 AS MovementId_TaxCorrective_err
                     , MovementItem.ObjectId   AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                     , MIFloat_Price.ValueData AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , SUM (MovementItem.Amount) AS Amount_ReturnIn
                     , 0 AS Amount_TaxCorrective
                     , 0 AS MovementId_Tax
                FROM Movement
                     /*INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     INNER JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                                                        AND Movement_Tax.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                   ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLO_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())*/

                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                                  ON MovementLinkObject_Branch.MovementId = Movement.Id
                                                 AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

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
                     
                WHERE Movement.DescId = zc_Movement_PriceCorrective()
                  AND Movement.StatusId = zc_Enum_Status_Complete() 
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId OR COALESCE (inDocumentTaxKindId, 0) = 0)
                  AND vbUserId NOT IN (5, 6604558)
                  
                GROUP BY MovementLinkObject_From.ObjectId
                       , MovementLinkObject_To.ObjectId
                       , MovementBoolean_PriceWithVAT.ValueData
                       , MovementFloat_VATPercent.ValueData
                       , MovementLinkObject_Contract.ObjectId
                       , MovementLO_DocumentTaxKind.ObjectId
                       , MovementLinkObject_Partner.ObjectId
                       , Movement.Id
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
                       , COALESCE (MovementLinkObject_Branch.ObjectId,0)
               UNION ALL
                -- Корректировки
                SELECT MovementLinkObject_From.ObjectId                  AS FromId
                     , MovementLinkObject_To.ObjectId                    AS ToId
                     , COALESCE (MovementLinkObject_Branch.ObjectId,0)   AS BranchId
                     , MovementBoolean_PriceWithVAT.ValueData            AS PriceWithVAT
                     , MovementFloat_VATPercent.ValueData                AS VATPercent
                     , MovementLinkObject_Contract.ObjectId              AS ContractId
                     , MovementLO_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
                     , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                     , COALESCE (MovementLinkMovement.MovementChildId, 0) AS MovementId_ReturnIn
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_Corrective()
                                 THEN Movement.Id
                            ELSE Movement.Id
                       END AS MovementId_TaxCorrective
                     , CASE WHEN Movement.OperDate < Movement_DocumentChild.OperDate THEN Movement.Id ELSE 0 END AS MovementId_TaxCorrective_err
                     , MovementItem.ObjectId   AS GoodsId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                     , MIFloat_Price.ValueData AS Price
                     , CASE WHEN MIFloat_CountForPrice.ValueData <> 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                     , 0 AS Amount_ReturnIn
                     , SUM (MovementItem.Amount) AS Amount_TaxCorrective
                     , CASE WHEN vbUserId = 5 THEN MovementLinkMovement_Child.MovementChildId ELSE 0 END AS MovementId_Tax
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                            AND (vbUserId <> 5 OR MovementItem.ObjectId = 331529) -- 2201 Консерви м`ясні М`ЯСО КУРЕЙ У ВЛАСНОМУ СОКУ 525 г/шт ТМ Алан

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                     -- Возврат
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

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                                  ON MovementLinkObject_Branch.MovementId = Movement.Id
                                                 AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()

                     -- Налоговая
                     LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                    ON MovementLinkMovement_Child.MovementId = Movement.Id
                                                   AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                     LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_Child.MovementChildId

                WHERE Movement.DescId = zc_Movement_TaxCorrective()
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
                       , MovementLinkMovement.MovementChildId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_Corrective()
                                   THEN Movement.Id
                              ELSE Movement.Id
                         END
                       , CASE WHEN Movement.OperDate < Movement_DocumentChild.OperDate THEN Movement.Id ELSE 0 END
                       , MovementItem.ObjectId
                       , MILinkObject_GoodsKind.ObjectId
                       , MIFloat_Price.ValueData
                       , MIFloat_CountForPrice.ValueData
                       , COALESCE (MovementLinkObject_Branch.ObjectId,0)
                       , CASE WHEN vbUserId = 5 THEN MovementLinkMovement_Child.MovementChildId ELSE 0 END
          ) AS tmpMovement 
          GROUP BY tmpMovement.FromId
                 , tmpMovement.ToId
                 --, tmpMovement.BranchId
                 , tmpMovement.PriceWithVAT
                 , tmpMovement.VATPercent
                 , tmpMovement.ContractId
                 , tmpMovement.DocumentTaxKindId
                 , tmpMovement.PartnerId
                 , tmpMovement.MovementId_ReturnIn
                 , tmpMovement.GoodsId
                 , tmpMovement.GoodsKindId
                 , tmpMovement.Price
                 , tmpMovement.MovementId_tax
       ) AS tmpGroupMovement
       
         LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = tmpGroupMovement.MovementId_ReturnIn
         LEFT JOIN MovementString AS MovementString_InvNumberPartner_ReturnIn
                                  ON MovementString_InvNumberPartner_ReturnIn.MovementId =  Movement_ReturnIn.Id
                                 AND MovementString_InvNumberPartner_ReturnIn.DescId = zc_MovementString_InvNumberPartner()
         LEFT JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = CASE WHEN tmpGroupMovement.MovementId_TaxCorrective_err > 0 THEN tmpGroupMovement.MovementId_TaxCorrective_err ELSE tmpGroupMovement.MovementId_TaxCorrective END
         LEFT JOIN MovementString AS MovementString_InvNumberPartner_TaxCorrective
                                  ON MovementString_InvNumberPartner_TaxCorrective.MovementId = Movement_TaxCorrective.Id
                                 AND MovementString_InvNumberPartner_TaxCorrective.DescId = zc_MovementString_InvNumberPartner()
         -- налоговая Накладная
         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                        ON MovementLinkMovement_Child.MovementId = Movement_TaxCorrective.Id
                                       AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
         LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_Child.MovementChildId
         LEFT JOIN MovementString AS MovementString_InvNumberPartner_Tax
                                  ON MovementString_InvNumberPartner_Tax.MovementId = Movement_DocumentChild.Id
                                 AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()
                     
         LEFT JOIN Object AS Object_From ON Object_From.Id = tmpGroupMovement.FromId
         LEFT JOIN Object AS Object_To ON Object_To.Id = tmpGroupMovement.ToId
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpGroupMovement.PartnerId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId
         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId
         LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpGroupMovement.ContractId
         LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

         /*-- для оплат берем филиал по отв. сотруднику
         LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                              ON ObjectLink_Contract_Personal.ObjectId = tmpGroupMovement.ContractId
                             AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId*/
         
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpGroupMovement.BranchId
         
         LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                      ON MovementLO_DocumentTaxKind.MovementId = Movement_TaxCorrective.Id
                                     AND MovementLO_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                     AND MovementLO_DocumentTaxKind.ObjectId   = zc_Enum_DocumentTaxKind_Prepay()

    WHERE 
     ((tmpGroupMovement.Amount_ReturnIn <> tmpGroupMovement.Amount_TaxCorrective
        OR (inDocumentTaxKindId <> 0
            AND (tmpGroupMovement.Amount_ReturnIn <> 0 OR tmpGroupMovement.Amount_TaxCorrective <> 0)
           ))
       AND MovementLO_DocumentTaxKind.MovementId IS NULL
          )

       OR (Movement_TaxCorrective.OperDate < Movement_DocumentChild.OperDate)
       OR vbUserId IN (5, 6604558)

   ;


--    update Movement set OperDate = '20.07.2022' WHERE Id = 23221889 ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.20         *
 13.10.20         *
 08.07.18         *
 15.09.14                                        * add InvNumberPartner...
 29.08.14                                        * add tmpUnit_Corrective
 12.07.14                                        * add Summ_...
 03.05.14                                        * all
 18.02.14         *
*/

-- тест
-- SELECT * FROM gpReport_CheckTaxCorrective (inStartDate:= '01.01.2019', inEndDate:= '01.01.2019', inDocumentTaxKindId:= 0, inSession:= zfCalc_UserAdmin());
--- SELECT * FROM gpReport_CheckTaxCorrective22(inStartDate := ('19.07.2022')::TDateTime , inEndDate := ('21.07.2022')::TDateTime , inDocumentTaxKindID := 0 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
