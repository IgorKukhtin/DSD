-- Function: gpUpdate_MI_GoodsSPSearch_1303_Goods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPInform_1303_Goods (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPInform_1303_Goods(
    IN inId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,    -- ������������� ���������
    IN inGoodsId             Integer   ,    -- ������� �����
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
    
    -- ��������� ������� �� ���������
    IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId AND COALESCE (ObjectId, 0) = inGoodsId)
    THEN
        RAISE EXCEPTION '����� ��� �����������.';
    END IF;    

    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 11041603 )
       AND vbUserId <> 3
    THEN
        RAISE EXCEPTION '������. � ��� ��� ���� ��������� ��� ��������.';     
    END IF;    

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inCol, NULL, zc_Enum_Process_Auto_PartionClose());

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.04.23                                                       *
*/
-- select * from gpUpdate_MI_GoodsSPInform_1303_Goods(inId := 586863221 , inMovementId := 31575857 , inGoodsID := 17691736 , inCol := 4 ,  inSession := '3');