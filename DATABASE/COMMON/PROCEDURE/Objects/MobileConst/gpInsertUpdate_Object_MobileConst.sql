-- Function: gpInsertUpdate_ObjObjectect_MobileConst

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileConst (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileConst (
 INOUT ioId                Integer  ,
    IN inType              TVarChar , -- ��� ��������. "Public" ��� "Private"
    IN inMobileVersion     TVarChar , -- ������ ���������� ����������. ������: "1.0.3.625"
    IN inMobileAPKFileName TVarChar , -- �������� ".apk" ����� ���������� ����������
    IN inOperDateDiff      Integer  , -- �� ������� ���� ����� ��������� ��� ������� � ������ �����
    IN inReturnDayCount    Integer  , -- ������� ���� ����������� �������� �� ������ �����
    IN inCriticalOverDays  Integer  , -- ���������� ���� ���������, ����� �������� ������������ ������ ����������
    IN inCriticalDebtSum   TFloat   , -- ����� �����, ����� �������� ������������ ������ ����������
    IN inUserId            Integer  , -- ����� �������� ��� ���������� ���������� � �������������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      IF inType NOT IN (zc_Enum_MobileConst_Public(), zc_Enum_MobileConst_Private())
      THEN
           RAISE EXCEPTION '�������� ��� �������� ��� ���������� ����������: %', COALESCE (inType, 'NULL');
      END IF;

      IF COALESCE (inUserId, 0) <> 0 AND NOT EXISTS (SELECT 1 FROM Object AS Object_User WHERE Object_User.Id = inUserId AND Object_User.DescId = zc_Object_User())
      THEN
           RAISE EXCEPTION '�������������� �� ������������: %', inUserId;
      END IF;

      IF COALESCE (inUserId, 0) = 0 AND inType = zc_Enum_MobileConst_Private() 
      THEN 
           RAISE EXCEPTION '��� ������� �������� ���������� ������ ������������';
      END IF;

      vbCode:= CASE inType 
                    WHEN zc_Enum_MobileConst_Public() THEN 0::Integer 
                    WHEN zc_Enum_MobileConst_Private() THEN inUserId
               END; 

      ioId:= NULL; 

      SELECT Object_MobileConst.Id
      INTO ioId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = vbCode
        AND Object_MobileConst.ValueData = inType;

      IF ioId IS NULL
      THEN 
           -- ��������� <������>
           ioId:= lpInsertUpdate_Object (ioId, zc_Object_MobileConst(), vbCode, inType);
      END IF;

      IF inType = zc_Enum_MobileConst_Public()
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

      IF inType = zc_Enum_MobileConst_Private()
      THEN
           -- ��������� ����� � <����� �������� ��� ���������� ���������� � �������������>
           PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileConst_User(), ioId, inUserId);
      END IF;

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
                                               , inType:= zc_Enum_MobileConst_Public()
                                               , inMobileVersion:= '1.26.0'::TVarChar
                                               , inMobileAPKFileName:= 'ProjectMobile.apk'::TVarChar
                                               , inOperDateDiff:= 0::Integer
                                               , inReturnDayCount:= 14::Integer
                                               , inCriticalOverDays:= 21::Integer
                                               , inCriticalDebtSum:= 1::TFloat
                                               , inUserId:= 0::Integer
                                               , inSession:= zfCalc_UserAdmin()
                                                ); 

SELECT * FROM gpInsertUpdate_Object_MobileConst (ioId:= 0::Integer
                                               , inType:= zc_Enum_MobileConst_Private()
                                               , inMobileVersion:= '1.26.0'::TVarChar
                                               , inMobileAPKFileName:= 'ProjectMobile.apk'::TVarChar
                                               , inOperDateDiff:= 1::Integer
                                               , inReturnDayCount:= 14::Integer
                                               , inCriticalOverDays:= 21::Integer
                                               , inCriticalDebtSum:= 25::TFloat
                                               , inUserId:= lpGetUserBySession (zfCalc_UserAdmin())
                                               , inSession:= zfCalc_UserAdmin()
                                                ); 
*/
