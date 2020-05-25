-- Function: gpSelect_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpSelect_ScaleLight_MI (BigInt, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ScaleLight_MI (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleLight_MI(
 -- IN inMovementId      BigInt    , -- ключ Документа
    IN inMovementId      Integer   , -- ключ Документа
    IN inBranchCode      Integer   , -- 
    IN inColor_1         Integer   , -- 
    IN inColor_2         Integer   , -- 
    IN inColor_3         Integer   , -- 
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (-- MovementItemId BigInt
               MovementItemId Integer
               -- Категория
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- Ш/К ящика
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
               -- 
             , StorageLineName TVarChar
             , isStartWeighing Boolean
             , Amount TFloat, AmountWeight TFloat, AmountOneWeight TFloat
             , RealWeight TFloat, RealWeightWeight TFloat
             , WeightTare TFloat
             , WeightOther TFloat
             , CountSkewer1_k TFloat, CountSkewer1 TFloat, CountSkewer2 TFloat
             , WeightSkewer1_k TFloat, WeightSkewer1 TFloat, WeightSkewer2 TFloat
             , TotalWeightSkewer1_k TFloat, TotalWeightSkewer1 TFloat, TotalWeightSkewer2 TFloat
             , Count TFloat, CountPack TFloat, HeadCount TFloat, LiveWeight TFloat
               -- Ш/К единицы
             , PartionGoods TVarChar
               --
             , PartionGoodsDate TDateTime
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , LightColor Integer
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Scale_MI());

     RETURN QUERY
       WITH tmpMI AS
            (SELECT MovementItem.Id AS MovementItemId
                  , MovementItem.ParentId
                  , MovementItem.GoodsTypeKindId
                  , MovementItem.BarCodeBoxId
                  , MovementItem.Amount
                  , MovementItem.RealWeight
                  , MovementItem.LineCode
                  , MovementItem.WmsCode
                  , MovementItem.InsertDate
                  , MovementItem.UpdateDate
                  , MovementItem.isErased
                  , Movement.OperDate
                  , Movement.GoodsId
             FROM wms_MI_WeighingProduction AS MovementItem
                  LEFT JOIN wms_Movement_WeighingProduction AS Movement ON Movement.Id = MovementItem.MovementId
             WHERE MovementItem.MovementId = inMovementId
            )
       SELECT
             tmpMI.MovementItemId  :: Integer   AS MovementItemId
             -- Категория
           , Object_GoodsTypeKind.Id            AS GoodsId
           , Object_GoodsTypeKind.ObjectCode    AS GoodsCode
           , Object_GoodsTypeKind.ValueData     AS GoodsName
             --
           , Object_Measure.Id                  AS MeasureId
           , Object_Measure.ValueData           AS MeasureName
             -- Ш/К ящика                                  
           , Object_BarCodeBox.Id               AS GoodsKindId
           , Object_BarCodeBox.ObjectCode       AS GoodsKindCode
           , Object_BarCodeBox.ValueData        AS GoodsKindName
             -- Код ВМС                                  
           , SUBSTRING (tmpMI.WmsCode FROM 5 FOR 4) :: TVarChar AS StorageLineName
             -- Открыт ящик                                   
           , CASE WHEN tmpMI.ParentId > 0 THEN FALSE ELSE TRUE END :: Boolean AS isStartWeighing
                                                
           , tmpMI.Amount          :: TFloat    AS Amount
           , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN tmpMI.RealWeight WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI.Amount * ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountWeight
           , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN tmpMI.RealWeight WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI.Amount * ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountOneWeight

           , tmpMI.RealWeight      :: TFloat    AS RealWeight
           , tmpMI.RealWeight      :: TFloat    AS RealWeightWeight
           , 0                     :: TFloat    AS WeightTare
           , 0                     :: TFloat    AS WeightOther
                                                
           , 0                     :: TFloat    AS CountSkewer1_k
           , 0                     :: TFloat    AS CountSkewer1
           , 0                     :: TFloat    AS CountSkewer2
           , 0                     :: TFloat    AS WeightSkewer1_k
           , 0                     :: TFloat    AS WeightSkewer1
           , 0                     :: TFloat    AS WeightSkewer2
           , 0                     :: TFloat    AS TotalWeightSkewer1_k
           , 0                     :: TFloat    AS TotalWeightSkewer1
           , 0                     :: TFloat    AS TotalWeightSkewer2
             -- № линии                                  
           , tmpMI.LineCode        :: TFloat    AS Count
             --
           , 0                     :: TFloat    AS CountPack
           , 0                     :: TFloat    AS HeadCount
           , 0                     :: TFloat    AS LiveWeight
             -- Ш/К единицы                      
           , tmpMI.WmsCode         :: TVarChar  AS PartionGoods
             --
           , tmpMI.OperDate        :: TDateTime AS PartionGoodsDate


           , tmpMI.InsertDate      :: TDateTime AS InsertDate
           , tmpMI.UpdateDate      :: TDateTime AS UpdateDate

           , tmpMI.isErased
           , CASE WHEN tmpMI.LineCode = 1 THEN inColor_1
                  WHEN tmpMI.LineCode = 2 THEN inColor_2
                  WHEN tmpMI.LineCode = 3 THEN inColor_3
                  ELSE zc_Color_White()
             END :: Integer AS LightColor

       FROM tmpMI
            LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = tmpMI.GoodsTypeKindId
            LEFT JOIN Object AS Object_BarCodeBox    ON Object_BarCodeBox.Id    = tmpMI.BarCodeBoxId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       ORDER BY tmpMI.MovementItemId DESC
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И
 12.06.19                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ScaleLight_MI (inMovementId:= 25173, inColor_1:= 1, inColor_2:=2, inColor_3:= 3, inBranchCode:= 1, inSession:= '2')
