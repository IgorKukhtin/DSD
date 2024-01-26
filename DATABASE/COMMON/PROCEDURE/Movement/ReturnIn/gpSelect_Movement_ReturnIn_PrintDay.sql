-- Function: gpSelect_Movement_ReturnIn_PrintDay()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn_PrintDay (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnIn_PrintDay(
    IN inMovementId        Integer  , -- ключ Документа продажи
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbFromId Integer;
    DECLARE vbToId Integer;
      
    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;

    DECLARE vbStoreKeeperName TVarChar;

    DECLARE vbPersonalId   Integer;
    DECLARE vbPersonalName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

   -- параметры из документа продажи
   SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId                    AS FromId
          , MovementLinkObject_To.ObjectId                      AS ToId 
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), MovementLinkObject_From.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)     AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          
          INTO vbDescId, vbStatusId, vbOperDate, vbFromId, vbToId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()  
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         
     WHERE Movement.Id = inMovementId;


    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;


     -- определение Экспедитора по дню недели
     vbPersonalId:= COALESCE ((SELECT ObjectLink_Partner_MemberTake.ChildObjectId
                               FROM ObjectLink AS ObjectLink_Partner_MemberTake
                               WHERE ObjectLink_Partner_MemberTake.ObjectId = vbToId
                                 AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM vbOperDate)
                                                                                WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                                                WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                                                WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                                                WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                                                WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                                                WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                                                WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                                            END
                              ), 0);
     -- название всегда по vbPersonalId
     vbPersonalName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPersonalId);


     --
     OPEN Cursor1 FOR
       SELECT CASE WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isJuridicalDocument
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = vbContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
       WHERE Movement.Id = inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
      
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
        WHERE Object_GoodsPropertyValue.ValueData  <> ''
           OR ObjectString_BarCode.ValueData       <> ''
           OR ObjectString_Article.ValueData       <> ''
           OR ObjectString_BarCodeGLN.ValueData    <> ''
           OR ObjectString_ArticleGLN.ValueData    <> ''
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.BarCode
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
       
    , tmpMovement_all AS (SELECT Movement.Id AS MovementId
                               , Movement.DescId
                               , Movement.InvNumber          AS InvNumber
                               , Movement.OperDate
                               , Object_Status.ObjectCode    AS StatusCode
                               , Object_Status.ValueData     AS StatusName 
                          FROM Movement
                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                         AND MovementLinkObject_From.ObjectId = vbToId
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())      
                                         AND MovementLinkObject_Contract.ObjectId = vbContractId 
                               --для пакетной печати , чтоб после того ка распечатано для первой накладной  на второй не печаталось
                               LEFT JOIN MovementBoolean AS MovementBoolean_PrintAuto
                                      ON MovementBoolean_PrintAuto.MovementId = Movement.Id
                                     AND MovementBoolean_PrintAuto.DescId = zc_MovementBoolean_PrintAuto()
                          WHERE Movement.OperDate = vbOperDate
                            AND Movement.DescId   = zc_Movement_ReturnIn()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND COALESCE (MovementBoolean_PrintAuto.ValueData,False) = FALSE
                         )
     ,    tmpMovement_list AS (SELECT Movement.ParentId           AS MovementParentId
                                    , MAX (Object_User.ValueData) AS StoreKeeperName
                               FROM tmpMovement_all
                                    INNER JOIN Movement ON Movement.ParentId = tmpMovement_all.MovementId
                                                       AND Movement.DescId   = zc_Movement_WeighingPartner()
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                                 ON MovementLinkObject_User.MovementId = Movement.Id
                                                                AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                    LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                               GROUP BY Movement.ParentId
                              )
        , tmpMovement AS (SELECT tmpMovement_all.MovementId
                               , tmpMovement_all.DescId
                               , tmpMovement_all.InvNumber
                               , tmpMovement_all.OperDate
                               , tmpMovement_all.StatusCode
                               , tmpMovement_all.StatusName 
                               , tmp.StoreKeeperName
                          FROM tmpMovement_all
                               LEFT JOIN tmpMovement_list AS tmp ON tmp.MovementParentId = tmpMovement_all.MovementId
                         )
  , tmpMIPartionMovement_all AS (SELECT tmpMovement.MovementId                  AS MovementId
                                      , MovementItem.Id                         AS MovementItemId
                                      , MovementItem.ObjectId                   AS GoodsId
                                      , MIFloat_MovementId.ValueData :: Integer AS MovementId_partion
                                 FROM tmpMovement
                                      LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                      
                                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                )
      , tmpMIPartionMovement AS (SELECT tmpMIPartionMovement_all.MovementId           AS MovementId
                                      , tmpMIPartionMovement_all.MovementItemId       AS MovementItemId
                                      , MIPartionMovement.ObjectId                    AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , MIFloat_AmountPartner.ValueData               AS AmountPartner
                                 FROM tmpMIPartionMovement_all
                                      LEFT JOIN MovementItem AS MIPartionMovement 
                                                             ON MIPartionMovement.MovementId = tmpMIPartionMovement_all.MovementId_partion
                                                            AND MIPartionMovement.DescId     = zc_MI_Master()
                                                            AND MIPartionMovement.ObjectId   = tmpMIPartionMovement_all.GoodsId
                                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                  ON MIFloat_AmountPartner.MovementItemId = MIPartionMovement.Id
                                                                 AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MIPartionMovement.Id
                                                                      AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                )
      , tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                       , MovementItem.MovementId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                   THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                   THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                              ELSE COALESCE (MIFloat_Price.ValueData, 0)
                         END AS Price
                       , CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                       , SUM (MovementItem.Amount) AS Amount
                       , SUM (CASE WHEN tmpMovement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
                                        THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                        ELSE MovementItem.Amount
                              END) AS AmountPartner
                       , SUM (tmpMIPartionMovement.AmountPartner) AS AmountPartner_PartionMovement
                  FROM tmpMovement
                       LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       LEFT JOIN tmpMIPartionMovement ON tmpMIPartionMovement.MovementItemId = MovementItem.Id
                                                     AND tmpMIPartionMovement.GoodsId = MovementItem.ObjectId
                                                     AND tmpMIPartionMovement.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                  GROUP BY MovementItem.ObjectId
                         , MovementItem.MovementId
                         , MILinkObject_GoodsKind.ObjectId
                         , MIFloat_Price.ValueData
                         , CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                 )
                 
      , tmpMovementFloat AS (SELECT *
                             FROM MovementFloat
                             WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                               AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                          , zc_MovementFloat_TotalCountKg()
                                                          , zc_MovementFloat_TotalCountSh()
                                                          , zc_MovementFloat_TotalSummMVAT()
                                                          , zc_MovementFloat_TotalSummPVAT()
                                                          , zc_MovementFloat_TotalSumm()
                                                          )
                             )

      , tmpMovementString AS (SELECT *
                             FROM MovementString
                             WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                               AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                           , zc_MovementString_InvNumberMark()
                                                           , zc_MovementString_Comment()
                                                          )
                             )
      , tmpMovementDate AS (SELECT *
                             FROM MovementDate
                             WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                               AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                             )

     -- Результат
     SELECT
             tmpMovement.MovementId                     AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpMovement.MovementId) AS IdBarCode
           , tmpMovement.InvNumber                      AS InvNumber
           , COALESCE (MovementDate_OperDatePartner.ValueData, tmpMovement.OperDate) AS OperDate
           , tmpMovement.StatusCode
           , tmpMovement.StatusName

           , COALESCE (MovementDate_OperDatePartner.ValueData, tmpMovement.OperDate) AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent

           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh

           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * MovementFloat_TotalSummMVAT.ValueData AS TotalSummMVAT
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData) AS SummVAT
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * MovementFloat_TotalSumm.ValueData AS TotalSumm

           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * MovementFloat_TotalSummMVAT.ValueData AS TotalSummMVAT_sign
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT_sign
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData) AS SummVAT_sign
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * MovementFloat_TotalSumm.ValueData AS TotalSumm_sign

           , COALESCE (Object_Partner.ValueData, Object_From.ValueData) AS FromName
           , Object_To.ValueData               		AS ToName
           , (Object_PaidKind.Id - 2) :: TVarChar       AS PaidKindName_user
           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , ObjectString_FromAddress.ValueData         AS PartnerAddress_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From

           , OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.Phone               AS Phone_To

           , COALESCE (Object_Member_Driver.ValueData, vbPersonalName)  AS MemberName_Driver
           , MovementString_Comment.ValueData           AS Comment
 
           , CASE WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isJuridicalDocument

           , (SELECT MS_InvNumberPartner.ValueData
              FROM tmpMovement
                   LEFT JOIN MovementLinkMovement AS MLM_Master ON MLM_Master.MovementChildId = tmpMovement.MovementId
                                                               AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                   LEFT JOIN MovementString AS MS_InvNumberPartner ON MS_InvNumberPartner.MovementId = MLM_Master.MovementId
                                                                  AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
               LIMIT 1) AS InvNumberPartner_TaxCorrective

           , tmpMovement.StoreKeeperName AS StoreKeeper
           , Object_BankAccount.Name                            AS BankAccount_ByContract
           , Object_BankAccount.MFO                             AS BankMFO_ByContract
           , Object_BankAccount.BankName                        AS BankName_ByContract

