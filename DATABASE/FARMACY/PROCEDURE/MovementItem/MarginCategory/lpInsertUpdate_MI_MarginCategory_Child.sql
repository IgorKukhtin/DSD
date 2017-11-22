-- Function: lpInsertUpdate_MI_Inventory_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_MarginCategory_Child(
 INOUT i0Id                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inMarginCategoryId    Integer   , -- MarginCategory
    IN inAmount              TFloat    , -- %
    IN inComment             TVarChar  , -- 
    IN inUserId              Integer     -- 
 )                              
RETURNS Integer AS
$BODY$
  DECLARE vbIsInsert Boolean; 
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
   
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inMarginCategoryId, inMovementId, inAmount, inParentId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.17         *
*/

-- ����
-- 