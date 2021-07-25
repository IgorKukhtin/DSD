-- Function: gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId           Integer,       -- ���� ������� <���������� ����>    
 INOUT ioCode         Integer,       -- ��� ������� <���������� ����>     
    IN inName         TVarChar,      -- �������� ������� ��� <���������� ����>
    IN inINN          TVarChar,      -- ���
    IN inComment      TVarChar,      -- ����������
    IN inEMail        TVarChar,      -- E-Mail
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbName TVarChar;
   DECLARE vbCode Integer;
   DECLARE vbPersonal Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_Member()); 
   
   IF COALESCE (vbIsInsert, FALSE) = FALSE
   THEN
       -- ���������� ���������, �.�. �������� ������ ���� ���������������� � �������� <����������>
       SELECT ObjectCode, ValueData INTO vbCode, vbName FROM Object WHERE Id = ioId;
   END IF;


   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Member(), inName, vbUserId); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), ioCode, inName);

   -- ��������� ���
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_INN(), ioId, inINN);
   -- ��������� ����������  
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_Comment(), ioId, inComment);
   -- ��������� E-Mail
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_EMail(), ioId, inEMail);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   
   --����� �������� ��� zc_Object_Member - ��������� ������ ValueData � ����������
   IF COALESCE (vbName,'') <> COALESCE (inName,'')
   THEN
       vbPersonal:= (SELECT ObjectLink.ObjectId
                     FROM ObjectLink
                     WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member()
                       AND ObjectLink.ChildObjectId = ioId
                       );

       IF COALESCE (vbPersonal,0) <> 0
       THEN
           -- ��������� <������>
           PERFORM lpInsertUpdate_Object (vbPersonal, zc_Object_Personal(), vbCode, inName);
       END IF;

   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
22.07.21          *
22.10.20          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Member()
