-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategoryItem (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategoryItem(
 INOUT ioId               Integer,       -- ���� ������� <��������� ��������� �������>
    IN inMarginCategoryId Integer, 
    IN inMinPrice         TFloat, 
    IN inMarginPercent    TFloat, 
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
   DECLARE vbMarginPercent TFloat;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   vbUserId := inSession;

   IF COALESCE(inMarginCategoryId, 0) = 0 THEN
      RAISE EXCEPTION '���������� ���������� ��������� �������';
   END IF;

   -- ���������� <������� ����� ��� �������������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   IF COALESCE(ioId, 0) <> 0 THEN
      vbMarginPercent := (SELECT ObjectFloat.ValueData 
                          FROM ObjectFloat 
                          WHERE ObjectFloat.ObjectId = ioId 
                            AND ObjectFloat.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()
                          );
   END IF;


   IF COALESCE(ioId, 0) = 0 
   THEN
      -- ��������� <������>
      ioId := lpInsertUpdate_Object (0, zc_Object_MarginCategoryItem(), 0, '');
   END IF;

   -- ��������� ����� � <���������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryItem_MarginCategory(), ioId, inMarginCategoryId);

   -- ��������� �������� <����������� ����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategoryItem_MinPrice(), ioId, inMinPrice);
   -- ��������� �������� <% �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategoryItem_MarginPercent(), ioId, inMarginPercent);

   -- ��������� �������
    IF ((COALESCE(inMarginPercent,0) <> 0 ) AND (inMarginPercent <> COALESCE(vbMarginPercent,0))) 
    THEN
        -- ��������� �������
        PERFORM gpInsertUpdate_ObjectHistory_MarginCategoryItem(
                ioId                    := 0 :: Integer,    -- ���� ������� <������� �������>
                inMarginCategoryItemId  := ioId,            -- 
                inPrice                 := inMinPrice,      -- ����
                inValue                 := inMarginPercent, -- % �������
                inSession  := inSession);

    END IF;


   -- ��������� ��������
   --PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MarginCategoryItem (Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.17         *
 09.04.15                          *
*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'��','2'); ROLLBACK