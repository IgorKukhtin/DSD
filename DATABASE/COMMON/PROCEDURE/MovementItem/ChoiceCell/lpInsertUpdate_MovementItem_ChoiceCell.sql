-- Function: lpInsertUpdate_MovementItem_ChoiceCell()
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ChoiceCell(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <>
    IN inChoiceCellId        Integer   , --
    IN inGoodsId             Integer   ,
    IN inGoodsKindId         Integer   ,
    IN inPartionGoodsDate    TDateTime ,
    IN inPartionGoodsDate_next TDateTime ,
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������
     IF EXISTS (SELECT lpSelect.MovementItemId
                FROM lpSelect_Movement_ChoiceCell_mi (inUserId) AS lpSelect
                WHERE lpSelect.GoodsId     = inGoodsId
                  AND lpSelect.GoodsKindId = inGoodsKindId
                  AND lpSelect.MovementItemId <> COALESCE (ioId, 0)
               )
     THEN
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), lpSelect.MovementItemId, FALSE)
                 -- ��������� ����� � <>
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), lpSelect.MovementItemId, inUserId)
                 -- ��������� �������� <>
               , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), lpSelect.MovementItemId, CURRENT_TIMESTAMP)

         FROM -- ������� ���������� ����� ������ ��� �������� 
              (SELECT lpSelect.MovementItemId
               FROM lpSelect_Movement_ChoiceCell_mi (inUserId) AS lpSelect
               WHERE lpSelect.GoodsId     = inGoodsId
                 AND lpSelect.GoodsKindId = inGoodsKindId
              ) AS lpSelect;

         /*RAISE EXCEPTION '������.%��� ������ <%> <%> %������ = <%> %��� ���������� ������� <����� � ��������>.%'
                        , CHR (13)
                        , lfGet_Object_ValueData (inGoodsId)
                        , lfGet_Object_ValueData_sh (inGoodsKindId)
                        , CHR (13)
                        , lfGet_Object_ValueData_sh (inChoiceCellId)
                        , CHR (13)
                        , CHR (13)
                        , (SELECT lpSelect.MovementItemId
                         ;*/
     END IF;

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0 -- OR inUserId = 602817
     THEN
         RAISE EXCEPTION '������.����� �� ���������� ��� ������ ������ = <%>.(%)(%)', lfGet_Object_ValueData_sh (inChoiceCellId), inGoodsId, inGoodsKindId;
     END IF;

     -- ��������
     IF COALESCE (inGoodsKindId, 0) = 0 -- OR inUserId = 602817
     THEN
         RAISE EXCEPTION '������.����� �� ���������� ��� ������ ������ = <%>.(%)', lfGet_Object_ValueData_sh (inChoiceCellId), inGoodsKindId;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inChoiceCellId, inMovementId, 0, NULL);
     


     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     --
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     --
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_next(), ioId, inPartionGoodsDate_next);
     -- �������� ��� ���� �� ����� ������ ����������� �� ����� ��������
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), ioId, TRUE);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.24         *
*/

-- ����
--