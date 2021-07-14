-- Function: gpInsertUpdate_Movement_Check_CheckCombine()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_CheckCombine(Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_CheckCombine(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementAddId       Integer   , -- ���� ������� <��������>
    IN inisCheckCombine      Boolean   , -- �� ��� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;
  
  IF COALESCE(inisCheckCombine, FALSE) <>TRUE
  THEN
    RETURN;
  END IF;
  

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 23.01.20                                                                    *
*/

-- ����

select * from gpInsertUpdate_Movement_Check_CheckCombine(inMovementId := 24038406 , inMovementAddId := 24038407 , inisCheckCombine := 'True' ,  inSession := '3');