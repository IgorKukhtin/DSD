-- Function: gpGet_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Partion_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , 
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (PartionId     Integer
             , GoodsId       Integer
             , PartNumber    TVarChar
              )
AS
$BODY$
   DECLARE vbUserId    Integer;

   DECLARE vbPartionId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbPartNumber TVarChar;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpGetUserBySession (inSession);
     
     -- Если Пустой
     IF TRIM (inBarCode) = '' AND TRIM (inPartNumber) = '' THEN

       -- Результат
       RETURN QUERY
         SELECT 0  :: Integer   AS PartionId
              , 0  :: Integer   AS GoodsId
              , '' :: TVarChar  AS PartNumber
               ;

       -- !!!Выход!!!
       RETURN;
       
     END IF;


    --RAISE EXCEPTION 'Ошибка.Ошибка в Штрихкоде <%>.', inBarCode;
     
     -- Если это PartNumber
     IF COALESCE (inPartNumber, '') <> '' --AND CHAR_LENGTH (inBarCode) >= 12
     THEN
          -- 
          SELECT Object_PartionGoods.ObjectId
               , Object_PartionGoods.MovementItemId
               , MIString_PartNumber.ValueData
                 INTO vbGoodsId, vbPartionId, vbPartNumber
          FROM MovementItemString AS MIString_PartNumber
               INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MIString_PartNumber.MovementItemId
          WHERE MIString_PartNumber.ValueData = TRIM (inPartNumber)
            AND MIString_PartNumber.DescId    = zc_MIString_PartNumber()
          ;
          
          -- если НЕ нашли
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION 'Ошибка.Комплектующее с S/N = <%> не найден.', inPartNumber;
          END IF;
     END IF;

     -- Если это Штрихкод
     IF COALESCE (inBarCode, '') <> '' AND COALESCE (vbGoodsId, 0) = 0
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
          
          -- если НЕ нашли
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION 'Ошибка.Комплектующее с Штрихкодом = <%> не найден.', inBarCode;
          END IF;

          -- пробуем найти
        /*SELECT Object_PartionGoods.MovementItemId
               , MIString_PartNumber.ValueData
                 INTO vbPartionId, vbPartNumber
          FROM Object_PartionGoods
               LEFT JOIN MovementItemString AS MIString_PartNumber
                                            ON MIString_PartNumber.MovementItemId = Object_PartionGoods.MovementItemId
                                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
          WHERE Object_PartionGoods.ObjectId = vbGoodsId
            AND vbGoodsId > 0;*/

     END IF;

     
     -- Результат
     RETURN QUERY
       SELECT vbPartionId
            , vbGoodsId
            , vbPartNumber ::TVarChar
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
