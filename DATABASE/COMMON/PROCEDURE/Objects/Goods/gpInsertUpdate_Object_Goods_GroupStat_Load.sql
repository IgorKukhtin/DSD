 -- Function: gpInsertUpdate_Object_Goods_GroupStat_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_GroupStat_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_GroupStat_Load(
    IN inGoodsCode      Integer   , -- Код объекта <Товар>
    IN inGoodsName      TVarChar    , -- 
    IN inGroupStatName  TVarChar    , -- 
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGroupStatId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустой код - Пропустили!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Передан код = 0, товар <%>', inGoodsName;
        --RETURN; -- !!!ВЫХОД!!!
     END IF;

     -- !!!Пустая группа статистики - Пропустили!!!
     IF COALESCE (TRIM (inGroupStatName), '') = '' THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;

     -- !!!поиск ИД товара!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inGoodsCode
                    AND Object_Goods.DescId     = zc_Object_Goods()
                    AND inGoodsCode > 0
                 );
     -- Проверка
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RETURN;
        RAISE EXCEPTION 'Ошибка.Не найден Товар <(%) %> .', inGoodsCode, inGoodsName;
     END IF;

     --пробуем найти группу Статистики
     vbGroupStatId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroupStat() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGroupStatName)) );
     IF COALESCE (vbGroupStatId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Группа статистики <%> не найдена', inGroupStatName;
     END IF;

    /* IF COALESCE (vbGroupStatId,0) = 0
     THEN
         --создаем
         vbGroupStatId := (SELECT tmp.ioId
                           FROM gpInsertUpdate_Object_GoodsGroupDirection (ioId           := 0         :: Integer
                                                                         , inCode         := 0         :: Integer
                                                                         , inName         := TRIM (inGroupStatName) :: TVarChar
                                                                         , inSession      := inSession :: TVarChar
                                                                          ) AS tmp);
     END IF;
     */
     
     
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupStat(), vbGoodsId, vbGroupStatId);

  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION 'Тест. Ок. <%> / <%>', vbGoodsId, vbGroupStatId; 
     END IF;   

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.25         *
*/

-- тест
--
