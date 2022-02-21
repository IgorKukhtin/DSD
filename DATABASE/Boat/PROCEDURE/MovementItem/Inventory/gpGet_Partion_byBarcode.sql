-- Function: gpGet_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Partion_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (PartionId     Integer
             , GoodsId       Integer
             , OperPriceList TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;

   DECLARE vbPartionId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbOperPriceList TFLoat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpGetUserBySession (inSession);
     
     -- Если Пустой
     IF TRIM (inBarCode) = '' THEN

       -- Результат
       RETURN QUERY
         SELECT 0 :: Integer AS PartionId
              , 0 :: Integer AS GoodsId
              , 0 :: TFloat  AS OperPriceList
               ;

       -- !!!Выход!!!
       RETURN;
       
     END IF;


    --RAISE EXCEPTION 'Ошибка.Ошибка в Штрихкоде <%>.', inBarCode;
     
     -- Если это Штрихкод
     IF COALESCE (inBarCode, '') <> '' --AND CHAR_LENGTH (inBarCode) >= 12
     THEN
          -- последние 10 - это ИД
          vbGoodsId:= (SELECT Object.Id
                       FROM Object
                           INNER JOIN ObjectString AS ObjectString_EAN
                                                   ON ObjectString_EAN.ObjectId = Object.Id
                                                  AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
                                                  AND ObjectString_EAN.ValueData = TRIM (inBarCode)
                       WHERE Object.DescId = zc_Object_Goods()
                        -- AND Object.Id = zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) :: Integer
                       );
          
          -- пробуем найти
          SELECT Object_PartionGoods.MovementItemId
               , Object_PartionGoods.OperPriceList
         INTO vbPartionId, vbOperPriceList
          FROM Object_PartionGoods
          WHERE Object_PartionGoods.ObjectId = vbGoodsId
            AND vbGoodsId > 0;

          -- если НЕ нашли
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION 'Ошибка.Товар со Штрихкодом = <%> не найден.', inBarCode;
          END IF;
     END IF;

/*
     --ИД товара, товар вібран из справочника
     IF COALESCE (inBarCode, '') <> '' AND CHAR_LENGTH (inBarCode) < 12
     THEN
          -- последние 10 - это Код
          vbGoodsId:= (SELECT Object.Id
                       FROM Object
                       WHERE Object.DescId = zc_Object_Goods()
                         AND Object.ObjectCode = zfConvert_StringToNumber (inBarCode) :: Integer
                       );
          -- пробуем найти
          SELECT Object_PartionGoods.MovementItemId
               , Object_PartionGoods.OperPriceList
         INTO vbPartionId, vbOperPriceList
          FROM Object_PartionGoods
          WHERE Object_PartionGoods.ObjectId = vbGoodsId
            AND vbGoodsId > 0;

          -- если НЕ нашли
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION 'Ошибка.Товар с Идентификатором = <%> не найден.', inBarCode;
          END IF;

     END IF;
     */
     
     -- Результат
     RETURN QUERY
       SELECT vbPartionId
            , vbGoodsId
            , vbOperPriceList ::TFLoat
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
-- SELECT tmp.*, Object_Goods.* FROM gpGet_Partion_byBarcode (inBarCode:= '221000038868', inSession:= zfCalc_UserAdmin()) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId 
