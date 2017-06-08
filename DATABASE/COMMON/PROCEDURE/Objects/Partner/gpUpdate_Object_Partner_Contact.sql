-- Function: gpUpdate_Object_Partner_Contact()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Contact (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Contact(
    IN inId                  Integer   ,    -- ���� ������� <����������> 

    IN inOrderName           TVarChar  ,    -- ������
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContactPersonId Integer;
   DECLARE vbContactPersonKindId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Contact());

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
          vbContactPersonId := lpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, vbUserId);
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


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.05.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Contact(inId := 10862 , inOrdeName := '������ �.�.' , inOrderPhone := '' , inOrderMail := '' ,  inSession := '5');
-- SELECT * FROM gpUpdate_Object_Partner_Contact(inId := 17170 , inOrdeName := '��������� ����' , inOrderPhone := '098-819-12-92' , inOrderMail := '' ,  inSession := '5');
