-- Function: gpInsert_Object_ContactPerson_byMaker  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_ContactPerson_byMaker (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_ContactPerson_byMaker(
    IN inId                       Integer   ,    -- ���� ������� < �����/��������> 
    IN inMakerId                  Integer   ,
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inPhone                    TVarChar  ,    -- 
    IN inMail                     TVarChar  ,    --
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_Object_ContactPerson());
   

   IF inId <> 0
   THEN 
       vbId := inId;
       -- RAISE EXCEPTION '������.���������� ���� ��� �������. ������� ����� ������ ����� ��������'; 
   ELSE
       -- ������ ����� ���������� ���� � ��� �����������
       vbId := (SELECT Object_ContactPerson.Id
                FROM Object AS Object_ContactPerson
                     LEFT JOIN ObjectString AS ObjectString_Phone
                                            ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                           AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                     LEFT JOIN ObjectString AS ObjectString_Mail
                                            ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                           AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                  -- AND UPPER (TRIM (Object_ContactPerson.ValueData)) = UPPER (TRIM (inName))
                  -- AND UPPER (TRIM (ObjectString_Phone.ValueData)) = UPPER (TRIM (inPhone))
                  AND UPPER (TRIM (ObjectString_Mail.ValueData)) = UPPER (TRIM (inMail))
                );
   END IF;

   IF COALESCE (vbId, 0) = 0
   THEN 
       -- ��������� <������>
       inId := lpInsertUpdate_Object (inId, zc_Object_ContactPerson(), lfGet_ObjectCode (0, zc_Object_ContactPerson()), TRIM (inName));
       
       -- ��������� ��-�� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Phone(), inId, TRIM (inPhone));
       -- ��������� ��-�� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Mail(), inId, TRIM (inMail));

       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   ELSE 
       inId := vbId; 

       -- ��������� ��-�� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ContactPerson_Mail(), inId, TRIM (inMail));
   END IF;
   
   -- ���������� � �������� zc_ObjectLink_Maker_ContactPerson
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Maker_ContactPerson(), inMakerId, inId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inMakerId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.19         *
*/

-- ����
-- 