-- Function: gpUpdate_MI_OrderInternal_AmountReal_RemainsSun()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_AmountReal_RemainsSun (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_AmountReal_RemainsSun(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- ������ �� �������� �������� ������� �� �������������
     CREATE TEMP TABLE _tmpRemainsGoodsPartionDate (GoodsId Integer, Amount TFloat, AmountRemains TFloat) ON COMMIT DROP;
       INSERT INTO _tmpRemainsGoodsPartionDate (GoodsId, Amount, AmountRemains)
          SELECT tmp.GoodsId              AS GoodsId
               , SUM (tmp.Amount)         AS Amount
               , SUM (tmp.AmountRemains)  AS AmountRemains
          FROM gpReport_GoodsPartionDate( inUnitId := inUnitId , inGoodsId := 0, inIsDetail := False ,  inSession := inSession) AS tmp
          GROUP BY tmp.GoodsId;


     -- ������ ������
     CREATE TEMP TABLE _tmp_MI (Id integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
       INSERT INTO _tmp_MI (Id, GoodsId, Amount)
             SELECT MovementItem.Id
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount
             FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE;
                
     -- ��������� ��������, 
     /*����� ��� ����� ��� - ��� �� ��� ������ � �������, �� ������ � ��� ������ ���� ���� ��������, � � ������ ������ ����*/
     PERFORM lpInsertUpdate_MI_OrderInternal_SUN (inId             := COALESCE (_tmp_MI.Id, 0)
                                                , inMovementId     := inMovementId
                                                , inGoodsId        := _tmp_MI.GoodsId
                                                , inAmount         := CASE WHEN COALESCE (_tmpRemains.Amount,0) <> 0 THEN 0 ELSE COALESCE (_tmp_MI.Amount,0) END ::TFloat
                                                , inAmountReal     := CASE WHEN COALESCE (_tmpRemains.Amount,0) <> 0 THEN COALESCE (_tmp_MI.Amount,0) ELSE 0 END ::TFloat
                                                , inRemainsSUN     := COALESCE (_tmpRemains.Amount,0) ::TFloat
                                                , inUserId         := vbUserId
                                                )
     FROM _tmp_MI
         LEFT JOIN _tmpRemainsGoodsPartionDate AS _tmpRemains ON _tmpRemains.GoodsId = _tmp_MI.GoodsId
     ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.07.19         *
*/

-- ����
--