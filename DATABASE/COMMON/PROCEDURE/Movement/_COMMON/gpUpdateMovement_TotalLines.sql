-- Function: gpUpdateMovement_TotalLines()

DROP FUNCTION IF EXISTS gpUpdateMovement_TotalLines (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_TotalLines(
    IN inId                  Integer   , -- ���� ������� <��������>
   OUT outTotalLines         TFloat   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     --�� ��������� ������ ���������
     outTotalLines := (SELECT COUNT (*) AS TotalLines 
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                       ) ::TFloat;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLines(), inId, outTotalLines);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.05.25         * 
*/


-- ����
--