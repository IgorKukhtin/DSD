-- Function: gpGet_MobilebConfig()

DROP FUNCTION IF EXISTS gpGet_MobilebConfig (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MobilebConfig(
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (BarCodePref         TVarChar
             , DocBarCodePref      TVarChar
             , ItemBarCodePref     TVarChar

             , ArticleSeparators   TVarChar

             -- ***** ��������� �������
             -- ��� ������������ ������������ True - ������ ���������, False - ������ ����������
             -- �������� ������ ����� ����� �� ��������
             , isCameraScanerSet Boolean
             , isCameraScaner    Boolean

             -- ��������� ������ ��� ��������� ������ ������������
             , isOpenScanChangingModeSet Boolean
             , isOpenScanChangingMode    Boolean

             -- �������� ������ ������������ ����� ���� �������
             , isHideScanButtonSet Boolean
             , isHideScanButton    Boolean

             -- �������� ������ ���������
             , isHideIlluminationButtonSet Boolean
             , isHideIlluminationButton    Boolean

             -- ��������� �������� ��� ������ ������������
             , isilluminationModeSet Boolean
             , isilluminationMode    Boolean

             -- ***** ������ � ����������� �������������
             -- �������
             , isDictGoodsArticleSet Boolean
             , isDictGoodsArticle    Boolean
             -- Interne Nr
             , isDictGoodsCodeSet    Boolean
             , isDictGoodsCode       Boolean
             -- EAN
             , isDictGoodsEANSet     Boolean
             , isDictGoodsEAN        Boolean

             -- ***** ������ � ��������� ������������
             -- Interne Nr
             , isDictCodeSet    Boolean
             , isDictCode       Boolean

               -- ����� ��������� ��/���
             , isNumSecurity    Boolean
               -- ���-�� ����������
             , CountSecurity    Integer
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ��������� �����
    RETURN QUERY
    SELECT zc_BarCodePref_Object()::TVarChar   AS BarCodePref
         , zc_BarCodePref_Movement()::TVarChar AS DocBarCodePref
         , zc_BarCodePref_Mi()::TVarChar       AS ItemBarCodePref
         , ' ,-'::TVarChar                     AS ArticleSeparators
         -- ***** ��������� �������
         -- ��� ������������ ������������ True - ������ ���������, False - ������ ����������
         -- �������� ������ ����� ����� �� ��������
         , FALSE   AS isCameraScanerSet
         , FALSE   AS isCameraScaner

         -- ��������� ������ ��� ��������� ������ ������������
         , FALSE   AS isOpenScanChangingModeSet
         , FALSE   AS isOpenScanChangingMode

         -- �������� ������ ������������ ����� ���� �������
         , FALSE   AS isHideScanButtonSet
         , FALSE   AS isHideScanButton

         -- �������� ������ ���������
         , FALSE   AS isHideIlluminationButtonSet
         , FALSE   AS isHideIlluminationButton

         -- ��������� �������� ��� ������ ������������
         , FALSE   AS isIlluminationModeSet
         , TRUE    AS isIlluminationMode

         -- ***** ������ � ����������� �������������
         -- �������
         , FALSE   AS isDictGoodsArticleSet
         , TRUE    AS isDictGoodsArticle
         -- Interne Nr
         , FALSE   AS isDictGoodsCodeSet
         , FALSE   AS isDictGoodsCode
         -- EAN
         , FALSE   AS isDictGoodsEANSet
         , FALSE    AS isDictGoodsEAN

         -- ***** ������ � ��������� ������������
         -- Interne Nr
         , FALSE   AS isDictCodeSet
         , FALSE   AS isDictCode

           -- ����� ��������� ��/���
         , CASE WHEN -- vbUserId = 5 OR
                     EXISTS (SELECT 1
                             FROM ObjectLink AS ObjectLink_User_Member
                                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                      AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId  = ObjectLink_Personal_Member.ObjectId
                                                          AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Personal_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                                  INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                        ON ObjectLink_Personal_PersonalServiceList.ObjectId      = ObjectLink_Personal_Member.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceList.DescId        = zc_ObjectLink_Personal_PersonalServiceList()
                                                       -- ³������ �������
                                                       AND ObjectLink_Personal_PersonalServiceList.ChildObjectId = 301885
                             WHERE ObjectLink_User_Member.ObjectId = vbUserId
                               AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                            )
                THEN TRUE
                ELSE FALSE
           END :: Boolean AS isNumSecurity

           -- ���-�� ����������
         , 3 :: Integer AS CountSecurity
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.04.24                                                       *
*/

-- ����
-- select * from gpGet_MobilebConfig(inSession := '5');
