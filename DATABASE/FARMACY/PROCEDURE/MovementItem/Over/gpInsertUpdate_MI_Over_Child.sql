-- Function: gpInsertUpdate_MI_Over_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inUnitId              Integer   , -- 
    IN inAmount              TFloat    , -- ����������
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
   OUT outAmountMaster       TFloat    ,
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --  
    IN inSession             TVarChar    -- ������ ������������

)                              
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- ��������� 
   ioId := lpInsertUpdate_MI_Over_Child(ioId               := ioId
                                      , inMovementId       := inMovementId
                                      , inParentId         := inParentId                                
                                      , inUnitId           := inUnitId
                                      , inAmount           := inAmount
                                      , inRemains          := inRemains
                                      , inPrice            := inPrice
                                      , inMCS              := inMCS
                                      , inMinExpirationDate:= inMinExpirationDate
                                      , inComment          := inComment
                                      , inUserId           := vbUserId
                                      );
   
   -- ������� ��������� ���� � ������� (���-�� � �����)
   outAmountMaster:= (SELECT  Sum(MI.Amount)::TFloat FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.ParentId = inParentId AND MI.DescId = zc_MI_Child() AND MI.isErased = False);
   
   PERFORM lpInsertUpdate_MovementItem (inParentId, zc_MI_Master(), MI_Master.ObjectId, inMovementId, outAmountMaster, NULL)
   FROM MovementItem AS MI_Master 
   WHERE MI_Master.MovementId = inMovementId AND MI_Master.Id = inParentId AND MI_Master.DescId = zc_MI_Master() AND MI_Master.isErased = False
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.16         *
 */

-- ����
-- 