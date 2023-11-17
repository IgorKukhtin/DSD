-- Function: gpSelect_Movement_Sale_ExpPack_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pack_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_ExpPack_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_ExpPack_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

--    DECLARE vbMovementId_SalePack Integer;
--    DECLARE vbStatusId_SalePack Integer;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbWeighingCount   Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDatePartner TDateTime;
    DECLARE vbIsLongUKTZED Boolean;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- кол-во Взвешиваний / паллет
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

     -- параметры из документа
     SELECT Movement.OperDate
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)    AS isLongUKTZED

          INTO vbOperDate, vbIsLongUKTZED
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()

      WHERE Movement.Id = inMovementId AND Movement.DescId <> zc_Movement_SendOnPrice()
    ;
     -- параметр из документа
     vbOperDatePartner:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner());


     -- определяется параметр
     vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) -- ObjectLink_Juridical_GoodsProperty.ChildObjectId
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
                               /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                    ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
                                                   AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
                          WHERE Movement.Id = inMovementId
                         );
     -- определяется параметр
     vbGoodsPropertyId_basis:= zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0); -- (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectLink_Juridical_GoodsProperty());


     -- Данные: заголовок + строчная часть
     OPEN Cursor1 FOR
     WITH tmpMovement AS
          (SELECT Movement.Id
           FROM Movement
           WHERE Movement.Id = inMovementId
          )
     , tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_GroupName.ValueData     AS GroupName
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

             LEFT JOIN ObjectString AS ObjectString_GroupName
                                    ON ObjectString_GroupName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.GroupName
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' OR BarCode <> '' OR Article <> '' OR GroupName <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
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

 -- строки док
 , tmpMI AS (SELECT MovementItem.*
                  , ObjectLink_GoodsGroup.ChildObjectId    AS GoodsGroupId
             FROM MovementItem
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                       ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             )

     , tmpMIFloat_AmountPartner AS (SELECT MIFloat_AmountPartner.*
                                         , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) OVER () AS AmountPartner_all
                                    FROM MovementItemFloat AS MIFloat_AmountPartner
                                    WHERE MIFloat_AmountPartner.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                   )



        -- на дату
      , tmpUKTZED AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, vbOperDatePartner) AS CodeUKTZED
                      FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp
                     )

      , tmpSticker AS (SELECT ObjectLink_Sticker_Goods.ChildObjectId AS GoodsId
                            , Object_StickerSort.ValueData           AS StickerSortName
                            , Object_StickerNorm.ValueData           AS StickerNormName
                            , ObjectBlob_Info.ValueData              AS Info
                       FROM (SELECT Object_Sticker.Id
                             FROM Object AS Object_Sticker
                             WHERE Object_Sticker.DescId = zc_Object_Sticker()
                               AND Object_Sticker.isErased = false
                              ) AS Object_Sticker
                       LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                            ON ObjectLink_Sticker_Goods.ObjectId = Object_Sticker.Id
                                           AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()

                       LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                            ON ObjectLink_Sticker_StickerSort.ObjectId = Object_Sticker.Id
                                           AND ObjectLink_Sticker_StickerSort.DescId = zc_ObjectLink_Sticker_StickerSort()
                       LEFT JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerNorm
                                            ON ObjectLink_Sticker_StickerNorm.ObjectId = Object_Sticker.Id
                                           AND ObjectLink_Sticker_StickerNorm.DescId = zc_ObjectLink_Sticker_StickerNorm()
                       LEFT JOIN Object AS Object_StickerNorm ON Object_StickerNorm.Id = ObjectLink_Sticker_StickerNorm.ChildObjectId

                       LEFT JOIN ObjectBlob AS ObjectBlob_Info
                                            ON ObjectBlob_Info.ObjectId = Object_Sticker.Id
                                           AND ObjectBlob_Info.DescId = zc_ObjectBlob_Sticker_Info()
                        )



      SELECT Movement.Id				                                AS MovementId
           , Movement.InvNumber				                                AS InvNumber
           , Movement.OperDate				                                AS OperDate

           , COALESCE(MovementString_InvNumberPartner.ValueData,Movement.InvNumber) AS InvNumberPartner
           , MovementString_InvNumberOrder.ValueData                                AS InvNumberOrder
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)   AS OperDatePartner


           , View_Contract.InvNumber         		                    AS ContractName
           , ObjectDate_Signing.ValueData                                   AS ContractSigningDate
           , View_Contract.ContractKindName                                 AS ContractKind

           , ObjectString_FromAddress.ValueData                             AS PartnerAddress_From
           , ObjectString_ToAddress.ValueData                               AS PartnerAddress_To

           , OH_JuridicalDetails_To.FullName                                AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                        AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                                    AS OKPO_To

           , OH_JuridicalDetails_From.FullName                              AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress                      AS JuridicalAddress_From

           , MovementItem.Id                                                        AS Id
           , Object_Goods.ObjectCode                                                AS GoodsCode
           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')                       AS GoodsName_Juridical
           , Object_GoodsKind.ValueData                                             AS GoodsKindName
           , Object_Measure.ValueData                                               AS MeasureName

           , COALESCE (tmpObject_GoodsPropertyValue.GroupName, '')  AS GroupName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical

           , MovementItem.Amount                                                    AS Amount
           , COALESCE (MIFloat_AmountPartner.ValueData, 0)                          AS AmountPartner
           , COALESCE (MIFloat_BoxCount.ValueData, 0)                                         AS Box_Count
           , COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0) AS Box_Weight
           , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Netto_Weight
           , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) + (COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0)) AS TFloat) AS Brutto_Weight

           , 'Україна, м.Дніпро' :: TVarChar AS LoadingPlace

           , vbWeighingCount ::TFloat AS WeighingCount  --итого кол-во паллет / взвешиваний
           , CASE WHEN COALESCE (MIFloat_AmountPartner.AmountPartner_all,0) <> 0 THEN vbWeighingCount * COALESCE (MIFloat_AmountPartner.ValueData, 0)* (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / MIFloat_AmountPartner.AmountPartner_all ELSE 0 END ::TFloat AS WeighingCount_part --для тек товара кол-во паллет / взвешиваний

           , CASE WHEN vbOperDate < '01.01.2017'
                       THEN ''

                  -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDatePartner
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED_new.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED_new.ValueData FROM 1 FOR 4) END
                  -- у товара
                  WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED.ValueData FROM 1 FOR 4) END
                  -- на дату у группы товара
                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '1601'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '1602'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30103()
                       THEN '1905'
                  ELSE '0'
              END :: TVarChar AS GoodsCodeUKTZED

           , (tmpSticker.StickerSortName ||' '||tmpSticker.StickerNormName||' '||tmpSticker.Info) :: TBlob AS StickerInfo

       FROM tmpMovement
/*
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
*/

            INNER JOIN tmpMI AS MovementItem
                             ON MovementItem.MovementId =  tmpMovement.Id
                            AND MovementItem.Amount <> 0

            LEFT JOIN tmpMIFloat_AmountPartner AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                        ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                             ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box.DescId = zc_MILinkObject_Box()


            LEFT JOIN ObjectFloat AS OF_Box_Weight
                                  ON OF_Box_Weight.ObjectId = MILinkObject_Box.ObjectId
                                 AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

-- MOVEMENT
            LEFT JOIN Movement ON Movement.Id = inMovementId--MovementItem.MovementId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
--            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN ( zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = MovementItem.GoodsGroupId

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

            LEFT JOIN tmpSticker ON tmpSticker.GoodsId = MovementItem.ObjectId

      ORDER BY MovementItem.MovementId, MovementItem.Id
--       ORDER BY MovementString_InvNumberPartner.ValueData
      ;
     RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_ExpPack_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.03.19         * add LoadingPlace
 22.10.14                                                       *
 21.10.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_ExpPack_Print (inMovementId := 185675, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_Sale_ExpPack_Print (inMovementId := 185675, inSession:= zfCalc_UserAdmin());
