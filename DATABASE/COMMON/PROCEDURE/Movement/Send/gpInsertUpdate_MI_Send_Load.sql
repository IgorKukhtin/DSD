-- Function: gpInsertUpdate_MI_Send_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_Load (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_Load(
    IN inMovementId            Integer   , --
    IN inGoodsCode             Integer   , 
    IN inGoodsName             TVarChar  , -- 
    IN inGoodsKindName         TVarChar  , 
    IN inAmount                TFloat    , -- количество
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbGoodsId           Integer;
   DECLARE vbGoodsKindId       Integer;                                                       
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     -- проверка
     IF COALESCE (inAmount,0) = 0
     THEN
         RETURN;
     END IF;

     --Находим товары
     vbGoodsId        := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
     -- находим вид товара
     vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());

     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар (<%>) <%> не найден.',inGoodsCode, inGoodsName;
     END IF;

     IF (COALESCE (vbGoodsKindId,0) = 0 AND COALESCE (inGoodsKindName,'') <> '' )
     THEN
         RAISE EXCEPTION 'Ошибка.Вид товара <%> не найден.', inGoodsKindName;
     END IF;
     
     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := 0              ::Integer
                                             , inMovementId          := inMovementId   ::Integer
                                             , inGoodsId             := vbGoodsId      ::Integer
                                             , inAmount              := inAmount       :: TFloat
                                             , inPartionGoodsDate    := NULL           :: TDateTime
                                             , inCount               := 0              :: TFloat
                                             , inHeadCount           := 0              :: TFloat
                                             , ioPartionGoods        := NULL           :: TVarChar
                                             , ioPartNumber          := NULL           :: TVarChar
                                             , inGoodsKindId         := COALESCE (vbGoodsKindId,0)  ::Integer
                                             , inGoodsKindCompleteId := 0              ::Integer
                                             , inAssetId             := 0              ::Integer
                                             , inAssetId_two         := 0              ::Integer
                                             , inUnitId              := 0              ::Integer
                                             , inStorageId           := 0              ::Integer
                                             , inPartionModelId      := 0              ::Integer
                                             , inPartionGoodsId      := 0              ::Integer
                                             , inUserId              := vbUserId
                                              ) AS tmp; 
                                           

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
14.04.23          *
*/

-- тест
--

/*

select * from  gpInsertUpdate_MI_Send_Load( inMovementId  :=25045637 ::          Integer   , --
     inGoodsCode   :=  4123    ::    Integer   , 
     inGoodsName   :=   'СВ-2' ::       TVarChar  , -- 
     inGoodsKindName := 'рябчик'::       TVarChar  , 
     inAmount      :=  853.5  ::      TFloat    , -- количество
     inSession :='9457'::TVarChar  )
*/