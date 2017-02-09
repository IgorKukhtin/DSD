-- Function: gpInsertUpdate_Object_Member_All(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member_All (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member_All(
 INOUT ioId	                 Integer   ,    -- ���� ������� <���������� ����> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <
    IN inIsOfficial          Boolean   ,    -- �������� ����������
    IN inINN                 TVarChar  ,    -- ��� ���
    IN inDriverCertificate   TVarChar  ,    -- ������������ ������������� 
    IN inCard                TVarChar  ,    -- � ���������� ����� ��
    IN inComment             TVarChar  ,    -- ���������� 
    IN inInfoMoneyId         Integer   ,    --
    IN inObjectToId          Integer   ,    --
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Member());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_calc);
   -- �������� ������������ <INN>
   IF TRIM (inINN) <> ''
   THEN
       IF EXISTS (SELECT ObjectString.ObjectId
                  FROM ObjectString
                  WHERE TRIM (ObjectString.ValueData) = TRIM (inINN)
                    AND ObjectString.ObjectId <> COALESCE (ioId, 0)
                    AND ObjectString.DescId = zc_ObjectString_Member_INN())
       THEN
           RAISE EXCEPTION '������. ��� ��� <%> ��� ���������� � <%>.', TRIM (inINN), lfGet_Object_ValueData ((SELECT ObjectString.ObjectId
                                                                                                               FROM ObjectString
                                                                                                               WHERE TRIM (ObjectString.ValueData) = TRIM (inINN)
                                                                                                                 AND ObjectString.ObjectId <> COALESCE (ioId, 0)
                                                                                                                 AND ObjectString.DescId = zc_ObjectString_Member_INN()
                                                                                                             ));
       END IF;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- ��������� �������� <�������� ����������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_INN(), ioId, inINN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificate(), ioId, inDriverCertificate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Card(), ioId, inCard);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Comment(), ioId, inComment);
   
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_InfoMoney(), ioId, inInfoMoneyId);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_ObjectTo(), ioId, inObjectToId);


   -- �������������� <���������� ����> � <����������>
   UPDATE Object SET ValueData = inName, ObjectCode = vbCode_calc
   WHERE Id IN (SELECT ObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Member() AND ChildObjectId = ioId);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.17         * 
*/

-- !!!�������������� <���������� ����> � <����������>!!!
-- UPDATE Object SET ValueData = Object2.ValueData , ObjectCode = Object2.ObjectCode from (SELECT Object.*, ObjectId FROM ObjectLink join Object on Object.Id = ObjectLink.ChildObjectId WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member()) as Object2 WHERE Object.Id  = Object2. ObjectId;
-- ����
-- SELECT * FROM gpInsertUpdate_Object_Member_All()
