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
                                )
           , tmpGoodsPropertyValue AS (SELECT tmp.GoodsPropertyId
                                            , tmp.ObjectId
                                            , tmp.MeasureId
                                            , tmp.StartPosIdent
                                            , tmp.EndPosIdent
                                            , tmp.BarCode
                                            , CASE WHEN tmp.MeasureId = zc_Measure_Sh()
                                                        THEN zfFormat_BarCodeShort (tmp.BarCode)
                                                   WHEN tmp.EndPosIdent <= 1
                                                        THEN ''
                                                   ELSE zfFormat_BarCodeShort (SUBSTRING (tmp.BarCode FROM tmp.StartPosIdent :: Integer FOR (1 + tmp.EndPosIdent - tmp.StartPosIdent) :: Integer))
                                              END AS Value
                                       FROM (SELECT tmpGoodsProperty.GoodsPropertyId
                                                  , ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                                  , tmpGoodsProperty.StartPosIdent
                                                  , CASE WHEN tmpGoodsProperty.GoodsPropertyId = 83955 -- Алан
                                                          AND SUBSTRING (ObjectString_BarCode.ValueData FROM 1 FOR 3) = '220'
                                                              THEN 1 + tmpGoodsProperty.EndPosIdent
                                                         ELSE tmpGoodsProperty.EndPosIdent
                                                    END AS EndPosIdent

                                                  , ObjectString_BarCode.ValueData         AS BarCode
                                                  , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                                             FROM tmpGoodsProperty
                                                  INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                        ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                       AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                  LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                          ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                         -- AND ObjectString_BarCode.ValueData <> ''
                                                                         AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                                  LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                       ON ObjectLink_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                      AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                       ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                            ) AS tmp
                                      )

select ObjectString_BarCodeShort.ValueData AS oldValue, tmpGoodsPropertyValue.Value AS NewValue
     , Object_Measure.ValueData
     , tmpGoodsPropertyValue.*, Object.*
     , lpInsertUpdate_ObjectString (zc_ObjectString_GoodsPropertyValue_BarCodeShort(), tmpGoodsPropertyValue.ObjectId, tmpGoodsPropertyValue.Value)
from tmpGoodsPropertyValue
     left join Object ON Object.Id = GoodsPropertyId
     left join Object AS Object_Measure ON Object_Measure.Id = MeasureId
     LEFT JOIN ObjectString AS ObjectString_BarCodeShort
                            ON ObjectString_BarCodeShort.ObjectId = tmpGoodsPropertyValue.ObjectId
                           AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
 where COALESCE (ObjectString_BarCodeShort.ValueData, '') <> COALESCE (Value, '')
-- where GoodsPropertyId = 472259

/*
+83952 -- ;16;1;"АТБ";f;;0;0
+83953 -- ;16;2;"Киев ОК";f;;0;0
+83954 -- ;16;3;"Метро";f;;0;0
+83955 -- ;16;4;"Алан";f;;0;0
+83956 -- ;16;5;"Фоззи";f;;0;0
+83957 -- ;16;6;"Кишени";f;;0;0
+420377 -- ;16;81;"Кишени-Кулинария";f;;0;0
+83958 -- ;16;7;"Виват";f;;0;0
+83959 -- ;16;8;"Билла";f;;0;0
+84098 -- ;16;9;"Билла-2";f;;0;0
+83960 -- ;16;10;"Амстор";f;;0;0
83961 -- ;16;11;"Омега";f;;0;0
83962 -- ;16;12;"Восторг";f;;0;0
+83963 -- ;16;13;"Ашан";f;;0;0
+83964 -- ;16;14;"Реал";f;;0;0
83965 -- ;16;15;"ЖД";f;;0;0
350249 -- ;16;16;"Таврия";f;;0;0
84099 -- ;16;17;"Адвентис";f;;0;0
84100 -- ;16;18;"Край";f;;0;0
351138 -- ;16;101;"Идеал";f;;0;0
351759 -- ;16;102;"Донукрторг";f;;0;0
*/