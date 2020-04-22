-- Function: lpGet_MovementItem_WagesAE_TotalSum()

DROP FUNCTION IF EXISTS lpGet_MovementItem_WagesAE_TotalSum(Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_WagesAE_TotalSum(
    IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
    IN inUserId              Integer     -- ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbSumma1                 TFloat;
   DECLARE vbSumma2                 TFloat;
   DECLARE vbSummaTMP               TFloat;
   DECLARE vbSummaMoneyBox          TFloat;
   DECLARE vbSummaMoneyBoxUsed      TFloat;
   DECLARE vbSummaMoneyBoxUsedAll   TFloat;
   DECLARE vbSummaMoneyBoxNew       TFloat;
   DECLARE vbSummaFullChargeRolling TFloat;
   DECLARE vbOperDate               TDateTime;
   DECLARE vbUnitID                 Integer;
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

      -- ������ �������� ����� �� ������� �����
      vbSummaFullChargeRolling := COALESCE((SELECT sum(MIF_SummaFullCharge.ValueData - COALESCE(MIF_SummaFullChargeFact.ValueData, MIF_SummaFullCharge.ValueData))
                                          FROM Movement
                                               INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                                                      AND MovementItem.MovementId = Movement.Id
                                                                      AND MovementItem.ObjectId = vbUnitID
                                               INNER JOIN MovementItemFloat AS MIF_SummaFullCharge
                                                                            ON MIF_SummaFullCharge.MovementItemId = MovementItem.Id
                                                                           AND MIF_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()
                                               LEFT JOIN MovementItemFloat AS MIF_SummaFullChargeFact
                                                                           ON MIF_SummaFullChargeFact.MovementItemId = MovementItem.Id
                                                                          AND MIF_SummaFullChargeFact.DescId = zc_MIFloat_SummaFullChargeFact()
                                          WHERE Movement.DescId = zc_Movement_Wages()
                                            AND Movement.OperDate < vbOperDate), 0);

      -- ��������� ����������� ��������� ����
      IF vbSummaTMP <> COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                 FROM MovementItemFloat AS MIFloat_SummaSUN1
                                 WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                   AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaFullCharge())), 0)
      THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullCharge(), inMovementItemId, COALESCE (vbSummaTMP, 0)::TFloat);
      END IF;


      -- ���� ������� �� ������ ������
      vbSummaTMP := COALESCE((SELECT SUM(MIF_SummaFundMonth.ValueData - COALESCE(MIF_SummaFundUsed.ValueData, 0))
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                                          AND MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.ObjectId = vbUnitID
                                   INNER JOIN MovementItemFloat AS MIF_SummaFundMonth
                                                                ON MIF_SummaFundMonth.MovementItemId = MovementItem.Id
                                                               AND MIF_SummaFundMonth.DescId = zc_MIFloat_SummaFundMonth()
                                   LEFT JOIN MovementItemFloat AS MIF_SummaFundUsed
                                                               ON MIF_SummaFundUsed.MovementItemId = MovementItem.Id
                                                              AND MIF_SummaFundUsed.DescId = zc_MIFloat_SummaFundUsed()
                              WHERE Movement.OperDate >= '01.03.2020'
                                AND Movement.OperDate <  date_trunc('month', vbOperDate)
                                AND Movement.DescId = zc_Movement_Wages()), 0);

       -- ��������� �������� <���� ��������� �� ����� �������>
      IF vbSummaTMP <> COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                               FROM MovementItemFloat AS MIFloat_SummaSUN1
                                               WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                                 AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaFund())), 0)
      THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFund(), inMovementItemId, COALESCE (vbSummaTMP, 0)::TFloat);
      END IF;


      -- ����� �� + �� + ����
      IF EXISTS(SELECT 1 FROM MovementItemFloat
                WHERE MovementItemFloat.MovementItemId = inMovementItemId
                  AND MovementItemFloat.DescId = zc_MIFloat_SummaFullChargeFact())
      THEN
        vbSumma2 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                              FROM MovementItemFloat AS MIFloat_SummaSUN1
                              WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaTechnicalRediscount(), zc_MIFloat_SummaFullChargeFact(), zc_MIFloat_SummaFundUsed())), 0);

      ELSE
        vbSumma2 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                              FROM MovementItemFloat AS MIFloat_SummaSUN1
                              WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaTechnicalRediscount(), zc_MIFloat_SummaFullCharge(), zc_MIFloat_SummaFundUsed())), 0);
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