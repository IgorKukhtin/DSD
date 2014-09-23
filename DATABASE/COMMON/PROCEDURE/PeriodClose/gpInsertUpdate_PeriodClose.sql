-- Function: gpInsertUpdate_PeriodClose (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_PeriodClose(
 INOUT ioId	        Integer   ,     -- ���� ������� ����� 
    IN inUserId         Integer   ,     -- ������������
    IN inRoleId         Integer   ,     -- ����
    IN inUnitId         Integer   ,     -- �������������
    IN inPeriod         Integer   ,     -- ���
    IN inCloseDate      TDateTime ,     -- �������� ������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInterval Interval;
   DECLARE vbAccessKeyId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��� ������  - ��� �����
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
   THEN vbAccessKeyId:= 0;
   ELSE vbAccessKeyId:= (SELECT AccessKeyId_PeriodClose FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PeriodClose <> 0 AND UserId = vbUserId GROUP BY AccessKeyId_PeriodClose);
   END IF;

   IF vbAccessKeyId <> 0 AND COALESCE (ioId, 0) <> 3
   THEN
       RAISE EXCEPTION '������.��� ����.';
   END IF;


   inCloseDate:= DATE_TRUNC ('DAY', inCloseDate);

   IF inUserId = 0 THEN
      inUserId := NULL;
   END IF;

   vbInterval := (to_char(inPeriod, '999')||' day')::interval;
   IF inRoleId = 0 THEN
      inRoleId := NULL;
   END IF;
   IF inUnitId = 0 THEN
      inUnitId := NULL;
   END IF;

   IF COALESCE (ioId, 0) = 0 THEN
      -- �������� ����� ������� ����������� � ������� �������� <���� �������>
      INSERT INTO PeriodClose (UserId, RoleId, UnitId, Period, CloseDate)
                  VALUES (inUserId, inRoleId, inUnitId, vbInterval, inCloseDate) RETURNING Id INTO ioId;
   ELSE
       -- �������� ������� ����������� �� �������� <���� �������>
       UPDATE PeriodClose SET UserId = inUserId, RoleId = inRoleId, UnitId = inUnitId, Period = vbInterval, CloseDate = inCloseDate
              WHERE Id = ioId;
       -- ���� ����� ������� �� ��� ������
       IF NOT FOUND THEN
          -- �������� ����� ������� ����������� �� ��������� <���� �������>
          INSERT INTO PeriodClose (Id, UserId, RoleId, UnitId, Period, CloseDate)
               VALUES (ioId, inUserId, inRoleId, inUnitId, vbInterval, inCloseDate) RETURNING Id INTO ioId;
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_PeriodClose (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.14                                        *
 23.09.13                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_UserRole()
