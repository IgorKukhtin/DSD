-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategoryItem (Integer, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategoryItem(
    IN inId               Integer,       -- ���� ������� <���� ���� ������>
    IN inMinPrice         TFloat, 
    IN inMarginPercent    TFloat, 
    IN inMarginCategoryId Integer, 
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

   IF COALESCE(inId, 0) = 0 THEN
      -- ��������� <������>
      inId := lpInsertUpdate_Object (0, zc_Object_MarginCategoryItem(), 0, '');
   END IF;

   -- ��������� �������� <����������� ����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategoryItem_MinPrice(), inId, inMinPrice);
   -- ��������� �������� <% �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategoryItem_MarginPercent(), inId, inMarginPercent);

   -- ��������� ����� � <���������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryItem_MarginCategory(), inId, inMarginCategoryId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, UserId);

   RETURN 
      QUERY SELECT inId AS Id;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MarginCategoryItem (Integer, TFloat, TFloat, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.15                          *

*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'��','2'); ROLLBACK
