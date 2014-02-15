-- Function: gpInsertUpdate_Object_Personal()

-- DROP FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer,Integer,Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                  Integer   , -- ���� ������� <����������>
    IN inMemberId            Integer   , -- ������ �� ���.���� 
    IN inPositionId          Integer   , -- ������ �� ���������
    IN inPositionLevelId     Integer   , -- ������ �� ������ ���������
    IN inUnitId              Integer   , -- ������ �� �������������
    IN inPersonalGroupId     Integer   , -- ����������� �����������
    IN inDateIn              TDateTime , -- ���� ��������
    IN inDateOut             TDateTime , -- ���� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbName TVarChar;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- ��������
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <���> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <�������������> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inPositionId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <���������> �� �������.';
   END IF;

   -- ���������� ���������, �.�. �������� ������ ���� ���������������� � �������� <���������� ����>
   SELECT ObjectCode, ValueData INTO vbCode, vbName FROM Object WHERE Id = inMemberId;   

   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT PersonalId FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0));
   -- END IF;

   -- ��������  ������������ ��� �������: <���> + <�������������> + <���������> + <������ ���������>
   IF EXISTS (SELECT PersonalName FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0) AND PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION '�������� <%> ��� �������������: <%> ���������: <%> ������ ���������: <%> �� ��������� � ����������� <%>.'
                    , vbName
                    , lfGet_Object_ValueData (inUnitId)
                    , lfGet_Object_ValueData (inPositionId)
                    , COALESCE (lfGet_Object_ValueData (inPositionLevelId), '')
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal());
   END IF; 


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName
                                , inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch())
                                                            -- ���� ��� "������������" �������������
                                                          , (SELECT zc_Enum_Process_AccessKey_TrasportDnepr() WHERE EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_Car_Unit() AND ChildObjectId = inUnitId))
                                                           )
                                 );
   -- ��������� ����� � <���.�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- ��������� ����� � <������ ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PositionLevel(), ioId, inPositionLevelId);
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);
      -- ��������� ����� � <����������� �����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalGroup(), ioId, inPersonalGroupId);
   -- ��������� �������� <���� ��������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);
   -- ��������� �������� <���� ����������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.13                                        * add inAccessKeyId ����� �� �������
 08.12.13                                        * add inAccessKeyId ����� � <���������� ����>
 21.11.13                                        * add �������� ������������ ��� �������
 21.11.13                                        * add inPositionLevelId
 09.11.13                                        * �������������� � �������� <���������� ����>
 28.10.13                                        * add RAISE...
 30.09.13                                        * del vbCode
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business              
 06.09.13                         * inName - �����. �� ����� ��� ���� ����������
 24.07.13                                        * inName - ���� !!! ��� ���� �� vbMemberName
 01.07.13          * 
 19.07.13                         * 
 19.07.13         *    rename zc_ObjectDate...
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='����� ������������', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inJuridicalId:=23966, inBusinessId:=0, inDateIn:=null, inDateOut:=null, inSession:='2')
