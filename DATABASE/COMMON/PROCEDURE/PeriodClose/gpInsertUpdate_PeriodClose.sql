-- Function: gpInsertUpdate_PeriodClose (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_PeriodClose(
 INOUT ioId	        Integer   ,     -- ���� �������
    IN inCode           Integer   ,     -- ����
    IN inName           TVarChar  ,     -- ��������
    IN inRoleId         Integer   ,     -- ����
    IN inRoleCode       Integer   ,     -- ����
    IN inUserId_excl    Integer   ,     -- ������������ - ����������
    IN inUserCode_excl  Integer   ,     -- ������������ - ����������
    IN inDescId         Integer   ,     -- ��� ���������
    IN inDescId_excl    Integer   ,     -- ��� ��������� - ����������
    IN inBranchId       Integer   ,     -- 
    IN inBranchCode     Integer   ,     -- 
    IN inPaidKindId     Integer   ,     -- 
    IN inPaidKindCode   Integer   ,     -- 
    IN inPeriod         Integer   ,     -- ���
    IN inCloseDate      TDateTime ,     -- �������� ������
    IN inCloseDate_excl TDateTime ,     -- �������� ������ - ����������
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


   -- ��������
   IF inDescId > 0 AND NOT EXISTS (SELECT 1 FROM lpSelect_PeriodClose_Desc (inUserId:= vbUserId) AS tmp WHERE tmp.DescId = inDescId)
   THEN
       RAISE EXCEPTION '������.��� ��������� �� ������.';
   END IF;
   -- ��������
   IF inDescId_excl > 0 AND NOT EXISTS (SELECT 1 FROM lpSelect_PeriodClose_Desc (inUserId:= vbUserId) AS tmp WHERE tmp.DescId = inDescId_excl)
   THEN
       RAISE EXCEPTION '������.��� ��������� - ���������� �� ������.';
   END IF;


   -- ������
   IF (inRoleCode      = 0) OR (inRoleId      = 0) THEN inRoleId     := NULL; END IF;
   IF (inUserCode_excl = 0) OR (inUserId_excl = 0) THEN inUserId_excl:= NULL; END IF;
   IF (inBranchCode    = 0) OR (inBranchId    = 0) THEN inBranchId   := NULL; END IF;
   IF (inPaidKindCode  = 0) OR (inPaidKindId  = 0) THEN inPaidKindId := NULL; END IF;


   -- ��� ������  - ��� �����
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
   THEN vbAccessKeyId:= 0;
   ELSE vbAccessKeyId:= (SELECT AccessKeyId_PeriodClose FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PeriodClose <> 0 AND UserId = vbUserId GROUP BY AccessKeyId_PeriodClose);
   END IF;

   IF vbAccessKeyId <> 0 AND COALESCE (ioId, 0) <> 3
   THEN
       RAISE EXCEPTION '������.��� ����.';
   END IF;


   -- ���������� �����
   inCloseDate:= DATE_TRUNC ('DAY', inCloseDate);
   -- ������������� � ������
   vbInterval := (TO_CHAR (inPeriod, '999') || ' DAY') :: INTERVAL;


   IF COALESCE (ioId, 0) = 0 THEN
      -- �������� ����� ������� ����������� � ������� �������� <���� �������>
      INSERT INTO PeriodClose (OperDate, UserId, RoleId, Period, CloseDate, Code, Name, DescId, DescId_excl, BranchId, PaidKindId, UserId_excl, CloseDate_excl)
                  VALUES (CURRENT_TIMESTAMP, vbUserId, inRoleId, vbInterval, inCloseDate, inCode, inName, inDescId, inDescId_excl, inBranchId, inPaidKindId, inUserId_excl, inCloseDate_excl) RETURNING Id INTO ioId;
   ELSE
       -- �������� ������� ����������� �� �������� <���� �������>
       UPDATE PeriodClose SET OperDate = CURRENT_TIMESTAMP, UserId = vbUserId, RoleId = inRoleId, Period = vbInterval, CloseDate = inCloseDate
            , Code           = inCode
            , Name           = inName
            , DescId         = inDescId
            , DescId_excl    = inDescId_excl
            , BranchId       = inBranchId
            , PaidKindId     = inPaidKindId
            , UserId_excl    = inUserId_excl
            , CloseDate_excl = inCloseDate_excl
       WHERE Id = ioId;
       -- ���� ����� ������� �� ��� ������
       IF NOT FOUND THEN
          -- �������� ����� ������� ����������� �� ��������� <���� �������>
          INSERT INTO PeriodClose (OperDate, UserId, RoleId, Period, CloseDate, Code, Name, DescId, DescId_excl, BranchId, PaidKindId, UserId_excl, CloseDate_excl)
                  VALUES (CURRENT_TIMESTAMP, vbUserId, inRoleId, vbInterval, inCloseDate, inCode, inName, inDescId, inDescId_excl, inBranchId, inPaidKindId, inUserId_excl, inCloseDate_excl)
                  RETURNING Id INTO ioId;
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.04.16                                        *
 25.05.14                                        *
 23.09.13                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_UserRole()
