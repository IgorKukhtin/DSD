-- Function: gpInsert_Object_ReceiptProdModelChild_Load (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_ReceiptProdModelChild_Load (Integer, Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_ReceiptProdModelChild_Load(
    IN inReceiptProdModelId     Integer  , -- прайс лист
    In inReceiptLevelId_top     Integer  , -- Level
    IN inGoodsCode              Integer  , -- 
    IN inArticle                TVarChar , --
    IN inGoodsName              TVarChar , 
    IN inAmount                 TFloat   , -- количество
    IN inSession                TVarChar   -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск товара по коду
    vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

    IF COALESCE (vbGoodsId, 0) = 0
    THEN
       -- RAISE EXCEPTION 'Ошибка.Значение код товара = <%> не найден. <%>', inGoodsCode;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение код товара = <%> не найден.<%> Артикул <%>' :: TVarChar
                                             , inProcedureName := 'gpInsert_Object_ReceiptProdModelChild_Load' :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := inGoodsCode :: TVarChar
                                             , inParam2        := inGoodsName :: TVarChar
                                             , inParam3        := inArticle   :: TVarChar
                                             );
    END IF;


    --
    PERFORM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := 0                     ::Integer
                                                       , inComment            := inGoodsName           ::TVarChar
                                                       , inReceiptProdModelId := inReceiptProdModelId  ::Integer
                                                       , inObjectId           := vbGoodsId             ::Integer
                                                       , inReceiptLevelId_top := inReceiptLevelId_top  ::Integer
                                                       , inReceiptLevelId     := 0                     ::Integer
                                                       , ioValue              := inAmount              ::TFloat
                                                       , ioValue_service      := 0                     ::TFloat
                                                       , inSession            := inSession             ::TVarChar
                                                        );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.21         *
*/

-- тест
