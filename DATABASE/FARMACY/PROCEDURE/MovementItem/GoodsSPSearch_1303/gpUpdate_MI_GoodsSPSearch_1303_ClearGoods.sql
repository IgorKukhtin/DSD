-- Function: gpUpdate_MI_GoodsSPSearch_1303_ClearGoods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPSearch_1303_ClearGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPSearch_1303_ClearGoods(
    IN inId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,    -- ������������� ���������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF COALESCE (inId, 0) = 0 OR COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';    
    END IF;
    
    -- ��������� ������� �� ���������
    IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId AND COALESCE (ObjectId, 0) = 0)
    THEN
        RAISE EXCEPTION '����� �� �����������.';
    END IF;    

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), 0, inMovementId, 0, NULL);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.07.22                                                       *
*/
-- select * from gpUpdate_MI_GoodsSPSearch_1303_ClearGoods(inId := 514496660 , inMovementId := 27854839 ,  inSession := '3');
