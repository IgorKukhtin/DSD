-- Function: gpUpdate_MI_GoodsSP_Goods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSP_Goods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSP_Goods(
    IN inId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,    -- ������������� ���������
    IN inGoodsId             Integer   ,    -- ������� �����
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
    IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId AND COALESCE (ObjectId, 0) = inGoodsId)
    THEN
        RAISE EXCEPTION '����� ��� �����������.';
    END IF;    

    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (59582, 393039, 1915124))
       AND vbUserId <> 3
    THEN
        RAISE EXCEPTION '������. � ��� ��� ���� ��������� ��� ��������.';     
    END IF;    

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL, zc_Enum_Process_Auto_PartionClose());

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
-- select * from gpUpdate_MI_GoodsSP_Goods(inId := 523696543 , inMovementId := 28341113 , inGoodsID := 12006218 , inSession := '3');