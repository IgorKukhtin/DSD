-- Function: gpUpdate_Object_Partner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_GLN (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_GLN(
 INOUT ioId                  Integer  ,    -- ���� ������� <����������> 
    IN inGLNCode             TVarChar ,    -- ��� GLN
    IN inGLNCodeJuridical    TVarChar ,    -- ��� GLN - ����������
    IN inGLNCodeRetail       TVarChar ,    -- ��� GLN - ����������
    IN inGLNCodeCorporate    TVarChar ,    -- ��� GLN - ���������
   OUT outGLNCodeJuridical   TVarChar ,    -- ��� GLN - ����������
   OUT outGLNCodeRetail      TVarChar ,    -- ��� GLN - ����������
   OUT outGLNCodeCorporate   TVarChar ,    -- ��� GLN - ���������
    IN inSession             TVarChar      -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_GLN());

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeJuridical(), ioId, inGLNCodeJuridical);
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeRetail(), ioId, inGLNCodeRetail);   
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeCorporate(), ioId, inGLNCodeCorporate);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


    SELECT CASE WHEN ObjectString_GLNCodeJuridical.ValueData <> '' THEN ObjectString_GLNCodeJuridical.ValueData WHEN ObjectString_GLNCode.ValueData <> '' THEN ObjectString_Juridical_GLNCode.ValueData ELSE '' END :: TVarChar AS GLNCodeJuridical
         , CASE WHEN ObjectString_GLNCodeRetail.ValueData <> '' THEN ObjectString_GLNCodeRetail.ValueData WHEN ObjectString_GLNCode.ValueData <> '' THEN CASE WHEN ObjectString_Retail_GLNCode.ValueData <> '' THEN ObjectString_Retail_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END ELSE '' END :: TVarChar AS GLNCodeRetail
         , CASE WHEN ObjectString_GLNCodeCorporate.ValueData <> '' THEN ObjectString_GLNCodeCorporate.ValueData WHEN ObjectString_Retail_GLNCodeCorporate.ValueData <> '' THEN vbGLNCodeCorporate ELSE '' END :: TVarChar AS GLNCodeCorporate
           INTO outGLNCodeJuridical, outGLNCodeRetail, outGLNCodeCorporate
        
         
     FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectString AS ObjectString_GLNCodeJuridical
                                ON ObjectString_GLNCodeJuridical.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeRetail
                                ON ObjectString_GLNCodeRetail.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeCorporate
                                ON ObjectString_GLNCodeCorporate.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()                                                                  

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                ON ObjectString_Juridical_GLNCode.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                               AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

    WHERE Object_Partner.Id = ioId
   ;

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.03.15         *

*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_GLN()
