-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inGoodsId                Integer   , -- ������
    IN inAmount                 TFloat    , -- ����������
    IN inComment                TVarChar  , --
    IN inIsEnabled              Boolean   ,
   OUT outIsErased              Boolean   , -- ������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE)
     THEN
         -- ���� ������������
         outIsErased := gpMovementItem_OrderInternal_SetUnErased (ioId, inSession);
     ENd IF;


     IF inIsEnabled = FALSE
     THEN
         -- ��������
         IF ioId > 0
         THEN
             -- �������
             PERFORM gpMovementItem_OrderInternal_SetErased (inMovementItemId:= ioId, inSession:= inSession);
             --
             outIsErased:= TRUE;

         END IF;

     ELSE
         -- ��������� <������� ���������>
         SELECT tmp.ioId
                INTO ioId
         FROM lpInsertUpdate_MovementItem_OrderInternal (ioId
                                                       , inMovementId
                                                       , inMovementId_OrderClient
                                                       , inGoodsId
                                                       , inAmount
                                                       , inComment
                                                       , vbUserId
                                                       ) AS tmp;
         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

     END IF;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.12.22         *
*/

-- ����
--