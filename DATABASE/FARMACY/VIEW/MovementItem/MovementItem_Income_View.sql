-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_Income_View;

CREATE OR REPLACE VIEW MovementItem_Income_View AS 
       SELECT
             MovementItem.Id                    AS Id
           , MovementItem.ObjectId              AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MILinkObject_Goods.ObjectId        AS PartnerGoodsId
           , Object_PartnerGoods.GoodsCode      AS PartnerGoodsCode
           , Object_PartnerGoods.GoodsName      AS PartnerGoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_Price.ValueData            AS Price
           , CASE 
                 WHEN Movement_Income.PriceWithVAT THEN  MIFloat_Price.ValueData
                                     ELSE (MIFloat_Price.ValueData * (1 + Movement_Income.NDS/100))::TFloat
             END AS PriceWithVAT
             
           , COALESCE(MIFloat_PriceSample.ValueData,0)::TFloat      AS PriceSample
           
           , COALESCE(MIFloat_PriceSample.ValueData,0)::TFloat      AS PriceSampleWithVAT
             
           , COALESCE(MIFloat_PriceSale.ValueData,0)::TFloat        AS PriceSale
           
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))::TFloat AS SummSale
           , MovementItem.isErased              AS isErased
           , MovementItem.MovementId            AS MovementId
           , COALESCE (MIDate_ExpirationDate.ValueData, NULL)           :: TDateTime AS ExpirationDate
           , COALESCE(MIString_PartionGoods.ValueData, '')              :: TVarChar  AS PartionGoods
           , MIString_FEA.ValueData             AS FEA
           , MIString_Measure.ValueData         AS Measure
           , Object_PartnerGoods.MakerName      AS MakerName

           ,MIString_SertificatNumber.ValueData AS SertificatNumber
           ,MIDate_SertificatStart.ValueData    AS SertificatStart
           ,MIDate_SertificatEnd.ValueData      AS SertificatEnd
           ,MIFloat_AmountManual.ValueData      AS AmountManual
           ,MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
           ,Object_ReasonDifferences.ValueData      AS ReasonDifferencesName
       FROM  MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

            LEFT JOIN MovementItemFloat AS MIFloat_PriceSample
                                        ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()

            LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                        ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                       AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()                                         

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()                                         

            LEFT JOIN MovementItemString AS MIString_Measure
                                         ON MIString_Measure.MovementItemId = MovementItem.Id
                                        AND MIString_Measure.DescId = zc_MIString_Measure()                                         

            LEFT JOIN MovementItemString AS MIString_FEA
                                         ON MIString_FEA.MovementItemId = MovementItem.Id
                                        AND MIString_FEA.DescId = zc_MIString_FEA()                                         

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

            LEFT JOIN Object_Goods_View AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN Movement_Income_View AS Movement_Income ON Movement_Income.Id = MovementItem.MovementId
            
            LEFT JOIN MovementItemString AS MIString_SertificatNumber
                                         ON MIString_SertificatNumber.MovementItemId = MovementItem.Id
                                        AND MIString_SertificatNumber.DescId = zc_MIString_SertificatNumber()                                         

            LEFT JOIN MovementItemDate  AS MIDate_SertificatStart
                                        ON MIDate_SertificatStart.MovementItemId = MovementItem.Id
                                       AND MIDate_SertificatStart.DescId = zc_MIDate_SertificatStart()                                         
            LEFT JOIN MovementItemDate  AS MIDate_SertificatEnd
                                        ON MIDate_SertificatEnd.MovementItemId = MovementItem.Id
                                       AND MIDate_SertificatEnd.DescId = zc_MIDate_SertificatEnd()                                         

            LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                        ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                             ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
            LEFT JOIN Object AS Object_ReasonDifferences 
                             ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
                                     
   WHERE MovementItem.DescId     = zc_MI_Master();


ALTER TABLE MovementItem_Income_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».  ¬ÓÓ·Í‡ÎÓ ¿.¿.
 01.10.15                                                       *RegNumber,Series,SertificatStart,SertificatEnd
 09.04.15                        * 
 06.03.15                        * 
 11.12.14                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM MovementItem_Income_View where id = 805
