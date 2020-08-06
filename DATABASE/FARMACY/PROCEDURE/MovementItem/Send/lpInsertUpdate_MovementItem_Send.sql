-- Function: lpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountManual        TFloat    , -- ���-�� ������
    IN inAmountStorage       TFloat    , --
    IN inReasonDifferencesId Integer   , -- ������� �����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount TFloat;
   DECLARE vbReasonDifferencesId Integer;
   DECLARE vbIsSUN       Boolean;
   DECLARE vbSumma       TFloat;
   DECLARE vbSummaNew    TFloat;
   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_to   Integer;
   DECLARE vbisReceived  Boolean;
   DECLARE vbLimitSUN    TFloat;
   DECLARE vbOperDate_pr TDateTime;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ������������ ������ �� ���������
     SELECT MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
          , (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE) :: Boolean
          , COALESCE (MovementFloat_TotalSummFrom.ValueData, 0)
          , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
          , COALESCE (ObjectFloat_LimitSUN.ValueData, 0)
            INTO vbUnitId_from
               , vbUnitId_to 
               , vbIsSUN
               , vbSumma
               , vbisReceived
               , vbLimitSUN
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.ID
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.ID
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
          LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                    ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                   AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                  ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                                 AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
          LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                    ON MovementBoolean_Received.MovementId = Movement.Id
                                   AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN ObjectFloat AS ObjectFloat_LimitSUN
                                ON ObjectFloat_LimitSUN.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectFloat_LimitSUN.DescId = zc_ObjectFloat_Retail_LimitSUN()
     WHERE Movement.Id = inMovementId;
     
     IF vbIsInsert AND vbIsSUN = False AND
        EXISTS(SELECT 1 FROM MovementItem AS MI 
               WHERE MI.MovementId = inMovementId AND MI.ObjectId = inGoodsId)
     THEN
          RAISE EXCEPTION '������.� ��������� ��� ����������� ����� <%> �������� ��������� � ����������� ���.', 
            (SELECT Object.ValueData FROM Object WHERE Object.ID = inGoodsId);
     END IF;

     -- ������������ ������ �� MovementItem
     SELECT MI.Amount 
          , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
        INTO vbAmount, vbReasonDifferencesId
     FROM MovementItem AS MI 
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                           ON MILinkObject_ReasonDifferences.MovementItemId = MI.Id
                                          AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                            
     WHERE MI.Id = ioId;

     -- ��������
     IF (COALESCE ((SELECT MovementBoolean_Deferred.ValueData FROM MovementBoolean  AS MovementBoolean_Deferred
                   WHERE MovementBoolean_Deferred.MovementId = inMovementId
                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE )
        AND ((COALESCE(inAmount, 0) <> COALESCE(vbAmount, 0)) OR (COALESCE(inReasonDifferencesId, 0) <> COALESCE(vbReasonDifferencesId, 0)))
     THEN
          RAISE EXCEPTION '������.�������� �������, ������������� ���������!';
     END IF;
     
     IF vbIsSUN = TRUE AND vbIsInsert = FALSE AND COALESCE (inAmount, 0) = 0 AND COALESCE (vbAmount, 0) > 0
     THEN
     
       -- ��������� <���-��>
       IF EXISTS(SELECT 1 FROM gpSelect_MovementItem_Send_Child(inMovementId := inMovementId,  inSession := inUserId::TVarChar) AS T1 
                 WHERE T1.Color_calc = zc_Color_Red() AND T1.ParentId = ioId)
       THEN       
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ZeroingUKTZED(), ioId, vbAmount);
       END IF;
     END IF;
          
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� <���-�� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, inAmountManual);
     -- ��������� <���-�� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStorage(), ioId, inAmountStorage);
 
     -- ��������� <������� �����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), ioId, inReasonDifferencesId);
     
     -- ������ ��� IsSUN
     IF vbIsSUN = TRUE
     THEN
         -- ��������� PriceFrom + Price_To
         PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN tmpPrice.UnitId = vbUnitId_from THEN zc_MIFloat_PriceFrom()
                                                        WHEN tmpPrice.UnitId = vbUnitId_to   THEN zc_MIFloat_PriceTo()
                                                   END
                                                 , ioId
                                                 , COALESCE (tmpPrice.Price, 0)
                                                  )
         FROM (WITH tmpPrice AS (SELECT ObjectLink_Unit.ChildObjectId                AS UnitId
                                      , ROUND (ObjectFloat_Price_Value.ValueData, 2) AS Price
                                  FROM ObjectLink AS ObjectLink_Goods
                                       INNER JOIN ObjectLink AS ObjectLink_Unit
                                                             ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectLink_Unit.ChildObjectId IN (vbUnitId_from, vbUnitId_to)
                                                            AND ObjectLink_Unit.DescId = zc_ObjectLink_Price_Unit()
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                             ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                  WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                 )
               SELECT tmpPrice.UnitId, tmpPrice.Price FROM tmpPrice
              ) AS tmpPrice;
     END IF;

    -- ��������� � 01,06,2020
    SELECT MIN (MovementProtocol.OperDate) AS OperDate_protocol
   INTO vbOperDate_pr
    FROM MovementProtocol
    WHERE MovementProtocol.MovementId = inMovementId;
                             
     IF vbOperDate_pr >= '01.06.2020' AND vbIsSUN = TRUE
     THEN
         -- ������ inAmountStorage � ������� ������ �� ��-�� zc_ObjectLink_Goods_GoodsPairSun - ������  �� ����� �������� - ObjectId � ChildObjectId
         -- ��� ObjectId
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStorage(), MovementItem.Id, inAmountStorage)
          FROM MovementItem
               INNER JOIN ObjectLink AS ObjectLink_GoodsPairSun 
                                     ON ObjectLink_GoodsPairSun.ObjectId = MovementItem.ObjectId
                                    AND ObjectLink_GoodsPairSun.DescId   = zc_ObjectLink_Goods_GoodsPairSun()
                                    AND ObjectLink_GoodsPairSun.ChildObjectId = inGoodsId
               INNER JOIN ObjectDate AS ObjectDate_PairSun
                                     ON ObjectDate_PairSun.ObjectId = ObjectLink_GoodsPairSun.ObjectId
                                    AND ObjectDate_PairSun.DescId = zc_ObjectDate_Goods_PairSun()
                                    AND ObjectDate_PairSun.ValueData <= vbOperDate_pr
                                   
          WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
             AND MovementItem.Id <> ioId;
          -- ��� ChildObjectId
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStorage(), MovementItem.Id, inAmountStorage)
          FROM MovementItem
               INNER JOIN ObjectLink AS ObjectLink_GoodsPairSun 
                                     ON ObjectLink_GoodsPairSun.ChildObjectId = MovementItem.ObjectId
                                    AND ObjectLink_GoodsPairSun.DescId   = zc_ObjectLink_Goods_GoodsPairSun()
                                    AND ObjectLink_GoodsPairSun.ObjectId = inGoodsId

               INNER JOIN ObjectDate AS ObjectDate_PairSun
                                     ON ObjectDate_PairSun.ObjectId = ObjectLink_GoodsPairSun.ObjectId
                                    AND ObjectDate_PairSun.DescId = zc_ObjectDate_Goods_PairSun()
                                    AND ObjectDate_PairSun.ValueData <= vbOperDate_pr

          WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
             AND MovementItem.Id <> ioId;
     END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (inMovementId);
     
     -- ��� ��� ��������� �����
     IF vbisSUN = TRUE AND vbisReceived = FALSE 
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())

     THEN
       SELECT COALESCE (MovementFloat_TotalSummFrom.ValueData, 0)
       INTO  vbSummaNew
       FROM MovementFloat AS MovementFloat_TotalSummFrom
       WHERE MovementFloat_TotalSummFrom.MovementId = inMovementId
         AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom();
     
       IF COALESCE(vbLimitSUN, 0) > 0 AND vbSummaNew < COALESCE(vbLimitSUN, 0) AND vbSummaNew < vbSumma
       THEN
         RAISE EXCEPTION '������. �������, ��������� ����� ����������� �� ��� ����� % ���. ���������.', COALESCE(vbLimitSUN, 0);
       END IF;
     END IF;
     
     IF vbIsInsert = TRUE
     THEN
         -- ��������� ������
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 05.02.19         * add inAmountStorage
 28.06.16         *
 29.07.15                                                                       *
 */

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
