-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS SETOF refcursor 

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
     vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    SELECT MovementLinkObject.ObjectId INTO vbUnitId
    FROM MovementLinkObject
    WHERE MovementLinkObject.MovementId = inMovementId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();
      
     PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);


     OPEN Cursor1 FOR
       SELECT
             tmpMI.Id                   AS Id
           , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)              AS GoodsId
           , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode)          AS GoodsCode
           , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName)          AS GoodsName
           , COALESCE(tmpMI.isTOP, tmpGoods.isTOP)                  AS isTOP
           , COALESCE(tmpMI.GoodsGroupId, tmpGoods.GoodsGroupId)     AS GoodsGroupId
           , COALESCE(tmpMI.GoodsGroupName, tmpGoods.GoodsGroupName) AS GoodsGroupName
           , COALESCE(tmpMI.NDSKindId, tmpGoods.NDSKindId)           AS NDSKindId
           , COALESCE(tmpMI.NDSKindName, tmpGoods.NDSKindName)       AS NDSKindName
           , COALESCE(tmpMI.NDS, tmpGoods.NDS)                       AS NDS
           , CASE 
               WHEN COALESCE(tmpMI.isTOP, tmpGoods.isTOP) THEN 12615935
               ELSE 0
             END                                                    AS isTopColor
           , COALESCE(tmpMI.Multiplicity, tmpGoods.Multiplicity)    AS Multiplicity
           , tmpMI.CalcAmount
           , NULLIF(tmpMI.Amount,0)                                 AS Amount
           , tmpMI.Price * tmpMI.CalcAmount                         AS Summ
           , FALSE                                                  AS isErased
           , tmpMI.Price
           , tmpMI.MinimumLot
           , tmpMI.PartionGoodsDate
           , tmpMI.Comment
           , tmpMI.PartnerGoodsCode 
           , tmpMI.PartnerGoodsName
           , tmpMI.JuridicalName 
           , tmpMI.ContractName 
           , tmpMI.MakerName 
           , tmpMI.SuperFinalPrice 
           , COALESCE(tmpMI.isCalculated, FALSE)                    AS isCalculated
           , CASE WHEN tmpMI.PartionGoodsDate < (CURRENT_DATE + INTERVAL '180 DAY') THEN 456
                     ELSE 0
                END AS PartionGoodsDateColor   
           , Remains.Amount                                         AS RemainsInUnit
           , Object_Price_View.MCSValue                             AS MCS
           , Income.Income_Amount                                   AS Income_Amount
           , tmpMI.AmountSecond                                     AS AmountSecond
           , NULLIF(tmpMI.AmountAll,0)                              AS AmountAll
           , NULLIF(COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll),0)      AS CalcAmountAll
           , tmpMI.Price * COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll)  AS SummAll
           
       FROM (SELECT Object_Goods.Id                              AS GoodsId
                  , Object_Goods.GoodsCodeInt                    AS GoodsCode
                  , Object_Goods.GoodsName                       AS GoodsName
                  , Object_Goods.MinimumLot                      AS Multiplicity
                  , Object_Goods.isTOP                           AS isTOP
                  , Object_Goods.GoodsGroupId                    AS GoodsGroupId
                  , Object_Goods.GoodsGroupName                  AS GoodsGroupName
                  , Object_Goods.NDSKindId                       AS NDSKindId
                  , Object_Goods.NDSKindName                     AS NDSKindName
                  , Object_Goods.NDS                             AS NDS
             FROM Object_Goods_View AS Object_Goods
             WHERE Object_Goods.ObjectId = vbObjectId AND Object_Goods.isErased = FALSE
                   AND inShowAll = true       
            ) AS tmpGoods

            FULL JOIN (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , CEIL(MovementItem.Amount / COALESCE(Object_Goods.MinimumLot, 1)) 
                                * COALESCE(Object_Goods.MinimumLot, 1)                         AS CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            , Object_Goods.GoodsCodeInt                                        AS GoodsCode
                            , Object_Goods.GoodsName                                           AS GoodsName
                            , Object_Goods.MinimumLot                                          AS Multiplicity
                            , Object_Goods.GoodsGroupId                                        AS GoodsGroupId
                            , Object_Goods.GoodsGroupName                                      AS GoodsGroupName
                            , Object_Goods.NDSKindId                                           AS NDSKindId
                            , Object_Goods.NDSKindName                                         AS NDSKindName
                            , Object_Goods.NDS                                                 AS NDS
                            , MIString_Comment.ValueData                                       AS Comment
                            , COALESCE(PriceList.MakerName, MinPrice.MakerName)                AS MakerName
                            , MIBoolean_Calculated.ValueData                                   AS isCalculated
                            , ObjectFloat_Goods_MinimumLot.valuedata                           AS MinimumLot
                            , COALESCE(PriceList.Price, MinPrice.Price)                        AS Price
                            , COALESCE(PriceList.PartionGoodsDate, MinPrice.PartionGoodsDate)  AS PartionGoodsDate
                            , COALESCE(PriceList.GoodsCode, MinPrice.GoodsCode)                AS PartnerGoodsCode 
                            , COALESCE(PriceList.GoodsName, MinPrice.GoodsName)                AS PartnerGoodsName
                            , COALESCE(PriceList.JuridicalName, MinPrice.JuridicalName)        AS JuridicalName
                            , COALESCE(PriceList.ContractName, MinPrice.ContractName)          AS ContractName
                            , COALESCE(PriceList.SuperFinalPrice, MinPrice.SuperFinalPrice)    AS SuperFinalPrice
                            , Object_Goods.isTOP                                               AS isTOP
                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0) AS AmountAll
                            , CEIL((MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(Object_Goods.MinimumLot, 1)) 
                               * COALESCE(Object_Goods.MinimumLot, 1)                          AS CalcAmountAll
                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                               
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                                        ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                                       AND MILinkObject_Juridical.MovementItemId = MovementItem.id  
                                                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                        ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                       AND MILinkObject_Contract.MovementItemId = MovementItem.id  

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                                                        ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                       AND MILinkObject_Goods.MovementItemId = MovementItem.id  

                       LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated 
                                                     ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                                    AND MIBoolean_Calculated.MovementItemId = MovementItem.id  

                       LEFT JOIN MovementItemString AS MIString_Comment 
                                                    ON MIString_Comment.DescId = zc_MIString_Comment()
                                                   AND MIString_Comment.MovementItemId = MovementItem.id  

                       LEFT JOIN _tmpMI AS PriceList ON COALESCE(PriceList.ContractId, 0) = COALESCE(MILinkObject_Contract.ObjectId, 0)
                                                    AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                    AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                    AND PriceList.MovementItemId = MovementItem.id 

                       LEFT JOIN (SELECT * FROM 
                                      (SELECT *, MIN(Id) OVER(PARTITION BY MovementItemId) AS MinId FROM
                                           (SELECT *
                                                , MIN(SuperFinalPrice) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                            FROM _tmpMI) AS DDD
                                       WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice) AS DDD
                                  WHERE Id = MinId) AS MinPrice
                              ON MinPrice.MovementItemId = MovementItem.Id
                            
                       LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                                              ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE(PriceList.GoodsId, MinPrice.GoodsId) 
                                             AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                             
                       JOIN Object_Goods_View AS Object_Goods 
                                              ON Object_Goods.Id = MovementItem.ObjectId 
                  LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                              ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                             AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()  
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()  
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
            LEFT JOIN Object_Price_View ON COALESCE(tmpMI.GoodsId,tmpGoods.GoodsId) = Object_Price_View.GoodsId
                                       AND Object_Price_View.UnitId = vbUnitId
            LEFT JOIN (
                        SELECT 
                            Container.ObjectId
                           ,SUM(Container.Amount) as Amount
                        FROM
                            Container
                            Inner Join ContainerLinkObject as ContainerLinkObject_Unit
                                                           ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                          AND ContainerLinkObject_Unit.ObjectId = vbUnitId
                        WHERE 
                          Container.DescId = zc_Container_Count()
                          AND
                          Container.Amount<>0
                        GROUP BY Container.ObjectId
                      ) AS Remains
                        ON  COALESCE(tmpMI.GoodsId,tmpGoods.GoodsId) = Remains.ObjectId
            LEFT JOIN (
                        SELECT
                            MovementItem_Income.ObjectId            AS Income_GoodsId,
                            SUM(MovementItem_Income.Amount)::TFloat AS Income_Amount
                        FROM
                            Movement AS Movement_Income
                            INNER JOIN MovementItem AS MovementItem_Income
                                                    ON Movement_Income.Id = MovementItem_Income.MovementId
                                                   AND MovementItem_Income.DescId = zc_MI_Master()
                                                   AND MovementItem_Income.isErased = FALSE
                                                   AND MovementItem_Income.Amount > 0
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = vbUnitId
                            INNER JOIN MovementDate AS MovementDate_Branch
                                                    ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                   AND MovementDate_Branch.DescId = zc_MovementDate_Branch() 
                        WHERE
                            Movement_Income.DescId = zc_Movement_Income()
                            AND
                            MovementDate_Branch.ValueData >= CURRENT_DATE
                            AND
                            Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY
                            MovementItem_Income.ObjectId
                      ) AS Income ON COALESCE(tmpMI.GoodsId,tmpGoods.GoodsId) = Income.Income_GoodsId;
        RETURN NEXT Cursor1;
     

     OPEN Cursor2 FOR
      SELECT *, CASE WHEN PartionGoodsDate < (CURRENT_DATE + INTERVAL '180 DAY') THEN 456
                     ELSE 0
                END AS PartionGoodsDateColor      
              , ObjectFloat_Goods_MinimumLot.ValueData           AS MinimumLot
              , MIFloat_Remains.ValueData          AS Remains

        FROM _tmpMI
         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                               ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId 
                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
            LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                        ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                       AND MIFloat_Remains.DescId = zc_MIFloat_Remains();

   RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.15                         * 
 05.02.15                         * 
 12.11.14                         * add MinimumLot
 05.11.14                         * add MakerName
 22.10.14                         *
 13.10.14                         *
 15.07.14                                                       *
 15.07.14                                                       *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
