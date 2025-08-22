-- Function: gpUpdateMovement_TotalLines()

DROP FUNCTION IF EXISTS lpUpdateMovement_TotalLines (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdateMovement_TotalLines(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inUserId              Integer    -- ������ ������������
)
RETURNS VOID 
AS
$BODY$
    DECLARE vbTotalLines TFloat;
BEGIN

     -- ������ ���������
     vbTotalLines := (SELECT COUNT (*) AS TotalLines 
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      ) ::TFloat;

     IF COALESCE (vbTotalLines,0) > 0
     THEN
          -- ��������� ��������
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLines(), inId, vbTotalLines);
     END IF;
     
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.08.25         * 
*/


-- ����
--