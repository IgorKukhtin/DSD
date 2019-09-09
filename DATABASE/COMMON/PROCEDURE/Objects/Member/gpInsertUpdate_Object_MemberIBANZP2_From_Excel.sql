-- Function: gpInsertUpdate_Object_MemberIBANZP2_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIBANZP2_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIBANZP2_From_Excel(
    IN inINN                 TVarChar  ,    -- ��� ���
    IN inCardSecond          TVarChar  ,    -- � ���������� ����� �� �2
    IN inCardIBANSecond      TVarChar  ,    -- � ���������� ����� IBAN �� �2
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


   -- ������� ���� �� ���, ���� �� ����� ��� ������ - ���� �� � ����� � ���� �� ����� ��� �� ���� ������ - �������� ������, ���� ����� - ������ ����� ��-��
   IF COALESCE (inINN, '') <> ''
   THEN
   -- �������� ����� ���. ���� �� ���
   vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                  FROM ObjectString
                  WHERE ObjectString.DescId = zc_ObjectString_Member_INN()
                    AND TRIM (ObjectString.ValueData) = TRIM (inINN)
                  );
   END IF;

   IF COALESCE (inCardSecond, '') <> ''
   THEN
       -- �������� ����� ���. ���� �� inCard
       vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                      FROM ObjectString
                      WHERE ObjectString.DescId = zc_ObjectString_Member_CardSecond()
                        AND TRIM (ObjectString.ValueData) = TRIM (inCardSecond)
                      );
   END IF;

   -- ���� �� ����� ��� ���� , ����� ������
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
       RAISE EXCEPTION '������.<%>, ��� ��� <%> ��� ����� ����� <%> �� �������.', inName, TRIM (inINN), TRIM (inCardSecond);
   ELSE
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecond(), vbMemberId, inCardIBANSecond);

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (vbMemberId, vbUserId);
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.09.19         *
*/
