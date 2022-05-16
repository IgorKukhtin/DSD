   -- Function: gpUpdate_MovementIten_Check_Price()

DROP FUNCTION IF EXISTS gpUpdate_MovementIten_Check_Price (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementIten_Check_Price(
    IN inMovementId          Integer   , -- ���� ������� <������ ���������>
    IN inMovementItemID      Integer   , -- ���� ������� <��������>
    IN inPrice               TFloat    , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPriceSale TFloat;
   DECLARE vbChangePercent TFloat;
   DECLARE vbAmount TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF inSession::Integer NOT IN (3, 375661, 235009, 4183126, 8001630, 9560329, 8051421, 14080152, 183242 )
    THEN
      RAISE EXCEPTION '��������� <����> ��� ���������.';
    END IF;

    SELECT
      StatusId
    INTO
      vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ���� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� ������� �� ���������
    IF COALESCE (inMovementItemID, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inMovementItemID)
    THEN
        RAISE EXCEPTION '�� ������ ������� �� ��������e';
    END IF;

    -- ������� ������� �� ��������� � ������
    IF COALESCE (inMovementId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inMovementItemID)
    THEN
        RAISE EXCEPTION '�� ����� �������� ��� ������������ �����';
    END IF;

    SELECT MovementItem.Amount, MovementItemFloat.ValueData AS PriceSale, MIFloat_ChangePercent.ValueData AS ChangePercent
    INTO vbAmount, vbPriceSale, vbChangePercent
    FROM MovementItem

         LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemID = MovementItem.ID
                                    AND MovementItemFloat.DescId = zc_MIFloat_PriceSale()

         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                     ON MIFloat_ChangePercent.MovementItemID = MovementItem.ID
                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

    WHERE MovementItem.ID = inMovementItemID;


    -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), inMovementItemID, inPrice);

    -- ��������� �������� <% ������>
    IF vbChangePercent NOT IN (50, 100)
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), inMovementItemID, 0);
    END IF;

    -- ��������� �������� <>
    IF COALESCE(inPrice, 0) = COALESCE(vbPriceSale, 0)
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inMovementItemID, 0);
    ELSE
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inMovementItemID, CASE WHEN vbAmount = 0 THEN 0.0
          ELSE ROUND(ROUND(vbAmount, 3) * COALESCE(vbPriceSale, 0), 2) - ROUND(ROUND(vbAmount, 3) * inPrice, 2) END);
    END IF;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementIten_Check_Price (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.12.20                                                       *
*/


-- select * from gpUpdate_MovementIten_Check_Price(inMovementId := 21296096 , inMovementItemID := 394839117 , inPrice := 500 ,  inSession := '3');