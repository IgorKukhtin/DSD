-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , PriceWithVAT TFloat
             , MarginPercent TFloat
             , Summ TFloat
             , SalePrice TFloat
             , SaleSumm TFloat
             , isErased Boolean
             , ExpirationDate TDateTime
             , PartionGoods TVarChar
             , MakerName TVarChar
             , FEA TVarChar
             , Measure TVarChar
             , DublePriceColour Integer
             , SertificatNumber TVarChar
             , SertificatStart TDateTime
             , SertificatEnd TDateTime
             , WarningColor Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbVAT TFloat;
  DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   SELECT Movement_Income_View.PriceWithVAT, Movement_Income_View.NDS INTO vbPriceWithVAT, vbVAT 
     FROM Movement_Income_View 
    WHERE Movement_Income_View.Id = inMovementId;


     IF inShowAll THEN

     RETURN QUERY
       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ''::TVarChar               AS PartnerGoodsCode
           , ''::TVarChar               AS PartnerGoodsName
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS Price
           , CAST (NULL AS TFloat)      AS PriceWithVAT
           , CAST (NULL AS TFloat)      AS MarginPercent
           , CAST (NULL AS TFloat)      AS Summ
           , CAST (NULL AS TFloat)      AS PriceSale
           , CAST (NULL AS TFloat)      AS SummSale
           , FALSE                      AS isErased
           , NULL::TDateTime            AS ExpirationDate
           , NULL::TVarChar             AS PartionGoods
           , NULL::TVarChar             AS MakerName
           , NULL::TVarChar             AS FEA
           , NULL::TVarChar             AS Measure
           , NULL::Integer              AS DublePriceColour
           , NULL::TVarChar             AS SertificatNumber
           , NULL::TDateTime            AS SertificatStart
           , NULL::TDateTime            AS SertificatEnd
           , NULL::INteger              AS WarningColor

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.GoodsCodeInt                                         AS GoodsCode
                  , Object_Goods.GoodsName                                            AS GoodsName
             FROM Object_Goods_View AS Object_Goods
             WHERE Object_Goods.isErased = FALSE AND Object_Goods.ObjectId = vbObjectId
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
        SELECT
             MovementItem.Id
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.PartnerGoodsCode
           , MovementItem.PartnerGoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.PriceWithVAT
           , ((MovementItem.PriceSale/MovementItem.PriceWithVAT - 1) * 100)::TFloat AS MarginPercent
           , MovementItem.AmountSumm
           , MovementItem.PriceSale
           , MovementItem.SummSale
           , MovementItem.isErased
           , MovementItem.ExpirationDate
           , MovementItem.PartionGoods
           , MovementItem.MakerName
           , MovementItem.FEA
           , MovementItem.Measure
           , DublePrice.DublePriceColour
           , MovementItem.SertificatNumber
           , MovementItem.SertificatStart
           , MovementItem.SertificatEnd
           , CASE 
               WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()
               WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()
             END AS WarningColor

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem_Income_View AS MovementItem ON MovementItem.MovementId = inMovementId
                                                         AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT OUTER JOIN (
                                SELECT  MovementItem_Income_View.GoodsId, zc_Color_Goods_Additional() AS DublePriceColour
                                FROM MovementItem_Income_View
                                WHERE MovementItem_Income_View.MovementId = inMovementId 
                                  AND MovementItem_Income_View.isErased   = FALSE
                                GROUP BY MovementItem_Income_View.GoodsId
                                HAVING COUNT(DISTINCT MovementItem_Income_View.Price) > 1
                            ) AS DublePrice 
                              ON MovementItem.GoodsId = DublePrice.GoodsId;

     ELSE

     RETURN QUERY
       SELECT
             MovementItem.Id
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.PartnerGoodsCode
           , MovementItem.PartnerGoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.PriceWithVAT
           , ((MovementItem.PriceSale/MovementItem.PriceWithVAT - 1) * 100)::TFloat AS MarginPercent
           , MovementItem.AmountSumm
           , MovementItem.PriceSale
           , MovementItem.SummSale
           , MovementItem.isErased
           , MovementItem.ExpirationDate
           , MovementItem.PartionGoods
           , MovementItem.MakerName
           , MovementItem.FEA
           , MovementItem.Measure
           , DublePrice.DublePriceColour
           , MovementItem.SertificatNumber
           , MovementItem.SertificatStart
           , MovementItem.SertificatEnd
           , CASE 
               WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()
               WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()
             END AS WarningColor

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem_Income_View AS MovementItem ON MovementItem.MovementId = inMovementId
                                                         AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT OUTER JOIN (
                                SELECT  MovementItem_Income_View.GoodsId, zc_Color_Goods_Additional() AS DublePriceColour
                                FROM MovementItem_Income_View
                                WHERE MovementItem_Income_View.MovementId = inMovementId 
                                  AND MovementItem_Income_View.isErased   = FALSE
                                GROUP BY MovementItem_Income_View.GoodsId
                                HAVING COUNT(DISTINCT MovementItem_Income_View.Price) > 1
                            ) AS DublePrice 
                              ON MovementItem.GoodsId = DublePrice.GoodsId;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 01.10.15                                                                        *SertificatNumber,SertificatStart,SertificatEnd               
 09.04.15                         *
 06.03.15                         *
 26.12.14                         *
 09.12.14                         *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
