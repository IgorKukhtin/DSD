-- Function: gpInsertUpdate_MI_Over_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inUnitId              Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --  
    IN inSession             TVarChar    -- ������ ������������

)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());

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
                                      , inComment          :=  inComment
                                      , inUserId           := vbUserId
                                      );
   
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