-- Function: gpInsertUpdate_Object_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                            Integer   , -- ���� ������� <����������>
    IN inMemberId                      Integer   , -- ������ �� ���.���� 
    IN inPositionId                    Integer   , -- ������ �� ���������
    IN inUnitId                        Integer   , -- ������ �� �������������
    IN inPersonalGroupId               Integer   , -- ����������� �����������
    IN inDateIn                        TDateTime , -- ���� ��������
    IN inDateOut                       TDateTime , -- ���� ����������
    IN inIsDateOut                     Boolean   , -- ������
    IN inIsMain                        Boolean   , -- �������� ����� ������
    IN inSession                       TVarChar    -- ������ ������������
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

   -- ��������  ������������ ��� �������: <���> + <�������������> + <���������> 
   IF EXISTS (SELECT PersonalName FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION '�������� <%> ��� �������������: <%> ���������: <%> �� ��������� � ����������� <%>.'
                    , vbName
                    , lfGet_Object_ValueData (inUnitId)
                    , lfGet_Object_ValueData (inPositionId)
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal());
   END IF; 


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName);

   -- ��������� ����� � <���.�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);
   -- ��������� ����� � <����������� �����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalGroup(), ioId, inPersonalGroupId);
    -- ��������� �������� <���� ��������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);

   -- ��������� �������� <���� ����������>
   IF inIsDateOut = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, zc_DateEnd());
   END IF;
   -- ��������� �������� <�������� ����� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), ioId, inIsMain);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer,TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='����� ������������', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inDateIn:=null, inDateOut:=null, inSession:='2')
