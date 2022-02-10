 -- Function: gpSelect_Scale_GoodsRemains()

DROP FUNCTION IF EXISTS gpSelect_Scale_GoodsRemains (Boolean, TDateTime, Integer, Integer, Integer, TVarChar, Integer,  TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_GoodsRemains(
    IN inIsGoodsComplete       Boolean  ,    -- склад ГП/производство/упаковка or обвалка
    IN inOperDate              TDateTime,
    IN inMovementId            Integer,      -- Документ
    IN inUnitId                Integer,
    IN inGoodsCode             Integer,
    IN inGoodsName             TVarChar,
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , PartionGoodsId Integer, PartionGoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , Amount_Remains TFloat
             , Amount_Remains_Weighing TFloat
             , Weight TFloat, CountForWeight TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer
             , ContainerId Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);



   IF (inBranchCode > 1000)
   THEN RETURN;
   END IF;


        -- Результат
        RETURN QUERY
            WITH tmpGoods AS (SELECT Object.Id AS GoodsId
                              FROM Object
                              WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE
                                AND inGoodsCode > 0
                             UNION ALL
                              SELECT Object.Id AS GoodsId
                              FROM Object
                              WHERE inGoodsCode = 0
                                AND TRIM (inGoodsName)  <> ''
                                AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE
                                AND Object.ValueData ILIKE ('%' || TRIM (inGoodsName) || '%')
                                AND LENGTH (TRIM (inGoodsName)) >=3
                             )
             , tmpContainer AS (SELECT Container.Id                  AS ContainerId
                                     , Container.ObjectId            AS GoodsId
                                     , CLO_GoodsKind.ObjectId        AS GoodsKindId
                                     , CLO_PartionGoods.ObjectId     AS PartionGoodsId
                                     , Object_PartionGoods.ValueData AS PartionGoodsName
                                     , Container.Amount              AS Amount
                                FROM Container
                                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                     INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                   AND CLO_Unit.ObjectId    = inUnitId
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                 WHERE Container.DescId = zc_Container_Count()
                                   AND Container.Amount > 0
                               )
           -- Результат
           SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , Object_Goods.Id                  AS GoodsId
                , Object_Goods.ObjectCode          AS GoodsCode
                , Object_Goods.ValueData           AS GoodsName
                , Object_GoodsKind.Id              AS GoodsKindId
                , Object_GoodsKind.ObjectCode      AS GoodsKindCode
                , Object_GoodsKind.ValueData       AS GoodsKindName
                , tmpContainer.PartionGoodsId      AS PartionGoodsId
                , tmpContainer.PartionGoodsName    AS PartionGoodsName
                , Object_Measure.Id                AS MeasureId
                , Object_Measure.ValueData         AS MeasureName

                , tmpContainer.Amount    :: TFloat AS Amount_Remains
                , (tmpContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS Amount_Remains_Weighing
    
                , ObjectFloat_Weight.ValueData         AS Weight
                , ObjectFloat_CountForWeight.ValueData AS CountForWeight

                , View_InfoMoney.InfoMoneyCode
                , View_InfoMoney.InfoMoneyGroupName
                , View_InfoMoney.InfoMoneyDestinationName
                , View_InfoMoney.InfoMoneyName
                , View_InfoMoney.InfoMoneyId
                
                , tmpContainer.ContainerId
           FROM tmpContainer
    
                LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpContainer.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpContainer.GoodsKindId

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = tmpContainer.GoodsId
                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                                      ON ObjectFloat_CountForWeight.ObjectId = tmpContainer.GoodsId
                                     AND ObjectFloat_CountForWeight.DescId   = zc_ObjectFloat_Goods_CountForWeight()

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpContainer.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
    
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = tmpContainer.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
    
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                     ON ObjectLink_Goods_InfoMoney.ObjectId = tmpContainer.GoodsId
                                    AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

           ORDER BY Object_GoodsKind.ValueData, Object_GoodsKind.ValueData
                  -- , ObjectString_Goods_GoodsGroupFull.ValueData
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.01.22                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_GoodsRemains (inIsGoodsComplete:= TRUE, inOperDate:= CURRENT_DATE, inMovementId:= 0, inUnitId:= 8459, inGoodsCode:= 39, inGoodsName:= '', inBranchCode:= 1, inSession:=zfCalc_UserAdmin())
