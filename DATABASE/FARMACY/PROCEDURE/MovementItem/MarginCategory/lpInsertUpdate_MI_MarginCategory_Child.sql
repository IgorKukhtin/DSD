-- Function: lpInsertUpdate_MI_Inventory_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_MarginCategory_Child(
 INOUT ioId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ���������
    IN inMarginCategoryItemId    Integer   , -- MarginCategoryItem
    IN inAmount                  TFloat    , -- %
    IN inUserId                  Integer     -- 
 )                              
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean; 
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
   
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inMarginCategoryItemId, inMovementId, inAmount, Null);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.17         *
*/

-- ����
-- 