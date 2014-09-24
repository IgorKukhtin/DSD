-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpCalculate_ExternalOrder (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCalculate_ExternalOrder(
    IN inInternalOrder Integer  ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId := lpGetUserBySession (inSession);
     
    SELECT  MovementLinkObject_Unit.ObjectId INTO vbUnitId 
      FROM  MovementLinkObject AS MovementLinkObject_Unit
      WHERE MovementLinkObject_Unit.MovementId = inInternalOrder
        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

   
   -- ������ ������, ��� � ������� ������������ ������ ���������. ���� ���������� ���, �� �������� � ������ ��������. 
   PERFORM lpCreate_ExternalOrder(
             inInternalOrder := inInternalOrder ,
               inJuridicalId := JuridicalId,
                    inUnitId := vbUnitId,
               inMainGoodsId := MainGoodsId,
                   inGoodsId := GoodsId,
                    inAmount := Amount, 
                     inPrice := Price, 
                    inUserId := vbUserId)
         FROM 

       (SELECT movementItem.Amount
             , COALESCE(PriceList.amount, 0) AS Price
             , PriceList.GoodsId
             , MainGoods.ID AS MainGoodsId
             , PriceList.JuridicalId
             , MIN(COALESCE(PriceList.amount, 0)) OVER (PARTITION BY movementItem.Id) AS Min_Price
          FROM MovementItem 
      LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid
      LEFT JOIN (SELECT PriceList.Amount, PriceList.objectid, JuridicalId, MILinkObject_Goods.ObjectId AS GoodsId 
                   FROM MovementItem AS PriceList  
                        JOIN LastPriceList_View ON LastPriceList_View.MovementId = PriceList.MovementId
                        JOIN MovementItemLinkObject AS MILinkObject_Goods
                                       ON MILinkObject_Goods.MovementItemId = PriceList.Id
                                      AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()) AS PriceList
                ON PriceList.objectid = Object_LinkGoods_View.GoodsMainId
                      
      LEFT JOIN OBJECT AS Goods ON Goods.Id = MovementItem.ObjectId
      LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = Object_LinkGoods_View.GoodsMainId
   
      WHERE movementItem.MovementId = inInternalOrder
   
        ORDER BY 1, 2) as xxx WHERE xxx.Price = xxx.min_price
   ORDER BY JuridicalId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpCalculate_ExternalOrder (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.09.14                         *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')