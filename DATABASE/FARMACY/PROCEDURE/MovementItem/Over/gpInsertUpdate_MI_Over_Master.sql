-- Function: gpInsertUpdate_MI_Over_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������
   OUT outSumma              TFloat    , -- 
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountChild TFloat;
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   vbAmountChild:= (SELECT Sum(MI.Amount)::TFloat AS Amount FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.ParentId = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = False);
        
   IF COALESCE(ioAmount,0) <> 0 AND COALESCE(ioAmount,0) <> vbAmountChild
   THEN 
   --��������
   ioAmount:= vbAmountChild;
   outSumma = (vbAmountChild * inPrice) ::TFloat;
   END IF;

   IF COALESCE(ioAmount,0) = 0  -- � ������ ��� ���-�� ����������� = 0
   THEN

       PERFORM lpInsertUpdate_MovementItem (ioId           :=  MI.Id
                                          , inDescId       := zc_MI_Child()
                                          , inObjectId     := MI.ObjectId
                                          , inMovementId   := inMovementId
                                          , inAmount       := 0
                                          , inParentId     := ioId
                                          , inUserId       := vbUserId
                                           )
       FROM MovementItem AS MI 
       WHERE MI.MovementId = inMovementId 
         AND MI.ParentId = ioId 
         AND MI.DescId = zc_MI_Child() 
         AND MI.isErased = False;

       outSumma = (vbAmountChild * inPrice) ::TFloat;
   END IF;
   
   -- ��������� <������� ���������>
   ioId :=lpInsertUpdate_MI_Over_Master (ioId               := ioId
                                       , inMovementId       := inMovementId
                                       , inGoodsId          := inGoodsId
                                       , inAmount           := ioAmount
                                       , inRemains          := inRemains
                                       , inPrice            := inPrice
                                       , inMCS              := inMCS
                                       , inMinExpirationDate := inMinExpirationDate
                                       , inComment          := inComment
                                       , inUserId           := vbUserId
                                       );
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.07.16         * 
 
*/

-- ����
-- select * from gpInsertUpdate_MI_Over_Master(ioId := 38654751 , inMovementId := 2333564 , inGoodsId := 361056 , inAmount := 67 , inRemains := 122 , inPrice := 1.7 , inMCS := 60 , inMinExpirationDate := ('01.11.2018')::TDateTime , inComment := 'ghjg' ,  inSession := '3');

