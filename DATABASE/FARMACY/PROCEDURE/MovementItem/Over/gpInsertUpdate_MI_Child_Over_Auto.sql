-- Function: gpInsertUpdate_MI_Child_Over_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Child_Over_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Child_Over_Auto(
    IN inUnitFromId          Integer   , -- �� ����
    IN inUnitToId            Integer   , -- ����
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
   DECLARE vbMovementItemChildId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;

    IF COALESCE (inAmount, 0) <> 0
    THEN
      -- ����� ��������� (���� - ����, �������������)
      vbMovementId:= (SELECT Movement.Id  
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                        AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId   = inUnitFromId
                      WHERE Movement.OperDate = inOperDate
                        AND Movement.DescId = zc_Movement_Over()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );
      -- ��������
      IF COALESCE (vbMovementId, 0) = 0 THEN
          RAISE EXCEPTION '������.�������� �� ���������.';
      END IF;

      
      -- ����� ������ Master (���� - �� ���������, �����)
      vbMovementItemId:= (SELECT MovementItem.Id
                          FROM MovementItem
                          WHERE MovementItem.MovementId = vbMovementId 
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.ObjectId   = inGoodsId
                            AND MovementItem.isErased   = FALSE
                         );
      /*-- ��������
      IF COALESCE (vbMovementItemId, 0) = 0
      THEN
          RAISE EXCEPTION '������.������ ������� �� ����������.';
      END IF;*/


     IF vbMovementItemId <> 0
     THEN
        -- ��������
        IF EXISTS (SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId AND MovementId = vbMovementId AND ObjectId = inUnitToId AND isErased = FALSE AND DescId = zc_MI_Child())
        THEN
           RAISE EXCEPTION '������.����������� "�����������" ����� <%> ��� ������ <%>', lfGet_Object_ValueData ((SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId)), lfGet_Object_ValueData (inUnitToId);
        END IF;

        -- ��������� ������ ���������
        vbMovementItemChildId := lpInsertUpdate_MI_Over_Child(ioId               := 0 --COALESCE (vbMovementItemChildId, 0)
                                                            , inMovementId       := vbMovementId
                                                            , inParentId         := vbMovementItemId                                
                                                            , inUnitId           := inUnitToId
                                                            , inAmount           := inAmount
                                                            , inRemains          := inRemains
                                                            , inPrice            := inPrice
                                                            , inMCS              := inMCS
                                                            , inMinExpirationDate:= inMinExpirationDate
                                                            , inComment          := Null :: TVarChar
                                                            , inUserId           := vbUserId
                                                            );

        -- ��������� � Master - ����� �� Child
        PERFORM lpInsertUpdate_MovementItem (ioId           := MovementItem.Id
                                           , inDescId       := MovementItem.DescId
                                           , inObjectId     := MovementItem.ObjectId
                                           , inMovementId   := MovementItem.MovementId
                                           , inAmount       := COALESCE ((SELECT SUM (Amount) FROM MovementItem WHERE MovementId = vbMovementId AND ParentId = vbMovementItemId AND isErased = FALSE AND DescId = zc_MI_Child()), 0)
                                           , inParentId     := MovementItem.ParentId
                                           , inUserId       := vbUserId
                                            )
        FROM MovementItem
        WHERE MovementItem.Id = vbMovementItemId
       ;

      
      END IF;
  
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.07.16         *
*/

-- ����
--select * from gpInsertUpdate_MI_Child_Over_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
