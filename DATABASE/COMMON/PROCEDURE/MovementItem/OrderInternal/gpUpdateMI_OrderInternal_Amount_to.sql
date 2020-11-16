-- Function: gpUpdateMI_OrderInternal_Amount_to()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_to (Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_to (Integer, Integer, TFloat, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_to (Integer, Integer, TFloat, TFloat, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_Amount_to(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inAmount              TFloat    , --
    IN inAmountTwo           TFloat    , --
    IN inIsClear             Boolean   , --
    IN inNumber              Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    IF inIsClear = TRUE
    THEN
        IF inNumber = 1
        THEN
            -- �������� - Amount
            UPDATE MovementItem SET Amount = 0
            FROM (SELECT MovementItem.Id
                       , COALESCE (MIBoolean_Calculated.ValueData, TRUE) AS isCalculated
                  FROM MovementItem
                       LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                     ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                  WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
                 ) AS tmpMI
            WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
              AND tmpMI.Id = MovementItem.Id
            --AND tmpMI.isCalculated = TRUE
            ;

        ELSEIF inNumber = 2
        THEN
            -- �������� - AmountSecond
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(),  MovementItem.Id, 0)
            FROM MovementItem
                 LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                              AND MIBoolean_Calculated.ValueData      = FALSE
            WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
            --AND MIBoolean_Calculated.MovementItemId IS NULL
           ;

        ELSEIF inNumber = 3
        THEN
            -- �������� - AmountNext
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext(),  MovementItem.Id, 0)
            FROM MovementItem
                 LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                              AND MIBoolean_Calculated.ValueData      = FALSE
            WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
            --AND MIBoolean_Calculated.MovementItemId IS NULL
           ;

        ELSEIF inNumber = 4
        THEN
            -- �������� - AmountNextSecond
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNextSecond(),  MovementItem.Id, 0)
            FROM MovementItem
                 LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                              AND MIBoolean_Calculated.ValueData      = FALSE
            WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
            --AND MIBoolean_Calculated.MovementItemId IS NULL
           ;

        ELSE
            RAISE EXCEPTION '������.�� ���������� �������� <inNumber> = %.', inNumber;
        END IF;

        -- ����������� �������� ����� �� ���������
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    ELSEIF inAmount > 0 AND ((inAmount > 5 AND inNumber IN (1, 3)) OR inNumber NOT IN (1, 3))
    THEN

        -- ��������
        IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.DescId = zc_MI_Master() AND MI.Id = inId AND MI.ObjectId > 0)
        THEN
            RAISE EXCEPTION '������.�� ���������� �������� <�����>.';
        END IF;
        -- ��������
        IF NOT EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_GoodsKind() AND MILO.MovementItemId = inId AND MILO.ObjectId > 0)
        THEN
            RAISE EXCEPTION '������.�� ���������� �������� <��� ������>.';
        END IF;


        IF 1=1 -- NOT EXISTS (SELECT 1 FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = inId AND MIB.DescId = zc_MIBoolean_Calculated() AND MIB.ValueData = FALSE)
        THEN
            IF inNumber = 1
            THEN
                -- ��������� - Amount
                UPDATE MovementItem SET Amount = inAmount WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.Id = inId;

            ELSEIF inNumber = 2
            THEN
                -- ��������� - AmountSecond
                PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), inId, inAmount);

            ELSEIF inNumber = 3
            THEN
                IF inAmount > COALESCE (inAmountTwo, 0)
                THEN
                    -- ��������� - AmountNext
                    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext(), inId, inAmount - COALESCE (inAmountTwo, 0));
                END IF;

            ELSEIF inNumber = 4
            THEN
                IF inAmount > COALESCE (inAmountTwo, 0)
                THEN
                    -- ��������� - AmountNextSecond
                    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNextSecond(), inId, inAmount - COALESCE (inAmountTwo, 0));
                END IF;

            ELSE
                RAISE EXCEPTION '������.�� ���������� �������� <inNumber> = %.', inNumber;
            END IF;

        END IF;


        -- ����������� �������� ����� �� ���������
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

        -- ��������� ��������
        PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.11.17                                        *
*/

-- ����
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_to (inMovementId:= 7343799, inOperDate:= '31.10.2017', inSession:= zfCalc_UserAdmin());
