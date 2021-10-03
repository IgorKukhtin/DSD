-- Function: gpUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_Child (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_Child(
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);

     -- ��������� ��������� zc_MI_Child - �� ��������� ����
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId         := COALESCE (tmp.Id) :: Integer
                                                    , inParentId   := inParentId
                                                    , inMovementId := inMovementId
                                                    , inObjectId   := tmp.ObjectId
                                                    , inAmount     := COALESCE (tmp.Value,0) :: TFloat
                                                    , inUserId     := vbUserId
                                                    )
     FROM gpSelect_MI_ProductionUnion_Child (inMovementId, TRUE, FALSE, inSession) AS tmp
     WHERE tmp.ParentId = inParentId;
         
     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE
     ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.07.21         *
*/

-- ����
--