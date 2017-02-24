-- Function: gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                       Integer   ,    -- ���� ������� <��c�������> 
    IN inCode                     Integer   ,    -- ��� ������� <��c�������>
    IN inName                     TVarChar  ,    -- �������� ������� <��c�������>
    IN inUnitId                   Integer   ,    -- ���� ������� <�������������> 
    IN inValutaId                 Integer   ,    -- ���� ������� <������> 
    IN inBrandId                  Integer   ,    -- ���� ������� <�������� �����> 
    IN inFabrikaId                Integer   ,    -- ���� ������� <������� �������������> 
    IN inPeriodId                 Integer   ,    -- ���� ������� <������> 
    IN inPeriod                   TFloat    ,    -- ������
    IN inKindAccount              TFloat    ,    -- ��� �����
    IN inPeriodYear               TFloat    ,    -- ��� �������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_Partner()); 
   
   -- �������� ���� ������������ ��� �������� <������������ >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);

   -- �������� ������������ <������������> ��� !!!�����!! <�������������>
   IF TRIM (inName) <> '' AND COALESCE (inUnitId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_Partner_Unit
                                       ON ObjectLink_Partner_Unit.ObjectId = Object.Id
                                      AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
                                      AND ObjectLink_Partner_Unit.ChildObjectId = inUnitId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION '������. ������ ������������� <%> ��� ����������� � <%>.', TRIM (inName), lfGet_Object_ValueData (inUnitId);
       END IF;
   END IF;


   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), vbCode_max, inName);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Unit(), ioId, inUnitId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Valuta(), ioId, inValutaId);
   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Brand(), ioId, inBrandId);
   -- ��������� ����� � <������� �������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Fabrika(), ioId, inFabrikaId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Period(), ioId, inPeriodId);

   -- ��������� <������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectLink_Partner_Period(), ioId, inPeriod);
   -- ��������� <��� �����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_KindAccount(), ioId, inKindAccount);
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
20.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner()
