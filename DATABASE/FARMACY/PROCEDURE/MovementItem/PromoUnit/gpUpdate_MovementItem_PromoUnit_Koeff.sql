-- Function: gpUpdate_MovementItem_PromoUnit_Koeff()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_PromoUnit_Koeff (Integer, TFloat, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_PromoUnit_Koeff(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inKoeff             TFloat    , -- ������������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;
    
    IF COALESCE (inKoeff, 0) < 0
    THEN
        RAISE EXCEPTION '������.������������ ������ ���� ������ ��� ����� 0.';
    END IF;

    SELECT 
      Movement.StatusId
    INTO
      vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ������������ � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(), inId, inKoeff);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.01.22                                                       *
*/
-- ����
-- select * from gpUpdate_MovementItem_PromoUnit_Koeff(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');