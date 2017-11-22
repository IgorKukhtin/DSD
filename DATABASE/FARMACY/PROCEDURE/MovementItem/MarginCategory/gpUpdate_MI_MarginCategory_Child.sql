-- Function: gpInsertUpdate_MovementItem_MarginCategory_child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Child (Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Child(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inAmountDiff          TFloat    , -- %
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Amount(), inId, inAmountDiff); 

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 21.11.17         *
*/

-- ����