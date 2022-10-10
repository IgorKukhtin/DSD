-- Function: gpUpdate_Movement_Promo_NotUseSUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_NotUseSUN (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_NotUseSUN(
    IN inMovementId              Integer    , -- ���� ������� <��������>
    IN inisNotUseSUN             Boolean    , -- �� ������������ ����� � ���
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
    
    -- ��������� <�� ������������ ����� � ���>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotUseSUN(), inMovementId, not inisNotUseSUN);
                        
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.22                                                       *
*/

-- select * from gpUpdate_Movement_Promo_NotUseSUN(inMovementId := 4193036 , inisNotUseSUN := 'False' ,  inSession := '3');