-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inOperPrice           TFloat    , -- ���� �� �������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inPartNumber          TVarChar  , --� �� ��� ��������
    IN inComment             TVarChar  , --
    IN inIsOn                Boolean   , -- ���
   OUT outIsErased           Boolean   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Send());
     vbUserId := lpGetUserBySession (inSession);


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ������
     IF vbIsInsert = TRUE THEN inIsOn:= TRUE; END IF;

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE)
     THEN
         -- ���� ������������
         outIsErased := gpMovementItem_Send_SetUnErased (ioId, inSession);
     ENd IF;


     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_Send (ioId
                                          , inMovementId
                                          , inGoodsId
                                          , inAmount
                                          , inOperPrice
                                          , inCountForPrice
                                          , inPartNumber
                                          , inComment
                                          , vbUserId
                                          ) AS tmp;
     
     -- (��������� �.�. ���� ������ ��� �����-�� ��������� � ������ �� ������ ��� ������� ������)
     IF COALESCE (inIsOn, FALSE) = FALSE
     THEN
         --������ ������� �� �������� 
         outIsErased := gpMovementItem_Send_SetErased (ioId, inSession);
     ENd IF;


     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.09.21         *
 23.06.21         *
*/

-- ����
--