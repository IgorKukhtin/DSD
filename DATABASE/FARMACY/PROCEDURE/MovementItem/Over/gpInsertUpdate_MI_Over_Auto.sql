-- Function: gpInsertUpdate_MI_Over_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Auto (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Auto(
    IN inUnitId              Integer   , -- �� ����
    IN inOperDate            TDateTime , -- ����
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inRemains	     TFloat    , -- 
    IN inPrice               TFloat    , -- ���� �� ����
    IN inMCS                 TFloat    , -- ������ ��� ������� ���
    IN inMinExpirationDate   TDateTime , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;

    IF COALESCE(inAmount, 0) <> 0 THEN
      -- ���� �� ��������� (���� - ����, �������������) 
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        Inner Join MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitId
        
      WHERE Movement.DescId = zc_Movement_Over() AND Movement.OperDate = inOperDate
          AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0 THEN
       -- ���������� ����� <��������>
       vbMovementId := lpInsertUpdate_Movement_Over (ioId               := 0
                                                   , inInvNumber        := CAST (NEXTVAL ('Movement_Over_seq') AS TVarChar) --inInvNumber
                                                   , inOperDate         := inOperDate
                                                   , inUnitId           := inUnitId
                                                   , inComment          := '������ �������������' :: TVarChar
                                                   , inUserId           := vbUserId
                                                   );
       END IF;
      
   
      -- ���� �� ������ (���� - �� ���������, �����)
      SELECT MovementItem.Id
       INTO vbMovementItemId
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId 
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = inGoodsId;

       -- ��������� ������ ���������
       vbMovementItemId := lpInsertUpdate_MI_Over_Master    (ioId                 := COALESCE(vbMovementItemId,0) ::Integer
                                                           , inMovementId         := vbMovementId
                                                           , inGoodsId            := inGoodsId
                                                           , inAmount             := inAmount
                                                           , inRemains            := inRemains
                                                           , inPrice              := inPrice
                                                           , inMCS                := inMCS
                                                           , inMinExpirationDate  := inMinExpirationDate
                                                           , inComment            := Null :: TVarChar
                                                           , inUserId             := vbUserId
                                                            );
  
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.06.16         *
*/

-- ����
--select * from gpInsertUpdate_MI_Over_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
