-- Function: gpInsertUpdate_MovementItem_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_CompetitorMarkups(Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_CompetitorMarkups(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsID             Integer   , -- �����
    IN inCompetitorId        Integer   , -- ���������
    IN inValue               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT MovementItem.Id 
                FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = inGoodsID)
      THEN
        SELECT MovementItem.Id 
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = inGoodsID;
      END IF;
    END IF;

    -- ���������
    IF COALESCE (ioId, 0) = 0
    THEN
    
        ioId := lpInsertUpdate_MovementItem_CompetitorMarkups (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                                             , inMovementId          := inMovementId          -- ���� ���������
                                                             , inGoodsID             := inGoodsID             -- �����
                                                             , inUserId              := vbUserId              -- ������������
                                                               );
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                        *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_CompetitorMarkups(ioId := 0 , inMovementId := 27717912 , inGoodsID := 18922 , inCompetitorId := 0 , inValue := 0 ,  inSession := '3');