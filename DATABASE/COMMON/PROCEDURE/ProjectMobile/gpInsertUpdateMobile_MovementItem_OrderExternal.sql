-- Function: gpInsertUpdateMobile_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_OrderExternal (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_OrderExternal(
    IN inGUID                TVarChar  , -- ���������� ���������� �������������
    IN inMovementGUID        TVarChar  , -- ���������� ���������� ������������� ����� ���������
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbCountForPrice TFloat;
   DECLARE vbStatusId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT MovementString_GUID.MovementId
           , Movement_OrderExternal.StatusId
      INTO vbMovementId
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID()
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbMovementId, 0) = 0
      THEN
           RAISE EXCEPTION '������. �� �������� ����� ���������.';
      END IF;

      IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
      THEN -- ���� ������ ���������, �� �����������
           PERFORM lpUnComplete_Movement_OrderExternal (inMovementId:= vbMovementId, inUserId:= vbUserId);
      END IF;

      SELECT MovementItem.Id
      INTO vbId
      FROM MovementItem
           JOIN MovementItemString
             ON MovementItemString.MovementItemId = MovementItem.Id
            AND MovementItemString.DescId = zc_MIString_GUID()
            AND MovementItemString.ValueData = inGUID
      WHERE MovementItem.MovementId = vbMovementId;

      -- ���������
      SELECT ioId INTO vbId FROM lpInsertUpdate_MovementItem_OrderExternal (ioId            := vbId
                                                                          , inMovementId    := vbMovementId
                                                                          , inGoodsId       := inGoodsId
                                                                          , inAmount        := inAmount
                                                                          , inAmountSecond  := 0
                                                                          , inGoodsKindId   := inGoodsKindId
                                                                          , ioPrice         := inPrice
                                                                          , ioCountForPrice := vbCountForPrice
                                                                          , inUserId        := vbUserId
                                                                           );

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);

      -- ��������� �������� <����/����� ���������� � ���������� ����������>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, CURRENT_TIMESTAMP);

      RETURN vbId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 28.02.17                                                        *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_MovementItem_OrderExternal (inGUID:= '{FFA0D4A2-3278-4B3B-A477-692067AFB021}'
                                                                , inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                                , inGoodsId:= 460651
                                                                , inGoodsKindId:= 8335
                                                                , inChangePercent:= 6.0
                                                                , inAmount:= 12.0
                                                                , inPrice:= 47.07
                                                                , inSession:= zfCalc_UserAdmin()
                                                                 )
*/
