-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategoryLink (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategoryLink(
    IN inId               Integer,       -- ���� ������� <���� ���� ������>
    IN inMarginCategoryId Integer, 
    IN inUnitId           Integer, 
    IN inJuridicalId      Integer, 
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE(Id INTEGER) AS
$BODY$
   DECLARE UserId Integer;
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   IF COALESCE(inMarginCategoryId, 0) = 0 THEN
      RAISE EXCEPTION '���������� ���������� ��������� �������';
   END IF;

   IF COALESCE(inJuridicalId, 0) = 0 THEN
      RAISE EXCEPTION '���������� ���������� ��������';
   END IF;

   IF COALESCE(inId, 0) = 0 THEN
      -- ��������� <������>
      inId := lpInsertUpdate_Object (0, zc_Object_MarginCategoryLink(), 0, '');
   END IF;

   -- ��������� ����� � <���������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryLink_MarginCategory(), inId, inMarginCategoryId);
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryLink_Unit(), inId, inUnitId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryLink_Juridical(), inId, inJuridicalId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, UserId);

   RETURN 
      QUERY SELECT inId AS Id;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MarginCategoryLink (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.15                          *

*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'��','2'); ROLLBACK
