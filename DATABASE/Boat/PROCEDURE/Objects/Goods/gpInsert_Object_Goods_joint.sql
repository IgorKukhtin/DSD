--
DROP FUNCTION IF EXISTS gpInsert_Object_Goods_joint (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Goods_joint(
    IN inGoodsGroupId    Integer ,
 INOUT ioGoodsId         Integer ,
    IN inGoodsName       TVarChar,
    IN inArticle         TVarChar,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   --если ТОвар сохранен, то ничего не меняем
   IF COALESCE (ioGoodsId,0) <> 0
   THEN
        RETURN;
   END IF;

   -- пробуем найти Товар
   IF COALESCE (inGoodsName, '') <> ''
   THEN
       -- по Названию
       ioGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData = TRIM (inGoodsName));

       IF COALESCE (ioGoodsId, 0) = 0
       THEN
       -- создаем
       ioGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (ioGoodsId,0):: Integer
                                              , inCode             := 0                     :: Integer
                                              , inName             := TRIM (inGoodsName)    :: TVarChar
                                              , inArticle          := TRIM (inArticle)     :: TVarChar
                                              , inArticleVergl     := ''                    :: TVarChar
                                              , inEAN              := ''                    :: TVarChar
                                              , inASIN             := ''                    :: TVarChar
                                              , inMatchCode        := ''                    :: TVarChar 
                                              , inFeeNumber        := ''                    :: TVarChar
                                              , inComment          := ''                    :: TVarChar
                                              , inIsArc            := False                 :: Boolean
                                              , inAmountMin        := 0                :: TFloat
                                              , inAmountRefer      := 0                :: TFloat
                                              , inEKPrice          := 0                :: TFloat
                                              , inEmpfPrice        := 0                :: TFloat
                                              , inGoodsGroupId     := inGoodsGroupId   :: Integer
                                              , inMeasureId        := 2761             :: Integer           --шт
                                              , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
                                              , inGoodsTypeId      := 0                :: Integer
                                              , inGoodsSizeId      := 0                :: Integer
                                              , inProdColorId      := 0                :: Integer
                                              , inPartnerId        := 0                :: Integer
                                              , inUnitId           := 0                :: Integer
                                              , inDiscountPartnerId := 0               :: Integer
                                              , inTaxKindId        := 2726             :: Integer                  --базовый
                                              , inEngineId         := NULL
                                              , inSession          := inSession        :: TVarChar
                                              );
       END IF;

       --RAISE EXCEPTION 'Ошибка.???';

   END IF;



   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods_From_Excel()