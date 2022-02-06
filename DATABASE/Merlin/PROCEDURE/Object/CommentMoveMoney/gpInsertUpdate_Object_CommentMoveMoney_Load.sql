--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentMoveMoney_Load (Integer, TVarChar, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentMoveMoney_Load(
    IN inCode                Integer,       -- ��� 
    IN inName                TVarChar,      -- �������� 
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
  DECLARE vbCommentMoveMoneyId      Integer;
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
       -- ����� � ���. 
       vbCommentMoveMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentMoveMoney() AND Object.ObjectCode = inCode);

       -- E��� �� ����� ����������
       --IF COALESCE (vbCommentMoveMoneyId,0) = 0
       --THEN
           -- ���������� 
           vbCommentMoveMoneyId := lpInsertUpdate_Object(COALESCE (vbCommentMoveMoneyId,0), zc_Object_CommentMoveMoney(), inCode::Integer, TRIM (inName) ::TVarChar);
           
           -- ��������� �������� <>
           PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CommentMoveMoney_UserAll(), vbCommentMoveMoneyId, CASE WHEN TRIM (inisUserAll) = '��' THEN TRUE ELSE FALSE END);

           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbCommentMoveMoneyId, inProtocolDate ::TDateTime);
           -- ��������� �������� <������������ (��������)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbCommentMoveMoneyId, vbUserProtocolId);

           --���� ������ ��
           IF inisErased = 1
           THEN
                UPDATE Object SET isErased = TRUE WHERE Id = vbCommentMoveMoneyId;
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