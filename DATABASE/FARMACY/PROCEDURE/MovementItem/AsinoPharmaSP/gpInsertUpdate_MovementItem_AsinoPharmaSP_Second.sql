-- Function: gpInsertUpdate_MovementItem_AsinoPharmaSP_Second ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_AsinoPharmaSP_Second (Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_AsinoPharmaSP_Second(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inGoodsId             Integer   , -- ������� �����
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    -- ��������� ����� ����� ����� ��� ����
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Second()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.ParentId = inParentId
                AND MovementItem.Id <> COALESCE (ioId, 0)
                AND MovementItem.ObjectId = inGoodsId) 
    THEN
      RAISE EXCEPTION '������.����� <%> ��� ����������� � �������� .', lfGet_Object_ValueData (inGoodsId);
    END IF;  
    
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Second(), inGoodsId, inMovementId, inAmount, inParentId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.03.23                                                       *
*/

-- select * from gpInsertUpdate_MovementItem_AsinoPharmaSP_Second(ioId := 0 , inMovementId := 31198092 , inParentId := 579203891 , inGoodsId := 1005720 , inAmount := 1 ,  inSession := '3');