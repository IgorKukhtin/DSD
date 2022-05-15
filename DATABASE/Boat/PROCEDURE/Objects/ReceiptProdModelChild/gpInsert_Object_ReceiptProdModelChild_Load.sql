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
    DECLARE vbUserId  Integer;
    DECLARE vbId      Integer;
    DECLARE vbGoodsId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());
    vbUserId:= lpGetUserBySession (inSession);
    

    IF inArticle ILIKE 'Int. Arbeitseinheiten' THEN RETURN; END IF;

    
    IF inGoodsCode > 0
    THEN
        -- поиск товара по коду
        vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);
    ELSE
        -- поиск товара по коду
        vbGoodsId := (SELECT Object.Id
                      FROM Object
                           INNER JOIN ObjectString AS ObjectString_Article
                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                  AND ObjectString_Article.ValueData ILIKE inArticle
                      WHERE Object.DescId = zc_Object_Goods()
                     );
    END IF;

    
    IF COALESCE (vbGoodsId, 0) = 0
    THEN
       RETURN;
       --
       -- RAISE EXCEPTION 'Ошибка.Значение код товара = <%> не найден. <%>', inGoodsCode;
       --
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение код товара = <%> не найден.<%> Артикул <%>' :: TVarChar
                                             , inProcedureName := 'gpInsert_Object_ReceiptProdModelChild_Load' :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := inGoodsCode :: TVarChar
                                             , inParam2        := inGoodsName :: TVarChar
                                             , inParam3        := inArticle   :: TVarChar
                                              );
    END IF;

    -- поиск ReceiptProdModelChild
    vbId:= (SELECT Object_ReceiptProdModelChild.Id
            FROM Object AS Object_ReceiptProdModelChild
                 JOIN ObjectLink AS ObjectLink_Object
                                 ON ObjectLink_Object.ObjectId      = Object_ReceiptProdModelChild.Id
                                AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
            WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
              AND Object_ReceiptProdModelChild.isErased = FALSE
           );


    --
    vbId:= (SELECT tmp.ioId
            FROM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := vbId
                                                            , inComment            := inGoodsName           ::TVarChar
                                                            , inReceiptProdModelId := inReceiptProdModelId  ::Integer
                                                            , inObjectId           := vbGoodsId             ::Integer
                                                            , inReceiptLevelId_top := inReceiptLevelId_top
                                                            , inReceiptLevelId     := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbId AND OL.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel())
                                                            , ioValue              := inAmount              ::TFloat
                                                            , ioValue_service      := 0                     ::TFloat
                                                            , ioIsCheck            := FALSE
                                                            , inSession            := inSession             ::TVarChar
                                                             ) AS tmp);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Check(), vbId, FALSE);
    
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
