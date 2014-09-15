-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadPriceList(
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
                     JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId 
                LEFT JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode 
                            FROM Object_Goods_View 
                           WHERE ObjectId = vbJuridicalId
                        ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
         WHERE LoadPriceListItem.GoodsId <> 0 AND LoadPriceList.Id = inId;

     -- ��� ������������� ����� ����� �������� ����������� � ������� �������

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ���� ������� <������� ��������>
                    LoadPriceListItem.GoodsId , -- ������� �����
                              Object_Goods.Id , -- ����� ��� ������
                                    inSession )
       FROM LoadPriceListItem
               JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
               JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                FROM Object_Goods_View 
                               WHERE ObjectId = vbJuridicalId
                    ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
          WHERE GoodsId <> 0 AND LoadPriceList.Id = inId
           AND (LoadPriceListItem.GoodsId, Object_Goods.Id) NOT IN 
               (SELECT GoodsMainId, GoodsId FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId AND ObjectMainId IS NULL);


     -- ���� ����� �� ���� ���� � �� ������ �� ������, �� �������. � ���� ������, �� ��������� ��
     SELECT
            Movement.Id INTO vbPriceListId
       FROM Movement 
            JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                    ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                   AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
      WHERE Movement.OperDate = vbOperDate AND Movement.DescId = zc_Movement_PriceList()
        AND MovementLinkObject_Juridical.ObjectId = vbJuridicalId;

      IF COALESCE(vbPriceListId, 0) = 0 THEN 
         vbPriceListId := gpInsertUpdate_Movement_PriceList(0, '', vbOperDate, vbJuridicalId, inSession);
      END IF;

     -- ������� ��������� ������
     PERFORM gpInsertUpdate_MovementItem_PriceList(
                      0 , -- ���� ������� <������� ���������>
          vbPriceListId , -- ���� ������� <��������>
                GoodsId , -- ������
                  Price , -- ����
         ExpirationDate , -- ������ ������
              inSession )
       FROM LoadPriceListItem 
      WHERE GoodsId <> 0 AND LoadPriceListId = inId
        AND GoodsId NOT IN (SELECT ObjectId FROM MovementItem WHERE MovementId = vbPriceListId);

    
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.09.14                        *  
*/

-- ����
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
