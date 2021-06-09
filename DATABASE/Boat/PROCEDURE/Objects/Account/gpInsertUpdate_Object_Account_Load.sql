--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Account_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account_Load(
    IN inAccountCode              Integer,       -- ��� ������
    IN inAccountName              TVarChar,      -- �������� ����
    IN inAccountDirectionName   TVarChar,      -- �������� ����������
    IN inAccountGroupName         TVarChar,      -- �������� ������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGroupId          Integer;
  DECLARE vbGroupCode        Integer;
  DECLARE vbDirectionId    Integer;
  DECLARE vbDirectionCode  Integer;
  DECLARE vbAccountId        Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inAccountCode,0) <> 0
   THEN
       -- ����� � ���. �������
       vbAccountId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Account() AND Object.isErased = FALSE AND Object.ObjectCode = inAccountCode);

       -- E��� �� ����� ����������
       IF COALESCE (vbAccountId,0) = 0 OR 1=1
       THEN

           /*��� ����������� � ����������  ��������� 2�/4� ����
           ���� ��� ������ 21201
           AccountDirectionCode = 21200
           AccountGroupCode = 20000
           */
           --��������� ���� ��  ����������
           vbDirectionCode := (SELECT RPAD (LEFT (inAccountCode ::TVarChar, 3), 5,'0')) ::Integer;
           vbDirectionId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_AccountDirection() AND Object.isErased = FALSE AND Object.ObjectCode = vbDirectionCode);
           --
           IF COALESCE (vbDirectionId,0) = 0 OR 1=1
           THEN
               -- ���������� ����� �������
               vbDirectionId := gpInsertUpdate_Object_AccountDirection (ioId      := vbDirectionId
                                                                      , inCode    := vbDirectionCode
                                                                      , inName    := TRIM (inAccountDirectionName)
                                                                      , inSession := inSession
                                                                       );
           END IF;

           --��������� ���� ��  ������
           vbGroupCode := (SELECT RPAD (LEFT (inAccountCode ::TVarChar, 1), 5,'0')) ::Integer;
           vbGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_AccountGroup() AND Object.isErased = FALSE AND Object.ObjectCode = vbGroupCode limit 1);
           --
           IF COALESCE (vbGroupId,0) = 0 OR 1=1
           THEN
               vbGroupId := gpInsertUpdate_Object_AccountGroup (ioId      := vbGroupId
                                                              , inCode    := vbGroupCode
                                                              , inName    := TRIM (inAccountGroupName)
                                                              , inSession := inSession
                                                               );
           END IF;

           -- ���������� ������
           PERFORM gpInsertUpdate_Object_Account (ioId                    := vbAccountId
                                                , inCode                  := inAccountCode
                                                , inName                  := TRIM (inAccountName)
                                                , inAccountGroupId        := vbGroupId
                                                , inAccountDirectionId    := vbDirectionId
                                                , inInfoMoneyDestinationId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE TRIM (inAccountName) AND Object.DescId = zc_Object_InfoMoneyDestination())
                                                , inInfoMoneyId           := 0
                                                , inSession               := inSession
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
 03.03.21          *
*/

-- ����
--