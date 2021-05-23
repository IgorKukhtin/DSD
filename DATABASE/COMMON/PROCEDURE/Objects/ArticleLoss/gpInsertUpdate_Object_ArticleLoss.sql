-- Function: gpInsertUpdate_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ArticleLoss(
 INOUT ioId                       Integer   ,     -- ���� ������� <������ ��������>
    IN inCode                     Integer   ,     -- ��� �������
    IN inName                     TVarChar  ,     -- �������� �������
    IN inComment                  TVarChar  ,     -- ����������    
    IN inInfoMoneyId              Integer   ,     -- ������ ����������
    IN inProfitLossDirectionId    Integer   ,     -- ��������� ������ ������ � �������� � ������� - �����������
    IN inBusinessId               Integer   ,     -- ������
    IN inBranchId                 Integer   ,     -- ������
    IN inSession                  TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ArticleLoss());


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ArticleLoss());

   -- �������� ������������ ��� �������� <������������> + <�������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ArticleLoss(), inName);

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ArticleLoss(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ArticleLoss(), vbCode_calc, inName);

   -- ��������� ����� � <������ ����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_InfoMoney(), ioId, inInfoMoneyId);
   -- ��������� ����� � <�����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_ProfitLossDirection(), ioId, inProfitLossDirectionId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Business(), ioId, inBusinessId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Branch(), ioId, inBranchId);
   -- ��������� c�������� � <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ArticleLoss_Comment(), ioId, inComment);
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 16.11.20         * inBranchId
 27.07.17         * add inBusinessId
 05.07.17         * add inComment
 01.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ArticleLoss(ioId:=null, inCode:=null, inName:='������ 1', inComment:= '', inInfoMoneyId:=0, inProfitLossDirectionId:=0, inBusinessId:=0, inSession:= zfCalc_UserAdmin())
