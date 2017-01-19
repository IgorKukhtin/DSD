-- Function: lpUpdate_Object_GoodsPropertyValue_BarCodeShort()

DROP FUNCTION IF EXISTS lpUpdate_Object_GoodsPropertyValue_BarCodeShort (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_GoodsPropertyValue_BarCodeShort(
    IN inGoodsPropertyId       Integer   ,    -- Классификатор свойств товаров
    IN inGoodsPropertyValueId  Integer   ,    -- 
    IN inUserId                Integer        -- Пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN
       --
       CREATE TEMP TABLE _tmpNew (ObjectId Integer, Value TVarChar) ON COMMIT DROP;
       WITH tmpGoodsProperty AS (SELECT Object_GoodsProperty.Id            AS GoodsPropertyId
                                      , CASE WHEN ObjectFloat_StartPosIdent.ValueData > 0
                                                  THEN ObjectFloat_StartPosIdent.ValueData
                                             ELSE 1
                                        END AS StartPosIdent
                                      , CASE WHEN ObjectFloat_EndPosIdent.ValueData > 0
                                                  THEN ObjectFloat_EndPosIdent.ValueData
                                             ELSE ObjectFloat_StartPosInt.ValueData - 1
                                        END AS EndPosIdent
                                 FROM Object AS Object_GoodsProperty
                                      INNER JOIN ObjectFloat AS ObjectFloat_StartPosInt
                                                             ON ObjectFloat_StartPosInt.ObjectId = Object_GoodsProperty.Id
                                                            AND ObjectFloat_StartPosInt.DescId = zc_ObjectFloat_GoodsProperty_StartPosInt()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_StartPosIdent 
                                                            ON ObjectFloat_StartPosIdent.ObjectId = Object_GoodsProperty.Id 
                                                           AND ObjectFloat_StartPosIdent.DescId = zc_ObjectFloat_GoodsProperty_StartPosIdent()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_EndPosIdent 
                                                            ON ObjectFloat_EndPosIdent.ObjectId = Object_GoodsProperty.Id 
                                                           AND ObjectFloat_EndPosIdent.DescId = zc_ObjectFloat_GoodsProperty_EndPosIdent()
                                 WHERE Object_GoodsProperty.DescId = zc_Object_GoodsProperty()
                                   AND Object_GoodsProperty.Id = inGoodsPropertyId
                                )
           , tmpGoodsPropertyValue AS (SELECT tmp.ObjectId
                                            , CASE WHEN tmp.MeasureId = zc_Measure_Sh()
                                                        THEN zfFormat_BarCodeShort (tmp.BarCode)
                                                   WHEN tmp.EndPosIdent <= 1
                                                        THEN ''
                                                   ELSE zfFormat_BarCodeShort (SUBSTRING (tmp.BarCode FROM tmp.StartPosIdent :: Integer FOR (1 + tmp.EndPosIdent - tmp.StartPosIdent) :: Integer))
                                              END AS Value
                                            , tmp.BarCodeShort
                                       FROM (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                                  , tmpGoodsProperty.StartPosIdent
                                                  , CASE WHEN tmpGoodsProperty.GoodsPropertyId = 83955 -- Алан
                                                          AND SUBSTRING (ObjectString_BarCode.ValueData FROM 1 FOR 3) = '220'
                                                              THEN 1 + tmpGoodsProperty.EndPosIdent - 1 --***
                                                         ELSE tmpGoodsProperty.EndPosIdent
                                                    END AS EndPosIdent

                                                  , ObjectString_BarCode.ValueData         AS BarCode
                                                  , COALESCE (ObjectString_BarCodeShort.ValueData, '') AS BarCodeShort
                                                  , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                                             FROM tmpGoodsProperty
                                                  INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                        ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                       AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                                       AND (ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = inGoodsPropertyValueId OR COALESCE (inGoodsPropertyValueId, 0) = 0)
                                                  LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                         ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                        AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                                  LEFT JOIN ObjectString AS ObjectString_BarCodeShort
                                                                         ON ObjectString_BarCodeShort.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                        AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
                                                  LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                       ON ObjectLink_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                      AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                       ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                            ) AS tmp
                                      )
       INSERT INTO _tmpNew (ObjectId, Value)
         SELECT tmpGoodsPropertyValue.ObjectId, tmpGoodsPropertyValue.Value FROM tmpGoodsPropertyValue WHERE tmpGoodsPropertyValue.Value <> tmpGoodsPropertyValue.BarCodeShort;


   -- сохранили
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsPropertyValue_BarCodeShort(), _tmpNew.ObjectId, _tmpNew.Value)
   FROM _tmpNew;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.01.16                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_GoodsPropertyValue_BarCodeShort()
