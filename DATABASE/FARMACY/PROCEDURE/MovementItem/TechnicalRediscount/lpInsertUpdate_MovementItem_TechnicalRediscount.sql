-- Function: lpInsertUpdate_MovementItem_TechnicalRediscount()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TechnicalRediscount(Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TechnicalRediscount(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inCommentTRID         Integer   , -- �����������
    IN isExplanation         TVarChar  , -- ���������
    IN isComment             TVarChar  , -- ����������� 2
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
BEGIN

     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, Null);

     -- ��������� <�����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentTR(), ioId, inCommentTRID);
     -- ��������� <���������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Explanation(), ioId, isExplanation);
     -- ��������� <����������� 2>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, isComment);

     PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
*/

-- ����

