-- Function: gpInsertUpdate_Object_MemberPhone_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberPhone_Load (TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberPhone_Load(
    IN inINN                 TVarChar  ,    -- ��� ���
    IN inPhone               TVarChar  ,    -- � ���������� ����� ��
    IN inSurName             TVarChar  ,    -- 
    IN inName                TVarChar  ,    -- 
    IN inFName               TVarChar  ,    -- 
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- �������� ����� ���. ���� �� ���
   vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                  FROM ObjectString
                  WHERE ObjectString.DescId = zc_ObjectString_Member_INN()
                    AND TRIM (ObjectString.ValueData) = TRIM (inINN)
                  );


   -- ���� �� ����� ������
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
        -- �������� ���
        inName := TRIM (inSurName) ||' '||TRIM (inName)||' '||TRIM (inFName) :: TVarChar;
       
        RAISE EXCEPTION '������. ��� ��� <%> �� ������ <%>.', TRIM (inINN), inName;
   ELSE
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Phone(), vbMemberId, inPhone);

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (vbMemberId, vbUserId);
   END IF;

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.03.24         *
*/