-- Function: gpInsertUpdate_MovementItem_MarginCategory_child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_MarginCategory_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inMarginCategoryId    Integer   , -- MarginCategory
    IN inAmount              TFloat    , -- %
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    ioId:= lpInsertUpdate_MI_MarginCategory_Child(ioId                 := COALESCE (ioId, 0) ::integer
                                                , inMovementId         := inMovementId
                                                , inParentId           := inParentId
                                                , inMarginCategoryId   := inMarginCategoryId
                                                , inAmount             := inAmount
                                                , inComment            := inComment
                                                , inUserId             := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 21.11.17         *
*/

-- ����