-- Function: gpInsertUpdate_MovementItem_Wages_Summa()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Summa(
    IN ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inHolidaysHospital    TFloat    , -- ������ / ����������
    IN inMarketing           TFloat    , -- ���������
    IN inDirector            TFloat    , -- ��������. ������ / ������
    IN inAmountCard          TFloat    , -- �� �����
    IN inisIssuedBy          Boolean   , -- 
   OUT outAmountHand         TFloat    , -- �� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (ioId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� ��������.';
    END IF;

     -- ��������� �������� <������ / ����������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HolidaysHospital(), ioId, inHolidaysHospital);
     -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Marketing(), ioId, inMarketing);
     -- ��������� �������� <��������. ������ / ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Director(), ioId, inDirector);

     -- ��������� �������� <�� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCard(), ioId, inAmountCard);

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);

    SELECT (MovementItem.Amount + 
            COALESCE (MIFloat_HolidaysHospital.ValueData, 0) + 
            COALESCE (MIFloat_Marketing.ValueData, 0) +
            COALESCE (MIFloat_Director.ValueData, 0) - 
            COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand
    INTO outAmountHand
    FROM  MovementItem

          LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                      ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                     AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

          LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                      ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                     AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

          LEFT JOIN MovementItemFloat AS MIFloat_Director
                                      ON MIFloat_Director.MovementItemId = MovementItem.Id
                                     AND MIFloat_Director.DescId = zc_MIFloat_Director()

          LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                      ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                     AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

    WHERE MovementItem.Id = ioId;

    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_Summa (, inSession:= '2')