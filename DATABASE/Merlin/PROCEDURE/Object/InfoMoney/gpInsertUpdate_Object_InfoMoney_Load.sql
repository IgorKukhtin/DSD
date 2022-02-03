--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney_Load (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney_Load(
    IN inCode                Integer,       -- ��� ������
    IN inParentCode          Integer,       -- ��� ������
    IN inInfoMoneyName       TVarChar,      -- �������� ������
    IN inInfoMoneyKindName   TVarChar,      -- �������� ����
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
  DECLARE vbParentId         Integer;
  DECLARE vbInfoMoneyId      Integer;
  DECLARE vbGroupNameFull TVarChar;
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

   IF COALESCE (inParentCode,0) <> 0
   THEN
       vbParentId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inParentCode);
       
       
       IF COALESCE (vbParentId,0) = 0
       THEN
           -- ���� �� ����� ������  - ������� 
           vbParentId := gpInsertUpdate_Object_InfoMoney(ioId	            := vbParentId            :: Integer       -- ���� ������� <> 
                                                       , inCode             := inParentCode :: Integer       -- ��� ������� <> 
                                                       , inName             := (inParentCode||' ������'):: TVarChar      -- �������� ������� <>
                                                       , inisService        := FALSE:: Boolean    
                                                       , inisUserAll        := FALSE:: Boolean    
                                                       , inInfoMoneyKindId  := NULL :: Integer       --
                                                       , inParentId         := NULL    :: Integer       -- ���� ������� <�����>
                                                       , inSession          := vbUserProtocolId :: TVarChar
                                                       );
                                                        

       END IF;
   END IF;


   IF COALESCE (inCode,0) <> 0
   THEN
       -- ����� � ���. �������
       vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inCode);
       
           -- ���������� ������
           vbInfoMoneyId := lpInsertUpdate_Object (COALESCE (vbInfoMoneyId,0), zc_Object_InfoMoney(), inCode::Integer, TRIM (inInfoMoneyName) ::TVarChar);
        
           -- �������� �������� <������ �������� ������>
           vbGroupNameFull:= lfGet_Object_TreeNameFull (vbParentId :: Integer, zc_ObjectLink_InfoMoney_Parent());
        
           -- ��������� ������
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InfoMoney_GroupNameFull(), vbInfoMoneyId, vbGroupNameFull);
           -- ���������
           --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), vbInfoMoneyId, inisService);
           -- ���������
           --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), vbInfoMoneyId, inisUserAll);
           -- ���������
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_InfoMoneyKind(), vbInfoMoneyId, CASE WHEN TRIM (inInfoMoneyKindName) = '������' THEN zc_Enum_InfoMoney_In()
                                                                                                           WHEN TRIM (inInfoMoneyKindName) = '������' THEN zc_Enum_InfoMoney_Out()
                                                                                                           ELSE NULL
                                                                                                      END :: Integer);
           -- ���������
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_Parent(), vbInfoMoneyId, vbParentId    :: Integer);


           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbInfoMoneyId, inProtocolDate ::TDateTime);
           -- ��������� �������� <������������ (��������)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbInfoMoneyId, vbUserProtocolId);

           --���� ������ ��
           IF inisErased = 1
           THEN
               UPDATE Object SET isErased = TRUE WHERE Id = vbInfoMoneyId;
           END IF;

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