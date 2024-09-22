-- Function: gpUpdate_MI_Message_PromoTradeStateKind()

DROP FUNCTION IF EXISTS gpUpdate_MI_Message_PromoTradeStateKind (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Message_PromoTradeStateKind(
 INOUT ioId                      Integer   , --
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inPromoTradeStateKindId   Integer   , -- ���������
    IN inComment                 TVarChar  ,
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());
     
     
     IF inPromoTradeStateKindId = -1
     THEN
         -- !!!������ �������!!!
         PERFORM lpSetErased_MovementItem (inMovementItemId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Sign() AND MovementItem.Amount = (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId) AND MovementItem.isErased = FALSE)
                                         , inUserId        := vbUserId
                                          );
         -- �������
         PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId
                                         , inUserId        := vbUserId
                                          );

     ELSE
          -- �������� ���������
          ioId:= gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := ioId
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := inPromoTradeStateKindId
                                                              , inIsQuickly             := TRUE
                                                              , inComment               := inComment
                                                              , inSession               := inSession
                                                               );
     END IF;

     --
     -- RAISE EXCEPTION '������.OK';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 27.06.20                                       *
*/

-- ����
--