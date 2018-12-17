-- Function: gpUpdate_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Reprice(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Reprice(
    IN inMovementItemID Integer,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUnitID Integer;
   DECLARE vbUnit_ForwardingID Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbPriceNew TFloat;
   DECLARE vbUserId Integer;
   DECLARE vbClippedReprice boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

  -- ���������� ������������
  vbUserId := inSession;

  IF COALESCE (inMovementItemID, 0) = 0
  THEN
    RAISE EXCEPTION '������. �������� �� ��������';
  END IF;

  SELECT
     Movement.ID,
     MovementLinkObject_Unit.ObjectId,
     COALESCE(MovementLinkObject_UnitForwarding.ObjectId, 0),
     COALESCE(MIBoolean_ClippedReprice.ValueData, False),
     MovementItem.ObjectId,
     MIFloat_PriceSale.ValueData
  INTO
    vbMovementID,
    vbUnitID,
    vbUnit_ForwardingID,
    vbClippedReprice,
    vbGoodsId,
    vbPriceNew
  FROM MovementItem

       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                     ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                    AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()

       LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                   ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                  AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

       LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                     ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                    AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

  WHERE MovementItem.ID = inMovementItemID;

  IF COALESCE (vbClippedReprice, FALSE) <> TRUE
  THEN
    RAISE EXCEPTION '������. ����������� ����� ������ ���������� ��� ���������� �������';
  END IF;

  IF vbUnit_ForwardingID = 0
  THEN
    IF EXISTS(SELECT 1 FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
              WHERE Movement.ID > vbMovementID
                AND Movement.DescId = zc_Movement_Reprice()
                AND MovementLinkObject_Unit.ObjectId = vbUnitID
                AND COALESCE(MovementLinkObject_UnitForwarding.ObjectId, 0) = 0)
    THEN
      RAISE EXCEPTION '������. ����������� ������� ������ � ��������� ���������� �� �������������';
    END IF;
  ELSE
    IF EXISTS(SELECT 1 FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
              WHERE Movement.ID > vbMovementID
                AND Movement.DescId = zc_Movement_Reprice()
                AND MovementLinkObject_Unit.ObjectId = vbUnitID
                AND  COALESCE(MovementLinkObject_UnitForwarding.ObjectId, 0) <> 0)
    THEN
      RAISE EXCEPTION '������. ����������� ������� ������ � ��������� ����������� ��� �� �������������';
    END IF;
  END IF;

    -- ����������� �����
  PERFORM lpInsertUpdate_Object_Price(inGoodsId := vbGoodsId,
                                      inUnitId  := vbUnitID,
                                      inPrice   := vbPriceNew,
                                      inDate    := CURRENT_DATE::TDateTime,
                                      inUserId  := vbUserId);
                                      
    -- ��������� <������� ��� ���������>
  PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ClippedReprice(), inMovementItemID, False);

    -- ����������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSummReprice(vbMovementID);                                      

--  RAISE EXCEPTION '������. %', inMovementItemID;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Reprice(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 22.11.18        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Reprice (8563866, '3')