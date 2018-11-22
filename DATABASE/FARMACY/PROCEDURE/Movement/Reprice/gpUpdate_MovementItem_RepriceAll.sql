-- Function: gpUpdate_MovementItem_RepriceAll()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_RepriceAll(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_RepriceAll(
    IN inMovementItemID Integer,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUnitID Integer;
   DECLARE vbUnit_ForwardingID Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbGoodsId Integer;
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
     Movement.OperDate,
     COALESCE(MovementLinkObject_UnitForwarding.ObjectId, 0),
     COALESCE(MIBoolean_ClippedReprice.ValueData, False),
     MovementItem.ObjectId
  INTO
    vbMovementID,
    vbUnitID,
    vbOperDate,
    vbUnit_ForwardingID,
    vbClippedReprice,
    vbGoodsId
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
    RAISE EXCEPTION '������. � ����������� ��� �������� �����������';
  END IF;

  PERFORM gpUpdate_MovementItem_Reprice(MovementItem.ID, inSession)
  FROM Movement

       INNER JOIN MovementItem ON Movement.ID = MovementItem.MovementId
                              AND MovementItem.ObjectId = vbGoodsId

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

  WHERE Movement.OperDate = vbOperDate
    AND Movement.DescId = zc_Movement_Reprice()
    AND COALESCE(MovementLinkObject_UnitForwarding.ObjectId, 0) = 0
    AND COALESCE(MIBoolean_ClippedReprice.ValueData, False) = True;


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
-- SELECT * FROM gpUpdate_MovementItem_RepriceAll (8563866, '3')