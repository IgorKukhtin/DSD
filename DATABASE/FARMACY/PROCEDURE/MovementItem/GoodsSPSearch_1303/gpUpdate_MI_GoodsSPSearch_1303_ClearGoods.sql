-- Function: gpUpdate_MI_GoodsSPSearch_1303_ClearGoods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPSearch_1303_ClearGoods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPSearch_1303_ClearGoods(
    IN inId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,    -- ������������� ���������
    IN inCol                 Integer   ,    -- ����� �.�.
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

    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 11041603 )
    THEN
        RAISE EXCEPTION '������. � ��� ��� ���� ��������� ��� ��������.';     
    END IF;    
    
    -- ��������� ������� �� ���������
    IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId AND COALESCE (ObjectId, 0) = 0)
    THEN
        RAISE EXCEPTION '����� �� �����������.';
    END IF;    

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), 0, inMovementId, inCol, NULL, zc_Enum_Process_Auto_PartionClose());

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