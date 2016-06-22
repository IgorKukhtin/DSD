-- Function: gpUpdate_Object_UnitForFarmacyCash()

DROP FUNCTION IF EXISTS gpUpdate_Object_UnitForFarmacyCash (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_UnitForFarmacyCash(
    IN inAmount     TFloat    ,    -- ������� ����� ��� �� �����������
    IN inSession    TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId := lpGetUserBySession (inSession);

    -- ����� ������
    vbUnitId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Unit', vbUserId));

    IF vbUnitId > 0
    THEN
        -- ��������� <������������ ���������� ������ � FarmacyCash >
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_UserFarmacyCash(), vbUnitId, vbUserId);
        -- ��������� <����/����� ���������� ������ � FarmacyCash>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_FarmacyCash(), vbUnitId, CURRENT_TIMESTAMP);
        -- ��������� <���-�� ������ � ������������� � FarmacyCash>
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_TaxService(), vbUnitId, inAmount);
    END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_UnitForFarmacyCash ()                            
