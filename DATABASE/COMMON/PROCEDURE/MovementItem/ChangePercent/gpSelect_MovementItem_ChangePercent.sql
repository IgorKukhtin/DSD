-- Function: gpSelect_MovementItem_ChangePercent()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChangePercent (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChangePercent (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ChangePercent(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, CountForPrice TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , AmountSumm TFloat 
             , Price_ChangePercent TFloat
             , Sum_ChangePercent TFloat
             
             , Sum_Diff1 TFloat
             , AmountSumm_tax TFloat
             , Sum_ChangePercent_tax TFloat
             , Sum_Diff2 TFloat
             , Sum_Diff3 TFloat
             
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer; 
  DECLARE vbChangePercent TFloat;
  DECLARE vbToId       Integer;
  DECLARE vbContractId Integer;
  DECLARE vbOperDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

-- параметры из документа
     SELECT MovementFloat_ChangePercent.ValueData  AS ChangePercent
          , MovementLinkObject_To.ObjectId         AS ToId
          , MovementLinkObject_Contract.ObjectId   AS ContractId
          , Movement.OperDate                      AS OperDate
   INTO vbChangePercent, vbToId, vbContractId, vbOperDate
     FROM Movement 
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

     WHERE Movement.Id = inMovementId;

     --параметры для получения налоговых
     vbStartDate := DATE_TRUNC ('MONTH', vbOperDate);
     vbEndDate   := DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     RETURN QUERY 
     --находим налоговые из которых полученны данные для документа, для расчета скидки, цены со скидкой    
     /*если 2 или больше налоговых, тогда для каждого кол-ва из налоговой считаем округл сумму без скидки и сумму со скидкой (здесь от цены со скидкой)
     , только потом складываем и получаем итог сумму без скидки и сумму со скидкой 
      */
     WITH
     tmpTax AS (SELECT Movement.Id 
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                 AND MovementLinkObject_To.ObjectId = vbToId

                     INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                 AND MovementLinkObject_Contract.ObjectId = vbContractId
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                )

   , tmpMI_Tax AS (SELECT tmpTax.Id                       AS MovementId
                        , MovementItem.ObjectId           AS GoodsId
                        , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                        , MIFloat_Price.ValueData         AS Price
                        , MIFloat_CountForPrice.ValueData AS CountForPrice
                        , MovementItem.Amount             AS Amount

                        --сумма
                        , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                        THEN CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                     ELSE CAST  (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                END AS TFloat)		AS AmountSumm
                        
                        --цена со скидкой без НДС
                        , CAST ( (MIFloat_Price.ValueData *(1 - vbChangePercent / 100)) AS NUMERIC (16, 2)) ::TFloat AS Price_ChangePercent
                        --Сумма со скидкой без НДС
                        , CAST ( CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                               THEN CAST (MovementItem.Amount / MIFloat_CountForPrice.ValueData AS NUMERIC (16,3))
                                            ELSE MovementItem.Amount
                                       END AS TFloat)
                                 * CAST ( (MIFloat_Price.ValueData *(1 - vbChangePercent / 100)) AS NUMERIC (16, 2))
                               AS NUMERIC (16, 2))                          ::TFloat AS Sum_ChangePercent
                   FROM tmpTax
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmpTax.Id
                                               AND MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.isErased = FALSE

                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                    ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                   AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   )
         
   , tmpCalc AS (SELECT tmp.GoodsId
                      , tmp.GoodsKindId
                      , tmp.CountForPrice
                      , tmp.Price
                      , tmp.Price_ChangePercent
                      , SUM (tmp.AmountSumm) AS AmountSumm
                      , SUM (tmp.Sum_ChangePercent) AS Sum_ChangePercent
                 FROM tmpMI_Tax AS tmp 
                 GROUP BY tmp.GoodsId
                        , tmp.GoodsKindId
                        , tmp.Price
                        , tmp.Price_ChangePercent
                        , tmp.CountForPrice 
                 ) AS tmp;
         

       SELECT
             MovementItem.Id				AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
           , Object_Goods.Id          			AS GoodsId
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData   			AS GoodsName
           , MovementItem.Amount			    AS Amount
           , MIFloat_Price.ValueData 			AS Price
           , MIFloat_CountForPrice.ValueData 	AS CountForPrice

           , Object_GoodsKind.Id        		AS GoodsKindId
           , Object_GoodsKind.ValueData 		AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
            --сумма
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST  (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)		AS AmountSumm
           
           --цена со скидкой без НДС
           , CAST ( (MIFloat_Price.ValueData *(1 - vbChangePercent / 100)) AS NUMERIC (16, 2)) ::TFloat AS Price_ChangePercent
           --Сумма со скидкой без НДС
           , CAST ( CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                  THEN CAST (MovementItem.Amount / MIFloat_CountForPrice.ValueData AS NUMERIC (16,3))
                               ELSE MovementItem.Amount
                          END AS TFloat)
                    * CAST ( (MIFloat_Price.ValueData *(1 - vbChangePercent / 100)) AS NUMERIC (16, 2))
                  AS NUMERIC (16, 2))                          ::TFloat AS Sum_ChangePercent
           
           -- сумма скидки 1) разница суммы без скидки и суммы со скидкой
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST  (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)
           - CAST ( CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                  THEN CAST (MovementItem.Amount / MIFloat_CountForPrice.ValueData AS NUMERIC (16,3))
                               ELSE MovementItem.Amount
                          END AS TFloat)
                    * CAST ( (MIFloat_Price.ValueData *(1 - vbChangePercent / 100)) AS NUMERIC (16, 2))
                  AS NUMERIC (16, 2)) AS Sum_Diff1
           -- сумма без скидки из налоговой  
           , tmpCalc.AmountSumm AS AmountSumm_tax
           -- сумма со скидкой из налоговой  
           , tmpCalc.Sum_ChangePercent AS Sum_ChangePercent_tax 
           -- разница налоговая
           , tmpCalc.AmountSumm - tmpCalc.Sum_ChangePercent AS Sum_Diff2
           
           --отклонение 
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST  (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)
           - CAST ( CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                  THEN CAST (MovementItem.Amount / MIFloat_CountForPrice.ValueData AS NUMERIC (16,3))
                               ELSE MovementItem.Amount
                          END AS TFloat)
                    * CAST ( (MIFloat_Price.ValueData *(1 - vbChangePercent / 100)) AS NUMERIC (16, 2))
                  AS NUMERIC (16, 2))
           -  (tmpCalc.AmountSumm - tmpCalc.Sum_ChangePercent) AS Sum_Diff3

           , MovementItem.isErased              AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            
            LEFT JOIN tmpCalc ON tmpCalc.GoodsId = Object_Goods.Id
                             AND tmpCalc.GoodsKindId = Object_GoodsKind.Id
                             AND tmpCalc.Price = MIFloat_Price.ValueData
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ChangePercent (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')

/*
там кол, цена без ск и цена со скидко 
+ сумма без ск и сумма со скидкой 

+ 2 варианта расчета суммы скидки 1) разница суммы без скидки и суммы со скидкой  
                                  2) тоже разница, но если 2 или больше налоговых, тогда для каждого кол-ва из налоговой считаем округл сумму без скидки и сумму со скидкой (здесь от цены со скидкой)
                                  , только потом складываем и получаем итог сумму без скидки и сумму со скидкой 
+ еще колонка с разницей суммы скидки для 2-х вариантов
*/