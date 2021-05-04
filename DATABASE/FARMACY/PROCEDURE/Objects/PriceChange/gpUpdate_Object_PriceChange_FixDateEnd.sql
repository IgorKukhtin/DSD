-- Function: gpUpdate_Object_PriceChange_FixDateEnd (TVarChar)
DROP FUNCTION IF EXISTS gpUpdate_Object_PriceChange_FixDateEnd(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PriceChange_FixDateEnd(
    IN inId          Integer,       -- ID
    IN inFixEndDate  TDateTime,     -- ���� ��������� �������� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
DECLARE
    vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE(inId, 0) = 0
    THEN
      RAISE EXCEPTION '������.������ �� ���������.';
    END IF;

    -- ��������� ��-�� <���� ��������� �������� ������>
    PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_FixEndDate(), inId, inFixEndDate);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 30.04.21                                                      *
*/

-- ����
-- select * from gpUpdate_Object_PriceChange_FixDateEnd(,  inSession := '3');