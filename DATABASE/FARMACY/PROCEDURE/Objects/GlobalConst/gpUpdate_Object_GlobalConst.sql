-- Function: gpUpdate_Object_GlobalConst()

DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst(
    IN inId                       Integer,   -- ���� �������  
    IN inSiteDiscount             TFloat,    -- 
    IN inisSiteDiscount           Boolean,   -- 
    IN inSession                  TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_GlobalConst_SiteDiscount(), inId, inisSiteDiscount);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GlobalConst_SiteDiscount(), inId, inSiteDiscount);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.01.19         *
*/

-- ����
-- 