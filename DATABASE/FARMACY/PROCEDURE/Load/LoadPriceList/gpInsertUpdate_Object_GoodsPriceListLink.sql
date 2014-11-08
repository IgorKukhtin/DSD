-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPriceListLink(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPriceListLink(
    IN inPriceListItemId     Integer   ,    -- ���� ������� <������ �������� �����-�����>
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserName TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbMainGoodsId Integer;
   DECLARE vbJuridicalId Integer;
   
   DECLARE vbMarionGoodsId Integer;
   DECLARE vbBarCodeGoodsId Integer;
   DECLARE vbPartnerGoodsId Integer;

   DECLARE vbMarionCode Integer;
   DECLARE vbBarCode TVarChar;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbGoodsCode TVarChar;
   DECLARE vbGoodsId Integer;
   DECLARE vbProducerName TVarChar;
   --DECLARE vbPartnerGoodsId Integer;
   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   IF COALESCE(vbObjectId, 0) = 0 THEN
      SELECT ValueData INTO vbUserName FROM Object WHERE Id = vbUserId;
      RAISE EXCEPTION '� ������������ "%" �� ����������� �������� ����', vbUserName;
   END IF;

   SELECT CommonCode, BarCode, GoodsName, GoodsCode, GoodsId, JuridicalId, ProducerName
     
     INTO vbMarionCode, vbBarCode, vbGoodsName, vbGoodsCode, vbMainGoodsId, vbJuridicalId, vbProducerName
     
     FROM LoadPriceListItem 
          JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
           WHERE LoadPriceListItem.Id = inPriceListItemId;

 
    -- ������������� ����� � ����� ����������

    SELECT Object_Goods_View.Id INTO vbGoodsId
      FROM Object_Goods_View 
     WHERE ObjectId = vbJuridicalId AND GoodsCode = vbGoodsCode;

     PERFORM lpInsertUpdate_Object_Goods(
                           vbGoodsId  ,    -- ���� ������� <�����>
                         vbGoodsCode  ,    -- ��� ������� <�����>
                         vbGoodsName  ,    -- �������� ������� <�����>
                                   0  ,    -- ������ �������
                                   0  ,    -- ������ �� ������� ���������
                                   0  ,    -- ���
                        vbJuridicalId ,    -- �� ���� ��� �������� ����
                             vbUserId , 
                                   0  ,
                       vbProducerName ,     
                                false );
    
    IF (SELECT COUNT(*) FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId AND vbMainGoodsId = GoodsMainId AND vbGoodsId = GoodsId) = 0 THEN
        PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ���� ������� 
                                vbMainGoodsId , -- ������� �����
                                    vbGoodsId , -- ����� �� ������
                                    inSession );
    END IF;                   	 

    IF vbMarionCode > 0 THEN
       -- ������������� ����� � ����� �������

       SELECT Id INTO vbMarionGoodsId
           FROM Object_Goods_View 
          WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsCodeInt = vbMarionCode;

       IF COALESCE(vbMarionGoodsId, 0) = 0 THEN
           -- ������� ����� ����, ������� ��� ���
          vbMarionGoodsId := lpInsertUpdate_Object(0, zc_Object_Goods(), CommonCode, vbGoodsName);
          PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbMarionGoodsId, zc_Enum_GlobalConst_Marion());
       END IF;       
             
       IF (SELECT COUNT(*) FROM Object_LinkGoods_View 
               WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsId = vbMarionGoodsId AND GoodsMainId = vbMainGoodsId) = 0 THEN
           PERFORM gpInsertUpdate_Object_LinkGoods(
                0 
              , vbMainGoodsId -- ������� �����
              , vbMarionGoodsId      -- ����� ��� ������
              , inSession                 -- ������ ������������
            );
       END IF;     
     END IF;          

    IF vbBarCode <> '' THEN
       -- ������������� ����� �� �����-�����
  
       SELECT Id INTO vbBarCodeGoodsId
           FROM Object_Goods_View 
          WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsName = vbBarCode;

       IF COALESCE(vbBarCodeGoodsId, 0) = 0 THEN
          -- ������� ����� ����, ������� ��� ���
          vbBarCodeGoodsId := lpInsertUpdate_Object(0, zc_Object_Goods(), 0, vbBarCode);
          PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbBarCodeGoodsId, zc_Enum_GlobalConst_BarCode());
       END IF;       

       IF (SELECT COUNT(*) FROM Object_LinkGoods_View 
               WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsId = vbBarCodeGoodsId AND GoodsMainId = vbMainGoodsId) = 0 THEN
           PERFORM gpInsertUpdate_Object_LinkGoods(
                0 
              , vbMainGoodsId -- ������� �����
              , vbBarCodeGoodsId      -- ����� ��� ������
              , inSession                 -- ������ ������������
            );
       END IF;     
             
     END IF;          
 
   -- ��������� ������ � �����-����
   
     PERFORM gpInsertUpdate_MovementItem_PriceList(
       PriceListItem.Id , -- ���� ������� <������� ���������>
  LastPriceList_View.MovementId , -- ���� ������� <��������>
          vbMainGoodsId , -- ������
              vbGoodsId , -- ����� �����-�����
           CASE LoadPriceList.NDSinPrice 
                 WHEN True THEN Price 
                 ELSE Price * (100 + ObjectFloat_NDSKind_NDS.ValueData) / 100 
           END:: TFloat  , -- ����
          ExpirationDate , -- ������ ������
              inSession )
       
      FROM LoadPriceListItem 
               JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
          JOIN LastPriceList_View ON LastPriceList_View.JuridicalId = LoadPriceList.JuridicalId
                            AND COALESCE(LastPriceList_View.ContractId, 0) = COALESCE(LoadPriceList.ContractId, 0)
          LEFT JOIN MovementItem AS PriceListItem ON PriceListItem.movementid = LastPriceList_View.MovementId  
                                            AND PriceListItem.ObjectId = LoadPriceListItem.GoodsId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = LoadPriceListItem.GoodsId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
               
          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.Childobjectid
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
     WHERE LoadPriceListItem.Id = inPriceListItemId; --CommonCode = 225244 OR BarCode = '8435001020030'
   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsPriceListLink(Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.11.14                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
