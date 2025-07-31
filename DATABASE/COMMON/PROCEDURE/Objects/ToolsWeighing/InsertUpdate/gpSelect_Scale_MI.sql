-- Function: gpSelect_Scale_MI()

DROP FUNCTION IF EXISTS gpSelect_Scale_MI (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_MI(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , Amount TFloat, AmountWeight TFloat, AmountPartner TFloat, AmountPartnerWeight TFloat
               -- цена поставщика для Сырья (из накладной)
             , PricePartner_in TFloat
               -- Количество у поставщика для Сырья (из накладной)
             , AmountPartner_in TFloat
             , SummPartner_in TFloat

             -- Признак "без оплаты" - Кол-во поставщика
             , isAmountPartnerSecond_in  Boolean
              -- Цена с НДС (да/нет) - для цена поставщика
             , isPriceWithVAT_in  Boolean
             --  Дата для цены возврат поставщику
             , OperDate_ReturnOut  TDateTime

               --
             , RealWeight TFloat, RealWeightWeight TFloat, CountTare TFloat, WeightTare TFloat
             , CountTareTotal TFloat, WeightTareTotal TFloat
             , CountTare1 TFloat, CountTare2 TFloat, CountTare3 TFloat, CountTare4 TFloat, CountTare5 TFloat, CountTare6 TFloat
             , WeightTare1  TFloat, WeightTare2  TFloat, WeightTare3  TFloat, WeightTare4  TFloat, WeightTare5  TFloat, WeightTare6  TFloat
             , Count TFloat, HeadCount TFloat, BoxCount TFloat
             , BoxNumber TFloat, LevelNumber TFloat
             , ChangePercentAmount TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , GoodsKindName TVarChar
             , BoxId Integer, BoxName TVarChar
             , PriceListName  TVarChar
             , ReasonName  TVarChar, AssetId  Integer, AssetName  TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isBarCode   Boolean
               --
             , isPromo     Boolean
             , OrderExternalName_1001 TVarChar
               --
             , Color_calc  Integer
             , TaxDoc      TFloat
             , TaxDoc_calc TFloat
             , AmountDoc   TFloat
             , AmountStart TFloat
             , AmountEnd   TFloat
               --
               -- Для Печати Этикетки № п/п
             , Ord_1001       Integer
               -- Для Печати Этикетки - № группы
             , Ord_1001_group Integer
               -- Для Печати Этикетки - накопительно кол-во
             , Amount_1001    TFloat
               --
             , Ord         Integer
             , isErased    Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbBranchCode Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);
     
     vbBranchCode:= (SELECT MF.ValueData :: Integer FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_BranchCode());


     -- определяется
     vbGoodsPropertyId:= zfCalc_GoodsPropertyId ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , (SELECT OL_Juridical.ChildObjectId FROM MovementLinkObject AS MLO LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                );

     RETURN QUERY
       WITH -- MovementItem
            tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                            -- цена поставщика для Сырья (из накладной)
                           , COALESCE (MIFloat_PricePartner.ValueData, 0) AS PricePartner_in
                             -- Количество у поставщика для Сырья (из накладной)
                           , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) AS AmountPartner_in
                           , COALESCE (MIFloat_SummPartner.ValueData, 0)         AS SummPartner_in


                             -- Признак "без оплаты" - Кол-во поставщика
                           , COALESCE (MIBoolean_AmountPartnerSecond.ValueData, FALSE) AS isAmountPartnerSecond_in
                             -- Цена с НДС (да/нет) - для цена поставщика
                           , COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) AS isPriceWithVAT_in
                             --  Дата для цены возврат поставщику
                           , MIDate_PriceRetOut.ValueData AS OperDate_ReturnOut

                           , COALESCE (MIFloat_RealWeight.ValueData, 0)          AS RealWeight
                             --  + Количество упаковок
                           , COALESCE (MIFloat_CountTare.ValueData, 0)  + CASE WHEN MIFloat_WeightPack.ValueData > 0 THEN COALESCE (MIFloat_CountPack.ValueData, 0)  ELSE 0 END AS CountTare
                             -- + Вес 1-ой упаковки
                           , COALESCE (MIFloat_WeightTare.ValueData, 0) + CASE WHEN MIFloat_WeightPack.ValueData > 0 THEN COALESCE (MIFloat_WeightPack.ValueData, 0) ELSE 0 END AS WeightTare

                           , COALESCE (MIFloat_CountTare1.ValueData, 0)  AS CountTare1
                           , COALESCE (MIFloat_WeightTare1.ValueData, 0) AS WeightTare1
                           , COALESCE (MIFloat_CountTare2.ValueData, 0)  AS CountTare2
                           , COALESCE (MIFloat_WeightTare2.ValueData, 0) AS WeightTare2
                           , COALESCE (MIFloat_CountTare3.ValueData, 0)  AS CountTare3
                           , COALESCE (MIFloat_WeightTare3.ValueData, 0) AS WeightTare3
                           , COALESCE (MIFloat_CountTare4.ValueData, 0)  AS CountTare4
                           , COALESCE (MIFloat_WeightTare4.ValueData, 0) AS WeightTare4
                           , COALESCE (MIFloat_CountTare5.ValueData, 0)  AS CountTare5
                           , COALESCE (MIFloat_WeightTare5.ValueData, 0) AS WeightTare5
                           , COALESCE (MIFloat_CountTare6.ValueData, 0)  AS CountTare6
                           , COALESCE (MIFloat_WeightTare6.ValueData, 0) AS WeightTare6

                           , CASE WHEN MIFloat_WeightPack.ValueData > 0 THEN 0 ELSE COALESCE (MIFloat_CountPack.ValueData, 0) END AS CountPack

                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount

                           , COALESCE (MIFloat_BoxNumber.ValueData, 0)   AS BoxNumber
                           , COALESCE (MIFloat_LevelNumber.ValueData, 0) AS LevelNumber

                           , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount

                           , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                           , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice

                           , MIString_PartionGoods.ValueData   AS PartionGoods
                           , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MILinkObject_Box.ObjectId, 0)       AS BoxId
                           , COALESCE (MILinkObject_PriceList.ObjectId, 0) AS PriceListId
                           , COALESCE (MILinkObject_Reason.ObjectId, 0)    AS ReasonId
                           , COALESCE (MILinkObject_Asset.ObjectId, 0)     AS AssetId

                           , MIDate_Insert.ValueData AS InsertDate
                           , MIDate_Update.ValueData AS UpdateDate

                           , MIFloat_PromoMovement.ValueData :: Integer AS MovementId_Promo

                           , COALESCE (MIBoolean_BarCode.ValueData, FALSE) AS isBarCode

                             -- Партия-Пересорт
                           , MILinkObject_Goods_out.ObjectId     AS GoodsId_out
                           , MILinkObject_GoodsKind_out.ObjectId AS GoodsKindId_out
                           , MIDate_PartionGoods_out.ValueData   AS PartionGoodsDate_out
                           , MIFloat_Amount_out.ValueData        AS Amount_out

                           , MovementItem.isErased

                      FROM MovementItem
                           LEFT JOIN MovementItemDate AS MIDate_Insert
                                                      ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           LEFT JOIN MovementItemDate AS MIDate_Update
                                                      ON MIDate_Update.MovementItemId = MovementItem.Id
                                                     AND MIDate_Update.DescId = zc_MIDate_Update()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           -- Партия-Пересорт
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_out
                                                            ON MILinkObject_Goods_out.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Goods_out.DescId         = zc_MILinkObject_Goods_out()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_out
                                                            ON MILinkObject_GoodsKind_out.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind_out.DescId         = zc_MILinkObject_GoodsKind_out()
                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods_out
                                                      ON MIDate_PartionGoods_out.MovementItemId = MovementItem.Id
                                                     AND MIDate_PartionGoods_out.DescId         = zc_MIDate_PartionGoods_out()
                           LEFT JOIN MovementItemFloat AS MIFloat_Amount_out
                                                       ON MIFloat_Amount_out.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Amount_out.DescId         = zc_MIFloat_Amount_out()

                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                       ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                       ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           -- цена Поставщика для Сырья (из накладной)
                           LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                                       ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
                           -- Количество у Поставщика для Сырья (из накладной)
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                                       ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                                       ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()

                           -- Признак "без оплаты"
                           LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPartnerSecond
                                                         ON MIBoolean_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_AmountPartnerSecond.DescId         = zc_MIBoolean_AmountPartnerSecond()
                           -- Цена с НДС (да/нет)
                           LEFT JOIN MovementItemBoolean AS MIBoolean_PriceWithVAT
                                                         ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_PriceWithVAT.DescId         = zc_MIBoolean_PriceWithVAT()
                           --  Дата для цены возврат поставщику
                           LEFT JOIN MovementItemDate AS MIDate_PriceRetOut
                                                      ON MIDate_PriceRetOut.MovementItemId = MovementItem.Id
                                                     AND MIDate_PriceRetOut.DescId         = zc_MIDate_PriceRetOut()

                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                                       ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                                       ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare1
                                                       ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare1
                                                       ON MIFloat_WeightTare1.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare1.DescId = zc_MIFloat_WeightTare1()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare2
                                                       ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare2
                                                       ON MIFloat_WeightTare2.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare2.DescId = zc_MIFloat_WeightTare2()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare3
                                                       ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare3
                                                       ON MIFloat_WeightTare3.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare3.DescId = zc_MIFloat_WeightTare3()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare4
                                                       ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare4
                                                       ON MIFloat_WeightTare4.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare4.DescId = zc_MIFloat_WeightTare4()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare5
                                                       ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare5
                                                       ON MIFloat_WeightTare5.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare5.DescId = zc_MIFloat_WeightTare5()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountTare6
                                                       ON MIFloat_CountTare6.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountTare6.DescId = zc_MIFloat_CountTare6()
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightTare6
                                                       ON MIFloat_WeightTare6.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightTare6.DescId = zc_MIFloat_WeightTare6()

                           -- <Количество упаковок>
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           -- Вес 1-ой упаковки
                           LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                                       ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()

                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                           LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                       ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_BoxNumber
                                                       ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                                      AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                           LEFT JOIN MovementItemFloat AS MIFloat_LevelNumber
                                                       ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

                           -- цена
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                            ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                                            ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Reason
                                                            ON MILinkObject_Reason.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Reason.DescId         = zc_MILinkObject_Reason()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                            ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset.DescId         = zc_MILinkObject_Asset()
                           LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                         ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                                        AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                     )
     -- Количество вложение
   , tmpAmountDoc AS (SELECT DISTINCT
                             ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                     AS GoodsId
                           , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
                           , ObjectFloat_AmountDoc.ValueData * (1 - tmpGoodsProperty.TaxDoc / 100) AS AmountStart
                           , ObjectFloat_AmountDoc.ValueData * (1 + tmpGoodsProperty.TaxDoc / 100) AS AmountEnd
                           , ObjectFloat_AmountDoc.ValueData                                       AS AmountDoc
                           , tmpGoodsProperty.TaxDoc                                               AS TaxDoc
                      FROM (SELECT OFl.ObjectId AS GoodsPropertyId, OFl.ValueData AS TaxDoc FROM ObjectFloat AS OFl WHERE OFl.ObjectId = vbGoodsPropertyId AND OFl.DescId = zc_ObjectFloat_GoodsProperty_TaxDoc() AND OFl.ValueData > 0
                           ) AS tmpGoodsProperty
                           INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                 ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                           LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                                 ON ObjectFloat_AmountDoc.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                AND ObjectFloat_AmountDoc.DescId   = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                               AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                               AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                           INNER JOIN tmpMI ON tmpMI.GoodsId     = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                                           AND tmpMI.GoodsKindId = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId
                                           AND tmpMI.isBarCode   = TRUE
                      WHERE ObjectFloat_AmountDoc.ValueData > 0
                     )
        , tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                         tmpMI.GoodsId
                                       , tmpMI.GoodsKindId
                                       , COALESCE (ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ValueData, 0) AS WeightPackageSticker
                                  FROM tmpMI
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                             ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = tmpMI.GoodsId
                                                            AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = tmpMI.GoodsKindId
                                       INNER JOIN Object AS Object_GoodsByGoodsKind
                                                         ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND Object_GoodsByGoodsKind.isErased = FALSE
                                       LEFT JOIN ObjectFloat AS ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
                                                             ON ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ObjectId  = Object_GoodsByGoodsKind.Id
                                                            AND ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.DescId    = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
                                 )
             -- Группы Для Печати Этикетки
           , tmp_group_1001_all AS (SELECT tmpMI.MovementItemId
                                         , tmpMI.MovementId_Promo
                                         , tmpMI.GoodsId
                                         , tmpMI.GoodsKindId
                                           -- № п/п для группы
                                         , ROW_NUMBER() OVER (PARTITION BY tmpMI.MovementId_Promo
                                                                         , tmpMI.GoodsId
                                                                         , tmpMI.GoodsKindId
                                                              ORDER BY tmpMI.MovementItemId ASC
                                                             ) AS Ord_group
                                    FROM tmpMI
                                    WHERE tmpMI.isErased = FALSE
                                      -- только последние
                                      AND tmpMI.isBarCode = TRUE
                                      -- Этикетки
                                      AND vbBranchCode > 1000
                                      -- AND vbUserId = 5
                                   )
           -- Группы Для Печати Этикетки, варианты: 1) нет групп 2) одна группа 3) больше 1-ой группы
          , tmp_group_1001_find AS (SELECT -- для 0 и 1 группы всегда Id_min
                                           COALESCE (tmp_group_1001_all_old.MovementItemId + 1, tmpMI.Id_min) AS Id_start
                                           -- если есть хоть одна группа, её Id и есть последний
                                         , COALESCE (tmp_group_1001_all.MovementItemId, tmpMI.Id_max) AS Id_end
                                           -- № п/п для группы
                                         , COALESCE (tmp_group_1001_all.Ord_group, 1) AS Ord_group
                                           -- если есть группа без №
                                         , tmpMI.Id_max
                                            --
                                         , tmpMI.MovementId_Promo
                                         , tmpMI.GoodsId
                                         , tmpMI.GoodsKindId
                                    FROM -- одна запись всегда
                                         (SELECT MIN (tmpMI.MovementItemId) AS Id_min, MAX (tmpMI.MovementItemId) AS Id_max
                                               , tmpMI.MovementId_Promo
                                               , tmpMI.GoodsId
                                               , tmpMI.GoodsKindId
                                          FROM tmpMI
                                          WHERE tmpMI.isErased = FALSE
                                            -- Этикетки
                                            AND vbBranchCode > 1000
                                            -- AND vbUserId = 5
                                          GROUP BY tmpMI.MovementId_Promo
                                                 , tmpMI.GoodsId
                                                 , tmpMI.GoodsKindId
                                         ) AS tmpMI
                                         -- здесь всегда последний Id для этой группы
                                         LEFT JOIN tmp_group_1001_all ON tmp_group_1001_all.MovementItemId   >= tmpMI.Id_min
                                                                     AND tmp_group_1001_all.MovementId_Promo = tmpMI.MovementId_Promo
                                                                     AND tmp_group_1001_all.GoodsId          = tmpMI.GoodsId
                                                                     AND tmp_group_1001_all.GoodsKindId      = tmpMI.GoodsKindId

                                         -- здесь может быть предыдущая группа
                                         LEFT JOIN tmp_group_1001_all AS tmp_group_1001_all_old 
                                                                      ON tmp_group_1001_all_old.Ord_group        = tmp_group_1001_all.Ord_group - 1
                                                                     AND tmp_group_1001_all_old.MovementId_Promo = tmpMI.MovementId_Promo
                                                                     AND tmp_group_1001_all_old.GoodsId          = tmpMI.GoodsId
                                                                     AND tmp_group_1001_all_old.GoodsKindId      = tmpMI.GoodsKindId
                                   )
                 -- Для Печати Этикетки
           , tmp_group_1001_res AS (-- группы с №
                                    SELECT tmp_group_1001_find.Id_start
                                         , tmp_group_1001_find.Id_end
                                           -- показать с этого айди накопительно ВЕС
                                         , tmp_group_1001_find.Id_end AS Id_show_w
                                           --
                                         , tmp_group_1001_find.MovementId_Promo
                                         , tmp_group_1001_find.GoodsId
                                         , tmp_group_1001_find.GoodsKindId
                                           -- № п/п для группы
                                         , tmp_group_1001_find.Ord_group
                                    FROM tmp_group_1001_find

                                   UNION ALL
                                    -- добавим последнюю группу без №
                                    SELECT tmpMI.Id_end + 1  AS Id_start
                                         , tmpMI.Id_max      AS Id_end
                                           -- показать с этого айди накопительно ВЕС
                                         , tmpMI.Id_end + 1  AS Id_show_w
                                           --
                                         , tmpMI.MovementId_Promo
                                         , tmpMI.GoodsId
                                         , tmpMI.GoodsKindId
                                           -- № п/п для группы
                                         , tmpMI.Ord_group + 1        AS Ord_group

                                    FROM -- получили одну запись - последняя группа, если после нее есть другие
                                         (SELECT tmp_group_1001_find.Id_end
                                               , tmp_group_1001_find.Id_max
                                               , tmp_group_1001_find.Ord_group
                                                 --
                                               , tmp_group_1001_find.MovementId_Promo
                                               , tmp_group_1001_find.GoodsId
                                               , tmp_group_1001_find.GoodsKindId
                                                 -- № п/п
                                               , ROW_NUMBER() OVER (PARTITION BY tmp_group_1001_find.MovementId_Promo
                                                                               , tmp_group_1001_find.GoodsId
                                                                               , tmp_group_1001_find.GoodsKindId
                                                                    -- нужна только последняя
                                                                    ORDER BY tmp_group_1001_find.Ord_group DESC
                                                                   ) AS Ord
                                          FROM tmp_group_1001_find
                                               -- только для последней
                                               JOIN (SELECT MAX (tmp_group_1001_find.Id_start) AS Id_start_max
                                                          , tmp_group_1001_find.MovementId_Promo
                                                          , tmp_group_1001_find.GoodsId
                                                          , tmp_group_1001_find.GoodsKindId
                                                     FROM tmp_group_1001_find
                                                     GROUP BY tmp_group_1001_find.MovementId_Promo
                                                            , tmp_group_1001_find.GoodsId
                                                            , tmp_group_1001_find.GoodsKindId
                                                    ) AS tmp_group_1001_check
                                                      ON tmp_group_1001_check.MovementId_Promo = tmp_group_1001_find.MovementId_Promo
                                                     AND tmp_group_1001_check.GoodsId          = tmp_group_1001_find.GoodsId
                                                     AND tmp_group_1001_check.GoodsKindId      = tmp_group_1001_find.GoodsKindId
                                                     -- только для последней
                                                     AND tmp_group_1001_check.Id_start_max     = tmp_group_1001_find.Id_start

                                          WHERE tmp_group_1001_find.Id_end < tmp_group_1001_find.Id_max
                                         ) AS tmpMI
                                    WHERE tmpMI.Ord = 1
                                   )
                 -- Для Печати Этикетки
               , tmp_group_1001 AS (SELECT tmpMI.MovementItemId
                                         , tmp_group_1001_res.Id_start
                                         , tmp_group_1001_res.Id_end
                                           -- № п/п для группы
                                         , tmp_group_1001_res.Ord_group
                                           -- показать с этого айди накопительно ВЕС
                                         , tmp_group_1001_res.Id_end AS Id_show_w
                                    FROM tmpMI
                                         -- Для Печати Этикетки
                                         JOIN tmp_group_1001_res ON tmpMI.MovementItemId BETWEEN tmp_group_1001_res.Id_start AND tmp_group_1001_res.Id_end
                                                                AND tmp_group_1001_res.MovementId_Promo = tmpMI.MovementId_Promo
                                                                AND tmp_group_1001_res.GoodsId          = tmpMI.GoodsId
                                                                AND tmp_group_1001_res.GoodsKindId      = tmpMI.GoodsKindId
                                   )

       -- Результат
       SELECT
             tmpMI.MovementItemId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_Measure.ValueData         AS MeasureName

           , tmpMI.Amount :: TFloat           AS Amount
           , (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountWeight

           , tmpMI.AmountPartner :: TFloat    AS AmountPartner
           , (tmpMI.AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountPartnerWeight

             -- цена поставщика для Сырья (из накладной)
           , tmpMI.PricePartner_in :: TFloat
             -- Количество у поставщика для Сырья (из накладной)
           , tmpMI.AmountPartner_in :: TFloat
           , tmpMI.SummPartner_in   :: TFloat


             -- Признак "без оплаты" - Кол-во поставщика
           , tmpMI.isAmountPartnerSecond_in :: Boolean
             -- Цена с НДС (да/нет) - для цена поставщика
           , tmpMI.isPriceWithVAT_in :: Boolean
             --  Дата для цены возврат поставщику
           , tmpMI.OperDate_ReturnOut :: TDateTime


           , tmpMI.RealWeight  :: TFloat      AS RealWeight
           , (tmpMI.RealWeight * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS RealWeightWeight
           , tmpMI.CountTare   :: TFloat      AS CountTare
           , tmpMI.WeightTare  :: TFloat      AS WeightTare

             -- Кол-во тары Итого or Кол-во ящиков Итого
           , CASE WHEN vbBranchCode = 115
                       THEN tmpMI.CountTare2 + tmpMI.CountTare3 + tmpMI.CountTare4 + tmpMI.CountTare5

                  ELSE tmpMI.CountTare + tmpMI.CountTare1 + tmpMI.CountTare2 + tmpMI.CountTare3 + tmpMI.CountTare4 + tmpMI.CountTare5 + tmpMI.CountTare6

             END :: TFloat AS CountTareTotal

             -- Вес тары Итог
           , (tmpMI.WeightTare * tmpMI.CountTare + tmpMI.WeightTare1 * tmpMI.CountTare1 + tmpMI.WeightTare2 * tmpMI.CountTare2 + tmpMI.WeightTare3 * tmpMI.CountTare3 + tmpMI.WeightTare4 * tmpMI.CountTare4 + tmpMI.WeightTare5 * tmpMI.CountTare5 + tmpMI.WeightTare6 * tmpMI.CountTare6) :: TFloat AS WeightTareTotal

           , tmpMI.CountTare1   :: TFloat   AS CountTare1
           , tmpMI.CountTare2   :: TFloat   AS CountTare2
           , tmpMI.CountTare3   :: TFloat   AS CountTare3
           , tmpMI.CountTare4   :: TFloat   AS CountTare4
           , tmpMI.CountTare5   :: TFloat   AS CountTare5
           , tmpMI.CountTare6   :: TFloat   AS CountTare6

           , tmpMI.WeightTare1  :: TFloat   AS WeightTare1
           , tmpMI.WeightTare2  :: TFloat   AS WeightTare2
           , tmpMI.WeightTare3  :: TFloat   AS WeightTare3
           , tmpMI.WeightTare4  :: TFloat   AS WeightTare4
           , tmpMI.WeightTare5  :: TFloat   AS WeightTare5
           , tmpMI.WeightTare6  :: TFloat   AS WeightTare6

             -- Кол. пакетов
           , tmpMI.CountPack   :: TFloat AS Count

             -- Кол. голов OR Кол-во шт.
           , CASE WHEN vbBranchCode = 115 AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND tmpMI.HeadCount > 0
                       THEN tmpMI.HeadCount

                  WHEN vbBranchCode = 115 AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0
                       THEN (tmpMI.AmountPartner / (ObjectFloat_Weight.ValueData + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))) :: Integer

                  ELSE tmpMI.HeadCount

             END :: TFloat AS HeadCount

           , tmpMI.BoxCount    :: TFloat AS BoxCount

           , tmpMI.BoxNumber   :: TFloat AS BoxNumber
           , tmpMI.LevelNumber :: TFloat AS LevelNumber

           , tmpMI.ChangePercentAmount :: TFloat AS ChangePercentAmount

           , tmpMI.Price         :: TFloat AS Price
           , tmpMI.CountForPrice :: TFloat AS CountForPrice

           , tmpMI.PartionGoods :: TVarChar       AS PartionGoods
           , COALESCE (tmpMI.OperDate_ReturnOut, tmpMI.PartionGoodsDate) :: TDateTime  AS PartionGoodsDate

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Box.Id                   AS BoxId
           , Object_Box.ValueData            AS BoxName
           , Object_PriceList.ValueData      AS PriceListName
           , (Object_Reason.ValueData || ' (' || Object_ReturnKind.ValueData || ')') :: TVarChar AS ReasonName
           , Object_Asset.Id                 AS  AssetId
           , (CASE WHEN -- Партия-Пересорт
                        tmpMI.GoodsId_out > 0 AND Object_Asset.ValueData IS NULL
                        THEN CASE WHEN Object_Measure.Id <> Object_Measure_out.Id
                                       THEN zfConvert_FloatToString (tmpMI.Amount_out) || ' ' || Object_Measure_out.ValueData || ' '
                                       ELSE ''
                             END
                          || '(' || zfConvert_DateShortToString (tmpMI.PartionGoodsDate) || '-'
                          || '' || zfConvert_DateShortToString (tmpMI.PartionGoodsDate_out) || ') '
                          || '(' || Object_Goods_out.ObjectCode :: TVarChar || ')'
                          || Object_Goods_out.ValueData
                          || ' * ' || COALESCE (Object_GoodsKind_out.ValueData, '')

                        ELSE Object_Asset.ValueData || ' (' || Object_Asset.ObjectCode :: TVarChar || ')'
                          || CASE WHEN ObjectString_Asset_InvNumber.ValueData  <> '' THEN ' (' || ObjectString_Asset_InvNumber.ValueData || ')'  ELSE '' END

              END) :: TVarChar AS AssetName

           , tmpMI.InsertDate :: TDateTime AS InsertDate
           , tmpMI.UpdateDate :: TDateTime AS UpdateDate

             --
           , COALESCE (tmpMI.isBarCode, FALSE) :: Boolean AS isBarCode
           , CASE WHEN tmpMI.MovementId_Promo > 0
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isPromo

             -- только для zc_Movement_OrderExternal - 1001...
           , (COALESCE (Object_Retail.ValueData, Object_GoodsProperty_alan.ValueData)
           || CASE WHEN tmpMI.MovementId_Promo > 0
                        THEN ' № <' || Movement_Promo_1001.InvNumber || '>' || ' от <' || zfConvert_DateToString (Movement_Promo_1001.OperDate) :: TVarChar || '>'
                        ELSE '' 
              END
             ) :: TVarChar AS OrderExternalName_1001

           , CASE WHEN tmpAmountDoc.AmountStart > 0 AND tmpMI.isErased = FALSE AND NOT (tmpMI.AmountPartner BETWEEN tmpAmountDoc.AmountStart AND tmpAmountDoc.AmountEnd)
                       THEN 16711680 -- clBlue
                  ELSE 0 -- clBlack
             END :: Integer AS Color_calc
           , tmpAmountDoc.TaxDoc :: TFloat AS TaxDoc
           , CASE WHEN tmpAmountDoc.AmountDoc > 0 AND tmpMI.isErased = FALSE
                       THEN 100 * tmpMI.AmountPartner / tmpAmountDoc.AmountDoc - 100
                  ELSE 0
             END :: TFloat AS TaxDoc_calc
           , tmpAmountDoc.AmountDoc   :: TFloat AS AmountDoc
           , tmpAmountDoc.AmountStart :: TFloat AS AmountStart
           , tmpAmountDoc.AmountEnd   :: TFloat AS AmountEnd

             -- Для Печати Этикетки № п/п
           , CASE WHEN tmpMI.isErased = TRUE
                       THEN 0
                  ELSE ROW_NUMBER() OVER (PARTITION BY COALESCE (tmp_group_1001.Ord_group, 1)
                                                     , tmpMI.MovementId_Promo
                                                     , tmpMI.GoodsId
                                                     , tmpMI.GoodsKindId
                                                     , tmpMI.isErased
                                          ORDER BY tmpMI.MovementItemId ASC
                                         )
             END :: Integer AS Ord_1001

             -- Для Печати Этикетки - № группы
           , CASE WHEN tmpMI.isErased = TRUE
                       THEN 0
                  ELSE COALESCE (tmp_group_1001.Ord_group, 1)
             END :: Integer AS Ord_1001_group
           --, tmp_group_1001.Id_start :: Integer AS Ord_1001_group

             -- Для Печати Этикетки - накопительно кол-во
           , (CASE WHEN tmpMI.MovementItemId >= tmp_group_1001.Id_show_w AND tmp_group_1001.Id_show_w > 0 AND tmpMI.isErased = FALSE
              THEN
              SUM (tmpMI.RealWeight -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END
                 - tmpMI.WeightTare * tmpMI.CountTare
                  ) OVER (PARTITION BY COALESCE (tmp_group_1001.Ord_group, 1)
                                     , tmpMI.MovementId_Promo
                                     , tmpMI.GoodsId
                                     , tmpMI.GoodsKindId
                          ORDER BY tmpMI.MovementItemId ASC
                         )
              ELSE 0
              END) :: TFloat AS Amount_1001
             --
           , ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId ASC) :: Integer AS Ord
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpMI.GoodsId
                                         AND tmpGoodsByGoodsKind.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN tmpAmountDoc ON tmpAmountDoc.GoodsId     = tmpMI.GoodsId
                                  AND tmpAmountDoc.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI.BoxId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMI.PriceListId
            LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = tmpMI.ReasonId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId

            -- Партия-Пересорт
            LEFT JOIN Object AS Object_Goods_out     ON Object_Goods_out.Id     = tmpMI.GoodsId_out
            LEFT JOIN Object AS Object_GoodsKind_out ON Object_GoodsKind_out.Id = tmpMI.GoodsKindId_out
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_out
                                 ON ObjectLink_Goods_Measure_out.ObjectId = tmpMI.GoodsId_out
                                AND ObjectLink_Goods_Measure_out.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_out ON Object_Measure_out.Id = ObjectLink_Goods_Measure_out.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                                 ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id
                                AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
            LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Asset_InvNumber
                                   ON ObjectString_Asset_InvNumber.ObjectId = Object_Asset.Id
                                  AND ObjectString_Asset_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- только для zc_Movement_OrderExternal - 1001...
            LEFT JOIN Movement AS Movement_Promo_1001 ON Movement_Promo_1001.Id = tmpMI.MovementId_Promo
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = tmpMI.MovementId_Promo
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
            LEFT JOIN Object AS Object_GoodsProperty_alan ON Object_GoodsProperty_alan.Id = 83955 -- Алан

            -- Для Печати Этикетки
            LEFT JOIN tmp_group_1001 ON tmp_group_1001.MovementItemId = tmpMI.MovementItemId

       -- WHERE tmpMI.isErased = FALSE
       --    OR vbUserId <> 5
       ORDER BY tmpMI.MovementItemId DESC
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.01.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_MI (inMovementId:= 25173, inSession:= '2')
