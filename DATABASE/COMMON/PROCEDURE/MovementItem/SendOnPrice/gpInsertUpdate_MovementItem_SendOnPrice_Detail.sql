-- Function: gpInsertUpdate_MovementItem_SendOnPrice_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice_Detail (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendOnPrice_Detail(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inParentId              Integer   , -- ���� ������� <������� �������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inReasonId_top          Integer   , -- 
    IN inReasonId              Integer   , -- 
    IN inReasonCode            Integer   , -- 
    IN inAmount                TFloat    , -- ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbReturnKindId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     IF COALESCE (inReasonId,0) = 0 AND COALESCE (inReasonId_top,0) = 0 AND COALESCE (inReasonCode,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� ��������� ��� �����������.';
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
     IF COALESCE (inReasonCode,0) = 0
     THEN
         inReasonId := inReasonId_top;
     ELSE
         -- ������� ������� �� ����
         inReasonId := (SELECT Object_Reason.Id AS ReasonId
                        FROM Object AS Object_Reason
                        WHERE Object_Reason.ObjectCode = inReasonCode
                          AND Object_Reason.DescId = zc_Object_Reason());
     END IF;
     --�������� ��� ��������
     vbReturnKindId := (SELECT  ObjectLink_ReturnKind.ChildObjectId AS ReturnKindId
                        FROM ObjectLink AS ObjectLink_ReturnKind
                        WHERE ObjectLink_ReturnKind.ObjectId = inReasonId
                              AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
                        );

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, inMovementId, inAmount, inParentId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Reason(), ioId, inReasonId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReturnKind(), ioId, vbReturnKindId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.21         *
*/

-- ����
--