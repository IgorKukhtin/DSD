-- Function: gpInsertUpdate_MovementItem_ProductionPersonal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProductionPersonal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- 
    IN inProductId           Integer   , --
    IN inGoodsId             Integer   , -- 
    IN inStartBegin          TDateTime ,
    IN inEndBegin            TDateTime ,
    IN inAmount              TFloat    , -- ����������
    IN inComment             TVarChar  ,
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Product(), ioId, inProductId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), ioId, inStartBegin);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), ioId, inEndBegin);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.12.22         *
 13.07.21         *
*/

-- ����
--