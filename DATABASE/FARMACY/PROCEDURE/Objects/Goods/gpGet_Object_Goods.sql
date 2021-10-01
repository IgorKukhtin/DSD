-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               MinimumLot TFloat, ReferCode TFloat, ReferPrice TFloat, Price TFloat, 
               isClose boolean, 
               isTOP boolean, PercentMarkup TFloat,  isUpload Boolean,
               isFirst boolean, isSecond boolean, 
               MorionCode Integer, BarCode TVarChar,
               NameUkr TVarChar, CodeUKTZED TVarChar, ExchangeId Integer, ExchangeName TVarChar,
               NotTransferTime boolean,
               isSUN_v3 boolean, KoeffSUN_v3 TFloat,
               MakerName TVarChar, FormDispensingId Integer, FormDispensingName TVarChar, NumberPlates Integer, QtyPackage Integer, isRecipe boolean,
               isErased boolean
               ) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
  
      IF COALESCE (inId, 0) = 0
      THEN
           -- определяется <Торговая сеть>
           vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

           -- Результат
           RETURN QUERY
             SELECT CAST (0 as Integer)    AS Id
                  , GoodsCodeIntNew        AS Code
                  , CAST ('' AS TVarChar)  AS Name
                     
                  , CAST (0 as Integer)    AS GoodsGroupId
                  , CAST ('' as TVarChar)  AS GoodsGroupName  
                  , COALESCE(ObjectMeasure.Id, 0)  AS MeasureId
                  , COALESCE(ObjectMeasure.ValueData, ''::TVarChar)  AS MeasureName
                  , COALESCE(ObjectNDSKind.Id, 0)  AS NDSKindId
                  , COALESCE(ObjectNDSKind.ValueData, ''::TVarChar)  AS NDSKindName

                  , 0::TFloat     AS MinimumLot
                  , 0::TFloat     AS ReferCode
                  , 0::TFloat     AS ReferPrice
                  , 0::TFloat     AS Price
                  , false         AS isClose
                  , false         AS isTOP
                  , 0::TFloat     AS PercentMarkup
                  , false         AS isUpload
                  , false         AS isFirst
                  , false         AS isSecond
                  , 0::Integer    AS MorionCode
                  , ''::TVarChar  AS BarCode
                  , ''::TVarChar  AS NameUkr
                  , ''::TVarChar  AS CodeUKTZED
                  , 0::Integer    AS ExchangeId
                  , ''::TVarChar  AS ExchangeName
                  , CAST (FALSE AS Boolean) AS NotTransferTime
                  , FALSE ::Boolean         AS isSUN_v3
                  , 0     :: TFloat         AS KoeffSUN_v3

                  , ''::TVarChar  AS MakerName
                  , 0::Integer    AS FormDispensingId
                  , ''::TVarChar  AS FormDispensingName
                  , 0::Integer    AS NumberPlates
                  , 0::Integer    AS QtyPackage
                  , FALSE ::Boolean         AS isRecipe

                  , CAST (FALSE AS Boolean) AS isErased

             FROM (SELECT lfGet_ObjectCode_byRetail (vbObjectId, 0, zc_Object_Goods()) AS GoodsCodeIntNew) AS Object_Goods
                  LEFT JOIN Object AS ObjectMeasure ON ObjectMeasure.Id = lpGet_DefaultValue('TGoodsEditForm;zc_Object_Measure', vbUserId)::Integer
                  LEFT JOIN Object AS ObjectNDSKind ON ObjectNDSKind.Id = lpGet_DefaultValue('TGoodsEditForm;zc_Object_NDSKind', vbUserId)::Integer;

      ELSE

           -- Результат
           RETURN QUERY 
             WITH tmpGoodsMain AS (SELECT ObjectLink_Main.ChildObjectId  AS GoodsMainId
                                        , ObjectLink_Child.ChildObjectId AS GoodsId
                                   FROM ObjectLink AS ObjectLink_Child 
                                        JOIN ObjectLink AS ObjectLink_Main 
                                                        ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                   WHERE ObjectLink_Child.ChildObjectId = inId
                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                  )
                , tmpGoodsMorion AS (SELECT ObjectLink_Main_Morion.ChildObjectId          AS GoodsMainId
                                          , MAX (Object_Goods_Morion.ObjectCode)::Integer AS MorionCode
                                     FROM ObjectLink AS ObjectLink_Main_Morion
                                          JOIN tmpGoodsMain ON tmpGoodsMain.GoodsMainId = ObjectLink_Main_Morion.ChildObjectId
                                          JOIN ObjectLink AS ObjectLink_Child_Morion
                                                          ON ObjectLink_Child_Morion.ObjectId = ObjectLink_Main_Morion.ObjectId
                                                         AND ObjectLink_Child_Morion.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          JOIN ObjectLink AS ObjectLink_Goods_Object_Morion
                                                          ON ObjectLink_Goods_Object_Morion.ObjectId = ObjectLink_Child_Morion.ChildObjectId
                                                         AND ObjectLink_Goods_Object_Morion.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object_Morion.ChildObjectId = zc_Enum_GlobalConst_Marion()
                                          LEFT JOIN Object AS Object_Goods_Morion ON Object_Goods_Morion.Id = ObjectLink_Goods_Object_Morion.ObjectId
                                     WHERE ObjectLink_Main_Morion.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                     GROUP BY ObjectLink_Main_Morion.ChildObjectId
                                    )
                , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId          AS GoodsMainId
                                           --, STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                           , MAX (Object_Goods_BarCode.ValueData)::TVarChar AS BarCode
                                      FROM ObjectLink AS ObjectLink_Main_BarCode
                                           JOIN tmpGoodsMain ON tmpGoodsMain.GoodsMainId = ObjectLink_Main_BarCode.ChildObjectId
                                           JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                           ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                          AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                           ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                          AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                          AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                           LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                                      WHERE ObjectLink_Main_BarCode.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                        AND length(Object_Goods_BarCode.ValueData) <= 13
                                      GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                                     )                  
             SELECT Object_Goods_View.Id             AS Id 
                  , Object_Goods_View.GoodsCodeInt   AS Code
                  , Object_Goods_View.GoodsName      AS Name
                  
                  , COALESCE(Object_Goods_View.GoodsGroupId, 0)   AS GoodsGroupId
                  , Object_Goods_View.GoodsGroupName AS GoodsGroupName
           
                  , Object_Goods_View.MeasureId      AS MeasureId
                  , Object_Goods_View.MeasureName    AS MeasureName
           
                  , Object_Goods_View.NDSKindId      AS NDSKindId
                  , Object_Goods_View.NDSKindName    AS NDSKindName

                  , Object_Goods_View.MinimumLot     AS MinimumLot
                  , ObjectFloat_Goods_ReferCode.ValueData  AS ReferCode
                  , ObjectFloat_Goods_ReferPrice.ValueData AS ReferPrice
                  , Object_Goods_View.Price          AS Price

                  , Object_Goods_View.isClose        AS isClose

                  , Object_Goods_View.isTOP          AS isTOP
                  , Object_Goods_View.PercentMarkup  AS PercentMarkup

                  , Object_Goods_View.IsUpload       AS isUpload

                  , Object_Goods_View.isFirst        AS isFirst
                  , Object_Goods_View.isSecond       AS isSecond
                  
                  , tmpGoodsMorion.MorionCode
                  , tmpGoodsBarCode.BarCode    ::TVarChar

                  , ObjectString_Goods_NameUkr.ValueData     AS NameUkr
                  , ObjectString_Goods_CodeUKTZED.ValueData  AS CodeUKTZED

                  , Object_Exchange.Id               AS ExchangeId
                  , Object_Exchange.ValueData        AS ExchangeName
                  , COALESCE (ObjectBoolean_Goods_NotTransferTime.ValueData, False)  AS NotTransferTime
                  
                  , COALESCE (ObjectBoolean_Goods_SUN_v3.ValueData, False) ::Boolean AS isSUN_v3
                  , COALESCE (ObjectFloat_Goods_KoeffSUN_v3.ValueData,0)   :: TFloat AS KoeffSUN_v3
                  
                  , Object_Goods_Main.MakerName
                  , Object_Goods_Main.FormDispensingId
                  , Object_FormDispensing.ValueData      AS FormDispensingName
                  , Object_Goods_Main.NumberPlates
                  , Object_Goods_Main.QtyPackage
                  , Object_Goods_Main.isRecipe

                  , Object_Goods_View.isErased       AS isErased                  
                  
             FROM Object_Goods_View
                  LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_ReferCode
                                         ON ObjectFloat_Goods_ReferCode.ObjectId = Object_Goods_View.Id 
                                        AND ObjectFloat_Goods_ReferCode.DescId = zc_ObjectFloat_Goods_ReferCode()   
                  LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_ReferPrice
                                         ON ObjectFloat_Goods_ReferPrice.ObjectId = Object_Goods_View.Id 
                                        AND ObjectFloat_Goods_ReferPrice.DescId = zc_ObjectFloat_Goods_ReferPrice()

                  LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_KoeffSUN_v3
                                         ON ObjectFloat_Goods_KoeffSUN_v3.ObjectId = Object_Goods_View.Id 
                                        AND ObjectFloat_Goods_KoeffSUN_v3.DescId = zc_ObjectFloat_Goods_KoeffSUN_v3()

                  -- определяем главный товар 
                  LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = Object_Goods_View.Id
                  -- определяем код Мориона
                  LEFT JOIN tmpGoodsMorion ON tmpGoodsMorion.GoodsMainId = tmpGoodsMain.GoodsMainId
                  -- определяем штрих-код производителя
                  LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = tmpGoodsMain.GoodsMainId

                  LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                         ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods_View.Id 
                                        AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()   
                                        
                  LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                         ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods_View.Id 
                                        AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()   

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                       ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods_View.Id
                                      AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()
                  LEFT JOIN Object AS Object_Exchange ON Object_Exchange.Id = ObjectLink_Goods_Exchange.ChildObjectId
                  
                  -- Не перевдить в сроки
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_NotTransferTime
                                          ON ObjectBoolean_Goods_NotTransferTime.ObjectId = Object_Goods_View.Id 
                                         AND ObjectBoolean_Goods_NotTransferTime.DescId = zc_ObjectBoolean_Goods_NotTransferTime()

                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SUN_v3
                                          ON ObjectBoolean_Goods_SUN_v3.ObjectId = Object_Goods_View.Id 
                                         AND ObjectBoolean_Goods_SUN_v3.DescId = zc_ObjectBoolean_Goods_SUN_v3()

                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = tmpGoodsMain.GoodsMainId

                  LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Object_Goods_Main.FormDispensingId

             WHERE Object_Goods_View.Id = inId;

     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Goods(integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.   Шаблий О.В.
 31.03.20         *
 01.04.19                                                                      * GoodsAnalog
 28.09.18                                                                      * NameUkr, CodeUKTZED, ExchangeId, ExchangeName
 19.05.17                                                       * MorionCode, BarCode
 12.04.16         *
 25.03.16                                        *
 10.06.15                        *  
 23.03.15                        *  
 16.02.15                        *  
 13.11.14                        *  Дефолты
 30.10.14                        *
 24.06.14         *
 20.06.13                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Goods (43813, zfCalc_UserAdmin())