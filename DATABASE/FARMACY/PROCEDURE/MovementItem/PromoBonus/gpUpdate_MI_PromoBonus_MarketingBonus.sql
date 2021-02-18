-- Function: gpUpdate_MI_PromoBonus_MarketingBonus()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoBonus_MarketingBonus (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoBonus_MarketingBonus(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmount              TFloat    , -- ������������� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbStatusId   Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);

    -- �������� - �����������/��������� ��������� �������� ������
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (inAmount, 0) < 0 OR COALESCE (inAmount, 0) > 100
    THEN
        RAISE EXCEPTION '������. ������������� ����� ������ ���� � ��������� �� 0 �� 100.';         
    END IF;
    
    IF COALESCE(inId, 0) = 0
    THEN
        RAISE EXCEPTION '������. ������ �� ����������.';         
    END IF;


     -- ���������
    IF COALESCE (inAmount, 0) <> (SELECT MovementItem.Amount
                                  FROM MovementItem WHERE  MovementItem.ID = inId)
    THEN
      UPDATE MovementItem SET Amount = COALESCE (inAmount, 0)
      WHERE MovementItem.ID = inId;
      
      -- ��������� <���� ���������>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
      
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 17.02.21                                                                      *
*/

-- ����
-- select * from gpUpdate_MI_PromoBonus_MarketingBonus(inId := 410422039 , inMovementId := 22181875 , inAmount := 10 ,  inSession := '3');