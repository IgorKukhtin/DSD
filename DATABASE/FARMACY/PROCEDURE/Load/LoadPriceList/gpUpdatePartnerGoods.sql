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
                                false )
        FROM LoadPriceListItem
                LEFT JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode 
                            FROM Object_Goods_View 
                           WHERE ObjectId = vbJuridicalId
                        ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
         WHERE LoadPriceListItem.GoodsId <> 0 AND LoadPriceListItem.LoadPriceListId  = inId;

     -- ��� ������������� ����� ����� �������� ����������� � ������� �������

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ���� ������� <������� ��������>
                    LoadPriceListItem.GoodsId , -- ������� �����
                              Object_Goods.Id , -- ����� ��� ������
                                    inSession )
       FROM LoadPriceListItem
               JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                FROM Object_Goods_View 
                               WHERE ObjectId = vbJuridicalId
                    ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
          WHERE GoodsId <> 0 AND LoadPriceListItem.LoadPriceListId = inId
           AND (LoadPriceListItem.GoodsId, Object_Goods.Id) NOT IN 
               (SELECT GoodsMainId, GoodsId FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId AND ObjectMainId IS NULL);
   
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.09.14                        *  
*/

-- ����
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
