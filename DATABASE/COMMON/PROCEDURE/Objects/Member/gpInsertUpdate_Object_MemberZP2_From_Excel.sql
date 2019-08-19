-- Function: gpInsertUpdate_Object_MemberZP2_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberZP2_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberZP2_From_Excel(
    IN inBankId              Integer   ,    --
    IN inINN                 TVarChar  ,    -- ��� ���
    IN inCard                TVarChar  ,    -- � ���������� ����� ��
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

   -- �������� ���
   inName := TRIM (inSurName) ||' '||TRIM (inName)||' '||TRIM (inFName) :: TVarChar;

   -- ���� �� ����� ������� ������
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
        RAISE EXCEPTION '������. ��� ��� <%> �� ������ <%>.', TRIM (inINN), inName;
   ELSE
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecond(), vbMemberId, inCard);
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecond(), vbMemberId, inBankId);
      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (vbMemberId, vbUserId);
   END IF;

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.12.18         *
*/
