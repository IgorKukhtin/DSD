-- Function: gpUpdate_Object_ReportCollation(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Buh (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation(
    IN inBarCode             TVarChar  , -- �������� ��������� ������� 
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId Integer;
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());

     -- ������ � ���� ������ - ������ �� ������, �.�. �� ������ ���������� "������" ���
     IF COALESCE (TRIM (inBarCode), '') = ''
     THEN
         RETURN; -- !!!�����!!!
     END IF;

     -- ������������ <���������� ����> - ��� ����������� ���� inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- ��������
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION '������.� ������������ <%> �� ��������� �������� <���.����>.', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- �� ����� ���� ��� ������
     vbId:= (SELECT Object.Id
             FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS Id) AS tmp
                 INNER JOIN Object ON Object.Id = tmp.Id
                                  AND Object.DescId = zc_Object_ReportCollation()
                                  AND Object.isErased = False
             WHERE CHAR_LENGTH (inBarCode) >= 13
            UNION
             SELECT Object.Id
             FROM (SELECT zfConvert_StringToNumber (inBarCode) AS BarCode ) AS tmp
                  INNER JOIN Object ON Object.ObjectCode = tmp.BarCode
                                   AND Object.DescId = zc_Object_ReportCollation()
                                   AND Object.isErased = FALSE
             WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13
             );

     -- ��������
     IF COALESCE (vbId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ � � <%> �� ������.', inBarCode;
     END IF;

                     
     -- ��������� �������� <���� ����� � �����������>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Buh(), vbId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (����� � �����������)>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Buh(), vbId, vbMemberId_user);
     -- ��������� �������� <����� � �����������>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReportCollation_Buh(), vbId, TRUE);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= FALSE);


if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin - Errr _end <%>', inBarCode;
    -- '��������� �������� ����� 3 ���.'
end if;

   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.01.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_ReportCollation(inBarCode := '201000923136' ,  inSession := '5');
