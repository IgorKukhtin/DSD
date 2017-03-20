-- Function: gpInsertUpdateMobile_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_StoreReal (TVarChar, TVarChar, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_StoreReal(
    IN inGUID         TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inMovementGUID TVarChar  , -- ���������� ���������� ������������� ���������
    IN inGoodsId      Integer   , -- ������
    IN inAmount       TFloat    , -- ����������
    IN inGoodsKindId  Integer   , -- ���� �������
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbMovementId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_StoreReal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      -- �������� Id ������ ��������� �� GUID
      SELECT MIString_GUID.MovementItemId 
      INTO vbId 
      FROM MovementItemString AS MIString_GUID
           JOIN MovementItem AS MovementItem_StoreReal
                             ON MovementItem_StoreReal.Id = MIString_GUID.MovementItemId
                            AND MovementItem_StoreReal.DescId = zc_MI_Master()
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementItem_StoreReal.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_StoreReal()
      WHERE MIString_GUID.DescId = zc_MIString_GUID() 
        AND MIString_GUID.ValueData = inGUID;

      vbId := lpInsertUpdate_MovementItem_StoreReal (ioId:= vbId
                                                   , inMovementId:= vbMovementId
                                                   , inGoodsId:= inGoodsId
                                                   , inAmount:= inAmount
                                                   , inGoodsKindId:= inGoodsKindId
                                                   , inUserId:= vbUserId
                                                   , inGUID:= inGUID
                                                    );

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 20.03.17                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_MovementItem_StoreReal (inGUID:= '{087C62AA-E6D2-4212-8165-0899029CE817}', inMovementGUID:= '{678E6742-8182-4FF4-8882-D1DFF49D6C62}', inGoodsId:= 1, inAmount:= 3, inGoodsKindId:= 0, inSession:= zfCalc_UserAdmin())
