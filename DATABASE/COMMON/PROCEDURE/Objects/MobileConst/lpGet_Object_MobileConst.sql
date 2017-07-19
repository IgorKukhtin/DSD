-- Function: lpGet_Object_MobileConst

DROP FUNCTION IF EXISTS lpGet_Object_MobileConst (Integer);

CREATE OR REPLACE FUNCTION lpGet_Object_MobileConst (
    IN inId Integer
)
RETURNS TABLE (Id                Integer  
             , ObjectCode        Integer
             , ValueData         TVarChar 
             , MobileVersion     TVarChar  -- ������ ���������� ����������. ������: "1.0.3.625"
             , MobileAPKFileName TVarChar  -- �������� ".apk" ����� ���������� ����������
             , OperDateDiff      Integer   -- �� ������� ���� ����� ��������� ��� ������� � ������ �����
             , ReturnDayCount    Integer   -- ������� ���� ����������� �������� �� ������ �����
             , CriticalOverDays  Integer   -- ���������� ���� ���������, ����� �������� ������������ ������ ����������
             , CriticalDebtSum   TFloat    -- ����� �����, ����� �������� ������������ ������ ����������
             , UserId            Integer   -- ����� �������� ��� ���������� ���������� � �������������
             , UserName          TVarChar
              )
AS $BODY$
BEGIN
      RETURN QUERY  
        SELECT Object_MobileConst.Id
             , Object_MobileConst.ObjectCode
             , Object_MobileConst.ValueData
             , ObjectString_MobileVersion.ValueData            AS MobileVersion
             , ObjectString_MobileAPKFileName.ValueData        AS MobileAPKFileName
             , ObjectFloat_OperDateDiff.ValueData::Integer     AS OperDateDiff
             , ObjectFloat_ReturnDayCount.ValueData::Integer   AS ReturnDayCount
             , ObjectFloat_CriticalOverDays.ValueData::Integer AS CriticalOverDays
             , ObjectFloat_CriticalDebtSum.ValueData           AS CriticalDebtSum
             , ObjectLink_User.ChildObjectId                   AS UserId
             , Object_User.ValueData                           AS UserName
        FROM Object AS Object_MobileConst
             LEFT JOIN ObjectString AS ObjectString_MobileVersion 
                                    ON ObjectString_MobileVersion.ObjectId = Object_MobileConst.Id
                                   AND ObjectString_MobileVersion.DescId = zc_ObjectString_MobileConst_MobileVersion ()
             LEFT JOIN ObjectString AS ObjectString_MobileAPKFileName
                                    ON ObjectString_MobileAPKFileName.ObjectId = Object_MobileConst.Id
                                   AND ObjectString_MobileAPKFileName.DescId = zc_ObjectString_MobileConst_MobileAPKFileName ()
             LEFT JOIN ObjectFloat AS ObjectFloat_OperDateDiff
                                   ON ObjectFloat_OperDateDiff.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_OperDateDiff.DescId = zc_ObjectFloat_MobileConst_OperDateDiff() 
             LEFT JOIN ObjectFloat AS ObjectFloat_ReturnDayCount
                                   ON ObjectFloat_ReturnDayCount.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_ReturnDayCount.DescId = zc_ObjectFloat_MobileConst_ReturnDayCount() 
             LEFT JOIN ObjectFloat AS ObjectFloat_CriticalOverDays
                                   ON ObjectFloat_CriticalOverDays.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_CriticalOverDays.DescId = zc_ObjectFloat_MobileConst_CriticalOverDays()
             LEFT JOIN ObjectFloat AS ObjectFloat_CriticalDebtSum
                                   ON ObjectFloat_CriticalDebtSum.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_CriticalDebtSum.DescId = zc_ObjectFloat_MobileConst_CriticalDebtSum()
             LEFT JOIN ObjectLink AS ObjectLink_User                     
                                  ON ObjectLink_User.ObjectId = Object_MobileConst.Id
                                 AND ObjectLink_User.DescId = zc_ObjectLink_MobileConst_User()
             LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User.ChildObjectId                    
        WHERE Object_MobileConst.Id = inId 
          AND Object_MobileConst.DescId = zc_Object_MobileConst()  
        ;
      

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 19.07.17                                                       *
*/

-- ����
-- SELECT * FROM lpGet_Object_MobileConst (inId:= 1005694);
