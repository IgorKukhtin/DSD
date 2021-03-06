--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney_Load(
    IN inInfoMoneyCode              Integer,       -- ��� ������
    IN inUnitCode                   Integer,       -- ��� �������������
    IN inInfoMoneyName              TVarChar,      -- �������� ������
    IN inInfoMoneyDestinationName   TVarChar,      -- �������� ����������
    IN inInfoMoneyGroupName         TVarChar,      -- �������� ������
    IN inSession                    TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUnitId           Integer;
  DECLARE vbGroupId          Integer;
  DECLARE vbGroupCode        Integer;
  DECLARE vbDestinationId    Integer;
  DECLARE vbDestinationCode  Integer;
  DECLARE vbInfoMoneyId      Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inInfoMoneyCode,0) <> 0
   THEN
       -- ����� � ���. �������
       vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.isErased = FALSE AND Object.ObjectCode = inInfoMoneyCode);
       
       -- E��� �� ����� ����������
       IF COALESCE (vbInfoMoneyId,0) = 0 OR 1=1
       THEN
       
           /*��� ����������� � ����������  ��������� 2�/4� ����
           ���� ��� ������ 21201
           InfoMoneyDestinationCode = 21200
           InfoMoneyGroupCode = 20000
           */
           --��������� ���� ��  ����������
           vbDestinationCode := (SELECT RPAD (LEFT (inInfoMoneyCode ::TVarChar, 3), 5,'0')) ::Integer;
           vbDestinationId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyDestination() AND Object.isErased = FALSE AND Object.ObjectCode = vbDestinationCode);
           IF COALESCE (vbDestinationId,0) = 0
           THEN
               --���������� ����� �������
               vbDestinationId := gpInsertUpdate_Object_InfoMoneyDestination (ioId      := 0
                                                                            , inCode    := vbDestinationCode
                                                                            , inName    := TRIM (inInfoMoneyDestinationName)
                                                                            , inSession := inSession
                                                                              );
           END IF;

           --��������� ���� ��  ������
           vbGroupCode := (SELECT RPAD (LEFT (inInfoMoneyCode ::TVarChar, 1), 5,'0')) ::Integer;
           vbGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyGroup() AND Object.isErased = FALSE AND Object.ObjectCode = vbGroupCode);
           IF COALESCE (vbGroupId,0) = 0
           THEN
               vbGroupId := gpInsertUpdate_Object_InfoMoneyGroup (ioId      := 0
                                                                , inCode    := vbGroupCode
                                                                , inName    := TRIM (inInfoMoneyGroupName)
                                                                , inSession := inSession
                                                                  );
           END IF;

           -- ���� ����� ��� ������������� ������ ��� �����
           IF COALESCE (inUnitCode, 0) <> 0
           THEN
               --
               vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.isErased = FALSE AND Object.ObjectCode = inUnitCode limit 1);
               IF COALESCE (vbUnitId,0) = 0
               THEN
                   RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������������� � ����� <%> �� �������.' :: TVarChar
                                                         , inProcedureName := 'gpInsertUpdate_Object_InfoMoney_Load' :: TVarChar
                                                         , inUserId        := vbUserId
                                                         , inParam1        := inObjectCode :: TVarChar
                                                         );
               END IF;
           END IF;

           -- ���������� ������
           PERFORM gpInsertUpdate_Object_InfoMoney (ioId                     := vbInfoMoneyId
                                                  , inCode                   := inInfoMoneyCode ::Integer
                                                  , inName                   := TRIM (inInfoMoneyName) ::TVarChar
                                                  , inInfoMoneyGroupId       := vbGroupId       ::Integer
                                                  , inInfoMoneyDestinationId := vbDestinationId ::Integer
                                                  , inUnitId                 := vbUnitId        ::Integer
                                                  , inisProfitLoss           := FALSE           ::Boolean
                                                  , inSession                := inSession
                                                    );
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