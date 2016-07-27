-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpCalculate_ExternalOrder (Integer, TVarChar);

-- Function: gpCalculate_ExternalOrder(integer, tvarchar)

-- DROP FUNCTION gpCalculate_ExternalOrder(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpCalculate_ExternalOrder (inInternalOrder integer, inSession tvarchar)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbObjectId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId := lpGetUserBySession (inSession);   
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     
     PERFORM lpDelete_Movement(MovementId, '') 
       FROM MovementLinkMovement 
      WHERE DescId = zc_MovementLinkMovement_Master()
        AND MovementChildId = inInternalOrder;
     
    SELECT  MovementLinkObject_Unit.ObjectId INTO vbUnitId 
      FROM  MovementLinkObject AS MovementLinkObject_Unit
      WHERE MovementLinkObject_Unit.MovementId = inInternalOrder
        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

    PERFORM lpCreateTempTable_OrderInternal(inInternalOrder, vbObjectId, 0, vbUserId);
   
   -- ������ ������, ��� � ������� ������������ ������ ���������. ���� ���������� ���, �� �������� � ������ ��������. 

   PERFORM lpCreate_ExternalOrder(
             inInternalOrder := inInternalOrder ,
               inJuridicalId := COALESCE(PriceList.JuridicalId, MinPrice.JuridicalId),
                inContractId := COALESCE(PriceList.ContractId, MinPrice.ContractId),
                    inUnitId := vbUnitId,
               inMainGoodsId := MovementItem.ObjectId,
                   inGoodsId := COALESCE(PriceList.GoodsId, MinPrice.GoodsId),
                    inAmount := (COALESCE(MIFloat_AmountManual.ValueData,CEIL((MovementItem.Amount + COALESCE(MIFloat_AmountSecond.ValueData,0))
                                      / COALESCE(Object_Goods.MinimumLot, 1)) * COALESCE(Object_Goods.MinimumLot, 1)))::TFloat, 
                     inPrice := COALESCE(PriceList.Price, MinPrice.Price), 
          inPartionGoodsDate := COALESCE(PriceList.PartionGoodsDate, MinPrice.PartionGoodsDate),
                   inComment := MIString_Comment.ValueData,
                    inUserId := vbUserId)
         FROM  MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                                        ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                                       AND MILinkObject_Juridical.MovementItemId = MovementItem.Id  
                                                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                        ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                       AND MILinkObject_Contract.MovementItemId = MovementItem.Id  

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                                                        ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                       AND MILinkObject_Goods.MovementItemId = MovementItem.Id  

                       LEFT JOIN _tmpMI AS PriceList ON COALESCE(PriceList.ContractId, 0) = COALESCE(MILinkObject_Contract.ObjectId, 0)
                                                    AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                    AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                    AND PriceList.MovementItemId = MovementItem.Id 
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                             
             LEFT JOIN (SELECT * FROM 
                                      (SELECT *, MIN(Id) OVER(PARTITION BY MovementItemId) AS MinId FROM
                                           (SELECT *
                                                , MIN(SuperFinalPrice) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                            FROM _tmpMI) AS DDD
                                       WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice) AS DDD
                                  WHERE Id = MinId) AS MinPrice
                              ON MinPrice.MovementItemId = MovementItem.Id
                    LEFT JOIN Object_Goods_View AS Object_Goods 
                                                ON Object_Goods.Id = MovementItem.ObjectId 

                    LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                                      AND MIString_Comment.DescId = zc_MIString_Comment()
            WHERE MovementItem.MovementId = inInternalOrder
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
              AND COALESCE(MIFloat_AmountManual.ValueData,(MovementItem.Amount + COALESCE(MIFloat_AmountSecond.ValueData,0))) > 0
              AND COALESCE(COALESCE(PriceList.Price, MinPrice.Price), 0) <> 0;
                       


-- � ��� ������������ ��, ������� ��� � ������

    PERFORM lpCreate_ExternalOrder(
             inInternalOrder := inInternalOrder ,
               inJuridicalId := 0,
                inContractId := 0,
                    inUnitId := vbUnitId,
               inMainGoodsId := ddd.ObjectId,
                   inGoodsId := ddd.ObjectId,
                    inAmount := COALESCE(ddd.AmountManual, ddd.Amount + COALESCE(AmountSecond,0)), 
                     inPrice := 0, 
          inPartionGoodsDate := NULL, 
                   inComment := Comment,
                    inUserId := vbUserId)
    FROM(
        WITH DDD AS(
                    /* ������ �����
                    SELECT DISTINCT MovementItem.Id 
                    FROM MovementItem  
                        JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid
                        JOIN MovementItem AS PriceList ON Object_LinkGoods_View.GoodsMainId = PriceList.objectid
                        JOIN LastPriceList_View ON LastPriceList_View.MovementId =  PriceList.MovementId
                    WHERE MovementItem.MovementId = inInternalOrder*/
                    SELECT DISTINCT MovementItem.Id 
                    FROM MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                                        ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                                       AND MILinkObject_Juridical.MovementItemId = MovementItem.Id  
                                                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                        ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                       AND MILinkObject_Contract.MovementItemId = MovementItem.Id  

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                                                        ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                       AND MILinkObject_Goods.MovementItemId = MovementItem.Id  

                       LEFT JOIN _tmpMI AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                    AND PriceList.JuridicalId              = MILinkObject_Juridical.ObjectId
                                                    AND PriceList.GoodsId                  = MILinkObject_Goods.ObjectId
                                                    AND PriceList.MovementItemId           = MovementItem.Id
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                             
                       LEFT JOIN (SELECT *
                                  FROM (SELECT *
                                             , MIN (Id) OVER (PARTITION BY MovementItemId) AS MinId
                                        FROM (SELECT *
                                                   , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                              FROM _tmpMI
                                             ) AS DDD
                                       WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                                      ) AS DDD
                                  WHERE Id = MinId
                                 ) AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id

            WHERE MovementItem.MovementId = inInternalOrder
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
              AND COALESCE (MIFloat_AmountManual.ValueData, (MovementItem.Amount + COALESCE(MIFloat_AmountSecond.ValueData,0))) > 0
              AND COALESCE (COALESCE (PriceList.Price, MinPrice.Price), 0) <> 0
                    )
        SELECT MovementItem.*, MIFloat_AmountSecond.ValueData AS AmountSecond, MIFloat_AmountManual.ValueData AS AmountManual, MIString_Comment.ValueData as Comment
        FROM MovementItem 
            LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                              ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()                                  
        WHERE 
            MovementId = inInternalOrder 
            AND 
            Id NOT IN(SELECT Id FROM ddd)) AS DDD
    WHERE
        COALESCE(ddd.AmountManual, ddd.Amount + COALESCE(AmountSecond,0)) > 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpCalculate_ExternalOrder(integer, tvarchar)
  OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.09.14                         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')