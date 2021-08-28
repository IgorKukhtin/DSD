-- Function: gpInsertUpdate_MovementItem_ContractGoods()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ContractGoods(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    IN inGoodsKindId            Integer   , -- ���� �������
    IN inisBonusNo              Boolean   , -- ��� ���������� �� �������
    IN inisSave                 Boolean   , -- c�������� ��/���
    IN inPrice                  TFloat    , --
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWeight TFloat;
   DECLARE vbMeasureId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());

     --�������� ���� ��� �������� � ������ ����� ����� �� �������, ���� � �� ��� �� ����������
     IF COALESCE (inisSave,FALSE) = FALSE
     THEN
         IF COALESCE (ioId,0) = 0 
         THEN 
             RETURN; 
         ELSE
             PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
             RETURN;
         END IF;
     END IF;

     --�������� ���� ����� ���������� ��������� ��������� �� �� ������� ��������
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE) AND  COALESCE (inisSave,FALSE) = TRUE
     THEN
         PERFORM lpSetUnErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_ContractGoods (ioId           := ioId
                                                      , inMovementId   := inMovementId
                                                      , inGoodsId      := inGoodsId
                                                      , inGoodsKindId  := inGoodsKindId
                                                      , inisBonusNo    := inisBonusNo
                                                      , inPrice        := inPrice
                                                      , inComment      := inComment
                                                      , inUserId       := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.07.21         *
*/

-- ����
--