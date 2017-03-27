-- Function: gpInsertUpdate_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Visit (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Visit(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPhotoMobileId       Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Visit());
	    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_Visit (ioId                 := COALESCE(ioId,0)
                                                , inMovementId     := inMovementId
                                                , inPhotoMobileId  := inPhotoMobileId
                                                , inAmount         := inAmount
                                                , inComment        := inComment
                                                , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 26.03.17         *
*/

-- ����
-- 