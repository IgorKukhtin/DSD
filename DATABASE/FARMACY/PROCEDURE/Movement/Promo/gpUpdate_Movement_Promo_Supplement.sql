-- Function: gpUpdate_Movement_Promo_Supplement()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Supplement (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Supplement(
    IN inMovementId              Integer    , -- ���� ������� <��������>
    IN inisSupplement            Boolean    , -- ������������ ����� � ���������� ���
    IN inSession                 TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
           
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;
    
    -- ��������� <������������ ����� � ���������� ���>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Supplement(), inMovementId, not inisSupplement);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.21                                                       *
*/

-- select * from gpUpdate_Movement_Promo_Supplement(inMovementId := 4193036 , inisSupplement := 'False' ,  inSession := '3');