 -- Function: gpUpdate_Unit_SetcCash()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetRequestDistribListDiffCash (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetRequestDistribListDiffCash(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
        
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RequestDistribListDiff(), vbUnitId, True);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 28.07.21                                                      *
*/

--����
-- SELECT * FROM gpUpdate_Unit_SetRequestDistribListDiffCash (inSession:= '3')

