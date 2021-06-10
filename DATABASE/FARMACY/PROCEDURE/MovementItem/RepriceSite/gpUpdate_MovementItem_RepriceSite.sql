-- Function: gpUpdate_MovementItem_RepriceSite()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_RepriceSite(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_RepriceSite(
    IN inMovementItemID Integer,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
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
     COALESCE(MIBoolean_ClippedReprice.ValueData, False),
     MovementItem.ObjectId,
     MIFloat_PriceSale.ValueData
  INTO
    vbMovementID,
    vbClippedReprice,
    vbGoodsId,
    vbPriceNew
  FROM MovementItem

       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId

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

  IF EXISTS(SELECT 1 FROM Movement
            WHERE Movement.ID > vbMovementID
              AND Movement.DescId = zc_Movement_RepriceSite())
  THEN
    RAISE EXCEPTION '������. ����������� ������� ������ � ��������� ����������';
  END IF;

    -- ����������� �����
  PERFORM lpInsertUpdate_Object_PriceSite(inGoodsId := vbGoodsId,
                                          inPrice   := vbPriceNew,
                                          inDate    := CURRENT_DATE::TDateTime,
                                          inUserId  := vbUserId);
                                      
    -- ��������� <������� ��� ���������>
  PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ClippedReprice(), inMovementItemID, False);

    -- ����������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSummRepriceSite(vbMovementID);                                      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_RepriceSite(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 10.06.21                                                       *  
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_RepriceSite (8563866, '3')