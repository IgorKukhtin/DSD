--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoneyDetail_Load (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyDetail_Load(
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
  DECLARE vbInfoMoneyDetailId      Integer;
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
       vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyDetail() AND Object.ObjectCode = inCode);

       -- E��� �� ����� ����������
       --IF COALESCE (vbInfoMoneyDetailId,0) = 0
       --THEN
           -- ���������� ������
           vbInfoMoneyDetailId := gpInsertUpdate_Object_InfoMoneyDetail (ioId               := COALESCE (vbInfoMoneyDetailId,0)
                                                                         , inCode             := inCode ::Integer
                                                                         , inName             := TRIM (inName) ::TVarChar
                                                                         , inInfoMoneyKindId  := CASE WHEN TRIM (inInfoMoneyKindName) = '������' THEN zc_Enum_InfoMoney_In()
                                                                                                      WHEN TRIM (inInfoMoneyKindName) = '������' THEN zc_Enum_InfoMoney_Out()
                                                                                                      ELSE NULL
                                                                                                 END :: Integer       --
                                                                         , inSession          := vbUserProtocolId :: TVarChar
                                                                         );

           -- ��������� �������� <>
           PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_InfoMoneyDetail_UserAll(), vbInfoMoneyDetailId, CASE WHEN TRIM (inisUserAll) = '��' THEN TRUE ELSE FALSE END);

           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbInfoMoneyDetailId, inProtocolDate ::TDateTime);
           -- ��������� �������� <������������ (��������)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbInfoMoneyDetailId, vbUserProtocolId);

           --���� ������ ��
           IF inisErased = 1
           THEN
                PERFORM lpUpdate_Object_isErased (vbInfoMoneyDetailId, TRUE, vbUserProtocolId);
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