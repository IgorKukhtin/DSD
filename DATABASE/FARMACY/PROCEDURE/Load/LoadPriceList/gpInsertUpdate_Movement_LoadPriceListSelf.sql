
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceListSelf 
          (Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceListSelf 
          (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceListSelf(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inGoodsCode           Integer   , 
    IN inRemains             TFloat    ,  
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbLoadPriceListId Integer;
  DECLARE vbLoadPriceListItemsId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);
	
  DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
    (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId 
                                    AND OperDate < CURRENT_DATE);

  DELETE FROM LoadPriceList WHERE Id IN
    (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId 
                                    AND OperDate < CURRENT_DATE);
   
  -- Поиск "шапки" за "сегодня"
  vbLoadPriceListId := (SELECT LoadPriceList.Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE);

  IF COALESCE(vbLoadPriceListId, 0) = 0 THEN
     INSERT INTO LoadPriceList (JuridicalId, ContractId, OperDate, NDSinPrice, UserId_Insert, Date_Insert)
             VALUES(inJuridicalId, NULL, Current_Date, True, vbUserId, CURRENT_TIMESTAMP);
  ELSE
     UPDATE LoadPriceList SET UserId_Insert = vbUserId, Date_Update /*Date_Insert*/ = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId;
  END IF;


   -- Поиск "элемента"
   SELECT Id INTO vbLoadPriceListItemsId FROM LoadPriceListItem WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode :: TVarChar;

   IF COALESCE(vbLoadPriceListItemsId, 0) = 0 THEN
      INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, ExpirationDate, PackCount, ProducerName, Remains)
             SELECT vbLoadPriceListId, 0, '', inGoodsCode, Object_Goods_Main_View.GoodsName, Object_Goods_Main_View.NDS, Object_Goods_Main_View.Id, 0.01, NULL, NULL, NULL, inRemains
              FROM Object_Goods_Main_View WHERE Object_Goods_Main_View.GoodsCode = inGoodsCode;
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.02.15                        *   
 30.01.15                        *   
*/
