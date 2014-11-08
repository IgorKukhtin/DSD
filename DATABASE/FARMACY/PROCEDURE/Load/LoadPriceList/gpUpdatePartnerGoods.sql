-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpUpdatePartnerGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdatePartnerGoods(
    IN inId                  Integer   , -- �����-����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- �������� ��������� ����������
     SELECT 
           LoadPriceList.OperDate	 
         , LoadPriceList.JuridicalId INTO vbOperDate, vbJuridicalId
      FROM LoadPriceList WHERE LoadPriceList.Id = inId;

     -- ������� ����� ����, ������� ��� ���

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), lpInsertUpdate_Object(0, zc_Object_Goods(), CommonCode, LoadPriceListItem.GoodsName), zc_Enum_GlobalConst_Marion())
            FROM LoadPriceListItem WHERE LoadPriceListItem.LoadPriceListId = inId
             AND CommonCode NOT IN (SELECT GoodsCodeInt FROM Object_Goods_View WHERE ObjectId = zc_Enum_GlobalConst_Marion())
             AND CommonCode > 0;

     -- ������� ����� ����, ������� ��� ���

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), lpInsertUpdate_Object(0, zc_Object_Goods(), 0, BarCode), zc_Enum_GlobalConst_BarCode())
            FROM LoadPriceListItem WHERE LoadPriceListItem.LoadPriceListId = inId
             AND BarCode NOT IN (SELECT GoodsName FROM Object_Goods_View WHERE ObjectId = zc_Enum_GlobalConst_BarCode())
             AND BarCode <> '';
     -- ��� �� ������ ��� ��������� ������ � ���������� ������� �����-�����

     PERFORM lpInsertUpdate_Object_Goods(
                     Object_Goods.Id  ,    -- ���� ������� <�����>
         LoadPriceListItem.GoodsCode  ,    -- ��� ������� <�����>
         LoadPriceListItem.GoodsName  ,    -- �������� ������� <�����>
                                   0  ,    -- ������ �������
                                   0  ,    -- ������ �� ������� ���������
                                   0  ,    -- ���
                        vbJuridicalId ,    -- �� ���� ��� �������� ����
                             vbUserId , 
                                   0  ,
       LoadPriceListItem.ProducerName ,     
                                false )
        FROM LoadPriceListItem
                LEFT JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode, Object_Goods_View.GoodsName, MakerName 
                            FROM Object_Goods_View 
                           WHERE ObjectId = vbJuridicalId
                        ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
         WHERE LoadPriceListItem.GoodsId <> 0 
           AND LoadPriceListItem.LoadPriceListId  = inId 
           AND ((COALESCE(Object_Goods.GoodsName, '') <> LoadPriceListItem.GoodsName)
                OR (COALESCE(Object_Goods.MakerName, '') <> LoadPriceListItem.ProducerName));

     -- ��� ������������� ����� ����� �������� ����������� � ������� �������

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ���� ������� <������� ��������>
                    LoadPriceListItem.GoodsId , -- ������� �����
                              Object_Goods.Id , -- ����� �� ������
                                    inSession )
       FROM LoadPriceListItem
               JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                FROM Object_Goods_View 
                               WHERE ObjectId = vbJuridicalId
                    ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
          WHERE GoodsId <> 0 AND LoadPriceListItem.LoadPriceListId = inId
           AND (LoadPriceListItem.GoodsId, Object_Goods.Id) NOT IN 
               (SELECT GoodsMainId, GoodsId FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId);
   
      -- �������� ���� �������, � ������� ��� �������� � ������� 

   /*   PERFORM gpInsertUpdate_Object_LinkGoods(
              0 
            , MainGoodsId -- ������� �����
            , GoodsId      -- ����� ��� ������
            , inSession                 -- ������ ������������
            )  
        FROM(
        SELECT DISTINCT 
            LoadPriceListItem.GoodsId AS MainGoodsId 
          , Object_Goods_View.Id AS GoodsId 
        FROM Object_Goods_View 
          JOIN LoadPriceListItem ON LoadPriceListItem.CommonCode = Object_Goods_View.goodscodeInt
                                AND LoadPriceListItem.LoadPriceListId = inId
      
      WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND LoadPriceListItem.GoodsId <> 0
                     
      AND Object_Goods_View.id NOT IN (SELECT goodsid FROM Object_LinkGoods_View WHERE ObjectId = zc_Enum_GlobalConst_Marion())) AS DDD;

      -- �������� �����-����, � ������� ��� �������� � ������� 

      PERFORM gpInsertUpdate_Object_LinkGoods(
              0 
            , MainGoodsId -- ������� �����
            , GoodsId      -- ����� ��� ������
            , inSession                 -- ������ ������������
            )  
        FROM(
        SELECT DISTINCT 
            LoadPriceListItem.GoodsId AS MainGoodsId 
          , Object_Goods_View.Id AS GoodsId 
        FROM Object_Goods_View 
          JOIN LoadPriceListItem ON LoadPriceListItem.BarCode = Object_Goods_View.GoodsName
                                AND LoadPriceListItem.LoadPriceListId = inId
      
      WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND LoadPriceListItem.GoodsId <> 0
                     
      AND Object_Goods_View.id NOT IN (SELECT goodsid FROM Object_LinkGoods_View WHERE ObjectId = zc_Enum_GlobalConst_BarCode())) AS DDD;
     */

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.10.14                        *  ���� ������ �������� � ������ ������� � ����������� ��������� � �������� �������������
 17.10.14                        *  
 03.10.14                        *  
 18.09.14                        *  
*/

-- ����
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')

/*
SELECT lpDelete_Object(Id, '') FROM (

SELECT *, MIN(Id) OVER (PARTITION BY GoodsMainId) as MINID FROM Object_LinkGoods_View
WHERE ObjectId = zc_Enum_GlobalConst_Marion()) AS DDD

WHERE Id <> MinId

*/