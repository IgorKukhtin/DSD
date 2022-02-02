--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit_Load (Integer, Integer, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit_Load(
    IN inCode                Integer,       -- ��� 
    IN inParentCode          Integer,       -- ��� ������
    IN inUnitName            TVarChar,      -- �������� 
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
  DECLARE vbUnitId      Integer;
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
       vbParentId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inParentCode);
       
       
       IF COALESCE (vbParentId,0) = 0
       THEN
           -- ���� �� ����� ������  - ������� 
           SELECT tmp.ioId
         INTO vbParentId
           FROM gpInsertUpdate_Object_Unit(ioId	 := vbParentId   :: Integer       -- ���� ������� <> 
                                         , ioCode      := inParentCode :: Integer       -- ��� ������� <> 
                                         , inName      := (inParentCode||' ������'):: TVarChar      -- �������� ������� <>
                                         , inPhone     := NULL:: TVarChar    
                                         , inComment   := NULL:: TVarChar  
                                         , inParentId  := NULL    :: Integer       -- ���� ������� <�����>
                                         , inSession   := vbUserProtocolId :: TVarChar
                                         ) AS tmp;
       END IF;
   END IF;


   IF COALESCE (inCode,0) <> 0
   THEN
       -- ����� � ���. �������
       vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inCode);
       
       -- E��� �� ����� ����������
       --IF COALESCE (vbUnitId,0) = 0
       --THEN
           -- ���������� ������
           SELECT tmp.ioId
         INTO vbUnitId
           FROM gpInsertUpdate_Object_Unit (ioId        := COALESCE (vbUnitId,0)
                                          , ioCode      := inCode ::Integer
                                          , inName      := TRIM (inUnitName) ::TVarChar
                                          , inPhone     := NULL:: TVarChar    
                                          , inComment   := NULL:: TVarChar 
                                          , inParentId  := vbParentId    :: Integer       -- ���� ������� <�����>
                                          , inSession   := vbUserProtocolId :: TVarChar
                                          ) AS tmp;

           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbUnitId, inProtocolDate ::TDateTime);
           -- ��������� �������� <������������ (��������)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbUnitId, vbUserProtocolId);

           --���� ������ ��
           IF inisErased = 1
           THEN
                PERFORM lpUpdate_Object_isErased (vbUnitId, TRUE, vbUserProtocolId);
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