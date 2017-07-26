-- Function: gpInsertUpdate_ObjObjectect_MobileConst

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileConst (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileConst (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileConst (
 INOUT ioId                Integer  ,
    IN inCode              Integer  , -- �������� 0 - ��� ����� ��������; �������� �� ������������ - ��� ������� ��������
    IN inMobileVersion     TVarChar , -- ������ ���������� ����������. ������: "1.0.3.625"
    IN inMobileAPKFileName TVarChar , -- �������� ".apk" ����� ���������� ����������
    IN inOperDateDiff      Integer  , -- �� ������� ���� ����� ��������� ��� ������� � ������ �����
    IN inReturnDayCount    Integer  , -- ������� ���� ����������� �������� �� ������ �����
    IN inCriticalOverDays  Integer  , -- ���������� ���� ���������, ����� �������� ������������ ������ ����������
    IN inCriticalDebtSum   TFloat   , -- ����� �����, ����� �������� ������������ ������ ����������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDescId Integer;
  DECLARE vbCode Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
      vbDescId:= 0;
      vbCode:= COALESCE (inCode, 0);

      IF vbCode <> 0
      THEN
           SELECT Object.DescId INTO vbDescId FROM Object WHERE Object.Id = vbCode;

           IF vbDescId NOT IN (zc_Object_User())
           THEN
                RAISE EXCEPTION '��� ������� �������� ���������� ������ ������������';
           END IF;
      END IF;

      ioId:= NULL; 

      SELECT Object_MobileConst.Id
      INTO ioId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = vbCode;

      IF ioId IS NULL
      THEN 
           -- ��������� <������>
           ioId:= lpInsertUpdate_Object (ioId, zc_Object_MobileConst(), vbCode, '');
      END IF;

      IF vbCode = 0
      THEN
           IF inMobileVersion IS NOT NULL 
           THEN 
                -- ��������� ��-�� <������ ���������� ����������>
                PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MobileConst_MobileVersion(), ioId, inMobileVersion);
           END IF;

           IF inMobileAPKFileName IS NOT NULL 
           THEN 
                -- ��������� ��-�� <�������� ".apk" ����� ���������� ����������>
                PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MobileConst_MobileAPKFileName(), ioId, inMobileAPKFileName);
           END IF;
      END IF;

      -- ��������� ��-�� <�� ������� ���� ����� ��������� ��� ������� � ������ �����>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_OperDateDiff(), ioId, inOperDateDiff::TFloat);
      -- ��������� ��-�� <������� ���� ����������� �������� �� ������ �����>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_ReturnDayCount(), ioId, inReturnDayCount::TFloat);
      -- ��������� ��-�� <���������� ���� ���������, ����� �������� ������������ ������ ����������>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_CriticalOverDays(), ioId, inCriticalOverDays::TFloat);
      -- ��������� ��-�� <����� �����, ����� �������� ������������ ������ ����������>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_CriticalDebtSum(), ioId, inCriticalDebtSum);

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 19.07.17                                                       *
*/

-- ����
/*
SELECT * FROM gpInsertUpdate_Object_MobileConst (ioId:= 0::Integer
                                               , inCode:= 0
                                               , inMobileVersion:= '1.27.0'::TVarChar
                                               , inMobileAPKFileName:= 'ProjectMobile.apk'::TVarChar
                                               , inOperDateDiff:= 0::Integer
                                               , inReturnDayCount:= 14::Integer
                                               , inCriticalOverDays:= 21::Integer
                                               , inCriticalDebtSum:= 1::TFloat
                                               , inSession:= zfCalc_UserAdmin()
                                                ); 

SELECT * FROM gpInsertUpdate_Object_MobileConst (ioId:= 0::Integer
                                               , inCode:= lpGetUserBySession (zfCalc_UserAdmin())
                                               , inMobileVersion:= '1.27.0'::TVarChar
                                               , inMobileAPKFileName:= 'ProjectMobile.apk'::TVarChar
                                               , inOperDateDiff:= 1::Integer
                                               , inReturnDayCount:= 14::Integer
                                               , inCriticalOverDays:= 21::Integer
                                               , inCriticalDebtSum:= 25::TFloat
                                               , inSession:= zfCalc_UserAdmin()
                                                ); 

DO $BODY$
BEGIN
      -- ������ ������ ������ ���. ����������
      PERFORM gpInsertUpdate_Object_MobileConst (ioId:= C.Id
                                               , inCode:= C.Code
                                               , inMobileVersion:= '1.28.0'::TVarChar
                                               , inMobileAPKFileName:= C.MobileAPKFileName
                                               , inOperDateDiff:= C.OperDateDiff
                                               , inReturnDayCount:= C.ReturnDayCount
                                               , inCriticalOverDays:= C.CriticalOverDays
                                               , inCriticalDebtSum:= C.CriticalDebtSum
                                               , inSession:= zfCalc_UserAdmin()
                                                )
      FROM lpGet_Object_MobileConst (inId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = 0 AND Object.DescId = zc_Object_MobileConst())) AS C;
END; $BODY$

*/
