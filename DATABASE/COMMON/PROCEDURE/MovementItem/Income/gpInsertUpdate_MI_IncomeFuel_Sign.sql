-- Function: gpInsertUpdate_MI_IncomeFuel_Sign()


DROP FUNCTION IF EXISTS gpInsertUpdate_MI_IncomeFuel_Sign (Integer, Integer, Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_IncomeFuel_Sign(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSignInternalId      Integer    ,
    IN inAmount              TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRouteMemberId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbDistance Tfloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inSignInternalId, inMovementId, inAmount, NULL);
   

   IF vbIsInsert = TRUE
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
/*   ELSE
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
*/
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 23.08.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
