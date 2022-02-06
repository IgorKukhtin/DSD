--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentInfoMoney_Load (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentInfoMoney_Load(
    IN inCode                Integer,       -- ��� 
    IN inName                TVarChar,      -- �������� 
    IN inInfoMoneyKindName   TVarChar,      -- �������� ����
    IN inisUserAll           TVarChar,      -- ������ ����
    IN inUserId              Integer,       -- Id ������������
    IN inisErased            Integer,       -- ������
    IN inProtocolDate        TDateTime,     -- ���� ���������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentInfoMoneyId      Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;


--RAISE EXCEPTION '������. <%>   .', vbUserProtocolId ;

   IF COALESCE (inCode,0) <> 0
   THEN
       -- ����� � ���. �������
       vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentInfoMoney() AND Object.ObjectCode = inCode);

       -- ��������� <������>
       vbCommentInfoMoneyId := lpInsertUpdate_Object(COALESCE (vbCommentInfoMoneyId,0), zc_Object_CommentInfoMoney(), inCode, inName);

       -- ���������
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommentInfoMoney_InfoMoneyKind(), vbCommentInfoMoneyId, CASE WHEN TRIM (inInfoMoneyKindName) = '������' THEN zc_Enum_InfoMoney_In()
                                                                                                                     WHEN TRIM (inInfoMoneyKindName) = '������' THEN zc_Enum_InfoMoney_Out()
                                                                                                                     ELSE NULL
                                                                                                                END :: Integer );

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, CASE WHEN TRIM (inisUserAll) = '��' THEN TRUE ELSE FALSE END);
       -- ��������� �������� <���� ��������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbCommentInfoMoneyId, inProtocolDate ::TDateTime);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbCommentInfoMoneyId, vbUserProtocolId);

       --���� ������ ��
       IF inisErased = 1
       THEN
           UPDATE Object SET isErased = TRUE WHERE Id = vbCommentInfoMoneyId;
       END IF;

       --END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.21          *
*/

-- ����
--