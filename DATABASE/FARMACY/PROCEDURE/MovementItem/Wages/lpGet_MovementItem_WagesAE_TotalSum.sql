-- Function: lpGet_MovementItem_WagesAE_TotalSum()

DROP FUNCTION IF EXISTS lpGet_MovementItem_WagesAE_TotalSum(Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_WagesAE_TotalSum(
    IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
    IN inUserId              Integer     -- ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbSumma1               TFloat;
   DECLARE vbSumma2               TFloat;
   DECLARE vbSummaMoneyBox        TFloat;
   DECLARE vbSummaMoneyBoxUsed    TFloat;
   DECLARE vbSummaMoneyBoxUsedAll TFloat;
   DECLARE vbSummaMoneyBoxNew     TFloat;
   DECLARE vbOperDate             TDateTime;
   DECLARE vbUnitID               Integer;
BEGIN

    -- �������� ����������
    IF COALESCE (inMovementItemId, 0) = 0
    THEN
        RAISE EXCEPTION '������. �������������� ������� �� ���������.';
    END IF;

    -- �������� ����������
    IF NOT EXISTS(SELECT 1
                  FROM MovementItem
                       INNER JOIN Movement ON Movement.ID = MovementItem.MovementID
                                          AND Movement.DescId = zc_Movement_Wages()
                  WHERE MovementItem.ID = inMovementItemId
                    AND MovementItem.DescId = zc_MI_Sign())
    THEN
        RAISE EXCEPTION '������. �������� �� ������.';
    END IF;

    SELECT Movement.OperDate, MovementItem.ObjectId
    INTO vbOperDate, vbUnitID
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementID
                            AND Movement.DescId = zc_Movement_Wages()
    WHERE MovementItem.ID = inMovementItemId
      AND MovementItem.DescId = zc_MI_Sign();

    vbSumma1 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                          FROM MovementItemFloat AS MIFloat_SummaSUN1
                          WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                            AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaCleaning(), zc_MIFloat_SummaSP(), zc_MIFloat_SummaOther(),
                                                             zc_MIFloat_ValidationResults(), zc_MIFloat_SummaSUN1())), 0);

    IF vbOperDate >= '01.03.2020'
    THEN

      -- ����� �� + ��
      vbSumma2 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                            FROM MovementItemFloat AS MIFloat_SummaSUN1
                            WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                              AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaTechnicalRediscount())), 0);

      IF vbOperDate >= '01.05.2020'
      THEN
        vbSumma2 := vbSumma2 + COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                         FROM MovementItemFloat AS MIFloat_SummaSUN1
                                         WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                           AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaFullCharge())));

      END IF;

      -- ����� ��������
      vbSummaMoneyBox := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                   FROM MovementItemFloat AS MIFloat_SummaSUN1
                                   WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                     AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaMoneyBox())), 0);

      -- ������������ � ������� ������
      vbSummaMoneyBoxUsed := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                       FROM MovementItemFloat AS MIFloat_SummaSUN1
                                       WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                         AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaMoneyBoxUsed())), 0);


      vbSummaMoneyBoxUsedAll := COALESCE((SELECT sum(MIF_SummaMoneyBoxMonth.ValueData)
                                          FROM Movement
                                               INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                                                      AND MovementItem.MovementId = Movement.Id
                                                                      AND MovementItem.ObjectId = vbUnitID
                                               INNER JOIN MovementItemFloat AS MIF_SummaMoneyBoxMonth
                                                                            ON MIF_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                                                           AND MIF_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxUsed()
                                          WHERE Movement.DescId = zc_Movement_Wages()), 0);

      IF vbSumma2 < 0 AND (vbSummaMoneyBox - vbSummaMoneyBoxUsedAll + vbSummaMoneyBoxUsed)  > 0
      THEN
        vbSummaMoneyBoxNew := (vbSummaMoneyBox - vbSummaMoneyBoxUsedAll + vbSummaMoneyBoxUsed);

        IF vbSummaMoneyBoxNew + vbSumma2 > 0
        THEN
          vbSummaMoneyBoxNew := - vbSumma2;
        END IF;

        IF vbSummaMoneyBoxNew <> vbSummaMoneyBoxUsed
        THEN
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBoxUsed(), inMovementItemId, vbSummaMoneyBoxNew);
        END IF;

      ELSE
        IF vbSummaMoneyBoxUsed <> 0
        THEN
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBoxUsed(), inMovementItemId, 0);
        END IF;
      END IF;

      vbSumma2 := vbSumma2 + COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                       FROM MovementItemFloat AS MIFloat_SummaSUN1
                                       WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                         AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaMoneyBoxUsed())), 0);

    ELSE
      vbSumma2 := 0;
    END IF;

    -- ���������
    RETURN vbSumma1 + vbSumma2;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.02.20                                                        *
*/

-- ����
-- SELECT * FROM lpGet_MovementItem_WagesAE_TotalSum (inMovementItemId := 323828208, inUserId := 3)