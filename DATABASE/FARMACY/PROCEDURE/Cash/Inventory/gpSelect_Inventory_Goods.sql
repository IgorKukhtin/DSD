-- Function: gpSelect_Inventory_Goods()

DROP FUNCTION IF EXISTS gpSelect_Inventory_Goods(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_Goods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, Name TVarChar
             , isErased Boolean
             
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDS TFloat
             
             , isClose Boolean
             , isTOP Boolean
             , isFirst Boolean             
             , isSecond Boolean
             
             , isSP Boolean
             , MorionCode Integer
             , isResolution_224  boolean
             , BarCode TVarChar

             , Color_calc Integer
              ) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- поиск <Торговой сети>
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
   
   -- Товары соц-проект (документ)
   CREATE TEMP TABLE tmpGoodsSP ON COMMIT DROP AS 
   SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
   FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
   WHERE tmp.isElectronicPrescript = False;
   
   ANALYSE tmpGoodsSP;

   RETURN QUERY
      WITH tmpNDSKind AS
               (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                      , ObjectFloat_NDSKind_NDS.ValueData
                FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
               )
        ,  tmpNDS AS (SELECT Object_NDSKind.Id
                         , Object_NDSKind.ValueData                        AS NDSKindName
                         , ObjectFloat_NDSKind_NDS.ValueData               AS NDS
                    FROM Object AS Object_NDSKind
                         LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                    WHERE Object_NDSKind.DescId = zc_Object_NDSKind()
                    )

      SELECT Object_Goods_Retail.Id
           , Object_Goods_Retail.GoodsMainId
           , Object_Goods_Main.ObjectCode                                             AS GoodsCode
           , Object_Goods_Main.Name                                                   AS GoodsName
           , Object_Goods_Retail.isErased
           
           , Object_Goods_Main.GoodsGroupId
           , Object_GoodsGroup.ValueData                                              AS GoodsGroupName
           , Object_Goods_Main.MeasureId
           , Object_Measure.ValueData                                                 AS MeasureName
           , Object_Goods_Main.NDSKindId
           , tmpNDSKind.ValueData                                                     AS NDS
           , Object_Goods_Main.isClose
           , Object_Goods_Retail.isTOP
           , Object_Goods_Retail.isFirst
           , Object_Goods_Retail.isSecond

           , COALESCE (tmpGoodsSP.isSP, False)::Boolean                               AS isSP

           , Object_Goods_Main.MorionCode

           , Object_Goods_Main.isResolution_224                                       AS isResolution_224
           
           , ('2020'||TRIM(to_char(Object_Goods_Main.ObjectCode, '000000000')))::TVarChar   AS BarCode

           , CASE WHEN COALESCE (tmpGoodsSP.isSP, False) = TRUE THEN zc_Color_Yelow()
                  WHEN Object_Goods_Retail.isSecond = TRUE THEN 16440317
                  WHEN Object_Goods_Retail.isFirst = TRUE THEN zc_Color_GreenL()
                  ELSE zc_Color_White() END                                           AS Color_calc   --10965163

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
           LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
           
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = Object_Goods_Main.MeasureId
           
           LEFT JOIN tmpNDSKind ON tmpNDSKind.ObjectId = Object_Goods_Main.NDSKindId
           LEFT JOIN Object AS Object_GoodsPairSun ON Object_GoodsPairSun.Id = Object_Goods_Retail.GoodsPairSunId

           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId

      WHERE Object_Goods_Retail.RetailId = vbObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 13.04.23                                                      * 
*/

-- тест

select * from gpSelect_Inventory_Goods(inSession := '3');