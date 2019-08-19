-- Function: gpInsertUpdate_Object_MemberZP1_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberZP1_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberZP1_From_Excel(
    IN inBankId              Integer   ,    --
    IN inINN                 TVarChar  ,    -- ��� ���
    IN inCard                TVarChar  ,    -- � ���������� ����� ��
    IN inName                TVarChar  ,    -- �������� ������� <
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
   -- ���� �� ����� ������� ������
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
       RAISE EXCEPTION '������. ��� ��� <%> �� ������ <%>.', TRIM (inINN), inName;
   ELSE
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Card(), vbMemberId, inCard);
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Bank(), vbMemberId, inBankId);
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
