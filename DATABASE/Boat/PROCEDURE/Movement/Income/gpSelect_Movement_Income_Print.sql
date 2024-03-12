-- Function: gpSelect_Movement_Income_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

OPEN Cursor1 FOR

        SELECT 
            Movement_Income.Id
          , Movement_Income.InvNumber
          , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
          , Movement_Income.OperDate                  AS OperDate
          , MovementDate_OperDatePartner.ValueData    AS OperDatePartner

          , MovementBoolean_PriceWithVAT.ValueData    AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_DiscountTax.ValueData       AS DiscountTax

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_Income 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Income.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Income.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()       

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
    
            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_Income.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
    
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
    
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Income.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_Income.Id = inMovementId
          AND Movement_Income.DescId = zc_Movement_Income();

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR

       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                             -- Цена продажи
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList

                      FROM MovementItem 
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                       ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                       ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                      AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE

                     )
       -- Результат
       SELECT tmpMI.Id
            , tmpMI.PartionId
            , Object_Goods.Id          AS GoodsId
            , Object_Goods.ObjectCode  AS GoodsCode
            , Object_Goods.ValueData   AS GoodsName

            , ObjectString_Article.ValueData        AS Article
            , ObjectString_ArticleVergl.ValueData   AS ArticleVergl

            , Object_GoodsGroup.Id                  AS GoodsGroupId
            , Object_GoodsGroup.ValueData           AS GoodsGroupName
            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData              AS MeasureName
            , Object_GoodsTag.ValueData             AS GoodsTagName
            , Object_GoodsType.ValueData            AS GoodsTypeName
            , Object_GoodsSize.ValueData            AS GoodsSizeName
            , Object_ProdColor.ValueData            AS ProdColorName

            , tmpMI.Amount
       
            , tmpMI.OperPrice      ::TFloat AS OperPrice
            , tmpMI.CountForPrice  ::TFloat AS CountForPrice
              -- Цена продажи
            , tmpMI.OperPriceList  ::TFloat AS OperPriceList
       
            , zfCalc_SummIn (tmpMI.Amount, tmpMI.OperPrice, tmpMI.CountForPrice) AS TotalSumm
            , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)           AS TotalSummPriceList
       
       FROM tmpMI
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = Object_PartionGoods.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = Object_PartionGoods.GoodsTypeId
            LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = Object_PartionGoods.ProdColorId
       
            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   =  zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                   ON ObjectString_ArticleVergl.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_ArticleVergl.DescId   = zc_ObjectString_ArticleVergl()

       WHERE tmpMI.Amount <> 0;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.     Воробкало А.А.
 21.04.17         * восстановлна из рез.копии gpSelect_Movement_Sale_Print
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_Print(inMovementId := 3897397 ,  inSession := '3');
