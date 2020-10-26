-- Function: gpInsertUpdate_Object_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer,  TDateTime, TDateTime, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId             Integer   , -- ���� ������� <����������>
    IN inMemberId       Integer   , -- ������ �� ���.����
    IN inPositionId     Integer   , -- ������ �� ���������
    IN inUnitId         Integer   , -- ������ �� �������������
    IN inDateIn         TDateTime , -- ���� ��������
    IN inDateOut        TDateTime , -- ���� ����������
    IN inIsDateOut      Boolean   , -- ������
    IN inIsMain         Boolean   , -- �������� ����� ������
    IN inComment        TVarChar  ,
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

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

   -- ��������  ������������ ��� �������: <���> + <�������������> + <���������> + <������ ���������>
   IF EXISTS (SELECT 1 
              FROM Object_Personal_View 
              WHERE PersonalName = vbName
                AND UnitId = inUnitId
                AND PositionId = COALESCE (inPositionId, 0)
              --AND PositionLevelId = COALESCE (inPositionLevelId, 0)
                AND PersonalId <> COALESCE(ioId, 0)) 
   THEN
      RAISE EXCEPTION '�������� <%> ��� �������������: <%> ���������: <%> �� ��������� � ����������� <%>.'   ---������ ���������: <%>
                    , vbName
                    , lfGet_Object_ValueData_sh (inUnitId)
                    , lfGet_Object_ValueData_sh (inPositionId)
                    --, COALESCE (lfGet_Object_ValueData_sh (inPositionLevelId), '')
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal());
   END IF;
   -- �������� ����� ������ - ������ ����
   IF inIsMain = TRUE
      AND EXISTS (SELECT 1 FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE AND View_Personal.PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION '�������� <�������� ����� ������> = ��, ��� ����������� ��� �������������: <%> ���������: <%>. ���� ������� ����� ���������� ������ 1 ���.'
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.UnitId          FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionId      FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    --, lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionLevelId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                     ;
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName);

   -- ��������� ����� � <���.�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- ��������� ����� � <������ ���������>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PositionLevel(), ioId, inPositionLevelId);
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Personal_Comment(), ioId, inComment);

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

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='����� ������������', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inJuridicalId:=23966, inBusinessId:=0, inDateIn:=null, inDateOut:=null, inSession:='2')
