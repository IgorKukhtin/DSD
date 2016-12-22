-- Function: gpCalculate_ExternalOrder()

DROP FUNCTION IF EXISTS gpCalculate_ExternalOrder (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCalculate_ExternalOrder (inInternalOrder integer, inSession TVarChar)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbCurName1 TVarChar;
   DECLARE vbCurName2 TVarChar;
   DECLARE vbRec Record;

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

   IF 1=0
   THEN
       PERFORM lpCreateTempTable_OrderInternal(inInternalOrder, vbObjectId, 0, vbUserId);
   ELSE

       -- ������ �������, ��� � gpSelect ������ "�������" ������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), inInternalOrder, FALSE);

       CREATE TEMP TABLE _tmpMI_OrderInternal_Master (MovementItemId Integer, PartionGoods TDateTime, MinimumLot TFloat, MCS TFloat, PriceFrom TFloat, JuridicalPrice TFloat, Remains TFloat, Income TFloat, CheckAmount TFloat, SendAmount TFloat, AmountDeferred TFloat, Maker TVarChar, isClose Boolean, isFirst Boolean, isSecond Boolean, isTOP Boolean, isUnitTOP Boolean, isMCSNotRecalc Boolean, isMCSIsClose Boolean, GoodsId_partner Integer, JuridicalId Integer, ContractId Integer) ON COMMIT DROP;
       CREATE TEMP TABLE _tmpMI_OrderInternal_Child  (MovementItemId Integer, GoodsId Integer, PartionGoods TDateTime, Price TFloat, JuridicalPrice TFloat, PriceListMovementItemId Integer, Maker TVarChar, JuridicalId Integer, ContractId Integer) ON COMMIT DROP;
       --
       SELECT zfCalc_Word_Split (tmp.CurName_all, ';', 1) AS CurName1
            , zfCalc_Word_Split (tmp.CurName_all, ';', 2) AS CurName2
              INTO vbCurName1, vbCurName2
       FROM (SELECT STRING_AGG (tmp.CurName, ';') AS CurName_all
             FROM (SELECT gpSelect_MovementItem_OrderInternal (inInternalOrder, FALSE, FALSE, inSession) :: TVarChar AS CurName
                  ) AS tmp
            ) AS tmp;

       -- 
       FOR vbRec IN EXECUTE 'FETCH ALL IN' || QUOTE_IDENT (vbCurName1)
       LOOP
           INSERT INTO _tmpMI_OrderInternal_Master (MovementItemId, PartionGoods, MinimumLot, MCS, PriceFrom, JuridicalPrice, Remains, Income, CheckAmount, SendAmount, AmountDeferred, Maker, isClose, isFirst, isSecond, isTOP, isUnitTOP, isMCSNotRecalc, isMCSIsClose, GoodsId_partner, JuridicalId, ContractId)
             VALUES (vbRec.Id, vbRec.PartionGoodsDate, vbRec.MinimumLot, vbRec.MCS, vbRec.Price, vbRec.SuperFinalPrice, vbRec.RemainsInUnit, vbRec.Income_Amount, vbRec.CheckAmount, vbRec.SendAmount, vbRec.AmountDeferred, vbRec.MakerName, vbRec.isClose, vbRec.isFirst, vbRec.isSecond, vbRec.isTOP, vbRec.isTOP_Price, vbRec.MCSNotRecalc, vbRec.MCSIsClose, COALESCE (vbRec.PartnerGoodsId, 0), COALESCE (vbRec.JuridicalId, 0), COALESCE (vbRec.ContractId, 0));
       END LOOP;
       --
       FOR vbRec IN EXECUTE 'FETCH ALL IN' || QUOTE_IDENT (vbCurName2)
       LOOP
           INSERT INTO _tmpMI_OrderInternal_Child (MovementItemId, GoodsId, PartionGoods, Price, JuridicalPrice, PriceListMovementItemId, Maker, JuridicalId, ContractId)
             VALUES (vbRec.MovementItemId, COALESCE (vbRec.GoodsId, 0), vbRec.PartionGoodsDate, vbRec.Price, vbRec.SuperFinalPrice, vbRec.PriceListMovementItemId, vbRec.MakerName, COALESCE (vbRec.JuridicalId, 0), COALESCE (vbRec.ContractId, 0));
       END LOOP;

       -- ��������� 
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), MovementItem.Id, _tmpMI_OrderInternal_Master.PartionGoods)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_MinimumLot(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.MinimumLot, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_MCS(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.MCS, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.Remains, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Check(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.CheckAmount, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Send(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.SendAmount, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountDeferred(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.AmountDeferred, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceFrom(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.PriceFrom, 0))
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(), MovementItem.Id, COALESCE (_tmpMI_OrderInternal_Master.JuridicalPrice, 0))
             , lpInsertUpdate_MovementItemString (zc_MIString_Maker(), MovementItem.Id, _tmpMI_OrderInternal_Master.Maker)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), MovementItem.Id, _tmpMI_OrderInternal_Master.isClose)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_First(), MovementItem.Id, _tmpMI_OrderInternal_Master.isFirst)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Second(), MovementItem.Id, _tmpMI_OrderInternal_Master.isSecond)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TOP(), MovementItem.Id, _tmpMI_OrderInternal_Master.isTOP)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_UnitTOP(), MovementItem.Id, _tmpMI_OrderInternal_Master.isUnitTOP)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_MCSNotRecalc(), MovementItem.Id, _tmpMI_OrderInternal_Master.isMCSNotRecalc)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_MCSIsClose(), MovementItem.Id, _tmpMI_OrderInternal_Master.isMCSIsClose)
               --
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), MovementItem.Id, _tmpMI_OrderInternal_Master.GoodsId_partner)
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), MovementItem.Id, _tmpMI_OrderInternal_Master.JuridicalId)
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), MovementItem.Id, _tmpMI_OrderInternal_Master.ContractId)
       FROM MovementItem
            LEFT JOIN _tmpMI_OrderInternal_Master ON _tmpMI_OrderInternal_Master.MovementItemId = MovementItem.Id
       WHERE MovementItem.MovementId = inInternalOrder
         AND MovementItem.DescId = zc_MI_Master()
      ;

       -- ��������� ��������
       PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
       FROM MovementItem
       WHERE MovementItem.MovementId = inInternalOrder
         AND MovementItem.DescId = zc_MI_Master();

       -- ��������� 
       PERFORM lpInsertUpdate_MovementItem_OrderInternal_child (ioId                        := COALESCE (MovementItem.MovementItemId, 0)
                                                              , inMovementId                := inInternalOrder
                                                              , inParentId                  := COALESCE (MovementItem.ParentId, _tmpMI_OrderInternal_Child.MovementItemId)
                                                              , inGoodsId                   := COALESCE (MovementItem.GoodsId, _tmpMI_OrderInternal_Child.GoodsId)
                                                              , inAmount                    := 0
                                                              , inPrice                     := COALESCE (_tmpMI_OrderInternal_Child.Price, 0)
                                                              , inJuridicalPrice            := COALESCE (_tmpMI_OrderInternal_Child.JuridicalPrice, 0)
                                                              , inPriceListMovementItemId   := COALESCE (_tmpMI_OrderInternal_Child.PriceListMovementItemId, 0)
                                                              , inPartionGoods              := _tmpMI_OrderInternal_Child.PartionGoods
                                                              , inMaker                     := _tmpMI_OrderInternal_Child.Maker
                                                              , inJuridicalId               := COALESCE (MovementItem.JuridicalId, _tmpMI_OrderInternal_Child.JuridicalId)
                                                              , inContractId                := COALESCE (MovementItem.ContractId, _tmpMI_OrderInternal_Child.ContractId)
                                                              , inUserId                    := vbUserId
                                                               )
       FROM (SELECT MovementItem.Id AS MovementItemId, MovementItem.ParentId
                  , COALESCE (MovementItem.ObjectId, 0)           AS GoodsId
                  , COALESCE (MILinkObject_Juridical.ObjectId, 0) AS JuridicalId
                  , COALESCE (MILinkObject_Contract.ObjectId, 0)  AS ContractId
             FROM MovementItem
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                         ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                        AND MILinkObject_Juridical.MovementItemId = MovementItem.Id
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                         ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                        AND MILinkObject_Contract.MovementItemId = MovementItem.Id
             WHERE MovementItem.MovementId = inInternalOrder
               AND MovementItem.DescId = zc_MI_Child()
            ) AS MovementItem
            FULL JOIN _tmpMI_OrderInternal_Child ON _tmpMI_OrderInternal_Child.MovementItemId = MovementItem.ParentId
                                                AND _tmpMI_OrderInternal_Child.JuridicalId    = MovementItem.JuridicalId
                                                AND _tmpMI_OrderInternal_Child.ContractId     = MovementItem.ContractId
                                                AND _tmpMI_OrderInternal_Child.GoodsId        = MovementItem.GoodsId
      ;

       -- 
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), inInternalOrder, TRUE);


   END IF;
   
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
                       


-- � ��� ����������� ��, ������� ��� � ������

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


    -- RAISE EXCEPTION '<%>   <%>', (select count(*) from _tmpMI_OrderInternal_Master), (select count(*) from _tmpMI_OrderInternal_Child);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.12.16         * add zc_MIFloat_AmountDeferred
 19.09.14                         *
*/

-- ����
-- SELECT * FROM gpCalculate_ExternalOrder (inInternalOrder:= 2333613, inSession:= '3');
-- SELECT * FROM gpCalculate_ExternalOrder (inInternalOrder:= 1730977, inSession:= '3');
