-- Function: gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst(
 INOUT ioId                       Integer   ,    -- ���� �������  
    IN inActualBankStatementDate  TDateTime ,    -- ����
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� ���� ������������ (������� ����� ������������ ������)
     IF NOT EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId = ioId)
        AND vbUserId <> zfCalc_UserAdmin() :: Integer
     THEN
          RAISE EXCEPTION '������.��� ���� �������� �������� <%>.', lfGet_Object_ValueData (ioId);
     END IF;

   -- ��������� <���� ...>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GlobalConst_ActualBankStatement(), ioId, inActualBankStatementDate);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.15                                        * add �������� ���� ������������ (������� ����� ������������ ������)
 07.06.15                         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Car()
