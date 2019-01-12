-- Function: gpInsertUpdate_Object_MakerReport (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MakerReport (Integer,Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MakerReport(
 INOUT ioId              Integer   ,    -- ���� ������� <>
    IN inMakerId         Integer   ,    -- 
    IN inJuridicalId     Integer   ,    -- 
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MakerReport());
   vbUserId := inSession; 

   -- �������� ������������
    IF EXISTS (SELECT 1 
               FROM Object AS Object_MakerReport
                    LEFT JOIN ObjectLink AS ObjectLink_Maker 
                                         ON ObjectLink_Maker.ObjectId = Object_MakerReport.Id 
                                        AND ObjectLink_Maker.DescId = zc_ObjectLink_MakerReport_Maker()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical 
                                         ON ObjectLink_Juridical.ObjectId = Object_MakerReport.Id 
                                        AND ObjectLink_Juridical.DescId = zc_ObjectLink_MakerReport_Juridical()
              WHERE Object_MakerReport.DescId = zc_Object_MakerReport()
                AND COALESCE (ObjectLink_Maker.ChildObjectId, 0) = inMakerId
                AND COALESCE (ObjectLink_Juridical.ChildObjectId, 0) = inJuridicalId
                AND Object_MakerReport.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.����� <%> - <%> �� ��������� ��� �����������' , lfGet_Object_ValueData (inMakerId), lfGet_Object_ValueData (inJuridicalId);
   END IF;  
 
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MakerReport(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MakerReport_Maker(), ioId, inMakerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MakerReport_Juridical(), ioId, inJuridicalId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.19         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MakerReport()