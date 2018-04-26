-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Income (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Income(
    IN inId             Integer  , -- ключ
    IN inisMask         Boolean  , -- по маске
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , JuridicalId Integer,  JuridicalName TVarChar
             , CompositionId Integer, CompositionName TVarChar
             , GoodsInfoId Integer, GoodsInfoName TVarChar
             , LineFabricaId Integer, LineFabricaName TVarChar
             , LabelId Integer, LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , Amount TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inId, 0) = 0
     THEN
         -- Результат
         RETURN QUERY
             SELECT
                  0 :: Integer              AS Id
               ,  0 :: Integer              AS GoodsId
               , lfGet_ObjectCode(0, zc_Object_Goods())  AS GoodsCode
               , '' :: TVarChar             AS GoodsName
               ,  0 :: Integer              AS GoodsGroupId
               , '' :: TVarChar             AS GoodsGroupName
               , Object_Measure.Id          AS MeasureId
               , Object_Measure.ValueData   AS MeasureName
               ,  0 :: Integer              AS JuridicalId
               , '' :: TVarChar             AS JuridicalName
               ,  0 :: Integer              AS CompositionId
               , '' :: TVarChar             AS CompositionName
               ,  0 :: Integer              AS GoodsInfoId
               , '' :: TVarChar             AS GoodsInfoName
               ,  0 :: Integer              AS LineFabricaId
               , '' :: TVarChar             AS LineFabricaName
               ,  0 :: Integer              AS LabelId
               , '' :: TVarChar             AS LabelName
               ,  0 :: Integer              AS GoodsSizeId
               , '' :: TVarChar             AS GoodsSizeName
               , 0  :: TFloat               AS Amount
               , 0  :: TFloat               AS OperPrice
               , 1  :: TFloat               AS CountForPrice
               , 0  :: TFloat               AS OperPriceList
             FROM Object AS Object_Measure
             WHERE Object_Measure.DescId   = zc_Object_Measure()
               AND Object_Measure.isErased = FALSE
             ORDER BY Object_Measure.Id
             LIMIT 1
            ;

     ELSE
         -- Результат
         RETURN QUERY
           WITH tmpMI AS (SELECT MovementItem.Id
                               , MovementItem.ObjectId AS GoodsId
                               , MovementItem.PartionId
                               , MovementItem.Amount
                               , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                               , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                               , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                               , MovementItem.isErased
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
                           WHERE MovementItem.Id     = inId
                             AND MovementItem.DescId = zc_MI_Master()
                          )
           -- Результат
           SELECT
                 CASE WHEN inisMask = FALSE THEN tmpMI.Id ELSE 0 END Id
               , Object_Goods.Id                AS GoodsId
               -- , Object_Goods.ObjectCode        AS GoodsCode
               , CASE WHEN inisMask = TRUE THEN lfGet_ObjectCode (0, zc_Object_Goods()) ELSE Object_Goods.ObjectCode END :: Integer AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName
               , Object_GoodsGroup.Id           AS GoodsGroupId
               -- , Object_GoodsGroup.ValueData    AS GoodsGroupName
               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupName
               , Object_Measure.Id              AS MeasureId
               , Object_Measure.ValueData       AS MeasureName
               , Object_Juridical.Id            AS JuridicalId
               , Object_Juridical.ValueData     As JuridicalName
               , Object_Composition.Id          AS CompositionId
               , Object_Composition.ValueData   AS CompositionName
               , Object_GoodsInfo.Id            AS GoodsInfoId
               , Object_GoodsInfo.ValueData     AS GoodsInfoName
               , Object_LineFabrica.Id          AS LineFabricaId
               , Object_LineFabrica.ValueData   AS LineFabricaName
               , Object_Label.Id                AS LabelId
               , Object_Label.ValueData         AS LabelName
               , Object_GoodsSize.Id            AS GoodsSizeId
               , CASE WHEN Object_GoodsSize.ValueData = '' THEN ' ' ELSE Object_GoodsSize.ValueData END :: TVarChar AS GoodsSizeName

               , tmpMI.Amount         ::TFloat
               , tmpMI.OperPrice      ::TFloat
               , tmpMI.CountForPrice  ::TFloat
               , tmpMI.OperPriceList  ::TFloat

           FROM tmpMI
                LEFT JOIN Object_PartionGoods          ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

                LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId
                LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
                LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   =  zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                LEFT JOIN Object AS Object_Juridical   ON Object_Juridical.Id   = Object_PartionGoods.JuridicalId
               ;

    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Income (inId:= 1, inSession:= '9818')
