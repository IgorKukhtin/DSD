-- Function: gpInsertUpdate_MovementItem_Send_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_Detail (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_Detail(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inParentId              Integer   , -- ���� ������� <������� �������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inSubjectDocId_top      Integer   , -- 
    IN inReturnKindId_top      Integer   , -- 
    IN inSubjectDocId          Integer   , -- 
    IN inReturnKindId          Integer   , -- 
    IN inAmount                TFloat    , -- ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inSubjectDocId,0) = 0 AND COALESCE (inSubjectDocId_top,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� ��������� ��� �����������.';
     END IF;

     IF COALESCE (inReturnKindId,0) = 0 AND COALESCE (inReturnKindId_top,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������ ��� �����������.';
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     --���� ��������� ����� ������ ����� ��������� ���������� ���-�� �� ������
     IF vbIsInsert = TRUE AND COALESCE (inAmount,0) = 0
     THEN
         SELECT (MovementItem.Amount - COALESCE (tmp.Amount,0)) AS Amount
        INTO inAmount
         FROM MovementItem
              INNER JOIN (SELECT SUM (MovementItem.Amount) AS Amount FROM MovementItem WHERE MovementItem.ParentId = inParentId) AS tmp ON 1 = 1
         WHERE MovementItem.Id = inParentId
         ;
     END IF;

     -- ���� �� ������� � ����� �������� ����� �� �����
     IF COALESCE (inSubjectDocId,0) = 0
     THEN
         inSubjectDocId := inSubjectDocId_top;
     END IF;
     -- ���� �� ������� � ����� �������� ����� �� �����
     IF COALESCE (inReturnKindId,0) = 0
     THEN
         inReturnKindId := inReturnKindId_top;
     END IF;
     

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, inMovementId, inAmount, inParentId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_SubjectDoc(), ioId, inSubjectDocId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReturnKind(), ioId, inReturnKindId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.04.21         *
*/

-- ����
--