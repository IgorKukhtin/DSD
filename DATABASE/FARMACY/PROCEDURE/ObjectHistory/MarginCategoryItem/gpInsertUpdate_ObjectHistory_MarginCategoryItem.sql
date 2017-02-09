-- Function: gpInsertUpdate_ObjectHistory_Price ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_MarginCategoryItem (Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_MarginCategoryItem(
 INOUT ioId                        Integer,    -- ���� ������� <������� �������>
    IN inMarginCategoryItemId      Integer,    -- 
    IN inOperDate                  TDateTime,  -- ���� ��������
    IN inPrice                     TFloat,     -- 
    IN inValue                     TFloat,     -- 
    IN inSession                   TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- ��������
   IF COALESCE (inMarginCategoryItemId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� <��������� �������>.';
   END IF;
   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_MarginCategoryItem(), inMarginCategoryItemId, inOperDate, vbUserId);
   -- ����������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_MarginCategoryItem_Price(), ioId, inPrice);
   -- % �������
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_MarginCategoryItem_Value(), ioId, inValue);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.17         *
*/
