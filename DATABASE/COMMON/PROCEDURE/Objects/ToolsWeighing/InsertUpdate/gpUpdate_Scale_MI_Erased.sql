-- Function: gpUpdate_Scale_MI_Erased()

-- DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_Erased (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_Erased (Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_Erased(
    IN inMovementItemId        Integer   , -- ���� ������� <������� ���������>
    IN inIsModeSorting         Boolean   , -- 
    IN inIsErased              Boolean   , -- 
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS TABLE (TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


    IF inIsModeSorting = TRUE
    THEN
        -- ������������� ����� ��������
        UPDATE wms_MI_WeighingProduction SET isErased = inIsErased, UpdateDate = CURRENT_TIMESTAMP WHERE Id = inMovementItemId;
         -- ���������
         RETURN QUERY
           SELECT 0 :: TFloat AS TotalSumm;

    ELSE
        -- ������������� ����� ��������
        IF inIsErased = TRUE
        THEN PERFORM lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
        ELSE PERFORM lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
        END IF;
    
        -- ��������� �������� <����/�����>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMovementItemId, CURRENT_TIMESTAMP);
    
         -- ���������
         RETURN QUERY
           SELECT MovementFloat.ValueData AS TotalSumm
           FROM MovementFloat
           WHERE MovementFloat.MovementId = (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
             AND MovementFloat.DescId = zc_MovementFloat_TotalSumm();
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 31.01.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MI_Erased (ioId:= 0, inIsErased:= TRUE, inSession:= '5')
