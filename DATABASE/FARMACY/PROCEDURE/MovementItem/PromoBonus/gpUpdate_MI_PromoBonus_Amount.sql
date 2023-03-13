-- Function: gpUpdate_MI_PromoBonus_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoBonus_Amount (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoBonus_Amount(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
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
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = (SELECT MovementItem.MovementId FROM MovementItem WHERE  MovementItem.ID = inId));

    -- �������� - �����������/��������� ��������� �������� ������
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
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
--ALTER FUNCTION gpUpdate_MI_PromoBonus_Amount (Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 08.03.23                                                                      *
*/

-- ����
-- select * from gpUpdate_MI_PromoBonus_Amount(inId := 410460411 , inAmount := 10 ,  inSession := '3');