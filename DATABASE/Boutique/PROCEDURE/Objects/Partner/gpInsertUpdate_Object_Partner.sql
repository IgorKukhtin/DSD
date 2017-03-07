-- Function: gpInsertUpdate_Object_Partner (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                       Integer   ,    -- ���� ������� <��c�������> 
    IN inCode                     Integer,       -- ��� ������� <��c�������>  
    IN inBrandId                  Integer   ,    -- ���� ������� <�������� �����> 
    IN inFabrikaId                Integer   ,    -- ���� ������� <������� �������������> 
    IN inPeriodId                 Integer   ,    -- ���� ������� <������> 
    IN inPeriodYear               TFloat    ,    -- ��� �������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   select coalesce(vbName,'')|| coalesce(valuedata,'') into vbName from object where id = inBrandId;
   select coalesce(vbName,'')|| coalesce('-'||valuedata,'') into vbName from object where id = inPeriodId;
   select coalesce(vbName,'')|| coalesce('-'||inPeriodYear::integer::Tvarchar,'') into vbName;

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Partner_seq'); END IF; 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, vbName);

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Brand(), ioId, inBrandId);
   -- ��������� ����� � <������� �������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Fabrika(), ioId, inFabrikaId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Period(), ioId, inPeriodId);

   -- ��������� <��� �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PeriodYear(), ioId, inPeriodYear);
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
06.03.17                                                           *
27.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner()
