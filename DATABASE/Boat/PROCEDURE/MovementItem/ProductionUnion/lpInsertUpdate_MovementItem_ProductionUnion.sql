-- Function: gpInsertUpdate_MovementItem_ProductionUnion()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProductionUnion(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inObjectId            Integer   , -- �������������
    IN inReceiptProdModelId  Integer   , -- 
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inObjectId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptProdModel(), ioId, inReceiptProdModelId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
         
         --��� ������� zc_MI_Master ��������� ����������� zc_MI_Child - �� ��������� ����, ��� update ���� ������ �� ������
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId         := 0
                                                        , inParentId   := ioId
                                                        , inMovementId := inMovementId
                                                        , inObjectId   := tmp.ObjectId
                                                        , inAmount     := (COALESCE (tmp.Value,0) + COALESCE (tmp.Value_service,0)) :: TFloat
                                                        , inUserId     := inUserId
                                                        )
         FROM gpSelect_MI_ProductionUnion_Child (inMovementId, TRUE, FALSE, inUserId ::TVarChar) AS tmp
         WHERE tmp.ParentId = ioId;
         
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.21         *
*/

-- ����
--