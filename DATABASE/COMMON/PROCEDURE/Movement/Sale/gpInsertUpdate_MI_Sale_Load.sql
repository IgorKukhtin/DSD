-- Function: gpInsertUpdate_MI_Sale_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Load (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Sale_Load(
    IN inMovementId            Integer   , --
    IN inGoodsCode             Integer   , 
    IN inGoodsName             TVarChar  , -- 
    IN inGoodsKindName         TVarChar  , 
    IN inAmount                TFloat    , -- количество склад
    IN inAmountPartner         TFloat    ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbGoodsId           Integer;
   DECLARE vbGoodsKindId       Integer;
   DECLARE vbPriceListId       Integer;
   DECLARE vbOperDate          TDateTime; 
   DECLARE vbPrice             TFloat; 
                                                      
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     IF COALESCE (inMovementId,0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен';
     END IF;

     -- проверка
     IF COALESCE (inAmount,0) = 0 AND COALESCE (inAmountPartner,0) = 0
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
 
     --данные из шапки документа
     SELECT Movement.OperDate
          , MovementLinkObject_PriceList.ObjectId
     INTO vbOperDate, vbPriceListId
     FROM Movement    
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                      ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                     AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
     WHERE Movement.Id = inMovementId;


     vbPrice := (SELECT lfSelect.ValuePrice  AS Price  -- Цена из прайса
                 FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId
                                                          , inOperDate   := vbOperDate
                                                           ) AS lfSelect
                 WHERE lfSelect.ValuePrice <> 0 
                   AND lfSelect.GoodsId = vbGoodsId
                   AND COALESCE (lfSelect.GoodsKindId,0) = COALESCE (vbGoodsKindId,0)
                 );
     --если не нашли цену для товар без вид товара
     IF COALESCE (vbPrice,0) = 0
     THEN
         vbPrice := (SELECT lfSelect.ValuePrice  AS Price  -- Цена из прайса
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId
                                                              , inOperDate   := vbOperDate
                                                               ) AS lfSelect
                     WHERE lfSelect.ValuePrice <> 0 
                       AND lfSelect.GoodsId = vbGoodsId
                       AND COALESCE (lfSelect.GoodsKindId,0) = 0
                     );
     END IF;
     
     -- сохранили <Элемент документа>   
     PERFORM lpInsertUpdate_MovementItem_Sale (ioId                 := 0
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := vbGoodsId
                                             , inAmount             := inAmount
                                             , inAmountPartner      := inAmountPartner
                                             , inAmountChangePercent:= inAmountPartner
                                             , inChangePercentAmount:= 0
                                             , ioPrice              := vbPrice
                                             , ioCountForPrice      := 1
                                             , inCount              := 0 :: TFloat
                                             , inHeadCount          := 0 :: TFloat
                                             , inBoxCount           := 0 :: TFloat
                                             , inPartionGoods       := ''   :: TVarChar
                                             , inGoodsKindId        := vbGoodsKindId
                                             , inAssetId            := 0
                                             , inBoxId              := 0
                                             , inCountPack          := 0 :: TFloat
                                             , inWeightTotal        := 0 :: TFloat
                                             , inWeightPack         := 0 :: TFloat
                                             , inIsBarCode          := False ::Boolean
                                             , inUserId             := vbUserId
                                              );
                                           
                                                           

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
12.02.26          *
*/

-- тест
--