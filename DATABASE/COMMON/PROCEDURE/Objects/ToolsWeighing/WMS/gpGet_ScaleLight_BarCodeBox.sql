-- Function: gpGet_ScaleLight_BarCodeBox()

DROP FUNCTION IF EXISTS gpGet_ScaleLight_BarCodeBox (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleLight_BarCodeBox(
    IN inGoodsId     Integer    , --
    IN inGoodsKindId Integer    , -- 
    IN inBoxId       Integer    , -- 
    IN inBoxBarCode  TVarChar   , --
    IN inSession     TVarChar     -- сессия пользователя
)
RETURNS TABLE (GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindCode       Integer
             , GoodsKindName       TVarChar

             , BarCodeBoxId        Integer  --
             , BoxCode             Integer  --
             , BoxBarCode          TVarChar --
             , BoxId               Integer  --
             , BoxName             TVarChar --
             , BoxWeight           TFloat   -- Вес самого ящика
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbBoxId         Integer;
   DECLARE vbBoxCode       Integer;
   DECLARE vbBoxBarCode    TVarChar;
   DECLARE vbBarCodeBoxId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    IF CHAR_LENGTH (inBoxBarCode) >= 13 
    THEN
        vbBoxBarCode:= TRIM (inBoxBarCode);
    ELSEIF zfConvert_StringToNumber(inBoxBarCode) > 0
    THEN
        vbBoxCode:= zfConvert_StringToNumber(inBoxBarCode);
    END IF;
    

    -- нашли Ящик
    vbBoxId:= (SELECT OL_GoodsPropertyBox_Box.ChildObjectId    AS BoxId
              
               FROM ObjectLink AS OL_GoodsPropertyBox_Goods
                    -- нашли Ящик
                    INNER JOIN ObjectLink AS OL_GoodsPropertyBox_GoodsKind
                                          ON OL_GoodsPropertyBox_GoodsKind.ObjectId      = OL_GoodsPropertyBox_Goods.ObjectId
                                         AND OL_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                         AND OL_GoodsPropertyBox_GoodsKind.DescId        = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                    -- ограничили - E2 + E3
                    INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Box
                                          ON OL_GoodsPropertyBox_Box.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                         AND OL_GoodsPropertyBox_Box.DescId   = zc_ObjectLink_GoodsPropertyBox_Box()
                                         AND OL_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())
               WHERE OL_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                 AND OL_GoodsPropertyBox_Goods.DescId        = zc_ObjectLink_GoodsPropertyBox_Goods()
              );

     -- проверка
     IF COALESCE (vbBoxId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> + <%> не определен вид ящика <%> или <%>.'
                       , lfGet_Object_ValueData (inGoodsId)
                       , lfGet_Object_ValueData_sh (inGoodsKindId)
                       , lfGet_Object_ValueData_sh (zc_Box_E2())
                       , lfGet_Object_ValueData_sh (zc_Box_E3())
                       ;
     END IF;
     
     -- проверка
     IF COALESCE (vbBoxId, 0) <> COALESCE (inBoxId, 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> + <%> должен быть ящик <%>, а не <%>.'
                       , lfGet_Object_ValueData (inGoodsId)
                       , lfGet_Object_ValueData_sh (inGoodsKindId)
                       , lfGet_Object_ValueData_sh (vbBoxId)
                       , lfGet_Object_ValueData_sh (inBoxId)
                       ;
     END IF;
     
     

     -- нашли zc_Object_BarCodeBox
     IF vbBoxCode > 0
     THEN
         -- по коду
         vbBarCodeBoxId:= (SELECT Object_BarCodeBox.Id
                           FROM ObjectLink AS ObjectLink_BarCodeBox_Box
                                INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id         = ObjectLink_BarCodeBox_Box.ObjectId
                                                                      AND Object_BarCodeBox.isErased   = FALSE
                                                                      AND Object_BarCodeBox.ObjectCode = vbBoxCode
                           WHERE ObjectLink_BarCodeBox_Box.ChildObjectId = vbBoxId
                             AND ObjectLink_BarCodeBox_Box.DescId        = zc_ObjectLink_BarCodeBox_Box()
                          );

     ELSEIF TRIM (vbBoxBarCode) <> ''
     THEN
         -- по Ш/К
         vbBarCodeBoxId:= (SELECT Object_BarCodeBox.Id
                           FROM ObjectLink AS ObjectLink_BarCodeBox_Box
                                INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id        = ObjectLink_BarCodeBox_Box.ObjectId
                                                                      AND Object_BarCodeBox.isErased  = FALSE
                                                                      AND Object_BarCodeBox.ValueData = vbBoxBarCode
                           WHERE ObjectLink_BarCodeBox_Box.ChildObjectId = vbBoxId
                             AND ObjectLink_BarCodeBox_Box.DescId        = zc_ObjectLink_BarCodeBox_Box()
                          );
         -- если не нашли - ДОБАВИМ
         IF COALESCE (vbBarCodeBoxId, 0) = 0
         THEN
             vbBarCodeBoxId:= gpInsertUpdate_Object_BarCodeBox (ioId         := vbBarCodeBoxId
                                                              , inCode       := 0
                                                              , inBarCode    := vbBoxBarCode
                                                              , inWeight     := 0
                                                              , inBoxId      := vbBoxId
                                                              , inSession    := inSession
                                                               );
         END IF;
     END IF;

     -- проверка - должны найти
     IF COALESCE (vbBarCodeBoxId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Ш/К для ящика с кодом <%>.', vbBoxCode;
     END IF;


      -- Результат
      RETURN QUERY
      SELECT Object_Goods.Id             AS GoodsId
           , Object_Goods.ObjectCode     AS GoodsCode
           , Object_Goods.ValueData      AS GoodsName
           , Object_GoodsKind.Id         AS GoodsKindId
           , Object_GoodsKind.ObjectCode AS GoodsKindCode
           , Object_GoodsKind.ValueData  AS GoodsKindName

           , Object_BarCodeBox.Id             AS BarCodeBoxId
           , Object_BarCodeBox.ObjectCode     AS BoxCode
           , Object_BarCodeBox.ValueData      AS BoxBarCode
             -- Ящик
           , Object_Box.Id                      AS BoxId
           , Object_Box.ValueData               AS BoxName
             -- Вес самого ящика
           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight
      
      FROM Object AS Object_Goods
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = inGoodsKindId
           LEFT JOIN Object AS Object_Box ON Object_Box.Id = vbBoxId
           LEFT JOIN ObjectFloat AS ObjectFloat_Box_Weight
                                 ON ObjectFloat_Box_Weight.ObjectId = Object_Box.Id
                                AND ObjectFloat_Box_Weight.DescId   = zc_ObjectFloat_Box_Weight()
           LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = vbBarCodeBoxId
      WHERE Object_Goods.Id = inGoodsId;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.19                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleLight_BarCodeBox (inGoodsId:= 2153, inGoodsKindId:= 8352, inBoxId:= zc_Box_E2(), inBoxBarCode:= '1111111111111', inSession:= zfCalc_UserAdmin())
