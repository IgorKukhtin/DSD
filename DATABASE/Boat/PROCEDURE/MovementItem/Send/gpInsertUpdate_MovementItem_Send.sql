-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN ioAmount              TFloat    , -- ����������
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

     -- ����� �����
     IF ioId < 0
     THEN
             -- ��������
             IF 1 < (SELECT COUNT(*) FROM MovementItem AS MI 
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     )
             THEN
                 RAISE EXCEPTION '������.������� ��������� ����� � ����� �������������.%<%>.', CHR (13), lfGet_Object_ValueData (inGoodsId);
             END IF;
             -- �����
             ioId:= (SELECT MI.Id FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     );
         -- 
         ioAmount:= ioAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0);

     END IF;

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
                                          , ioAmount
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