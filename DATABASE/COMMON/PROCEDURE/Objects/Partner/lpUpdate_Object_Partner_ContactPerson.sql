-- Function: lpUpdate_Object_Partner_ContactPerson()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_ContactPerson (Integer
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , Integer);

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_ContactPerson (Integer
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar);


CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_ContactPerson(
    IN inId                  Integer   ,    -- ���� ������� <����������> 

    IN inOrderName           TVarChar  ,    -- ������
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- ��������
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- ����
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbContactPersonId Integer;
   DECLARE vbContactPersonKindId Integer;
BEGIN
 
  -- ���������� ���� 
  -- ������
   IF inOrderName <> '' THEN
      -- ��������
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CreateOrder();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inOrderPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inOrderMail

                                JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                               AND ObjectLink_ContactPerson_Object.ChildObjectId = inId

                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inOrderName
                           );
      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, inSession);
      END IF;
      -- ��������� � ���������
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContactPerson_Object(), ObjectLink_ContactPerson_Object.ObjectId, NULL)
      FROM ObjectLink AS ObjectLink_ContactPerson_Object
           INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = ObjectLink_ContactPerson_Object.ObjectId
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
      WHERE ObjectLink_ContactPerson_Object.ChildObjectId = inId
        AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
        AND ObjectLink_ContactPerson_Object.ObjectId <> vbContactPersonId;

   ELSE IF TRIM (inOrderPhone) <> '' OR TRIM (inOrderMail) <> ''
        THEN RAISE EXCEPTION '������. �� ��������� ������ <����� ���>';
        END IF;
   END IF;

 -- ��������
   IF inDocName <> '' THEN
      -- ��������
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CheckDocument();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inDocPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inDocMail
                                                            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                               AND ObjectLink_ContactPerson_Object.ChildObjectId = inId

                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inDocName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inDocName, inDocPhone, inDocMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, inSession);
      END IF;
      -- ��������� � ���������
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContactPerson_Object(), ObjectLink_ContactPerson_Object.ObjectId, NULL)
      FROM ObjectLink AS ObjectLink_ContactPerson_Object
           INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = ObjectLink_ContactPerson_Object.ObjectId
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
      WHERE ObjectLink_ContactPerson_Object.ChildObjectId = inId
        AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
        AND ObjectLink_ContactPerson_Object.ObjectId <> vbContactPersonId;

   ELSE IF TRIM (inDocPhone) <> '' OR TRIM (inDocMail) <> ''
        THEN RAISE EXCEPTION '������. �� ��������� ������ <�������� ���>';
        END IF;
   END IF;

   -- ���� ������
   IF inActName <> '' THEN
      -- ��������
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_AktSverki();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inActPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inActMail

                                JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                               AND ObjectLink_ContactPerson_Object.ChildObjectId = inId

                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inActName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inActName, inActPhone, inActMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, inSession);
      END IF;
      -- ��������� � ���������
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContactPerson_Object(), ObjectLink_ContactPerson_Object.ObjectId, NULL)
      FROM ObjectLink AS ObjectLink_ContactPerson_Object
           INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = ObjectLink_ContactPerson_Object.ObjectId
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
      WHERE ObjectLink_ContactPerson_Object.ChildObjectId = inId
        AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
        AND ObjectLink_ContactPerson_Object.ObjectId <> vbContactPersonId;

   ELSE IF TRIM (inDocPhone) <> '' OR TRIM (inDocMail) <> ''
        THEN RAISE EXCEPTION '������. �� ��������� ������ <��� ������ ���>';
        END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.03.15                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_Partner_ContactPerson()
