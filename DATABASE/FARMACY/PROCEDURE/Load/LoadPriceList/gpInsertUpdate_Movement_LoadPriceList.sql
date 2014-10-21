CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId          Integer   , -- �������
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice               TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
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

   -- ���� �� ���� � inJuridicalId
   SELECT GoodsMainId INTO vbGoodsId
     FROM Object_LinkGoods_View 
    WHERE ObjectId = inJuridicalId AND GoodsCode = inGoodsCode;

   -- ���� �� ������ ���� 
   IF (COALESCE(vbGoodsId, 0) = 0) AND (inCommonCode > 0) THEN
      SELECT GoodsMainId INTO vbGoodsId
        FROM Object_LinkGoods_View 
       WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsCodeInt = inCommonCode;
   END IF;
   
   -- ���� �� �����-���� 
   IF (COALESCE(vbGoodsId, 0) = 0) AND (inBarCode <> '') THEN
      SELECT GoodsMainId INTO vbGoodsId
        FROM Object_LinkGoods_View 
       WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsName = inBarCode;
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
