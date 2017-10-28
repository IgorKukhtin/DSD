-- Function: gpInsertUpdate_Object_GoodsSP_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                                  TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                                  TFloat, TFloat, TFloat, TFloat, TFloat, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Sticker_From_Excel(
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inStickerGroupName    TVarChar  , -- 
    IN inStickerTypeName     TVarChar  , -- 
    IN inStickerTagName      TVarChar  , -- 
    IN inStickerSortName     TVarChar  , -- 
    IN inStickerNormName     TVarChar  , -- 
    IN inValue1              TFloat    , -- значение цены
    IN inValue2              TFloat    , -- значение цены
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inInfo                TBlob     , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка <>
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN;      --RAISE EXCEPTION 'Ошибка.Значение <Товар> должно быть установлено.';
     END IF; 

     -- !!!поиск ИД главного товара!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inCode
                    AND Object_Goods.DescId = zc_Object_Goods()
                 );

     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Значение кода % не найдено в справочнике.', inCode;
     END IF;  
   
     vbId := (SELECT ObjectLink_Sticker_Goods.ObjectId
              FROM ObjectLink AS ObjectLink_Sticker_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerGroup
                                        ON ObjectLink_Sticker_StickerGroup.ObjectId = ObjectLink_Sticker_Goods.ObjectId
                                       AND ObjectLink_Sticker_StickerGroup.DescId = zc_ObjectLink_Sticker_StickerGroup()
                   INNER JOIN Object AS Object_StickerGroup ON Object_StickerGroup.Id = ObjectLink_Sticker_StickerGroup.ChildObjectId
                                                           AND UPPER (TRIM(Object_StickerGroup.ValueData)) = UPPER (TRIM(inStickerGroupName))
      
                   LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerType
                                        ON ObjectLink_Sticker_StickerType.ObjectId = ObjectLink_Sticker_Goods.ObjectId 
                                       AND ObjectLink_Sticker_StickerType.DescId = zc_ObjectLink_Sticker_StickerType()
                   INNER JOIN Object AS Object_StickerType ON Object_StickerType.Id = ObjectLink_Sticker_StickerType.ChildObjectId
                                                          AND UPPER (TRIM(Object_StickerType.ValueData)) = UPPER (TRIM(inStickerTypeName))
      
                   LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerTag
                                        ON ObjectLink_Sticker_StickerTag.ObjectId = ObjectLink_Sticker_Goods.ObjectId
                                       AND ObjectLink_Sticker_StickerTag.DescId = zc_ObjectLink_Sticker_StickerTag()
                   INNER JOIN Object AS Object_StickerTag ON Object_StickerTag.Id = ObjectLink_Sticker_StickerTag.ChildObjectId
                                                         AND UPPER (TRIM(Object_StickerTag.ValueData)) = UPPER (TRIM(inStickerTagName))
      
                   LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                        ON ObjectLink_Sticker_StickerSort.ObjectId = ObjectLink_Sticker_Goods.ObjectId 
                                       AND ObjectLink_Sticker_StickerSort.DescId = zc_ObjectLink_Sticker_StickerSort()
                   INNER JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId
                                                          AND UPPER (TRIM(Object_StickerSort.ValueData)) = UPPER (TRIM(inStickerSortName))
      
                   LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerNorm
                                        ON ObjectLink_Sticker_StickerNorm.ObjectId = ObjectLink_Sticker_Goods.ObjectId 
                                       AND ObjectLink_Sticker_StickerNorm.DescId = zc_ObjectLink_Sticker_StickerNorm()
                   INNER JOIN Object AS Object_StickerNorm ON Object_StickerNorm.Id = ObjectLink_Sticker_StickerNorm.ChildObjectId
                                                          AND UPPER (TRIM(Object_StickerNorm.ValueData)) = UPPER (TRIM(inStickerNormName))
      
              WHERE ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
                AND ObjectLink_Sticker_Goods.ChildObjectId = vbGoodsId
              );
              
     IF COALESCE (vbId, 0) <> 0 THEN
        RETURN;      -- данные по товару уже есть
     END IF; 
              
     PERFORM gpInsertUpdate_Object_Sticker(ioId                  := 0                   ::Integer
                                         , inCode                := lfGet_ObjectCode (0, zc_Object_Sticker())  ::Integer
                                         , inComment             := ''                  ::TVarChar
                                         , inJuridicalId         := 0                   ::Integer
                                         , inGoodsId             := vbGoodsId           ::Integer
                                         , inStickerFileId       := 0                   ::Integer
                                         , inStickerGroupName    := inStickerGroupName  ::TVarChar
                                         , inStickerTypeName     := inStickerTypeName   ::TVarChar
                                         , inStickerTagName      := inStickerTagName    ::TVarChar
                                         , inStickerSortName     := inStickerSortName   ::TVarChar
                                         , inStickerNormName     := inStickerNormName   ::TVarChar
                                         , inInfo                := inInfo              ::TBlob
                                         , inValue1              := inValue1            ::TFloat
                                         , inValue2              := inValue2            ::TFloat
                                         , inValue3              := inValue3            ::TFloat
                                         , inValue4              := inValue4            ::TFloat
                                         , inValue5              := inValue5            ::TFloat
                                         , inSession             := inSession 
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Sticker_From_Excel (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');