--  СТРОКИ ДОКУМЕНТОВ
           , Object_Goods.ObjectCode  			AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner_abs
           , CASE WHEN tmpMovement.DescId <> zc_Movement_PriceCorrective() THEN 1 ELSE -1 END * tmpMI.AmountPartner              AS AmountPartner
           , tmpMI.AmountPartner_PartionMovement
           
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * tmpMI.Price / tmpMI.CountForPrice AS Price
           , tmpMI.CountForPrice             AS CountForPrice
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 0 END * tmpMI.AmountPartner              AS AmountPartner_ashan

             -- сумма по ценам док-та
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
           * CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN tmpMovement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
           * CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / tmpMI.CountForPrice
             AS PriceNoVAT

             -- расчет цены с НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST (tmpMI.Price + tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / tmpMI.CountForPrice
             AS PriceWVAT

             -- расчет суммы без НДС, до 2 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT


       FROM tmpMovement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = tmpMovement.MovementId
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  tmpMovement.MovementId
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  tmpMovement.MovementId
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  tmpMovement.MovementId
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = tmpMovement.MovementId
                                    AND MovementString_Comment.DescId     = zc_MovementString_Comment()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  tmpMovement.MovementId
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  tmpMovement.MovementId
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  tmpMovement.MovementId
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = tmpMovement.MovementId
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = tmpMovement.MovementId
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = tmpMovement.MovementId
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = tmpMovement.MovementId
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN Object AS Object_From ON Object_From.Id = vbToId --- клиент из док.продажи --MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_From.Id)
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = tmpMovement.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_Driver
                                         ON MovementLinkObject_Member_Driver.MovementId = tmpMovement.MovementId
                                        AND MovementLinkObject_Member_Driver.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member_Driver ON Object_Member_Driver.Id = MovementLinkObject_Member_Driver.ObjectId

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = vbPaidKindId -- MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = vbContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = vbContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
-- ============================
            --по контрагенту находим юр.лицо
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = vbToId ---MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_From.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, tmpMovement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, tmpMovement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId, COALESCE (View_Contract.JuridicalBasisId, Object_To.Id))
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, tmpMovement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, tmpMovement.OperDate) <  OH_JuridicalDetails_To.EndDate
-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId

--СТРОКИ документов 
            INNER JOIN tmpMI ON tmpMI.MovementId = tmpMovement.MovementId 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId
          
       WHERE tmpMI.AmountPartner <> 0
       ORDER BY tmpMovement.MovementId, tmpMovement.InvNumber, Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.09.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReturnIn_PrintDay (inMovementId:= 15582166, inSession:= '5'); -- FETCH ALL "<unnamed portal 43>"
