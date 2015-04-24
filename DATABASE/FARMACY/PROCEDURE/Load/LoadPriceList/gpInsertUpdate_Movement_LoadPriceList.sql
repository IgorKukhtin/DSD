DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList 
          (Integer, Integer, Integer, 
           TVarChar, TVarChar, TVarChar, TVarChar,
           TFloat, TFloat,
           TDateTime,
           TVarChar, TVarChar, 
           Boolean,
           TVarChar);


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList 
          (Integer, Integer, Integer, 
           TVarChar, TVarChar, TVarChar,
           TFloat, TFloat,
           TDateTime,
           TVarChar, TVarChar, 
           Boolean,
           TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inContractId          Integer   , -- Договор
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice               TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbLoadPriceListId Integer;
   DECLARE vbLoadPriceListItemsId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
	
  IF COALESCE(inPrice, 0) = 0 THEN 
     RETURN;
  END IF;

  -- Проверка что передано таки Юр лицо и Договор. а не наоборот. 

  IF COALESCE(inJuridicalId, 0) = 0 THEN 
     RAISE EXCEPTION 'Не установлено значение параметра Юридическое лицо (JuridicalId)';
  END IF;

  IF (SELECT DescId FROM Object WHERE Id = inJuridicalId) <> zc_Object_Juridical() THEN
     RAISE EXCEPTION 'Не правильно передается значение параметра Юридическое лицо (JuridicalId)';
  END IF;

  IF COALESCE(inContractId, 0) <> 0 THEN 
     IF (SELECT DescId FROM Object WHERE Id = inContractId) <> zc_Object_Contract() THEN
        RAISE EXCEPTION 'Не правильно передается значение параметра Договор (ContractId)';
     END IF;
  END IF;
  
  DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
    (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId AND COALESCE(ContractId, 0) = inContractId
                                    AND OperDate < CURRENT_DATE);

  DELETE FROM LoadPriceList WHERE Id IN
    (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId AND COALESCE(ContractId, 0) = inContractId
                                    AND OperDate < CURRENT_DATE);
   
  SELECT Id INTO vbLoadPriceListId 
    FROM LoadPriceList
   WHERE JuridicalId = inJuridicalId AND OperDate = Current_Date AND COALESCE(ContractId, 0) = inContractId;

  IF COALESCE(vbLoadPriceListId, 0) = 0 THEN
     INSERT INTO LoadPriceList (JuridicalId, ContractId, OperDate, NDSinPrice)
             VALUES(inJuridicalId, inContractId, Current_Date, inNDSinPrice);
  END IF;

  SELECT Id INTO vbLoadPriceListItemsId 
    FROM LoadPriceListItem 
   WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode;

   -- Ищем по общему коду 
   IF (COALESCE(vbGoodsId, 0) = 0) AND (inCommonCode > 0) THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId INTO vbGoodsId
        FROM Object_Goods_View 
        JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                        ON Object_Goods_View.Id = ObjectLink_LinkGoods_Goods.ChildObjectId
                       AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
        JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                        ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       AND ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId                         
       WHERE Object_Goods_View.ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsCodeInt = inCommonCode;
   END IF;
   
   -- Ищем по штрих-коду 
   IF (COALESCE(vbGoodsId, 0) = 0) AND (inBarCode <> '') THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId INTO vbGoodsId
        FROM Object_Goods_View 
        JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                        ON Object_Goods_View.Id = ObjectLink_LinkGoods_Goods.ChildObjectId
                       AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
        JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                        ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       AND ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId                         
       WHERE Object_Goods_View.ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsName = inBarCode;
   END IF;

   -- Ищем по коду и inJuridicalId
   IF (COALESCE(vbGoodsId, 0) = 0) THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId INTO vbGoodsId
        FROM Object_Goods_View 
        JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                        ON Object_Goods_View.Id = ObjectLink_LinkGoods_Goods.ChildObjectId
                       AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
        JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                        ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       AND ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId                         
       WHERE Object_Goods_View.ObjectId = inJuridicalId AND GoodsCode = inGoodsCode;
   END IF;

   IF inExpirationDate = CURRENT_DATE THEN 
      inExpirationDate := zc_DateEnd();
   END IF;	

   IF COALESCE(vbLoadPriceListItemsId, 0) = 0 THEN
      INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, ExpirationDate, PackCount, ProducerName)
             VALUES(vbLoadPriceListId, inCommonCode, inBarCode, inGoodsCode, inGoodsName, inGoodsNDS, vbGoodsId, inPrice, inExpirationDate, inPackCount, inProducerName);
   ELSE
      UPDATE LoadPriceListItem 
         SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = inBarCode, GoodsNDS = inGoodsNDS, GoodsId = vbGoodsId, 
             Price = inPrice, ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
       WHERE Id = vbLoadPriceListItemsId;
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.02.15                        *   убрал вьюхи из поиска. 
 11.11.14                        *   
 28.10.14                        *   
 22.10.14                        *   Поменял очередность поиска
 18.09.14                        *  
*/
