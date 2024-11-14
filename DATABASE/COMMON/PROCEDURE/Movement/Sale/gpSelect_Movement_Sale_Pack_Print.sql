-- Function: gpSelect_Movement_Sale_Pack_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pack_Print21 (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pack_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pack_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Pack_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_by     Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbIsContract_30201 Boolean;

    DECLARE Cursor1 refcursor;
    DECLARE vbOperDatePartner TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale_Pack_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- Дата
     vbOperDatePartner:= (SELECT COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                          WHERE Movement.Id = inMovementId
                         );
                         
     vbIsContract_30201:= (SELECT CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                            THEN TRUE
                                       ELSE FALSE
                                  END
                           FROM Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                            AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                     ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                    AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                           WHERE Movement.Id = inMovementId
                          );



     -- определяется параметр
     vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId)
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          WHERE Movement.Id = inMovementId
                         );
-- RAISE EXCEPTION '<%>', lfGet_Object_ValueData (vbGoodsPropertyId);

     -- Данные: заголовок + строчная часть
     OPEN Cursor1 FOR
     WITH -- список всех Документов Взвешивания или одного - inMovementId_by
       tmpMovement AS (SELECT Movement.Id, Movement.ParentId
                       FROM Movement
                       WHERE Movement.ParentId = inMovementId
                         AND Movement.DescId = zc_Movement_WeighingPartner()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         AND (Movement.Id = inMovementId_by OR COALESCE (inMovementId_by, 0) = 0)
                      )
     , tmpMovementCount AS (SELECT Count(*) AS WeighingCount
                            FROM Movement
                            WHERE Movement.ParentId = inMovementId
                              AND Movement.DescId = zc_Movement_WeighingPartner()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
       -- список Артикулы покупателя для товаров + GoodsKindId
     , tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                             , Object_GoodsPropertyValue.ValueData  AS Name
                                             , ObjectString_BarCode.ValueData       AS BarCode
                                             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
                                             , ObjectString_Article.ValueData       AS Article
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId, 0)  AS GoodsBoxId
                                             , COALESCE (ObjectFloat_Weight.ValueData, 0)                          AS GoodsBox_Weight
                                        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                             ) AS tmpGoodsProperty
                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
                                             LEFT JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                   ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                                                 
                                       )
       -- список Артикулы для товаров (нужны если не найдем по GoodsKindId)
     , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                  , tmpObject_GoodsPropertyValue.Name
                                                  , tmpObject_GoodsPropertyValue.Article
                                                  , tmpObject_GoodsPropertyValue.BarCode
                                                  , tmpObject_GoodsPropertyValue.BarCodeGLN
                                             FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' GROUP BY GoodsId
                                                  ) AS tmpGoodsProperty_find
                                                  LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                            )
       -- строчная часть документов Взвешивания или одного - inMovementId_by
     , tmpMI AS (WITH
                 tmp AS (SELECT MovementItem.*
                         FROM tmpMovement
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                         )
                  , tmpMILO AS (SELECT *
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmp.Id FROM tmp)
                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                )
                   SELECT MovementItem.MovementId                           AS MovementId
                       , MovementItem.Id                                   AS MI_Id
                       , MovementItem.ObjectId                             AS GoodsId
                       , MovementItem.Amount                               AS Amount
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                   FROM tmp AS MovementItem
                       LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 )

   , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                       FROM MovementItemBoolean
                       WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                         AND MovementItemBoolean.DescId = zc_MIBoolean_BarCode()
                        )
     , tmpMI_Float AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner(), zc_MIFloat_BoxCount(), zc_MIFloat_LevelNumber(), zc_MIFloat_BoxNumber(), zc_MIFloat_CountTare(), zc_MIFloat_WeightTare())
                        )
     , tmp_GoodsKind AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                              
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                          AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )
     , tmpMovementItem AS (SELECT tmpMI.MovementId                           AS MovementId
                                , tmpMI.GoodsId                              AS GoodsId
                                , SUM (CASE WHEN MIBoolean_BarCode.ValueData = TRUE THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE tmpMI.Amount END) AS Amount
                                , SUM (CASE WHEN MIBoolean_BarCode.ValueData = TRUE THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE tmpMI.Amount END
                                     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END
                                      ) AS AmountWeight
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                               -- , tmpMI.GoodsKindId
                                , MAX (COALESCE (MIFloat_LevelNumber.ValueData, 0))   AS LevelNumber
                                , SUM (COALESCE (MIFloat_BoxCount.ValueData, 0))      AS BoxCount
                                , COUNT (*)                                           AS BoxCount_calc
                              --, SUM (COALESCE (MIFloat_BoxNumber.ValueData, 0))     AS BoxNumber
                                , MAX (COALESCE (MIFloat_BoxNumber.ValueData, 0))     AS BoxNumber
                                , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                                , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) AS AmountPartnerWeight
                                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartnerSh

                                  -- так считаем Кол-во Упаковок (пакетов)
                                , SUM (CASE WHEN MIFloat_WeightTare.ValueData < 0.1 THEN COALESCE (MIFloat_CountTare.ValueData, 0) ELSE 0 END) AS CountPackage_calc

                           FROM tmpMI
                                LEFT JOIN tmpMI_Boolean AS MIBoolean_BarCode
                                                        ON MIBoolean_BarCode.MovementItemId = tmpMI.MI_Id
                                                       AND MIBoolean_BarCode.DescId         = zc_MIBoolean_BarCode()
                                LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                LEFT JOIN tmpMI_Float AS MIFloat_BoxCount
                                                      ON MIFloat_BoxCount.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                                LEFT JOIN tmpMI_Float AS MIFloat_BoxNumber
                                                     ON MIFloat_BoxNumber.MovementItemId = tmpMI.MI_Id
                                                    AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                                LEFT JOIN tmpMI_Float AS MIFloat_LevelNumber
                                                      ON MIFloat_LevelNumber.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

                                LEFT JOIN tmpMI_Float AS MIFloat_CountTare
                                                      ON MIFloat_CountTare.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                                LEFT JOIN tmpMI_Float AS MIFloat_WeightTare
                                                      ON MIFloat_WeightTare.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                                LEFT JOIN tmp_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MI_Id

                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                      ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                           GROUP BY tmpMI.MovementId, tmpMI.GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          )
       -- StickerProperty -  кількість діб 
     , tmpStickerProperty AS (SELECT ObjectLink_Sticker_Goods.ChildObjectId              AS GoodsId
                                   , ObjectLink_StickerProperty_GoodsKind.ChildObjectId  AS GoodsKindId
                                   , COALESCE (ObjectFloat_Value5.ValueData, 0)          AS Value5
                                     --  № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Sticker_Goods.ChildObjectId, ObjectLink_StickerProperty_GoodsKind.ChildObjectId ORDER BY COALESCE (ObjectFloat_Value5.ValueData, 0) DESC) AS Ord
                              FROM Object AS Object_StickerProperty
                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                         ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                         ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                                         ON ObjectLink_Sticker_Juridical.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Juridical.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                         ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                          ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                                         AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()

                              WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                                AND Object_StickerProperty.isErased = FALSE
                                AND ObjectLink_Sticker_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                             )
       -- 
     , tmpMovementData AS (SELECT tmpMovementItem.*
                                , tmpMovement.ParentId AS ParentId_Movement
                           FROM tmpMovement
                                INNER JOIN tmpMovementItem ON tmpMovementItem.MovementId = tmpMovement.Id AND tmpMovementItem.AmountPartner <> 0
                           )
       -- 
     , tmpMovementParent AS (SELECT Movement_Sale.*
                             FROM (SELECT DISTINCT tmpMovementData.ParentId_Movement FROM tmpMovementData) AS tmpMovement
                                  LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpMovement.ParentId_Movement
                             )
       --для ParentId_Movement                        
     , tmpMovementDate AS (SELECT MovementDate.*
                           FROM MovementDate
                           WHERE MovementDate.MovementId IN (SELECT tmpMovementParent.Id FROM tmpMovementParent)
                            AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                           )                     


     , tmpMLO_From_To AS (SELECT *
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                            AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementData.MovementId FROM tmpMovementData)
                           )

     , tmpMLO_Contract AS (SELECT *
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.DescId IN (zc_MovementLinkObject_Contract())
                             AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementData.ParentId_Movement FROM tmpMovementData)
                           )
 
     , tmpMS_InvNumberAll AS (SELECT *
                              FROM MovementString
                              WHERE MovementString.DescId IN (zc_MovementString_InvNumberPartner(), zc_MovementString_InvNumberOrder())
                                AND MovementString.MovementId IN (SELECT DISTINCT tmpMovementData.ParentId_Movement FROM tmpMovementData)
                               )
                                               
     , tmpMovementParam AS (SELECT tmpMovement.MovementId
                                 , Movement_Sale.OperDate				                      AS OperDate
                                 , COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate)  AS OperDatePartner
                                 , Movement_Sale.InvNumber		                                  AS InvNumber
                                 , MovementString_InvNumberPartner.ValueData                              AS InvNumberPartner
                                 , MovementString_InvNumberOrder.ValueData                                AS InvNumberOrder

                                 , OH_JuridicalDetails_From.FullName                                      AS JuridicalName_From
                                 , OH_JuridicalDetails_From.JuridicalAddress                              AS JuridicalAddress_From
                                 , OH_JuridicalDetails_From.OKPO                                          AS OKPO_From
                      
                                 , OH_JuridicalDetails_To.FullName                                        AS JuridicalName_To
                                 , OH_JuridicalDetails_To.JuridicalAddress                                AS JuridicalAddress_To
                                 , ObjectString_ToAddress.ValueData                                       AS PartnerAddress_To
                      
                                 , Object_From.ValueData             		                          AS FromName
                                 , Object_To.ValueData                                                    AS ToName
                                 , MovementLinkObject_Contract.ObjectId                                   AS ContractId
                                 , View_Contract.InvNumber        	                                  AS ContractName
                                 , ObjectDate_Signing.ValueData                                           AS ContractSigningDate
                                 , ObjectLink_Juridical_Retail.ChildObjectId                              AS RetailId
                            FROM (SELECT DISTINCT tmpMovementData.MovementId, tmpMovementData.ParentId_Movement FROM tmpMovementData) AS tmpMovement
                                 LEFT JOIN tmpMLO_From_To AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = tmpMovement.MovementId
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                      ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     
                                 LEFT JOIN tmpMLO_From_To AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = tmpMovement.MovementId
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                     
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                 LEFT JOIN tmpMovementParent AS Movement_Sale ON Movement_Sale.Id = tmpMovement.ParentId_Movement

                                 LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                           ON MovementDate_OperDatePartner.MovementId = tmpMovement.ParentId_Movement --Movement_Sale.Id

                                 LEFT JOIN tmpMS_InvNumberAll AS MovementString_InvNumberPartner
                                                              ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id
                                                             AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                 LEFT JOIN tmpMS_InvNumberAll AS MovementString_InvNumberOrder
                                                              ON MovementString_InvNumberOrder.MovementId = Movement_Sale.Id
                                                             AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                                 LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = Movement_Sale.Id
                                                             AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                 LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

                                 LEFT JOIN ObjectDate AS ObjectDate_Signing
                                                      ON ObjectDate_Signing.ObjectId = View_Contract.ContractId
                                                     AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                                     AND View_Contract.InvNumber <> '-'

                                 LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                                     ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, View_Contract.JuridicalBasisId)
                                                                                    AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                                    AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) <  OH_JuridicalDetails_From.EndDate
                                 LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                                     ON OH_JuridicalDetails_To.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                                                    AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                                                    AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) <  OH_JuridicalDetails_To.EndDate

                                 LEFT JOIN ObjectString AS ObjectString_FromAddress
                                                        ON ObjectString_FromAddress.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()
                                 LEFT JOIN ObjectString AS ObjectString_ToAddress
                                                        ON ObjectString_ToAddress.ObjectId = MovementLinkObject_To.ObjectId
                                                       AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
               )
 
     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovementData.MovementId FROM tmpMovementData)
                              AND MovementFloat.DescId IN ( zc_MovementFloat_WeighingNumber(),zc_MovementFloat_TotalCountKg()) 
                            )
     -- свойства товара
     , tmpObjectLink AS (SELECT ObjectLink.*
                      FROM ObjectLink
                      WHERE ObjectLink.ObjectId IN (SELECT tmpMovementData.GoodsId FROM tmpMovementData)
                        AND ObjectLink.DescId IN (zc_ObjectLink_Goods_InfoMoney(), zc_ObjectLink_Goods_Measure())
                     )
     , tmpObjectString AS (SELECT ObjectString.*
                           FROM ObjectString
                           WHERE ObjectString.ObjectId IN (SELECT tmpMovementData.GoodsId FROM tmpMovementData)
                             AND ObjectString.DescId = zc_ObjectString_Goods_GroupNameFull()
                           )

      -- Результат
     SELECT tmpMovementItem.MovementId	                                            AS MovementId
           , CAST (ROW_NUMBER() OVER (PARTITION BY MovementFloat_WeighingNumber.ValueData, tmpMovementItem.MovementId ORDER BY MovementFloat_WeighingNumber.ValueData, tmpMovementItem.MovementId, ObjectString_Goods_GoodsGroupFull.ValueData, Object_Goods.ValueData, Object_GoodsKind.ValueData) AS Integer) AS NumOrder
           , tmpMovementParam.OperDate
           , tmpMovementParam.OperDatePartner
           , MovementFloat_WeighingNumber.ValueData                                 AS WeighingNumber
           , (SELECT WeighingCount FROM tmpMovementCount) :: Integer                AS WeighingCount
           , tmpMovementParam.InvNumber
           , tmpMovementParam.InvNumberPartner
           , tmpMovementParam.InvNumberOrder
           , MovementFloat_TotalCountKg.ValueData                                   AS TotalCountKg

           , tmpMovementParam.JuridicalName_From
           , tmpMovementParam.JuridicalAddress_From
           , tmpMovementParam.OKPO_From

           , tmpMovementParam.JuridicalName_To
           , tmpMovementParam.JuridicalAddress_To
           , tmpMovementParam.PartnerAddress_To

           , tmpMovementParam.FromName
           , tmpMovementParam.ToName

           , tmpMovementParam.ContractName
           , tmpMovementParam.ContractSigningDate

           , ObjectString_Goods_GoodsGroupFull.ValueData                            AS GoodsGroupNameFull
           , Object_Goods.ObjectCode                                                AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) AS GoodsName_Juridical
           , Object_GoodsKind.ValueData                                             AS GoodsKindName
           , Object_Measure.ValueData                                               AS MeasureName
           , COALESCE (tmpObject_GoodsPropertyValue.Article, COALESCE (tmpObject_GoodsPropertyValueGroup.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, '')) AS BarCode_Juridical
           , tmpMovementItem.LevelNumber                                            AS LevelNumber
           , CASE WHEN COALESCE (tmpMovementItem.BoxCount, 0) = 0 AND tmpMovementItem.BoxCount_calc > 0 THEN tmpMovementItem.BoxCount_calc ELSE tmpMovementItem.BoxCount END :: Integer AS BoxCount
           , tmpMovementItem.BoxNumber
           , (COALESCE (tmpMovementItem.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0)):: TFloat AS BoxWeight

           , tmpMovementItem.Amount                                       :: TFloat AS Amount
           , tmpMovementItem.AmountWeight                                 :: TFloat AS AmountWeight
           , tmpMovementItem.AmountPartner                                :: TFloat AS AmountPartner
           , tmpMovementItem.AmountPartnerWeight                          :: TFloat AS AmountPartnerWeight
           , tmpMovementItem.AmountPartnerSh                              :: TFloat AS AmountPartnerSh

             -- ВЕС Скидка + потери - ?хотя может быть надо было учесть ТОЛЬКО Скидку?
           , (tmpMovementItem.AmountWeight - tmpMovementItem.AmountPartnerWeight) :: TFloat AS AmountWeight_diff

             -- ВЕС БРУТТО - учитывается скидка за вес
           , (-- "чистый" вес "со склада" - ???почему по ТЗ скидка за вес НЕ должна учитываться???
              tmpMovementItem.AmountWeight
            + -- плюс Вес "гофроящиков"
              COALESCE (tmpMovementItem.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0)
            + -- плюс Вес Упаковок (пакетов)
              CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc
                          * -- вес 1-ого пакета
                            COALESCE (ObjectFloat_WeightPackage.ValueData, 0)

                   WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                        THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                             CAST (tmpMovementItem.AmountPartnerWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                   ELSE 0
              END
             ) :: TFloat AS AmountWeightWithBox

             -- ВЕС БРУТТО
           , (-- "чистый" вес "у покупателя" - ???почему по ТЗ скидка за вес НЕ должна учитываться???
              tmpMovementItem.AmountPartnerWeight
            + -- плюс Вес "гофроящиков"
              COALESCE (tmpMovementItem.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0)
            + -- плюс Вес Упаковок (пакетов)
              CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)

                  WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                        THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                             CAST (tmpMovementItem.AmountPartnerWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                   ELSE 0
              END
             ) :: TFloat AS AmountPartnerWeightWithBox


             -- Кол-во Упаковок (пакетов)
           , CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc

                  WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                       THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                            CAST (tmpMovementItem.AmountPartnerWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                  ELSE 0
             END :: TFloat AS CountPackage_calc
             -- Вес Упаковок (пакетов)
           , CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc
                          * -- вес 1-ого пакета
                            COALESCE (ObjectFloat_WeightPackage.ValueData, 0)

                  WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                       THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                            CAST (tmpMovementItem.AmountPartnerWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                          * -- вес 1-ого пакета
                            COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                  ELSE 0
             END :: TFloat AS WeightPackage_calc


              -- Штрих-код GS1-128
           ,  -- 01 - EAN код товару на палеті - 14
             ('01' || '0' || CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                  THEN COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, ''))
                                  ELSE COALESCE (tmpObject_GoodsPropertyValue.BarCode,    COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, ''))
                             END
              -- 37 - Кількість коробів - 8
           || '37' || REPEAT ('0', 8 - LENGTH ((tmpMovementItem.BoxCount :: Integer) :: TVarChar)) || (tmpMovementItem.BoxCount :: Integer) :: TVarChar
              -- 3103 - Вага з Х знаків після коми - 6
           || '3103' || REPEAT ('0', 3 - LENGTH (FLOOR (tmpMovementItem.AmountPartnerWeight) :: TVarChar))
                            || FLOOR (tmpMovementItem.AmountPartnerWeight) :: TVarChar
                     || REPEAT ('0', 3 - LENGTH ((FLOOR (tmpMovementItem.AmountPartnerWeight * 1000) - FLOOR (tmpMovementItem.AmountPartnerWeight) * 1000) :: TVarChar))
                            || (FLOOR (tmpMovementItem.AmountPartnerWeight * 1000) - FLOOR (tmpMovementItem.AmountPartnerWeight) * 1000) :: TVarChar
              -- 15 - Дата закінчення терміну придатності - 6 - РРММДД
           || '15' || (EXTRACT (YEAR  FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL) - 2000) :: TVarChar
                   || CASE WHEN EXTRACT (MONTH FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL) < 10
                                THEN '0'
                           ELSE ''
                      END || EXTRACT (MONTH FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL)  :: TVarChar
                   || CASE WHEN EXTRACT (DAY   FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL) < 10
                                THEN '0'
                           ELSE ''
                      END || EXTRACT (DAY   FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL)  :: TVarChar
             ) :: TVarChar AS BarCode_128

              -- Штрих-код GS1-128
           ,  -- 01 - EAN код товару на палеті - 14
             ('(01)' || '0' || CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, ''))
                                    ELSE COALESCE (tmpObject_GoodsPropertyValue.BarCode,    COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, ''))
                               END
              -- 37 - Кількість коробів - 8
           || '(37)' || REPEAT ('0', 8 - LENGTH ((tmpMovementItem.BoxCount :: Integer) :: TVarChar)) || (tmpMovementItem.BoxCount :: Integer) :: TVarChar
              -- 3103 - Вага з Х знаків після коми - 6
           || '(3103)' || REPEAT ('0', 3 - LENGTH (FLOOR (tmpMovementItem.AmountPartnerWeight) :: TVarChar))
                            || FLOOR (tmpMovementItem.AmountPartnerWeight) :: TVarChar
                     || REPEAT ('0', 3 - LENGTH ((FLOOR (tmpMovementItem.AmountPartnerWeight * 1000) - FLOOR (tmpMovementItem.AmountPartnerWeight) * 1000) :: TVarChar))
                            || (FLOOR (tmpMovementItem.AmountPartnerWeight * 1000) - FLOOR (tmpMovementItem.AmountPartnerWeight) * 1000) :: TVarChar
              -- 15 - Дата закінчення терміну придатності - 6 - РРММДД
           || '(15)' || (EXTRACT (YEAR  FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL) - 2000) :: TVarChar
                   || CASE WHEN EXTRACT (MONTH FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL) < 10
                                THEN '0'
                           ELSE ''
                      END || EXTRACT (MONTH FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL)  :: TVarChar
                   || CASE WHEN EXTRACT (DAY   FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL) < 10
                                THEN '0'
                           ELSE ''
                      END || EXTRACT (DAY   FROM vbOperDatePartner + ((COALESCE (tmpStickerProperty.Value5, 0) :: Integer) :: TVarChar || ' DAY' ):: INTERVAL)  :: TVarChar
             ) :: TVarChar AS BarCode_128_str
             
           , tmpStickerProperty.Value5 :: Integer AS Value5_termin
           , MAX (tmpStickerProperty.Value5) OVER () :: Integer AS max_termin


           , CASE WHEN tmpMovementParam.ContractId > 0
                       AND Object_InfoMoney_View.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                              , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                               )
                      THEN FALSE
                  ELSE TRUE
             END :: Boolean AS isBranch

           , CASE WHEN tmpMovementParam.RetailId = 310853 -- Ашан
                      THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isAshan
           , CASE WHEN tmpMovementParam.RetailId = 310854 -- Фоззі
                      THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isFozzi

           , CASE WHEN tmpMovementParam.ContractId IN (4440485 -- Фоззі для договора Id = 4440485 + доп страничка
                                                     , 9081123 -- 402Р для ФОЗЗІ КОММЕРЦ ТОВ с. Зимна Вода вул. Яворівська буд.30
                                                     , 887538  -- 402Р для СІЛЬПО-ФУД ТОВ с. Зимна Вода вул. Яворівська буд.30
                                                      )
                      THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isFozzyPage5
                     
           , vbIsContract_30201 :: Boolean AS isContract_30201

           , 'Україна, м.Дніпро' :: TVarChar AS LoadingPlace

       FROM tmpMovementData AS tmpMovementItem
          LEFT JOIN tmpMovementParam ON tmpMovementParam.MovementId = tmpMovementItem.MovementId
            
          LEFT JOIN tmpStickerProperty ON tmpStickerProperty.GoodsId     = tmpMovementItem.GoodsId
                                      AND tmpStickerProperty.GoodsKindId = tmpMovementItem.GoodsKindId
                                      AND tmpStickerProperty.Ord         = 1
          
          LEFT JOIN tmpObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMovementItem.GoodsId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN tmpMovementFloat AS MovementFloat_WeighingNumber
                                     ON MovementFloat_WeighingNumber.MovementId = tmpMovementItem.MovementId
                                    AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
          LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                     ON MovementFloat_TotalCountKg.MovementId = tmpMovementItem.MovementId
                                    AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovementItem.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovementItem.GoodsKindId

          LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = Object_Goods.Id
                                                AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id

          LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = Object_Goods.Id
                                                     AND tmpObject_GoodsPropertyValue.GoodsId IS NULL

          LEFT JOIN tmpObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id

          LEFT JOIN tmpObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMovementItem.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMovementItem.GoodsKindId
          -- вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

       ORDER BY tmpMovementItem.MovementId
              --MovementFloat_WeighingNumber

              --, tmpMovementItem.BoxNumber
              --, tmpMovementItem.Num*/
      ;
     RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.02.18         *
 25.05.15                                        * ALL
 24.11.14                                                       *
 03.11.14                                                       *
 31.10.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_Pack_Print (inMovementId := 130359, inMovementId_by:=0, inSession:= zfCalc_UserAdmin());; -- FETCH ALL "<unnamed portal 1>";
--SELECT * FROM gpSelect_Movement_Sale_Pack_Print (inMovementId := 8604341, inMovementId_by:=0, inSession:= zfCalc_UserAdmin());
--FETCH ALL "<unnamed portal 3>";
--select * from gpSelect_Movement_Sale_Pack_Print(inMovementId := 25014201 , inMovementId_by := 0 ,  inSession := '5');
